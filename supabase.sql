-- À coller dans Supabase > SQL Editor > Run (une seule fois)
create extension if not exists pgcrypto;

create table ingredients (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  unit text not null default 'g' check (unit in ('g','ml')), -- valeurs pour 100 g ou 100 ml
  kcal numeric not null default 0,
  protein numeric not null default 0,
  carbs numeric not null default 0,
  fat numeric not null default 0,
  created_at timestamptz not null default now()
);

create table recipes (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  cover_url text,
  cover_path text,               -- chemin dans le bucket, pour remplacer/supprimer la photo
  prep_min int not null default 0,
  cook_min int not null default 0,
  servings int not null default 1 check (servings > 0),
  steps text[] not null default '{}',
  notes text,
  created_at timestamptz not null default now()
);

create table recipe_ingredients (
  id uuid primary key default gen_random_uuid(),
  recipe_id uuid not null references recipes(id) on delete cascade,
  ingredient_id uuid not null references ingredients(id) on delete restrict,
  quantity numeric not null check (quantity > 0),  -- en g ou ml selon l'ingrédient
  position int not null default 0
);

-- Application mono-utilisatrice sans connexion : accès ouvert via la clé "anon".
alter table ingredients enable row level security;
alter table recipes enable row level security;
alter table recipe_ingredients enable row level security;
create policy "acces_ingredients" on ingredients for all to anon using (true) with check (true);
create policy "acces_recipes" on recipes for all to anon using (true) with check (true);
create policy "acces_recipe_ingredients" on recipe_ingredients for all to anon using (true) with check (true);

-- Photos
insert into storage.buckets (id, name, public) values ('recipe-photos', 'recipe-photos', true)
on conflict (id) do nothing;
create policy "acces_photos" on storage.objects for all to anon
  using (bucket_id = 'recipe-photos') with check (bucket_id = 'recipe-photos');
