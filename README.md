Rails app generated with [lewagon/rails-templates](https://github.com/lewagon/rails-templates), created by the [Le Wagon coding bootcamp](https://www.lewagon.com) team.

## Performance et médias — sujets à rediscuter

1. Déplacer la vidéo d’accueil hors du dyno Heroku, idéalement vers S3 et CloudFront, puis produire des versions MP4/WebM plus légères avec une image `poster`. La vidéo actuelle pèse environ 33 Mo et monopolise un worker pendant son transfert.

2. Générer progressivement les variantes WebP manquantes des anciennes photos avec la tâche `images:generate_derivatives`. Les nouveaux téléversements disposent déjà des formats 480, 960 et 1600 pixels, mais plusieurs anciens fichiers sont encore servis dans leur format original.

3. Placer le bucket S3 privé derrière CloudFront et servir les médias publics avec des URLs stables. Les URLs S3 signées actuelles expirent après 15 minutes, ce qui réduit l’efficacité du cache navigateur malgré les en-têtes de cache longue durée.

4. Réévaluer la configuration Puma selon la mémoire et les connexions PostgreSQL disponibles sur le dyno. Deux workers avec cinq threads pourraient être plus adaptés que les quatre workers par défaut, particulièrement une fois la vidéo sortie du dyno.
