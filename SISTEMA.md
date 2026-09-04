# Invitación de boda con panel de invitados

Documento para levantar este mismo sistema en otro proyecto. No es un
tutorial: es lo que hay que saber para no repetir los errores que ya
cometimos acá.

---

## Qué es

Dos cosas en un mismo sitio estático:

1. **La invitación**, que el invitado abre desde su celular. Una sola
   página larga, dividida en secciones que se van revelando al bajar.
2. **El panel** (`/admin`), donde los novios cargan a los invitados,
   generan los links personalizados y ven quién confirmó.

Cada invitado recibe **su propio link**. Al abrirlo, la invitación
muestra su nombre, cuántos lugares tiene reservados y en qué mesa se
sienta.

---

## Con qué está hecho

| | |
|---|---|
| Framework | Astro (sitio estático, sin servidor propio) |
| Estilos | Tailwind + CSS scopeado por componente |
| Animaciones | GSAP con ScrollTrigger |
| Base de datos | Supabase (Postgres + Auth + Realtime) |
| Hosting | Vercel |
| Lectura de Excel | SheetJS (`xlsx`), cargada solo al importar |

No hay backend propio. El navegador habla directo con Supabase, y lo que
protege los datos son las políticas de la base, no el código de la
página.

---

## Cómo funciona el link personalizado

El link corto es `dominio.com/k7m2p`, donde `k7m2p` es el código del
invitado.

Esa dirección **no es una página de Astro**. La resuelve un rewrite de
Vercel en `vercel.json`:

```json
{ "rewrites": [
  { "source": "/en/:codigo", "destination": "/en" },
  { "source": "/:codigo",    "destination": "/" }
]}
```

Vercel sirve la invitación normal, y el JavaScript lee el código de la
URL para buscar al invitado.

**Trampa:** el dev server de Astro no aplica ese rewrite, así que en
localhost `/k7m2p` da 404. Por eso la función que lee el código acepta
también `?i=k7m2p`, que sí funciona local. Sin esto se pierden horas
creyendo que algo está roto.

El nombre **no viaja en el link**, solo el código. Así, si se corrige un
nombre mal escrito, el link ya enviado muestra el nombre corregido sin
reenviar nada.

---

## La base de datos

Cuatro tablas. Los archivos `supabase/paso-*.sql` se corren en orden en
el SQL Editor; cada uno es idempotente.

### `invitados`

| Columna | Para qué |
|---|---|
| `codigo` | El del link. Corto, sin vocales ni caracteres confundibles (0/O, 1/l) para poder dictarlo por teléfono |
| `nombre` | |
| `pases` | Cuántos lugares se le **ofrecieron** |
| `asisten` | Cuántos dijo que **van a venir**. Null = todavía no respondió |
| `acompanantes` | `text[]` con los nombres de los que lo acompañan |
| `mesa` | Null hasta que se arman las mesas |
| `idioma` | `es` o `en` |
| `confirmado`, `confirmado_en` | |

**`pases` y `asisten` no son lo mismo, y esa diferencia es el punto.**
Una invitación de 2 donde va uno solo libera un lugar. Si el panel suma
`pases` de los confirmados, infla el total y se reserva de más.

### `deseos`

Muro de mensajes que dejan los invitados. Uno por invitado: la función
que los guarda **reemplaza** el anterior en vez de sumar otro, para que
nadie llene el muro solo.

**No tiene clave foránea contra `invitados`.** Consecuencia: borrar
invitados no borra sus deseos, y quedan mensajes colgados. Hay que
vaciar las dos tablas.

### `perfiles` y `ajustes`

`perfiles` guarda el rol (`admin` o `novio`). Todo usuario nuevo entra
como `novio` por un trigger; el admin se marca a mano.

`ajustes.registro_abierto` es un interruptor: si está apagado, los
novios no pueden agregar invitados. **Verificarlo antes de entregar**,
o el cliente no puede cargar ni uno y no entiende por qué.

### Las funciones

El invitado navega **sin cuenta** (anónimo) y **no tiene permiso de leer
la tabla `invitados`**. Si lo tuviera, cualquiera podría descargarse la
lista entera con nombres, códigos y mesas.

Por eso todo lo que necesita el invitado pasa por funciones con permisos
propios (`security definer`):

- `buscar_invitado(codigo)` — devuelve sus datos
- `confirmar_asistencia(codigo, cuantos, nombres[])` — guarda la respuesta
- `guardar_deseo(...)` — deja su mensaje

`confirmar_asistencia` **recorta el número en la base**, no en el
navegador: nadie puede anotar diez asistentes en una invitación de dos
editando la página.

---

## Decisiones que parecen detalles y no lo son

**Los pases se traban cuando el invitado confirma.** Su respuesta se
guardó contra ese número; bajarlos después dejaba la fila diciendo
"3 / 2", que es imposible, y contando 3 en el total. Para cambiarlos hay
que marcarlo primero como sin responder.

**Los nombres de acompañantes son obligatorios.** Fueron opcionales al
principio y la mayoría quedaba vacía, con lo que la lista no servía para
las tarjetas de mesa. Se apaga el botón de confirmar mientras falte
alguno, en vez de dejar apretar y avisar después.

**Quien ya respondió puede corregirse** desde el mismo link. Confirmó
por dos y a la semana el acompañante no puede ir: sin esa puerta de
vuelta, el dato queda viejo y se reserva de más.

**Un link dado de baja avisa.** Antes seguía mostrando la invitación con
los datos de muestra, o sea el nombre de otra persona. Pero hay que
separar "la consulta no encontró a nadie" de "la consulta falló": si se
tratan igual, una caída momentánea de la base le dice "tu invitación no
vale" a alguien que sí está invitado.

**La mesa se actualiza sin recargar**, pero no con el tiempo real de
Supabase: eso respeta las políticas de lectura, y el invitado anónimo no
recibiría nada. Se vuelve a preguntar por la misma función, al volver a
la pestaña y cada tanto mientras está a la vista. Con la pestaña
escondida no se pregunta nada.

**El borrado de un deseo sí usa tiempo real**, porque la tabla `deseos`
sí es de lectura pública. Requiere `replica identity full` (lo pone el
paso 4): sin eso el aviso dice que se borró algo pero no cuál.

**Contenido distinto por idioma, no solo texto traducido.** La foto de
los novios de chicos trae el texto impreso adentro del archivo, así que
hay una por idioma. Y el QR de regalo es de un banco local, inútil para
quien paga desde el exterior: la versión en inglés muestra PayPal en su
lugar.

---

## Las trampas técnicas que costaron horas

**1. CSS scopeado y elementos creados por JavaScript.**
Astro agrega un atributo `[data-astro-cid-…]` a cada selector, y lo
escribe al renderizar. Los elementos creados con `document.createElement`
**nunca lo reciben**, así que ninguna regla les aplica y aparecen sin
estilo. Solución: colgarlos de un contenedor que sí venga del servidor,
con `:global()` para el hijo.

```css
/* No funciona en un botón creado por JS */
.opcion { … }

/* Sí funciona */
.contenedor :global(.opcion) { … }
```

**2. Centrar con flex y contenido más alto que la pantalla.**
Un hijo más alto que un contenedor con `align-items: center` **se
desborda para los dos lados**, y lo que sobresale por arriba no se
alcanza ni con scroll (el scroll no llega a valores negativos). Agregar
`overflow-y: auto` no alcanza. Hay que centrar con `margin: auto` en el
hijo.

**3. Elementos superpuestos y contextos de apilamiento.**
Una sección con `z-index: 2` fue tapada por la siguiente, que no tenía
z-index: su hijo interno con `z-index: 2` competía de igual a igual en el
contexto raíz y ganaba por ir después en el DOM. Solución: darle a la
sección su propio contexto.

**4. `hidden` contra las clases de Tailwind.**
`el.hidden = true` no esconde nada si el elemento tiene una clase que
declara `display` (como `flex`). Para esconder sí o sí:
`el.style.display = "none"`.

**5. `import.meta.env.DEV` dentro de un `<script>` de Astro.**
Queda sin reemplazar y depende de que Vite haya inyectado el objeto de
entorno en el navegador. Resolverlo en el frontmatter (servidor) y
pasarlo al HTML como atributo.

**6. Dev servers viejos.**
Tras muchas ediciones seguidas, una instancia de Astro puede quedar
sirviendo CSS incompleto. Si el diseño se ve "pelado" sin motivo, matar
el proceso y levantar uno limpio antes de buscar el bug en el código.

---

## La importación desde Excel

El cliente aprieta un botón, elige su archivo y ve lo que se va a crear.

**Las columnas se ubican por el nombre del encabezado, no por su
posición.** Es lo que permite tomar la planilla como está en vez de
pedirle que la acomode. Se aceptan variantes (`Nombre`, `Invitado`,
`Familia`…), sin distinguir mayúsculas ni acentos, y **con tolerancia a
errores de tipeo**: `nombes` se reconoce como `nombres`. Primero se
buscan las coincidencias exactas y recién después las parecidas, para
que una columna bien escrita no se la lleve el parecido de otra.

Tampoco se asume que los encabezados estén en la primera fila: es común
que arriba haya un título o una fila en blanco.

**Entre leer y guardar va una pantalla de confirmación, y no es un
trámite.** Si la detección se equivoca, se crean cincuenta invitados con
la mesa y los pases cambiados, y eso se deshace de a uno. Ahí se ve lo
que se va a crear y se corrige con un desplegable por columna.

Si no reconoce nada, **no se planta**: abre igual con los desplegables
vacíos para elegir a mano. Un cartel de error sin salida deja trabado a
alguien que no sabe por qué su archivo "no sirve".

Las filas con problemas no frenan la importación: se cargan las buenas y
se avisa cuáles quedaron afuera y por qué.

Se inserta **de a una fila**: el código es aleatorio y puede chocar con
uno existente, así se reintenta solo la que chocó en vez de perder las
cincuenta.

**Limitación conocida:** subir el archivo siempre **crea** invitados
nuevos. Volver a subir la misma lista con datos agregados **duplica**
todo. No hay actualización por importación.

---

## Vista previa en localhost

Para diseñar sin cargar datos reales, algunas partes muestran valores de
muestra **solo en desarrollo**, con una bandera resuelta en el servidor y
pasada al HTML. Al compilar no se escribe el atributo y desaparece sola:
no hay que acordarse de borrar nada antes de publicar.

---

## Orden para entregar

1. Correr los `paso-*.sql` en orden en el SQL Editor de Supabase
2. Verificar que `ajustes.registro_abierto` esté encendido
3. Vaciar los datos de prueba (`vaciar-para-entregar.sql`) — mirar
   primero qué hay, que no se deshace
4. Confirmar que no queden archivos sueltos en `public/`: todo lo que
   está ahí se publica y queda descargable por cualquiera
5. Recién entonces, desplegar

**El orden importa:** si el frontend nuevo llega antes que la migración,
los invitados reales no pueden confirmar.
