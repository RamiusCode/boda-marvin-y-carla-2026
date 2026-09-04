-- ═══════════════════════════════════════════════════════════
-- MARVIN & CARLA · VACIAR ANTES DE ENTREGAR
--
-- Borra los invitados y los deseos de prueba, y deja la base
-- lista para que el cliente cargue su lista de verdad.
--
-- ⚠️  ESTO NO SE PUEDE DESHACER.
--     No hay papelera ni "control Z". Antes de correrlo,
--     mirá el punto 1: descarga una copia de lo que hay.
--
-- CÓMO USARLO:
--   1. Ctrl+A  (seleccionar todo)
--   2. Ctrl+C  (copiar)
--   3. Supabase → SQL Editor → borrar lo que haya → pegar → Run
-- ═══════════════════════════════════════════════════════════


-- ───────────────────────────────────────────────────────────
-- 1. MIRÁ QUÉ SE VA A BORRAR
--
--    Corré PRIMERO solo estas dos consultas, seleccionándolas
--    con el mouse y apretando Run. Si algo de lo que aparece
--    no querés perderlo, frená acá.
--
--    Con el botón "Download CSV" del resultado te guardás una
--    copia antes de borrar.
-- ───────────────────────────────────────────────────────────
select 'invitados' as tabla, count(*) as filas from public.invitados
union all
select 'deseos', count(*) from public.deseos;

select nombre, pases, mesa, confirmado, codigo
from public.invitados
order by creado_en;


-- ───────────────────────────────────────────────────────────
-- 2. EL BORRADO
--
--    Los deseos van primero por prolijidad, aunque no dependen
--    de los invitados: la tabla no tiene clave foránea contra
--    ellos. Por eso mismo borrar los invitados desde el panel
--    NO borra los deseos, y quedarían mensajes colgados en el
--    muro sin nadie a quien pertenecen.
--
--    delete y no truncate: truncate no dispara las políticas
--    ni el aviso de tiempo real, así que a quien tenga la
--    invitación abierta no se le limpiaría el muro solo.
-- ───────────────────────────────────────────────────────────
delete from public.deseos;
delete from public.invitados;


-- ───────────────────────────────────────────────────────────
-- 3. LO QUE NO SE TOCA, Y ESTÁ BIEN QUE NO SE TOQUE
--
--    · Las cuentas de acceso (auth.users y perfiles). Si se
--      borraran, tu cliente no podría entrar a su panel.
--    · Los ajustes, o sea el interruptor de registro abierto.
--    · La estructura: columnas, funciones y permisos quedan
--      intactos. Esto vacía datos, no deshace los pasos 1 a 7.
--
--    Se listan para que confirmes que siguen ahí.
-- ───────────────────────────────────────────────────────────
select p.rol, u.email
from public.perfiles p
join auth.users u on u.id = p.id
order by p.rol;

select * from public.ajustes;


-- ───────────────────────────────────────────────────────────
-- 4. VERIFICACIÓN
--    Las dos tienen que dar 0.
-- ───────────────────────────────────────────────────────────
select 'invitados' as tabla, count(*) as filas from public.invitados
union all
select 'deseos', count(*) from public.deseos;
