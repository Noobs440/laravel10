# Étape 1 : Choisir une image PHP officielle avec Apache
FROM php:8.1-apache

# Étape 2 : Installer les dépendances nécessaires
RUN apt-get update && apt-get install -y \
    libzip-dev zip unzip git curl libonig-dev libpng-dev libxml2-dev libpq-dev \
    && docker-php-ext-install pdo pdo_mysql zip mbstring exif pcntl bcmath gd

# Étape 3 : Installer Composer (gestionnaire de dépendances PHP)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Étape 4 : Copier tout le projet dans le conteneur
COPY . /var/www/html

# Étape 5 : Définir le répertoire de travail
WORKDIR /var/www/html

# Étape 6 : Installer les dépendances PHP via Composer
RUN composer install --no-dev --optimize-autoloader

# Étape 7 : Donner les bonnes permissions (important)
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Étape 8 : Exposer le port 80
EXPOSE 80

# Étape 9 : Lancer Apache en mode foreground
CMD ["apache2-foreground"]
