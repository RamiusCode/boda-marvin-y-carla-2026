-- ═══════════════════════════════════════════════════════════
-- MARVIN & CARLA · PASO 6
-- Número de mesa por invitado
--
-- CÓMO USARLO:
--   1. Ctrl+A  (seleccionar todo)
--   2. Ctrl+C  (copiar)
--   3. Supabase → SQL Editor → borrar lo que haya → pegar → Run
--
-- Es seguro correrlo aunque ya lo hayas corrido antes.
-- ═══════════════════════════════════════════════════════════


-- ───────────────────────────────────────────────────────────
-- 1. LA MESA DE CADA INVITADO
--
--    Va sin default y admite null a propósito: las mesas se
--    arman cuando ya se sabe quién confirmó, y las invitaciones
--    salen mucho antes. Null quiere decir "todavía sin asignar",
--    y la invitación en ese caso no dibuja el renglón.
--
--    El check deja pasar el null, pero si hay número tiene que
--    ser positivo: un "mesa 0" en la tarjeta es un error de
--    carga, no una mesa.
-- ───────────────────────────────────────────────────────────
alter table public.invitados
  add column if not exists mesa integer;

do $$
begin
  alter table public.invitados
    add constraint invitados_mesa_check check (mesa is null or mesa > 0);
exception when duplicate_object then
  raise notice 'el check de mesa ya existía';
end $$;


-- ───────────────────────────────────────────────────────────
-- 2. LA PUERTA DEL INVITADO (actualizada)
--
--    Devuelve también la mesa, para que la tarjeta del pase la
--    muestre con el mismo dato que ya trae el nombre.
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
  idioma     text,
  mesa       integer
)
language sql
stable
security definer
set search_path = public
as $$
  select i.nombre, i.pases, i.confirmado, i.idioma, i.mesa
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
  idioma     text,
  mesa       integer
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
  select i.nombre, i.pases, i.confirmado, i.idioma, i.mesa
  from public.invitados i
  where i.codigo = codigo_buscado
  limit 1;
end;
$$;

grant execute on function public.confirmar_asistencia(text) to anon, authenticated;


-- ───────────────────────────────────────────────────────────
-- 4. AVISARLE A LA API QUE CAMBIÓ LA TABLA
--
--    Supabase guarda en memoria la forma de cada tabla. Hasta
--    que se entera del cambio, al guardar desde el panel
--    contesta:
--
--      Could not find the 'mesa' column of 'invitados'
--      in the schema cache
--
--    Suele refrescarse solo en unos segundos; esto lo fuerza
--    para no tener que esperar ni recargar nada.
-- ───────────────────────────────────────────────────────────
notify pgrst, 'reload schema';


-- ───────────────────────────────────────────────────────────
-- 5. VERIFICACIÓN
--    Debe devolver los invitados que haya, todos con la mesa
--    vacía hasta que se cargue desde el panel.
-- ───────────────────────────────────────────────────────────
select nombre, pases, idioma, mesa, confirmado
from public.invitados
order by creado_en desc;
