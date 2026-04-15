# Portfolio Admin - Instructions d'installation et d'utilisation

## 🚀 Installation

### 1. Accéder au container Laravel
```bash
docker compose exec app bash
```

### 2. Créer le lien de stockage
```bash
php artisan storage:link
```

### 3. Lancer les migrations
```bash
php artisan migrate:fresh
```

### 4. Créer l'utilisateur admin
```bash
php artisan db:seed --class=AdminSeeder
```

### 5. Compiler les assets
```bash
npm install
npm run build
```

## 🔑 Connexion Admin

**URL:** `/login`

**Identifiants par défaut:**
- Email: `admin@sddavid.com`
- Mot de passe: `Password1234`

⚠️ **Important:** Changez le mot de passe après votre première connexion !

## 📋 Fonctionnalités Admin

### Dashboard (`/admin/dashboard`)
- Vue d'ensemble avec statistiques
- Accès rapide à toutes les sections

### Gestion des Projets (`/admin/projects`)
- ➕ Créer des projets
- ✏️ Modifier les projets existants
- 🗑️ Supprimer des projets
- 🖼️ Upload d'images
- 🔄 Ordre d'affichage personnalisable

**Champs:**
- Nom du projet *
- Description *
- Public cible *
- Image
- Ordre d'affichage
- Statut actif/inactif

### Gestion des Sliders (`/admin/sliders`)
- ➕ Créer des slides pour la page d'accueil
- 🖼️ Jusqu'à 3 images par slide
- 🎨 Titre, slogan et sous-titre

**Champs:**
- Titre *
- Slogan
- Sous-titre
- Image 1, 2, 3
- Ordre d'affichage
- Statut actif/inactif

### Gestion des Compétences (`/admin/skills`)
- ➕ Ajouter vos compétences
- 🖼️ Icône/image pour chaque compétence
- 📝 Description détaillée

**Champs:**
- Titre *
- Sous-titre
- Description
- Image/Icône
- Ordre d'affichage
- Statut actif/inactif

### Section À propos (`/admin/about`)
- ✏️ Modifier les informations personnelles
- 🖼️ Photo de profil

**Champs:**
- Titre *
- Sous-titre 1
- Sous-titre 2
- Sous-titre 3
- Image

### Messages de Contact (`/admin/contacts`)
- 📧 Consultation des messages reçus
- ✓ Marquer comme lu/non lu
- 🗑️ Supprimer les messages

**Informations affichées:**
- Nom de l'expéditeur
- Email
- Sujet
- Message
- Date de réception
- Statut (lu/non lu)

## 🌐 Site Public

### Page d'accueil (`/`)

**Sections:**

1. **🏠 Accueil/Slider** (ancre: `#accueil`)
   - Affichage des sliders actifs
   - Design esthétique avec loader animé

2. **👤 À propos** (ancre: `#apropos`)
   - Présentation personnelle
   - Image de profil

3. **⚡ Compétences** (ancre: `#competences`)
   - Grille de compétences
   - Icônes et descriptions

4. **💼 Projets** (ancre: `#projets`)
   - Portfolio de projets
   - Cartes avec images

5. **📧 Contact** (ancre: `#contact`)
   - Formulaire de contact
   - Envoi direct en base de données

### Caractéristiques du design:
- ✨ Animation de chargement esthétique (2 secondes)
- 🎯 Menu centré avec liens d'ancrage
- 🎨 Dégradés modernes (purple/pink)
- 📱 Responsive design
- 🔄 Transitions fluides
- 🌊 Scroll smooth

## 🛠️ Commandes utiles

### Développement
```bash
# Compiler les assets en mode dev avec hot reload
npm run dev

# Build production
npm run build

# Nettoyer le cache Laravel
php artisan cache:clear
php artisan config:clear
php artisan view:clear
```

### Base de données
```bash
# Reset complet avec seed
php artisan migrate:fresh --seed

# Créer une nouvelle migration
php artisan make:migration nom_de_la_migration

# Créer un nouveau seeder
php artisan make:seeder NomDuSeeder
```

### Logs
```bash
# Voir les logs Laravel
tail -f storage/logs/laravel.log
```

## 📁 Structure des fichiers

### Backend (Laravel)
```
laravel/
├── app/
│   ├── Http/Controllers/
│   │   ├── Admin/          # Controllers admin
│   │   └── HomeController.php
│   └── Models/             # Project, Slider, Skill, About, Contact
├── database/
│   ├── migrations/         # Tables de la base
│   └── seeders/           # AdminSeeder
└── routes/
    └── web.php            # Routes publiques et admin
```

### Frontend (Vue.js + Inertia)
```
laravel/resources/js/
├── Pages/
│   ├── Admin/             # Pages d'administration
│   │   ├── Dashboard.vue
│   │   ├── Projects/      # CRUD Projets
│   │   ├── Sliders/       # CRUD Sliders
│   │   ├── Skills/        # CRUD Compétences
│   │   ├── About/         # Édition À propos
│   │   └── Contacts/      # Liste messages
│   └── Public/
│       └── Home.vue       # Page d'accueil publique
└── Layouts/
    └── AuthenticatedLayout.vue  # Layout admin
```

## 🎨 Personnalisation

### Couleurs (Tailwind)
Les couleurs principales utilisées sont:
- Purple: `purple-400`, `purple-500`, `purple-900`
- Pink: `pink-400`, `pink-500`
- Slate: `slate-800`, `slate-900`

### Logo/Nom
Modifiez dans:
- `resources/js/Layouts/AuthenticatedLayout.vue`
- `resources/js/Pages/Public/Home.vue`

### Images
Les images uploadées sont stockées dans:
- `storage/app/public/`
- Accessibles via `/storage/` après `php artisan storage:link`

## 🔒 Sécurité

- ✅ Routes admin protégées par authentification
- ✅ Validation des formulaires
- ✅ Protection CSRF
- ✅ Upload d'images sécurisé (max 2MB)

## 📞 Support

Pour toute question ou problème:
1. Vérifiez les logs Laravel: `storage/logs/laravel.log`
2. Vérifiez la console du navigateur (F12)
3. Assurez-vous que les migrations ont été exécutées
4. Vérifiez que le lien de stockage a été créé

## 🎉 Félicitations !

Votre portfolio avec interface d'administration est prêt à l'emploi !

N'oubliez pas de:
- [ ] Changer le mot de passe admin
- [ ] Ajouter vos premiers projets
- [ ] Personnaliser la section À propos
- [ ] Ajouter vos compétences
- [ ] Créer des sliders attractifs
