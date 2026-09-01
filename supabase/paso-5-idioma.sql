-- ═══════════════════════════════════════════════════════════
-- MARVIN & CARLA · PASO 5
-- Idioma por invitado (español por defecto)
--
-- CÓMO USARLO:
--   1. Ctrl+A  (seleccionar todo)
--   2. Ctrl+C  (copiar)
--   3. Supabase → SQL Editor → borrar lo que haya → pegar → Run
--
-- Es seguro correrlo aunque ya lo hayas corrido antes.
-- ═══════════════════════════════════════════════════════════


-- ───────────────────────────────────────────────────────────
-- 1. EL IDIOMA DE CADA INVITADO
--
--    'es' por defecto: los que ya están cargados quedan en
--    español sin tener que tocarlos.
--
--    El check evita que un error de tipeo meta un idioma que
--    la invitación no sabe mostrar.
-- ───────────────────────────────────────────────────────────
alter table public.invitados
  add column if not exists idioma text not null default 'es';

do $$
begin
  alter table public.invitados
    add constraint invitados_idioma_check check (idioma in ('es', 'en'));
exception when duplicate_object then
  raise notice 'el check de idioma ya existía';
end $$;


-- ───────────────────────────────────────────────────────────
-- 2. LA PUERTA DEL INVITADO (actualizada)
--
--    Devuelve también el idioma. Se usa para dos cosas:
--    saber en qué idioma armar el link desde el panel, y que
--    la invitación pueda avisar si alguien entró por la
--    dirección equivocada.
--
--    Hay que borrarla y rehacerla: Postgres no deja cambiar
--    lo que devuelve una función con create or replace.
-- ───────────────────────────────────────────────────────────
drop function if exists public.buscar_invitado(text);

create function public.buscar_invitado(codigo_buscado text)
returns table (
  nombre     text,
  pases      integer,
  confirmado boolean,
  idioma     text
)
language sql
stable
security definer
set search_path = public
as $$
  select i.nombre, i.pases, i.confirmado, i.idioma
  from public.invitados i
  where i.codigo = codigo_buscado
  limit 1;
$$;

grant execute on function public.buscar_invitado(text) to anon, authenticated;


-- ───────────────────────────────────────────────────────────
-- 3. CONFIRMAR ASISTENCIA (actualizada, por lo mismo)
-- ───────────────────────────────────────────────────────────
drop function if exists public.confirmar_asistencia(text);

create function public.confirmar_asistencia(codigo_buscado text)
returns table (
  nombre     text,
  pases      integer,
  confirmado boolean,
  idioma     text
)
language plpgsql
security definer
set search_path = public
as $$
begin
  -- Solo marca la primera vez: si vuelve a entrar y toca de
  -- nuevo, no se pisa la fecha original.
  update public.invitados i
     set confirmado = true,
         confirmado_en = coalesce(i.confirmado_en, now())
   where i.codigo = codigo_buscado;

  return query
  select i.nombre, i.pases, i.confirmado, i.idioma
  from public.invitados i
  where i.codigo = codigo_buscado
  limit 1;
end;
$$;

grant execute on function public.confirmar_asistencia(text) to anon, authenticated;


-- ───────────────────────────────────────────────────────────
-- 4. VERIFICACIÓN
--    Debe devolver los invitados que haya, todos en 'es'.
-- ───────────────────────────────────────────────────────────
select nombre, pases, idioma, confirmado
from public.invitados
order by creado_en desc;
