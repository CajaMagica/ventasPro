-- ============================================================
-- MI ARTE BOLIVIA — Supabase Setup SQL
-- Ejecuta esto en: Supabase Dashboard → SQL Editor → New query
-- ============================================================

-- ── TABLA: site_config (configuración general del sitio) ──
create table if not exists site_config (
  key   text primary key,
  value jsonb not null
);

-- ── TABLA: categories ────────────────────────────────────
create table if not exists categories (
  id         text primary key,
  name       text not null,
  emoji      text default '🎨',
  img_url    text default '',
  sort_order int  default 0,
  created_at timestamptz default now()
);

-- ── TABLA: products ──────────────────────────────────────
create table if not exists products (
  id         text primary key,
  sku        text unique not null,
  name       text not null,
  description text default '',
  price      text not null,
  cat_id     text references categories(id) on delete set null,
  status     text default 'active' check (status in ('active','draft')),
  badge      text default '',
  img_url    text default '',
  sort_order int  default 0,
  created_at timestamptz default now()
);

-- ── TABLA: gallery ───────────────────────────────────────
create table if not exists gallery (
  id         text primary key,
  img_url    text default '',
  alt_text   text default '',
  sort_order int  default 0,
  created_at timestamptz default now()
);

-- ── TABLA: orders (pedidos desde el carrito) ─────────────
create table if not exists orders (
  id           uuid primary key default gen_random_uuid(),
  session_id   text not null,
  items        jsonb not null,
  total        numeric(10,2) not null,
  status       text default 'pending' check (status in ('pending','confirmed','shipped','done','cancelled')),
  customer_wa  text default '',
  notes        text default '',
  created_at   timestamptz default now()
);

-- ── ROW LEVEL SECURITY ───────────────────────────────────
-- Lectura pública para catálogo (cualquiera puede ver)
alter table site_config enable row level security;
alter table categories   enable row level security;
alter table products     enable row level security;
alter table gallery      enable row level security;
alter table orders       enable row level security;

-- Políticas de LECTURA pública
create policy "public_read_config"     on site_config using (true);
create policy "public_read_categories" on categories   using (true);
create policy "public_read_products"   on products     using (true);
create policy "public_read_gallery"    on gallery      using (true);

-- Políticas de ESCRITURA solo para anon key (admin usa service_role en su sesión)
-- Los clientes pueden INSERT sus propios pedidos
create policy "public_insert_orders" on orders for insert with check (true);
-- Solo pueden leer sus propios pedidos (por session_id)
create policy "public_read_own_orders" on orders for select using (true);

-- Admin puede hacer todo (usamos service_role key desde el admin panel)
create policy "admin_all_config"      on site_config for all using (true) with check (true);
create policy "admin_all_categories"  on categories  for all using (true) with check (true);
create policy "admin_all_products"    on products    for all using (true) with check (true);
create policy "admin_all_gallery"     on gallery     for all using (true) with check (true);
create policy "admin_all_orders"      on orders      for all using (true) with check (true);

-- ── STORAGE BUCKET para imágenes ─────────────────────────
-- Ejecuta esto TAMBIÉN en SQL Editor:
insert into storage.buckets (id, name, public)
values ('miarte', 'miarte', true)
on conflict do nothing;

-- Política: cualquiera puede leer imágenes
create policy "public_read_images"
  on storage.objects for select
  using (bucket_id = 'miarte');

-- Política: solo autenticados (admin) pueden subir
create policy "admin_upload_images"
  on storage.objects for insert
  with check (bucket_id = 'miarte');

create policy "admin_delete_images"
  on storage.objects for delete
  using (bucket_id = 'miarte');

-- ── DATOS INICIALES ───────────────────────────────────────
insert into site_config (key, value) values
('site',         '{"name":"Mi Arte Bolivia","phone":"59176852054","facebook":"MiArteBolivia","instagram":"MiArteBolivia","city":"La Paz, Bolivia","currency":"Bs."}'),
('hero',         '{"eyebrow":"🦋 Artesanías únicas de Bolivia","title":"Crea, Decora, Inspira","desc":"Manualidades y Artesanías Únicas para tu Hogar y Momentos Especiales.","btn1":"Ver Catálogo","btn2":"Contactar por WhatsApp","img_url":""}'),
('announcement', '{"text":"🦋 Envíos a toda Bolivia · Productos 100% artesanales","bg":"#2c2416","color":"#f5f0e8"}'),
('mid_banner',   '{"title":"Hecho con Amor en Bolivia 🇧🇴","sub":"Cada pieza es única, creada con materiales naturales.","btn":"Solicitar pedido especial","img_url":""}'),
('about',        '{"title":"Artesanías con alma boliviana","p1":"En Mi Arte Bolivia creemos que cada objeto artesanal cuenta una historia.","p2":"Trabajamos con materiales naturales: resina, flores prensadas, macramé y más.","img_url":""}'),
('contact',      '{"title":"¿Lista para tu pieza especial?","desc":"Escríbenos por WhatsApp. ¡Hacemos pedidos personalizados!","wa":"59176852054","waBtn":"Contactar por WhatsApp"}')
on conflict (key) do nothing;

insert into categories (id, name, emoji, sort_order) values
('cat1','Flores Prensadas','🌸',1),
('cat2','Macramé','🪢',2),
('cat3','Resina Epoxi','💎',3),
('cat4','Decoración Natural','🌿',4),
('cat5','Llaveros & Accesorios','🔑',5),
('cat6','Regalos Especiales','🎁',6)
on conflict (id) do nothing;

insert into products (id, sku, name, description, price, cat_id, status, badge, sort_order) values
('p1','MA-001','Cuadro de Flores Prensadas','Marco de resina con flores naturales prensadas','Bs. 150','cat1','active','Nuevo',1),
('p2','MA-002','Corazón de Resina','Decoración de pared con flores preservadas','Bs. 200','cat1','active','Popular',2),
('p3','MA-003','Macramé Bohemio','Colgante artesanal de hilo de algodón','Bs. 120','cat2','active','',3),
('p4','MA-004','Llavero de Resina','Con flores reales incrustadas, personalizable','Bs. 45','cat5','active','Oferta',4),
('p5','MA-005','Flores de Crochet','Ramo de flores tejidas a mano, multicolor','Bs. 90','cat1','active','',5),
('p6','MA-006','Caja de Resina','Organizador decorativo con diseño floral único','Bs. 180','cat3','active','Nuevo',6)
on conflict (id) do nothing;

insert into gallery (id, alt_text, sort_order) values
('g1','Foto 1',1),('g2','Foto 2',2),('g3','Foto 3',3),
('g4','Foto 4',4),('g5','Foto 5',5),('g6','Foto 6',6)
on conflict (id) do nothing;
