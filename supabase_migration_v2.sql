-- MIGRATION V2 : catégories + ingrédients "par quantité"
-- À exécuter UNE fois dans Supabase > SQL Editor. Aucune donnée n'est supprimée ni modifiée :
-- les recettes et ingrédients existants gardent toutes leurs valeurs.
begin;

-- 1. Catégorie des recettes (une seule par recette).
--    Les recettes existantes restent sans catégorie (NULL) : elles apparaissent dans un filtre
--    "À classer" tant que vous ne leur avez pas attribué de catégorie via "Modifier".
alter table recipes add column if not exists category text;
alter table recipes drop constraint if exists recipes_category_check;
alter table recipes add constraint recipes_category_check
  check (category is null or category in ('Apéro','Entrée','Plat','Dessert','Boissons'));

-- 2. Mode "Par quantité" : unit = 'piece' + libellé de l'unité de référence (ex. "concombre").
--    Les valeurs nutritionnelles correspondent alors à 1 unité (et non plus à 100 g / 100 ml).
alter table ingredients add column if not exists unit_label text;
alter table ingredients drop constraint if exists ingredients_unit_check;
alter table ingredients add constraint ingredients_unit_check check (unit in ('g','ml','piece'));
alter table ingredients drop constraint if exists ingredients_piece_label_check;
alter table ingredients add constraint ingredients_piece_label_check
  check (unit <> 'piece' or (unit_label is not null and length(trim(unit_label)) > 0));

commit;

-- OPTIONNEL : classer d'un coup toutes les recettes existantes (modifiable ensuite recette par recette).
-- update recipes set category = 'Plat' where category is null;
