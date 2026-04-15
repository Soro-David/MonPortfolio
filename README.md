# 🎨 Portfolio avec Interface d'Administration

Système complet de gestion de portfolio avec interface d'administration intuitive et page publique moderne.

## ✨ Fonctionnalités

### 🔐 Administration
- **Dashboard** avec statistiques en temps réel
- **Gestion des projets** (CRUD complet avec images)
- **Gestion des sliders** (page d'accueil avec 3 images par slide)
- **Gestion des compétences** (avec icônes et descriptions)
- **Section À propos** (personnalisation complète)
- **Messages de contact** (consultation et gestion)

### 🌐 Site Public
- **Design moderne** avec dégradés purple/pink
- **Animation de chargement** esthétique
- **Menu centré** avec liens d'ancrage (#accueil, #apropos, etc.)
- **Sections dynamiques** alimentées par l'admin
- **Formulaire de contact** fonctionnel
- **Responsive design** mobile-first

## 🚀 Installation Rapide

### Prérequis
- Docker & Docker Compose
- Git

### Dans le container Laravel

```bash
# 1. Accéder au container
docker compose exec app bash

# 2. Lancer le script de setup
cd /var/www/html
chmod +x setup.sh
./setup.sh
```

Ou manuellement:

```bash
# Lien de stockage
php artisan storage:link

# Migrations
php artisan migrate:fresh

# Créer l'admin
php artisan db:seed --class=AdminSeeder

# Assets
npm install && npm run build
```

## 🔑 Connexion

**URL Admin:** http://localhost:8081/login

**Identifiants:**
- Email: `admin@sddavid.com`
- Mot de passe: `Password1234`

⚠️ **Changez le mot de passe après la première connexion !**

## 📚 Documentation Complète

Consultez [INSTALLATION.md](INSTALLATION.md) pour:
- Instructions détaillées
- Guide d'utilisation de chaque section
- Structure des fichiers
- Personnalisation
- Dépannage

## 🛠️ Stack Technique

### Backend
- **Laravel 13** - Framework PHP
- **Inertia.js** - SSR React/Vue
- **MySQL** - Base de données

### Frontend
- **Vue.js 3** - Framework JavaScript
- **Tailwind CSS** - Styling
- **Vite** - Build tool

### Infrastructure
- **Docker** - Containerisation
- **Nginx** - Serveur web

## 📁 Structure du Projet

```
MonPortfolio/
├── docker/              # Configuration Docker
├── laravel/
│   ├── app/
│   │   ├── Http/Controllers/
│   │   │   ├── Admin/          # Controllers admin
│   │   │   └── HomeController.php
│   │   └── Models/             # Models Eloquent
│   ├── database/
│   │   ├── migrations/         # Schémas de tables
│   │   └── seeders/            # Données initiales
│   ├── resources/
│   │   └── js/
│   │       ├── Pages/
│   │       │   ├── Admin/      # Vues admin
│   │       │   └── Public/     # Vues publiques
│   │       └── Layouts/
│   └── routes/
│       └── web.php             # Définition des routes
├── docker-compose.yml
└── INSTALLATION.md
```

## 🎨 Sections Admin

| Section | Route | Fonctionnalités |
|---------|-------|----------------|
| Dashboard | `/admin/dashboard` | Vue d'ensemble, statistiques |
| Projets | `/admin/projects` | Créer, modifier, supprimer |
| Sliders | `/admin/sliders` | Gérer les slides d'accueil |
| Compétences | `/admin/skills` | Ajouter vos skills |
| À propos | `/admin/about` | Personnaliser votre présentation |
| Messages | `/admin/contacts` | Consulter les contacts |

## 🌟 Sections Publiques

| Section | Ancre | Description |
|---------|-------|-------------|
| Accueil | `#accueil` | Slider principal avec images |
| À propos | `#apropos` | Présentation personnelle |
| Compétences | `#competences` | Grille de compétences |
| Projets | `#projets` | Portfolio de projets |
| Contact | `#contact` | Formulaire de contact |

## 🔄 Développement

```bash
# Mode développement avec hot-reload
npm run dev

# Build production
npm run build

# Nettoyer le cache
php artisan cache:clear
php artisan config:clear
```

## 📸 Captures d'écran

### Page d'accueil
- Animation de chargement avec spinner double
- Design moderne avec dégradés
- Menu centré avec emojis

### Dashboard Admin
- Cartes statistiques colorées
- Accès rapide aux sections
- Design épuré et professionnel

## 🎯 Prochaines étapes

Après l'installation:

1. ✅ Connectez-vous à l'admin
2. ✅ Changez le mot de passe
3. ✅ Ajoutez vos projets
4. ✅ Créez des sliders
5. ✅ Complétez vos compétences
6. ✅ Personnalisez la section À propos
7. ✅ Testez le formulaire de contact

## 🐛 Dépannage

### Les images ne s'affichent pas
```bash
php artisan storage:link
```

### Erreur 404 sur les routes
```bash
php artisan route:clear
php artisan config:clear
```

### Assets non compilés
```bash
npm install
npm run build
```

## 📄 Licence

Ce projet est un portfolio personnel. Libre d'utilisation et de modification.

## 👨‍💻 Auteur

**Soro Dognenin David**

---

**Bon développement ! 🚀**
