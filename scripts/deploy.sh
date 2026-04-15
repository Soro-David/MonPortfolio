#!/bin/bash

##############################################################################
# Script de déploiement automatisé pour MonPortfolio
# Exécuté par GitHub Actions après tests réussis
##############################################################################

set -e  # Exit on error

LOG_FILE="/var/log/portfolio-deploy.log"
APP_PATH="/var/www/portfolio"
BACKUP_PATH="/var/backups/portfolio"
DATE=$(date '+%Y-%m-%d_%H-%M-%S')

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[$(date '+%Y-%m-%d %H:%M:%S')] ERROR:${NC} $1" | tee -a "$LOG_FILE"
    exit 1
}

warning() {
    echo -e "${YELLOW}[$(date '+%Y-%m-%d %H:%M:%S')] WARNING:${NC} $1" | tee -a "$LOG_FILE"
}

log "=========================================="
log "Démarrage du déploiement - $DATE"
log "=========================================="

# 1. Backup de l'application actuelle
log "📦 Sauvegarde de l'application actuelle..."
if [ -d "$APP_PATH" ]; then
    mkdir -p "$BACKUP_PATH"
    tar -czf "$BACKUP_PATH/backup-$DATE.tar.gz" "$APP_PATH" || warning "Backup failed, continuant..."
    log "✅ Backup créé: $BACKUP_PATH/backup-$DATE.tar.gz"
fi

# 2. Arrêter les containers
log "🛑 Arrêt des containers Docker..."
cd "$APP_PATH"
docker compose down || warning "Erreur lors de l'arrêt des containers"

# 3. Mettre à jour les fichiers
log "📥 Mise à jour des fichiers de l'application..."
git pull origin main || error "Échec du pull git"

# 4. Créer le fichier .env s'il n'existe pas
log "⚙️ Configuration de l'environnement..."
if [ ! -f "$APP_PATH/laravel/.env" ]; then
    cp "$APP_PATH/laravel/.env.example" "$APP_PATH/laravel/.env"
    log "Fichier .env créé depuis le template"
fi

# 5. Construire et démarrer les containers
log "🐳 Démarrage des containers Docker..."
docker compose build --no-cache || error "Erreur lors de la construction Docker"
docker compose up -d || error "Erreur lors du lancement des containers"

# Attendre que MySQL soit prêt
log "⏳ Attente du démarrage de MySQL..."
sleep 15

# 6. Exécuter les migrations
log "📊 Exécution des migrations..."
docker compose exec -T app php artisan migrate --force || warning "Migrations échouées"

# 7. Exécuter les seeders
log "🌱 Exécution des seeders..."
docker compose exec -T app php artisan db:seed || warning "Seeders échouées"

# 8. Clear cache
log "🧹 Nettoyage du cache..."
docker compose exec -T app php artisan cache:clear || warning "Erreur clear cache"
docker compose exec -T app php artisan config:cache || warning "Erreur config cache"
docker compose exec -T app php artisan view:cache || warning "Erreur view cache"

# 9. Permissions
log "🔐 Configuration des permissions..."
docker compose exec -T app chgrp -R www-data storage bootstrap/cache
docker compose exec -T app chmod -R ug+rwx storage bootstrap/cache

# 10. Build frontend si nécessaire
log "🎨 Compilation des assets frontend..."
docker compose exec -T app npm run build || warning "Erreur build frontend"

# 11. Vérification de la santé
log "🏥 Vérification de la santé de l'application..."
sleep 5

# Vérifier que Nginx respond
if curl -f http://localhost:8081 > /dev/null 2>&1; then
    log "✅ Nginx répond correctement"
else
    warning "Nginx ne répond pas correctement"
fi

# 12. Cleanup
log "🧹 Nettoyage des anciens backups..."
find "$BACKUP_PATH" -name "backup-*.tar.gz" -mtime +7 -delete
log "Anciens backups supprimés (plus de 7 jours)"

log "=========================================="
log "✅ Déploiement terminé avec succès!"
log "=========================================="
log "Application disponible à: http://$APP_HOST"
log "Date de déploiement: $DATE"
log ""

# Envoyer une notification (optionnel)
if [ ! -z "$SLACK_WEBHOOK" ]; then
    curl -X POST "$SLACK_WEBHOOK" \
        -H 'Content-Type: application/json' \
        -d "{
            \"text\": \"✅ Déploiement Portfolio réussi\",
            \"blocks\": [{
                \"type\": \"section\",
                \"text\": {
                    \"type\": \"mrkdwn\",
                    \"text\": \"*Déploiement réussi*\n\`$DATE\`\"
                }
            }]
        }" || warning "Erreur envoi notification Slack"
fi

exit 0
