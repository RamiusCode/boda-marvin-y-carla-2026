-- ═══════════════════════════════════════════════════════════
-- MARVIN & CARLA · PASO 3
-- Un solo deseo por invitado (reemplazable)
--
-- CÓMO USARLO:
--   1. Ctrl+A  (seleccionar todo)
--   2. Ctrl+C  (copiar)
--   3. Supabase → SQL Editor → borrar lo que haya → pegar → Run
--
-- Es seguro correrlo aunque ya lo hayas corrido antes.
-- ═══════════════════════════════════════════════════════════


-- ───────────────────────────────────────────────────────────
-- 1. GUARDAR DE QUIÉN ES CADA DESEO
--
--    El código es el que viaja en el link del invitado. Con él
--    se sabe si ya dejó uno.
-- ───────────────────────────────────────────────────────────
alter table public.deseos
  add column if not exists codigo text;

-- Un deseo por código. Los NULL no chocan entre sí en Postgres,
-- así que la invitación general —que no tiene código— puede
-- seguir recibiendo varios.
create unique index if not exists deseos_codigo_key
  on public.deseos (codigo);


-- ───────────────────────────────────────────────────────────
-- 2. GUARDAR UN DESEO
--
--    Antes el invitado escribía directo en la tabla. Ahora pasa
--    por esta función, y eso permite dos cosas que con el
--    insert suelto no se podían:
--
--    · que el segundo deseo REEMPLACE al primero en vez de
--      sumarse
--    · que nadie pueda editar el deseo de otro, porque el
--      invitado ya no tiene permiso de escritura directo
-- ───────────────────────────────────────────────────────────
create or replace function public.guardar_deseo(
  codigo_invitado text,
  nombre_deseo    text,
  mensaje_deseo   text
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  n text := btrim(nombre_deseo);
  m text := btrim(mensaje_deseo);
  c text := nullif(btrim(coalesce(codigo_invitado, '')), '');
begin
  -- Los límites viven acá y no en el formulario: el formulario
  -- se puede saltear, esto no.
  if char_length(n) < 2 or char_length(n) > 40 then
    raise exception 'El nombre tiene que tener entre 2 y 40 letras';
  end if;

  if char_length(m) < 5 or char_length(m) > 400 then
    raise exception 'El mensaje tiene que tener entre 5 y 400 letras';
  end if;

  if c is null then
    -- Invitación general: no hay a quién identificar
    insert into public.deseos (nombre, mensaje) values (n, m);
  else
    insert into public.deseos (codigo, nombre, mensaje)
    values (c, n, m)
    on conflict (codigo) do update
      set nombre    = excluded.nombre,
          mensaje   = excluded.mensaje,
          creado_en = now();
  end if;
end;
$$;

grant execute on function public.guardar_deseo(text, text, text)
  to anon, authenticated;


-- ───────────────────────────────────────────────────────────
-- 3. CERRAR LA ESCRITURA DIRECTA
--
--    Ya no hace falta: todo pasa por la función de arriba.
--    Leer sigue abierto, porque los deseos se muestran en la
--    invitación.
-- ───────────────────────────────────────────────────────────
drop policy if exists "deseos: escribir" on public.deseos;


-- ───────────────────────────────────────────────────────────
-- 4. VERIFICACIÓN
--    Debe devolver la función guardar_deseo y la cantidad de
--    deseos que haya hoy.
-- ───────────────────────────────────────────────────────────
select 'funcion' as tipo, proname as nombre
from pg_proc where proname = 'guardar_deseo'
union all
select 'deseos guardados', count(*)::text from public.deseos;
