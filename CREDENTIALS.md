# 🔐 Informations de Connexion

## Admin

**URL de connexion:** http://localhost:8081/login

**Identifiants par défaut:**
```
Email: admin@sddavid.com
Mot de passe: Password1234
```

⚠️ **IMPORTANT:** Changez ces identifiants après votre première connexion !

## Routes Principales

### Public
- **Page d'accueil:** http://localhost/
- **Contact (POST):** http://localhost/contact

### Admin (nécessite authentification)
- **Dashboard:** http://localhost/admin/dashboard
- **Projets:** http://localhost/admin/projects
- **Sliders:** http://localhost/admin/sliders
- **Compétences:** http://localhost/admin/skills
- **À propos:** http://localhost/admin/about
- **Messages:** http://localhost/admin/contacts

## Base de Données

### Tables créées
1. **users** - Utilisateurs admin
2. **projects** - Projets du portfolio
3. **sliders** - Slides de la page d'accueil
4. **skills** - Compétences
5. **abouts** - Information À propos
6. **contacts** - Messages de contact

### Seeder Admin
Fichier: `database/seeders/AdminSeeder.php`

Crée un utilisateur avec:
- Nom: Admin
- Email: admin@sddavid.com
- Mot de passe: Password1234 (hashé)

## Stockage des Images

### Emplacement
Les images uploadées sont stockées dans:
```
storage/app/public/
├── projects/     # Images des projets
├── sliders/      # Images des sliders
├── skills/       # Images des compétences
└── about/        # Image À propos
```

### URL publique
Après `php artisan storage:link`, accessibles via:
```
http://localhost/storage/{chemin}
```

Exemple: `http://localhost/storage/projects/mon-image.jpg`

## Tailles d'images recommandées

| Section | Taille recommandée | Format |
|---------|-------------------|--------|
| Projets | 1200x800 px | JPG/PNG |
| Sliders | 1920x1080 px | JPG/PNG |
| Compétences | 200x200 px | PNG (fond transparent) |
| À propos | 800x800 px | JPG/PNG |

Limite: 2MB par image

## Variables d'environnement importantes

Dans `.env`:

```env
APP_NAME="Portfolio"
APP_URL=http://localhost

DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=portfolio
DB_USERNAME=root
DB_PASSWORD=root

FILESYSTEM_DISK=public
```

## Commandes utiles

### Réinitialiser le mot de passe admin
```bash
php artisan tinker

# Dans tinker:
$user = App\Models\User::where('email', 'admin@sddavid.com')->first();
$user->password = Hash::make('nouveau_mot_de_passe');
$user->save();
```

### Créer un nouvel admin
```bash
php artisan tinker

# Dans tinker:
App\Models\User::create([
    'name' => 'Nom Admin',
    'email' => 'nouvel@admin.com',
    'password' => Hash::make('mot_de_passe')
]);
```

### Vider toutes les données et recommencer
```bash
php artisan migrate:fresh --seed
```

## Support

En cas de problème:
1. Consultez les logs: `storage/logs/laravel.log`
2. Vérifiez la console navigateur (F12)
3. Assurez-vous que les migrations sont à jour
4. Vérifiez que le lien storage existe

---

**Date de création:** {{ date('d/m/Y') }}
**Version:** 1.0.0
