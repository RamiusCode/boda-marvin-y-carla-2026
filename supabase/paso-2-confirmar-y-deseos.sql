-- ═══════════════════════════════════════════════════════════
-- MARVIN & CARLA · PASO 2
-- Confirmación de asistencia + Buenos deseos
--
-- CÓMO USARLO:
--   1. Ctrl+A  (seleccionar todo)
--   2. Ctrl+C  (copiar)
--   3. Supabase → SQL Editor → borrar lo que haya → pegar → Run
--
-- Es seguro correrlo aunque ya lo hayas corrido antes.
-- ═══════════════════════════════════════════════════════════


-- ───────────────────────────────────────────────────────────
-- 1. CONFIRMACIÓN · dos columnas nuevas en invitados
-- ───────────────────────────────────────────────────────────
alter table public.invitados
  add column if not exists confirmado     boolean not null default false,
  add column if not exists confirmado_en  timestamptz;


-- ───────────────────────────────────────────────────────────
-- 2. LA PUERTA DEL INVITADO (actualizada)
--
--    Ahora devuelve también si ya confirmó, para que la
--    invitación muestre "Ya confirmaste" en vez del botón.
--
--    Hay que borrarla y rehacerla: Postgres no deja cambiar
--    lo que devuelve una función con create or replace.
-- ───────────────────────────────────────────────────────────
drop function if exists public.buscar_invitado(text);

create function public.buscar_invitado(codigo_buscado text)
returns table (nombre text, pases integer, confirmado boolean)
language sql
stable
security definer
set search_path = public
as $$
  select i.nombre, i.pases, i.confirmado
  from public.invitados i
  where i.codigo = codigo_buscado
  limit 1;
$$;

grant execute on function public.buscar_invitado(text) to anon, authenticated;


-- ───────────────────────────────────────────────────────────
-- 3. CONFIRMAR ASISTENCIA
--
--    El invitado no está logueado, así que no puede tocar la
--    tabla. Se le da esta función: recibe su código, marca esa
--    fila y devuelve cómo quedó. No puede hacer nada más.
-- ───────────────────────────────────────────────────────────
create or replace function public.confirmar_asistencia(codigo_buscado text)
returns table (nombre text, pases integer, confirmado boolean)
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
  select i.nombre, i.pases, i.confirmado
  from public.invitados i
  where i.codigo = codigo_buscado
  limit 1;
end;
$$;

grant execute on function public.confirmar_asistencia(text) to anon, authenticated;


-- ───────────────────────────────────────────────────────────
-- 4. BUENOS DESEOS · tabla nueva
-- ───────────────────────────────────────────────────────────
create table if not exists public.deseos (
  id         uuid primary key default gen_random_uuid(),
  nombre     text not null,
  mensaje    text not null,
  creado_en  timestamptz not null default now()
);

-- Los más nuevos primero: es como los muestra la invitación
create index if not exists deseos_creado_idx
  on public.deseos (creado_en desc);

alter table public.deseos enable row level security;

-- Cualquiera puede leerlos: son públicos, se ven en la invitación
drop policy if exists "deseos: leer" on public.deseos;
create policy "deseos: leer"
  on public.deseos for select
  to anon, authenticated
  using (true);

-- Cualquiera puede dejar uno, pero con límites de largo.
-- El control va acá, en la base, y no solo en el formulario:
-- el formulario se puede saltear, esto no.
drop policy if exists "deseos: escribir" on public.deseos;
create policy "deseos: escribir"
  on public.deseos for insert
  to anon, authenticated
  with check (
    char_length(btrim(nombre))  between 2 and 40
    and char_length(btrim(mensaje)) between 5 and 400
  );

-- Borrar solo desde el panel (hay que estar logueado)
drop policy if exists "deseos: borrar" on public.deseos;
create policy "deseos: borrar"
  on public.deseos for delete
  to authenticated
  using (true);


-- ───────────────────────────────────────────────────────────
-- 5. VERIFICACIÓN
--    Debe devolver 3 filas: confirmar_asistencia,
--    buscar_invitado y la tabla deseos en 0.
-- ───────────────────────────────────────────────────────────
select 'funcion' as tipo, proname as nombre, '' as dato
from pg_proc
where proname in ('buscar_invitado', 'confirmar_asistencia')
union all
select 'tabla', 'deseos', count(*)::text from public.deseos;
