# Mon carnet de recettes

Application statique (HTML/CSS/JS) hébergée sur GitHub Pages. Toutes les données (recettes, ingrédients, photos) vivent dans Supabase : ajouter, modifier ou supprimer quoi que ce soit se fait dans l’application, sans toucher au code ni republier.

## 1. Configurer Supabase

1. Créez un compte gratuit sur https://supabase.com, puis **New project** (choisissez une région européenne).
2. Menu **SQL Editor** > **New query** : collez tout le contenu de `supabase.sql` > **Run**. Cela crée les tables, les règles d’accès et le bucket de photos `recipe-photos`.
3. Menu **Project Settings > API** : copiez la **Project URL** et la clé **anon public**.
4. Ouvrez `config.js` et remplacez les deux valeurs.

## 2. Tester en local (facultatif)

Dans le dossier : `python3 -m http.server 8000`, puis ouvrez http://localhost:8000.

## 3. Déployer sur GitHub Pages

1. Créez un dépôt GitHub et envoyez-y les 4 fichiers (`index.html`, `config.js`, `supabase.sql`, `README.md`).
2. Dépôt > **Settings > Pages** > Source : **Deploy from a branch**, branche `main`, dossier `/ (root)` > Save.
3. Après une minute, le site est disponible sur `https://VOTRE-PSEUDO.github.io/NOM-DU-DEPOT/`.

Cette publication ne se fait qu’une fois. Ensuite, tout se gère depuis le site.

## Ordre conseillé pour le premier test

1. Onglet **Ingrédients** : créez riz, poulet, crème fraîche…
2. **Ajouter une recette** : photo, ingrédients, quantités, étapes. Les calories se calculent en direct.
3. Retour sur **Recettes** : testez la recherche « poulet, riz ».

## Sécurité (à connaître)

Sans connexion, quiconque connaît l’adresse du site et la clé `anon` peut modifier les données. Pour un usage personnel, gardez l’URL pour vous. Si vous voulez la verrouiller plus tard, il suffira d’ajouter une authentification Supabase (un seul compte) et de remplacer les politiques `to anon` par `to authenticated`.

## Fonctionnement

- `recipes` : titre, photo, temps, portions, étapes, notes.
- `ingredients` : nom, unité (100 g ou 100 ml), kcal, protéines, glucides, lipides.
- `recipe_ingredients` : lie une recette à un ingrédient avec une quantité. Les valeurs nutritionnelles sont calculées à chaque affichage à partir de la bibliothèque, donc toujours à jour.
- Supprimer une recette supprime ses lignes d’ingrédients et sa photo. Un ingrédient utilisé dans une recette ne peut pas être supprimé (message explicatif).

## Mise à jour V2 (catégories, recherche par nom, ingrédients « par quantité »)

1. **Avant tout**, exécutez `supabase_migration_v2.sql` dans Supabase > SQL Editor > Run. Vos recettes et ingrédients existants sont conservés.
2. Remplacez `index.html` dans votre dépôt GitHub (gardez votre `config.js`).
3. Les anciennes recettes apparaissent dans un filtre « À classer » : ouvrez-les, cliquez sur **Modifier**, choisissez une catégorie et enregistrez. (Le filtre disparaît quand tout est classé.)
4. Nouvelle installation : exécutez `supabase.sql` puis `supabase_migration_v2.sql`.

## Mise à jour V3 (ingrédients « par quantité » simplifiés, cartes mobiles)

1. Exécutez `supabase_migration_v3.sql` dans Supabase > SQL Editor (sans perte de données).
2. Remplacez `index.html` dans votre dépôt GitHub.
3. En mode « Par quantité », les valeurs saisies correspondent à **1 unité de l’ingrédient** (1 aubergine, 1 œuf…). Dans la recette, saisissez 0,5, 1, 2… ; le nom de l’ingrédient fait office d’unité.
