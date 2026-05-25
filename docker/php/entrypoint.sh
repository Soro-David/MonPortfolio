#!/bin/sh
set -e

echo "⏳  Attente de MySQL sur ${DB_HOST}:${DB_PORT:-3306}..."
until nc -z "${DB_HOST:-mysql}" "${DB_PORT:-3306}"; do
  sleep 2
done
echo "✅  MySQL disponible."

cd /var/www/html

# Installer les dépendances PHP si vendor/ absent ou incomplet
if [ ! -f vendor/autoload.php ]; then
  echo "📦  Installation des dépendances Composer..."
  composer install --no-interaction --optimize-autoloader
fi

# Générer la clé si elle n'existe pas
php artisan key:generate --no-interaction --force 2>/dev/null || true

# Permissions
chmod -R 775 storage bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache 2>/dev/null || true

# Migrations
echo "🗄️   Lancement des migrations..."
php artisan migrate --force --no-interaction

# Lien symbolique storage
php artisan storage:link --force 2>/dev/null || true

echo "🚀  Démarrage de php-fpm (Force 0.0.0.0)..."
echo "[www]" > /usr/local/etc/php-fpm.d/99-custom.conf
echo "listen = 0.0.0.0:9000" >> /usr/local/etc/php-fpm.d/99-custom.conf
exec php-fpm
