# =============================================================
# MonPortfolio – Image optimisée pour la production
# Base alpine : extensions PHP précompilées (pas de compilation)
# =============================================================
FROM php:8.4-fpm-alpine AS base

# Dépendances système légères (alpine = apk, pas apt)
RUN apk add --no-cache \
    git curl zip unzip \
    libpng-dev libzip-dev oniguruma-dev libxml2-dev \
    mysql-client nginx supervisor

# Extensions PHP via docker-php-ext-install (précompilées dans l'image)
RUN docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd zip opcache

# Config PHP optimisée production
RUN { \
    echo 'upload_max_filesize = 20M'; \
    echo 'post_max_size = 25M'; \
    echo 'max_execution_time = 120'; \
    echo 'memory_limit = 256M'; \
    echo 'opcache.enable=1'; \
    echo 'opcache.memory_consumption=128'; \
    } > /usr/local/etc/php/conf.d/custom.ini

# ======== Composer ========
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# Copier d'abord les fichiers de dépendances pour bénéficier du cache Docker
COPY laravel/composer.json laravel/composer.lock ./
RUN composer install --no-dev --no-interaction --optimize-autoloader --no-scripts

# Copier le reste du projet Laravel
COPY laravel/ .

# Build assets frontend si package.json présent
RUN if [ -f package.json ]; then \
    apk add --no-cache nodejs npm && \
    npm ci --prefer-offline && \
    npm run build && \
    rm -f public/hot; \
    fi

# Permissions storage/cache
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache \
    && chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# ======== Nginx config (pour servir les assets statiques) ========
COPY docker/nginx-portfolio.conf /etc/nginx/http.d/default.conf

# ======== Supervisor config (nginx + php-fpm ensemble) ========
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8000

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
