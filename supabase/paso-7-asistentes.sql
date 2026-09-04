-- ═══════════════════════════════════════════════════════════
-- MARVIN & CARLA · PASO 7
-- Cuántos vienen de verdad, y con quién
--
-- CÓMO USARLO:
--   1. Ctrl+A  (seleccionar todo)
--   2. Ctrl+C  (copiar)
--   3. Supabase → SQL Editor → borrar lo que haya → pegar → Run
--
-- Es seguro correrlo aunque ya lo hayas corrido antes.
-- ═══════════════════════════════════════════════════════════


-- ───────────────────────────────────────────────────────────
-- 1. LAS DOS COLUMNAS NUEVAS
--
--    'pases' es cuántos lugares se le ofrecieron al invitado.
--    'asisten' es cuántos dijo que van a venir. No son lo
--    mismo, y esa diferencia es justamente lo que hay que
--    saber para reservar: una invitación de 2 donde va uno
--    solo libera un lugar.
--
--    Ambas admiten null: null en 'asisten' quiere decir
--    "todavía no respondió", que es distinto de "viene cero".
-- ───────────────────────────────────────────────────────────
alter table public.invitados
  add column if not exists asisten integer;

alter table public.invitados
  add column if not exists acompanantes text[];

do $$
begin
  alter table public.invitados
    add constraint invitados_asisten_check check (asisten is null or asisten >= 1);
exception when duplicate_object then
  raise notice 'el check de asisten ya existía';
end $$;


-- ───────────────────────────────────────────────────────────
-- 2. LA PUERTA DEL INVITADO (actualizada)
--
--    Devuelve lo que ya había respondido. Se usa para que,
--    si vuelve a entrar para corregir, el modal aparezca con
--    su respuesta anterior ya puesta en vez de en blanco.
-- ───────────────────────────────────────────────────────────
drop function if exists public.buscar_invitado(text);

create function public.buscar_invitado(codigo_buscado text)
returns table (
  nombre       text,
  pases        integer,
  confirmado   boolean,
  idioma       text,
  mesa         integer,
  asisten      integer,
  acompanantes text[]
)
language sql
stable
security definer
set search_path = public
as $$
  select i.nombre, i.pases, i.confirmado, i.idioma, i.mesa,
         i.asisten, i.acompanantes
  from public.invitados i
  where i.codigo = codigo_buscado
  limit 1;
$$;

grant execute on function public.buscar_invitado(text) to anon, authenticated;


-- ───────────────────────────────────────────────────────────
-- 3. CONFIRMAR ASISTENCIA (ahora recibe la respuesta)
--
--    Cambia de un parámetro a tres, así que hay que borrar
--    las dos versiones viejas: si quedara la de un solo
--    parámetro, Postgres no sabría cuál llamar.
--
--    Se puede llamar más de una vez: el invitado que confirmó
--    por dos y después se queda solo vuelve a entrar por su
--    mismo link y corrige. La fecha original no se pisa.
-- ───────────────────────────────────────────────────────────
drop function if exists public.confirmar_asistencia(text);
drop function if exists public.confirmar_asistencia(text, integer, text[]);

create function public.confirmar_asistencia(
  codigo_buscado      text,
  asisten_nuevo       integer default null,
  acompanantes_nuevos text[]  default null
)
returns table (
  nombre       text,
  pases        integer,
  confirmado   boolean,
  idioma       text,
  mesa         integer,
  asisten      integer,
  acompanantes text[]
)
language plpgsql
security definer
set search_path = public
as $$
declare
  tope    integer;
  cuantos integer;
  limpios text[];
begin
  select i.pases into tope
  from public.invitados i
  where i.codigo = codigo_buscado;

  -- Código inexistente: no se toca nada y no se devuelve nada
  if tope is null then
    return;
  end if;

  /*
     El número llega del navegador, así que no se confía en él: se recorta
     al rango que la invitación permite. Sin esto, cualquiera podría anotar
     diez asistentes en una invitación de dos pases.

     Si no viene nada, se asume que vienen todos: es lo que significaba
     confirmar antes de que existiera esta pregunta, así que las respuestas
     viejas siguen queriendo decir lo mismo.
  */
  cuantos := least(greatest(coalesce(asisten_nuevo, tope), 1), tope);

  /*
     Los nombres se limpian acá y no en el navegador: se sacan los espacios
     de sobra y se descartan los que quedaron vacíos —los campos son
     opcionales, así que vienen vacíos a propósito.
  */
  select array_agg(x)
    into limpios
  from (
    select btrim(n) as x
    from unnest(coalesce(acompanantes_nuevos, array[]::text[])) as n
    where btrim(n) <> ''
  ) s;

  limpios := coalesce(limpios, array[]::text[]);

  /*
     Nunca más nombres que acompañantes: el invitado principal ya está en
     la columna 'nombre'. Si alguien baja de 3 a 2 después de haber escrito
     dos nombres, el sobrante se descarta en vez de quedar colgado.
  */
  limpios := limpios[1:greatest(cuantos - 1, 0)];

  update public.invitados i
     set confirmado    = true,
         confirmado_en = coalesce(i.confirmado_en, now()),
         asisten       = cuantos,
         acompanantes  = limpios
   where i.codigo = codigo_buscado;

  return query
  select i.nombre, i.pases, i.confirmado, i.idioma, i.mesa,
         i.asisten, i.acompanantes
  from public.invitados i
  where i.codigo = codigo_buscado
  limit 1;
end;
$$;

grant execute on function public.confirmar_asistencia(text, integer, text[])
  to anon, authenticated;


-- ───────────────────────────────────────────────────────────
-- 4. LOS QUE YA HABÍAN CONFIRMADO
--
--    Antes de este paso, confirmar quería decir "vamos todos".
--    Se les completa 'asisten' con sus pases para que el total
--    del panel no arranque en cero para ellos.
--
--    Solo toca a los que tienen la columna vacía: correrlo de
--    nuevo no pisa lo que alguien haya respondido después.
-- ───────────────────────────────────────────────────────────
update public.invitados
   set asisten = pases
 where confirmado = true
   and asisten is null;


-- ───────────────────────────────────────────────────────────
-- 5. AVISARLE A LA API QUE CAMBIÓ LA TABLA
--
--    Sin esto, al guardar desde el panel contesta durante unos
--    segundos:
--      Could not find the 'asisten' column of 'invitados'
--      in the schema cache
-- ───────────────────────────────────────────────────────────
notify pgrst, 'reload schema';


-- ───────────────────────────────────────────────────────────
-- 6. VERIFICACIÓN
--    Los que ya habían confirmado deben aparecer con
--    asisten = pases. El resto, con asisten vacío.
-- ───────────────────────────────────────────────────────────
select nombre, pases, asisten, acompanantes, mesa, confirmado
from public.invitados
order by creado_en desc;
