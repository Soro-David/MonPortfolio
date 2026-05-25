#!/bin/bash
# ==============================================================================
# Script de commandes shell pour le déploiement et l'administration du VPS
# ==============================================================================

ACTION=$1

echo "========================================"
echo " MonPortfolio - Gestion & Déploiement"
echo "========================================"

case "$ACTION" in
  "dev")
    echo "▶ Démarrage de l'environnement LOCAL..."
    docker compose -f docker-compose.yml up -d --build
    echo "✅ Environnement local démarré sur http://localhost:8000"
    ;;
    
  "prod")
    echo "▶ Démarrage de l'environnement de PRODUCTION..."
    # Assurez-vous d'avoir configuré le fichier .env.production dans laravel/
    docker compose -f docker-compose.prod.yml up -d --build
    echo "✅ Environnement de production démarré sur le port 80"
    ;;
    
  "build-assets")
    echo "▶ Génération des assets de production (Vite)..."
    cd laravel
    npm install
    npm run build
    cd ..
    echo "✅ Assets générés."
    ;;
    
  "deploy")
    echo "▶ Lancement du DÉPLOIEMENT MANUEL sur le VPS..."
    git pull origin main

    # Toujours revenir à la racine du projet avant d'appeler docker compose
    PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"

    echo "1. Build des assets Javascript/CSS..."
    # Sous-shell pour que le 'cd laravel' n'affecte pas le répertoire courant
    (cd "$PROJECT_ROOT/laravel" && npm install && npm run build) || echo "⚠ npm build ignoré (npm absent sur ce serveur)"

    echo "2. Redémarrage des conteneurs en production..."
    docker compose -f "$PROJECT_ROOT/docker-compose.prod.yml" up -d --build

    echo "3. Installation des dépendances PHP et optimisation..."
    docker compose -f "$PROJECT_ROOT/docker-compose.prod.yml" exec -T app composer install --optimize-autoloader --no-dev
    docker compose -f "$PROJECT_ROOT/docker-compose.prod.yml" exec -T app php artisan config:cache
    docker compose -f "$PROJECT_ROOT/docker-compose.prod.yml" exec -T app php artisan route:cache
    docker compose -f "$PROJECT_ROOT/docker-compose.prod.yml" exec -T app php artisan view:cache

    echo "4. Exécution des migrations et seeders..."
    docker compose -f "$PROJECT_ROOT/docker-compose.prod.yml" exec -T app php artisan migrate --force
    docker compose -f "$PROJECT_ROOT/docker-compose.prod.yml" exec -T app php artisan db:seed --force

    echo "✅ Déploiement terminé avec succès !"
    ;;
    
  "stop")
    echo "▶ Arrêt de tous les environnements..."
    docker compose -f docker-compose.yml down
    docker compose -f docker-compose.prod.yml down
    ;;
    
  *)
    echo "Usage: ./run.sh {dev|prod|build-assets|deploy|stop}"
    echo ""
    echo "Commandes:"
    echo "  dev          : Lance la petite configuration (local avec Vite HMR)."
    echo "  prod         : Lance la grande configuration (production sans Vite)."
    echo "  build-assets : Recompile les assets Vue.js pour la production."
    echo "  deploy       : Fait un pull du code, build les assets, et relance la stack prod."
    echo "  stop         : Arrête tous les conteneurs (local et prod)."
    ;;
esac
