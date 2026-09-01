-- ═══════════════════════════════════════════════════════════
-- INVITACIÓN DE BODA · Marvin & Carla
-- Estructura de la base de datos
--
-- CÓMO USARLO:
--   1. Ctrl+A  (seleccionar todo)
--   2. Ctrl+C  (copiar)
--   3. Ir a Supabase → SQL Editor → borrar lo que haya → pegar → Run
-- ═══════════════════════════════════════════════════════════


-- ───────────────────────────────────────────────────────────
-- 1. TABLA DE INVITADOS
-- ───────────────────────────────────────────────────────────
create table if not exists public.invitados (
  id          uuid primary key default gen_random_uuid(),
  -- Código corto que viaja en el link: ...vercel.app/k7m2p
  codigo      text not null unique,
  nombre      text not null,
  pases       integer not null default 1 check (pases > 0 and pases <= 20),
  creado_en   timestamptz not null default now()
);

-- Búsqueda rápida por código: es la consulta que hace cada invitado
create index if not exists invitados_codigo_idx on public.invitados (codigo);


-- ───────────────────────────────────────────────────────────
-- 2. PERFILES · quién es admin y quién es novio
-- ───────────────────────────────────────────────────────────
create table if not exists public.perfiles (
  id    uuid primary key references auth.users (id) on delete cascade,
  rol   text not null default 'novio' check (rol in ('admin', 'novio'))
);

-- Cada usuario nuevo entra como 'novio'. El admin se marca abajo.
create or replace function public.crear_perfil()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.perfiles (id, rol)
  values (new.id, 'novio')
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists al_crear_usuario on auth.users;
create trigger al_crear_usuario
  after insert on auth.users
  for each row execute function public.crear_perfil();


-- ───────────────────────────────────────────────────────────
-- 3. AJUSTES · el interruptor del super administrador
-- ───────────────────────────────────────────────────────────
create table if not exists public.ajustes (
  id                integer primary key default 1 check (id = 1),
  registro_abierto  boolean not null default true
);

insert into public.ajustes (id, registro_abierto)
values (1, true)
on conflict (id) do nothing;


-- ───────────────────────────────────────────────────────────
-- 4. FUNCIONES AUXILIARES
-- ───────────────────────────────────────────────────────────

-- ¿El usuario que está pidiendo es admin?
create or replace function public.es_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.perfiles
    where id = auth.uid() and rol = 'admin'
  );
$$;

-- ¿Está abierto el registro de invitados?
create or replace function public.registro_abierto()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce((select registro_abierto from public.ajustes where id = 1), false);
$$;


-- ───────────────────────────────────────────────────────────
-- 5. SEGURIDAD (RLS)
--
--    La clave que va en el navegador es pública: cualquiera puede
--    verla. Lo que protege los datos son estas reglas.
-- ───────────────────────────────────────────────────────────

alter table public.invitados enable row level security;
alter table public.perfiles  enable row level security;
alter table public.ajustes   enable row level security;

-- ── INVITADOS ──
drop policy if exists "invitados: leer autenticados" on public.invitados;
create policy "invitados: leer autenticados"
  on public.invitados for select
  to authenticated
  using (true);

drop policy if exists "invitados: agregar" on public.invitados;
create policy "invitados: agregar"
  on public.invitados for insert
  to authenticated
  with check (public.registro_abierto() or public.es_admin());

drop policy if exists "invitados: editar" on public.invitados;
create policy "invitados: editar"
  on public.invitados for update
  to authenticated
  using (public.registro_abierto() or public.es_admin())
  with check (public.registro_abierto() or public.es_admin());

drop policy if exists "invitados: borrar" on public.invitados;
create policy "invitados: borrar"
  on public.invitados for delete
  to authenticated
  using (public.registro_abierto() or public.es_admin());

-- ── PERFILES ──
drop policy if exists "perfiles: ver el propio" on public.perfiles;
create policy "perfiles: ver el propio"
  on public.perfiles for select
  to authenticated
  using (id = auth.uid() or public.es_admin());

-- ── AJUSTES ──
drop policy if exists "ajustes: leer" on public.ajustes;
create policy "ajustes: leer"
  on public.ajustes for select
  to authenticated
  using (true);

drop policy if exists "ajustes: cambiar solo admin" on public.ajustes;
create policy "ajustes: cambiar solo admin"
  on public.ajustes for update
  to authenticated
  using (public.es_admin())
  with check (public.es_admin());


-- ───────────────────────────────────────────────────────────
-- 6. LA PUERTA DEL INVITADO
--
--    El invitado no está logueado. En vez de darle acceso a la
--    tabla, se le da esta función: recibe un código y devuelve
--    solo ese nombre y esos pases. Nada más.
-- ───────────────────────────────────────────────────────────
create or replace function public.buscar_invitado(codigo_buscado text)
returns table (nombre text, pases integer)
language sql
stable
security definer
set search_path = public
as $$
  select i.nombre, i.pases
  from public.invitados i
  where i.codigo = codigo_buscado
  limit 1;
$$;

grant execute on function public.buscar_invitado(text) to anon, authenticated;


-- ───────────────────────────────────────────────────────────
-- 7. PERFILES DE LOS USUARIOS YA CREADOS
-- ───────────────────────────────────────────────────────────
insert into public.perfiles (id, rol)
select id, 'novio' from auth.users
on conflict (id) do nothing;

update public.perfiles set rol = 'admin'
where id = (select id from auth.users where email = 'ramius123@gmail.com');


-- ───────────────────────────────────────────────────────────
-- 8. VERIFICACIÓN
--    Debe devolver dos filas: ramius123 = admin, el otro = novio
-- ───────────────────────────────────────────────────────────
select u.email, p.rol
from public.perfiles p
join auth.users u on u.id = p.id;
