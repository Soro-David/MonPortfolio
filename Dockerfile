FROM php:8.4-fpm

# Dépendances système
RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libonig-dev libxml2-dev libzip-dev \
    default-mysql-client

# Extensions PHP
RUN docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd zip

# Installer Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# Installer Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# Copier Laravel
COPY laravel/ .

# Installer dépendances backend
RUN composer install

# Installer frontend
RUN npm install && npm run build

# Forcer le mode assets buildés en production (désactive Vite dev server)
RUN rm -f /var/www/public/hot

# Config PHP pour les uploads (images, fichiers)
RUN echo "upload_max_filesize = 20M\npost_max_size = 25M\nmax_execution_time = 120\nmax_input_time = 120\nmemory_limit = 256M" \
    > /usr/local/etc/php/conf.d/uploads.ini

CMD ["php-fpm"]
