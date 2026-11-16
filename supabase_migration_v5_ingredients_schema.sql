-- ============================================================================
-- MIGRATION V5 : COLONNE CATÉGORIE, INDEX DE RECHERCHE & UNICITÉ NORMALISÉE
-- ============================================================================

CREATE EXTENSION IF NOT EXISTS pg_trgm;

ALTER TABLE public.ingredients
  ADD COLUMN IF NOT EXISTS category TEXT;

CREATE INDEX IF NOT EXISTS idx_ingredients_category
  ON public.ingredients(category);

CREATE INDEX IF NOT EXISTS idx_ingredients_name_trgm
  ON public.ingredients USING gin (lower(name) gin_trgm_ops);

DO $$ BEGIN IF NOT EXISTS ( SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_ingredients_name_norm' ) THEN IF NOT EXISTS ( SELECT lower(trim(name)) FROM public.ingredients GROUP BY lower(trim(name)) HAVING count(*) > 1 ) THEN CREATE UNIQUE INDEX idx_ingredients_name_norm ON public.ingredients (lower(trim(name))); END IF; END IF; END $$;