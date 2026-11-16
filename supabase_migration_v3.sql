-- MIGRATION V3 : le mode "Par quantité" n'a plus d'"unité de référence" séparée.
-- Les valeurs nutritionnelles correspondent à 1 unité de l'ingrédient (le nom définit l'unité).
-- À exécuter UNE fois dans Supabase > SQL Editor. Script répétable et sans perte de données :
-- aucune table, recette ou ingrédient n'est supprimé ni modifié.
begin;

-- Sécurité : si la V2 n'a jamais été exécutée, on s'assure que le mode 'piece' est accepté.
alter table ingredients add column if not exists unit_label text;   -- colonne conservée (anciennes données), plus utilisée
alter table ingredients drop constraint if exists ingredients_unit_check;
alter table ingredients add constraint ingredients_unit_check check (unit in ('g','ml','piece'));

-- Cette règle imposait un libellé pour chaque ingrédient "par quantité" : elle est retirée.
alter table ingredients drop constraint if exists ingredients_piece_label_check;

commit;
