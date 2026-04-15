# 📝 Aide-Mémoire - Commandes Rapides

## 🚀 Installation Initiale

```bash
# Accéder au container
docker compose exec app bash

# Setup complet
php artisan storage:link
php artisan migrate:fresh
php artisan db:seed --class=AdminSeeder
npm install && npm run build
```

## 🔄 Développement

```bash
# Hot reload (mode dev)
npm run dev

# Build production
npm run build

# Watcher (auto-rebuild)
npm run watch
```

## 🗄️ Base de données

```bash
# Reset complet
php artisan migrate:fresh --seed

# Reset sans seed
php artisan migrate:fresh

# Nouvelle migration
php artisan make:migration create_nom_table

# Rollback dernière migration
php artisan migrate:rollback

# Status des migrations
php artisan migrate:status
```

## 🧹 Cache

```bash
# Tout nettoyer
php artisan optimize:clear

# Ou individuellement:
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear
```

## 👤 Gestion Utilisateurs

```bash
# Ouvrir tinker
php artisan tinker

# Créer un admin
User::create(['name' => 'Admin', 'email' => 'admin@test.com', 'password' => Hash::make('password')]);

# Changer mot de passe
$user = User::find(1);
$user->password = Hash::make('nouveau_mdp');
$user->save();

# Lister les users
User::all();
```

## 📁 Artisan Make

```bash
# Controller
php artisan make:controller NomController

# Model + Migration
php artisan make:model NomModel -m

# Seeder
php artisan make:seeder NomSeeder

# Request (validation)
php artisan make:request NomRequest
```

## 🔍 Debug

```bash
# Voir les logs en temps réel
tail -f storage/logs/laravel.log

# Voir les routes
php artisan route:list

# Filtrer les routes admin
php artisan route:list --path=admin

# Info sur l'app
php artisan about
```

## 📦 Composer

```bash
# Installer dépendances
composer install

# Update packages
composer update

# Dump autoload
composer dump-autoload
```

## 🎨 NPM

```bash
# Installer
npm install

# Dev
npm run dev

# Build
npm run build

# Clean install
rm -rf node_modules package-lock.json
npm install
```

## 🐳 Docker

```bash
# Démarrer les containers
docker-compose up -d

# Arrêter
docker-compose down

# Voir les logs
docker-compose logs -f

# Rebuild
docker-compose up -d --build

# Entrer dans Laravel
docker compose exec app bash

# Entrer dans MySQL
docker-compose exec mysql bash
mysql -u root -p
```

## 🔗 Storage Link

```bash
# Créer le lien symbolique
php artisan storage:link

# Vérifier si le lien existe
ls -la public/storage

# Recréer si nécessaire
rm public/storage
php artisan storage:link
```

## 📊 Base de données (MySQL)

```bash
# Via Docker
docker-compose exec mysql mysql -u root -p

# Une fois connecté:
USE portfolio;
SHOW TABLES;
SELECT * FROM users;
DESCRIBE projects;
```

## 🧪 Tests

```bash
# Tous les tests
php artisan test

# Un fichier spécifique
php artisan test --filter NomTest

# Avec couverture
php artisan test --coverage
```

## 🛠️ Maintenance

```bash
# Mode maintenance ON
php artisan down

# Mode maintenance OFF
php artisan up

# Avec secret pour accès
php artisan down --secret="mon-secret"
# Accès: http://localhost/mon-secret
```

## 📝 Seeding

```bash
# Tous les seeders
php artisan db:seed

# Un seeder spécifique
php artisan db:seed --class=AdminSeeder

# Fresh + seed
php artisan migrate:fresh --seed
```

## 🔐 Permissions (si nécessaire)

```bash
# Donner permissions storage/bootstrap
chmod -R 775 storage bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache
```

## ⚡ Optimisation Production

```bash
# Tout optimiser
php artisan optimize

# Config cache
php artisan config:cache

# Route cache
php artisan route:cache

# View cache
php artisan view:cache
```

## 🎯 Raccourcis Personnalisés

Ajoutez à votre `.bashrc` ou `.zshrc`:

```bash
# Alias Docker
alias dlaravel='docker compose exec app bash'
alias dmysql='docker-compose exec mysql bash'

# Alias Laravel
alias pa='php artisan'
alias pam='php artisan migrate'
alias pamf='php artisan migrate:fresh'
alias pas='php artisan db:seed'
alias pac='php artisan cache:clear'

# Alias NPM
alias nrd='npm run dev'
alias nrb='npm run build'
```

---

💡 **Tip:** Gardez ce fichier ouvert pendant le développement !
