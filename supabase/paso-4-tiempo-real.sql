-- ═══════════════════════════════════════════════════════════
-- MARVIN & CARLA · PASO 4
-- El panel se actualiza solo, sin recargar
--
-- CÓMO USARLO:
--   1. Ctrl+A  (seleccionar todo)
--   2. Ctrl+C  (copiar)
--   3. Supabase → SQL Editor → borrar lo que haya → pegar → Run
--
-- Es seguro correrlo aunque ya lo hayas corrido antes.
-- ═══════════════════════════════════════════════════════════


-- ───────────────────────────────────────────────────────────
-- 1. AVISAR LOS CAMBIOS DE ESTAS DOS TABLAS
--
--    Supabase no avisa de nada por defecto: hay que anotar
--    tabla por tabla cuál queremos que emita cambios.
--
--    Va dentro de un bloque porque, si la tabla ya estaba
--    anotada, el comando suelto corta con error y el resto del
--    archivo no se ejecuta.
-- ───────────────────────────────────────────────────────────
do $$
begin
  begin
    alter publication supabase_realtime add table public.invitados;
  exception when duplicate_object then
    raise notice 'invitados ya estaba anotada';
  end;

  begin
    alter publication supabase_realtime add table public.deseos;
  exception when duplicate_object then
    raise notice 'deseos ya estaba anotada';
  end;
end $$;


-- ───────────────────────────────────────────────────────────
-- 2. QUE EL AVISO TRAIGA LA FILA COMPLETA
--
--    Por defecto, al borrar una fila el aviso solo trae su id.
--    Con esto trae también el resto, que es lo que el panel
--    necesita para saber a quién sacar de la lista.
-- ───────────────────────────────────────────────────────────
alter table public.invitados replica identity full;
alter table public.deseos    replica identity full;


-- ───────────────────────────────────────────────────────────
-- 3. VERIFICACIÓN
--    Debe devolver las dos tablas: invitados y deseos.
-- ───────────────────────────────────────────────────────────
select tablename
from pg_publication_tables
where pubname = 'supabase_realtime'
order by tablename;
