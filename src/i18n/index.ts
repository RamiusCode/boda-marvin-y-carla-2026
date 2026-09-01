// src/i18n/index.ts
// Los textos de la invitación, en los dos idiomas.
//
// ── POR QUÉ ASÍ ──────────────────────────────────────────────
// Antes cada componente tenía sus frases escritas adentro, en un bloque
// DATOS EDITABLES. Con dos idiomas eso no escala: habría que duplicar cada
// componente o llenarlos de condicionales.
//
// Ahora las frases viven acá, agrupadas por sección, y el componente pide
// las suyas. El diseño no se toca al traducir.
//
// ── CÓMO SE ELIGE EL IDIOMA ──────────────────────────────────
// No se cambia con JavaScript al vuelo: hay dos direcciones distintas.
//
//   dominio.com/k7m2p       → español
//   dominio.com/en/k7m2p    → inglés
//
// Si el texto se reemplazara al vuelo, el invitado inglés vería medio
// segundo de español antes del cambio. Con dos páginas cada uno recibe la
// suya ya armada.
//
// ── PARA AGREGAR UNA SECCIÓN ─────────────────────────────────
// 1. Agregá sus frases a es.ts
// 2. Agregá las mismas claves a en.ts (TypeScript avisa si falta alguna)
// 3. En el componente: const t = textos(idioma).nombreDeLaSeccion

import { es } from "./es";
import { en } from "./en";

export type Idioma = "es" | "en";

/*
   El tipo sale del español y en.ts lo tiene que cumplir. Así, si se agrega
   una frase y se olvida traducirla, el error salta al compilar y no en la
   invitación de un invitado.
*/
export type Textos = typeof es;

const diccionarios: Record<Idioma, Textos> = { es, en };

/** Los textos del idioma pedido. Si llega cualquier otra cosa, español. */
export function textos(idioma: Idioma | string | undefined): Textos {
    return diccionarios[idioma as Idioma] ?? es;
}

/** Los idiomas que la invitación sabe mostrar, para validar lo que llega */
export function esIdiomaValido(valor: unknown): valor is Idioma {
    return valor === "es" || valor === "en";
}
