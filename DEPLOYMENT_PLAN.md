# 🚀 Plan de Déploiement - MonPortfolio sur VPS

## 📋 Table des matières
1. [Architecture CI/CD](#architecture-cicd)
2. [Configuration VPS](#configuration-vps)
3. [Configuration GitHub](#configuration-github)
4. [Flux de déploiement](#flux-de-déploiement)
5. [Troubleshooting](#troubleshooting)
6. [Rollback](#rollback)

---

## Architecture CI/CD

### 🔄 Flux général

```
Push sur main → Tests → Build Docker → Deploy VPS
     ↓              ↓          ↓           ↓
  GitHub      Ubuntu       Registry    SSH Script
             Runner                    Exécution
```

### Étapes du pipeline:

1. **Tests (test)**
   - Checkout du code
   - Setup PHP 8.4 + dépendances
   - Setup Node.js 20
   - Installation dépendances PHP/NPM
   - Build frontend
   - Tests unitaires
   - Durée: ~5-10 minutes

2. **Build Docker (build-and-push)**
   - Construction de l'image Docker
   - Push vers GitHub Container Registry
   - Durée: ~3-5 minutes

3. **Déploiement VPS (deploy)**
   - Connexion SSH au VPS
   - Exécution script de déploiement
   - Durée: ~5-10 minutes

---

## Configuration VPS

### 1️⃣ Prérequis sur le VPS

#### A. Installation de Docker et Docker Compose

```bash
# Mettre à jour le système
sudo apt update && sudo apt upgrade -y

# Installer Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Installer Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Ajouter l'utilisateur au groupe docker
sudo usermod -aG docker $USER
newgrp docker

# Vérifier l'installation
docker --version
docker compose --version
```

#### B. Installation de Git

```bash
sudo apt install -y git
git config --global user.email "your-email@example.com"
git config --global user.name "Your Name"
```

#### C. Configuration SSH

```bash
# Créer le dossier .ssh si n'existe pas
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Ajouter votre clé SSH publique (vous la générerez plus tard)
# echo "votre_clé_publique" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

#### D. Créer les répertoires nécessaires

```bash
# Répertoire de l'application
sudo mkdir -p /var/www/portfolio
sudo chown $USER:$USER /var/www/portfolio

# Répertoires de backups et logs
sudo mkdir -p /var/backups/portfolio
sudo mkdir -p /var/log/portfolio
sudo chown $USER:$USER /var/backups/portfolio
sudo chown $USER:$USER /var/log/portfolio

# Répertoire pour le fichier .env
mkdir -p /var/www/portfolio/laravel
```

### 2️⃣ Cloner le repository

```bash
cd /var/www
git clone https://github.com/Soro-David/MonPortfolio.git portfolio
cd portfolio

# Créer le fichier .env
cp laravel/.env.example laravel/.env

# Éditer .env avec vos paramètres
nano laravel/.env
```

**Paramètres importants à configurer dans `.env`:**

```env
APP_NAME=MonPortfolio
APP_ENV=production
APP_DEBUG=false
APP_URL=https://votredomaine.com

DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=portfolio
DB_USERNAME=portfolio_user
DB_PASSWORD=votre_mot_de_passe_secure

MAIL_MAILER=smtp
MAIL_HOST=smtp.mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=votre_username
MAIL_PASSWORD=votre_password

# Pour les uploads de fichiers
FILESYSTEM_DISK=public
```

### 3️⃣ Configuration DNS

Si vous utilisez un domaine:

```bash
# Pointer votre domaine vers l'IP du VPS
# Dans votre registraire de domaine:
A record: votredomaine.com → IP_DU_VPS
```

### 4️⃣ Génération de clé SSH pour GitHub Actions

Sur votre machine locale:

```bash
# Générer une paire de clés SSH
ssh-keygen -t ed25519 -C "github-actions-portfolio" -f ./github_actions_key -N ""

# Afficher les clés
cat ./github_actions_key           # Clé privée (pour GitHub Secrets)
cat ./github_actions_key.pub       # Clé publique (pour VPS)
```

Sur le VPS:

```bash
# Ajouter la clé publique
echo "contenu_de_github_actions_key.pub" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# Vérifier la connexion (localement)
ssh -i ./github_actions_key -p 22 username@VPS_IP
```

### 5️⃣ Configuration Docker Compose sur VPS

Assurez-vous que le `docker-compose.yml` est prêt. Vous pouvez ajouter un fichier `.env` spécifique pour le VPS:

```bash
# Créer un fichier docker-compose.override.yml pour l'environnement de production
cat > /var/www/portfolio/docker-compose.override.yml << 'EOF'
version: '3.8'
services:
  nginx:
    restart: always
    ports:
      - "80:80"
      - "443:443"
    # Ajouter certificat SSL si disponible
    # volumes:
    #   - /etc/letsencrypt:/etc/letsencrypt:ro

  db:
    restart: always
    # Ajouter un volume pour la persistance des données
    volumes:
      - db_data:/var/lib/mysql

  app:
    restart: always

volumes:
  db_data:
EOF
```

---

## Configuration GitHub

### 1️⃣ Ajouter les Secrets dans GitHub

1. Accédez à: **Settings → Secrets and variables → Actions**
2. Cliquez sur **New repository secret**
3. Ajoutez les secrets suivants:

| Secret | Valeur | Description |
|--------|--------|-------------|
| `VPS_HOST` | `IP_ou_domaine_VPS` | Adresse IP ou domaine du VPS |
| `VPS_USER` | `nom_utilisateur` | Utilisateur SSH sur le VPS |
| `VPS_SSH_KEY` | Contenu de `github_actions_key` | Clé SSH privée (sans passphrase) |
| `VPS_SSH_PORT` | `22` | Port SSH (par défaut 22) |
| `VPS_APP_PATH` | `/var/www/portfolio` | Chemin d'application sur le VPS |
| `SLACK_WEBHOOK` | (optionnel) | URL webhook pour notifications Slack |

### 2️⃣ Exemple d'ajout de secrets via CLI

```bash
# Vous pouvez aussi utiliser GitHub CLI
gh secret set VPS_HOST -b "IP_du_VPS"
gh secret set VPS_USER -b "username"
gh secret set VPS_SSH_KEY < ./github_actions_key
gh secret set VPS_SSH_PORT -b "22"
gh secret set VPS_APP_PATH -b "/var/www/portfolio"
```

### 3️⃣ Sécurité des Secrets

⚠️ **Important:**
- Ne jamais commiter les clés privées dans le repository
- Régulièrement rotationner les clés SSH
- Utiliser des mots de passe forts pour les bases de données
- Activer l'authentification 2FA sur GitHub

---

## Flux de Déploiement

### 📊 Processus complet

```
1. Développement local
   └─ git commit & git push origin main
   
2. GitHub Actions déclenché
   ├─ Tests
   │  ├─ PHP dependencies
   │  ├─ Node dependencies
   │  ├─ Build frontend
   │  └─ PHPUnit tests
   ├─ Build Docker
   │  └─ Push to GHCR
   └─ Deploy
      ├─ SSH connect
      ├─ Git pull
      ├─ Docker pull
      └─ Exécuter deploy.sh
         ├─ Backup
         ├─ Docker compose up
         ├─ Migrations
         ├─ Seeders
         ├─ Cache clear
         └─ Health check
```

### Visualiser le pipeline

1. Accédez à: **Actions** dans votre repository GitHub
2. Cliquez sur le dernier commit
3. Observez les étapes en temps réel

---

## Vérification après déploiement

### 1️⃣ Vérifier les containers

```bash
# Sur le VPS
cd /var/www/portfolio
docker compose ps

# Résultat attendu:
# NAME      STATUS
# laravel   Up 2 minutes
# nginx     Up 2 minutes
# mysql     Up 2 minutes
# node      Up 2 minutes
```

### 2️⃣ Vérifier les logs

```bash
# Logs Laravel
docker compose logs app

# Logs Nginx
docker compose logs nginx

# Logs MySQL
docker compose logs db

# Logs complets
docker compose logs -f
```

### 3️⃣ Tester l'application

```bash
# Tester HTTP
curl http://localhost:8081

# Vérifier la base de données
docker compose exec db mysql -u portfolio_user -p portfolio -e "SELECT 1;"

# Vérifier les migrations
docker compose exec app php artisan migrate:status
```

### 4️⃣ Vérifier les backups

```bash
ls -lh /var/backups/portfolio/
# Affiche les archives de backup avec timestamps
```

---

## Troubleshooting

### ❌ Le déploiement échoue sur "Tests"

**Symptôme:** Erreur dans la phase de tests

**Solutions:**
```bash
# Vérifier le fichier .env.example
cat laravel/.env.example

# Vérifier la version PHP requise
grep -r "php" laravel/composer.json

# Vérifier les extensions PHP nécessaires
grep -r "ext-" laravel/composer.json
```

### ❌ Erreur de connexion SSH

**Symptôme:** `Permission denied (publickey)`

**Solutions:**
```bash
# Vérifier sur le VPS:
cat ~/.ssh/authorized_keys | grep "github-actions"

# Vérifier les permissions:
ls -la ~/.ssh/
# Doit être: drwx------ et fichiers 600

# Régénérer la clé si nécessaire:
ssh-keygen -t ed25519 -C "github-actions-portfolio" -f ./github_actions_key -N ""
# Mettre à jour le secret VPS_SSH_KEY dans GitHub
```

### ❌ Docker build échoue

**Symptôme:** Erreur lors du build Docker

**Solutions:**
```bash
# Sur le VPS, tester le build local:
cd /var/www/portfolio
docker compose build --no-cache

# Vérifier l'espace disque:
df -h

# Vérifier les logs Docker:
docker logs laravel
```

### ❌ Migrations échouent

**Symptôme:** `SQLSTATE[HY000]: General error`

**Solutions:**
```bash
# Sur le VPS:
docker compose exec db mysql -u root -proot

# Dans MySQL:
SHOW DATABASES;
USE portfolio;
SHOW TABLES;

# Vérifier l'utilisateur de base de données:
SELECT user FROM mysql.user WHERE user='portfolio_user';
```

### ❌ Nginx ne répond pas

**Symptôme:** Timeout ou Connection refused

**Solutions:**
```bash
# Vérifier l'état de Nginx:
docker compose ps nginx

# Vérifier les logs Nginx:
docker compose logs nginx

# Vérifier la configuration Nginx:
docker compose exec nginx cat /etc/nginx/conf.d/default.conf

# Redémarrer le service:
docker compose restart nginx
```

### ✅ Réinitialiser complètement

Si tout est cassé, réinitialiser:

```bash
cd /var/www/portfolio

# Arrêter et supprimer tout
docker compose down -v

# Nettoyer les fichiers
rm -rf storage/logs/*
rm -rf bootstrap/cache/*

# Redémarrer
docker compose up -d
docker compose exec app php artisan migrate:fresh --seed
```

---

## Rollback

### 🔄 Restaurer une version précédente

#### Méthode 1: Via GitHub Actions (recommandé)

```bash
# Revenir au commit précédent
git revert HEAD
git push origin main
# Cela créera un nouveau commit qui annule les modifications

# Ou réinitialiser à un commit spécifique
git reset --hard COMMIT_HASH
git push origin main --force-with-lease
```

#### Méthode 2: Via Backup tar.gz

```bash
# Sur le VPS:
cd /var/www

# Lister les backups disponibles
ls -lh /var/backups/portfolio/

# Restaurer un backup
tar -xzf /var/backups/portfolio/backup-2026-04-15_14-30-00.tar.gz -C /

# Redémarrer l'application
cd /var/www/portfolio
docker compose down
docker compose up -d
```

#### Méthode 3: Git revert

```bash
# Identifier le commit problématique
git log --oneline

# Annuler le commit (en créant un nouveau commit)
git revert COMMIT_HASH
git push origin main
```

---

## 📝 Commandes utiles

### GitHub Actions

```bash
# Vérifier le statut des workflows
gh run list --repo Soro-David/MonPortfolio

# Afficher les détails d'une exécution
gh run view <RUN_ID>

# Voir les logs d'une exécution
gh run view <RUN_ID> --log

# Relancer un workflow échoué
gh run rerun <RUN_ID>
```

### VPS Management

```bash
# Arrêter proprement l'application
cd /var/www/portfolio
docker compose stop

# Démarrer l'application
docker compose start

# Redémarrer l'application
docker compose restart

# Voir l'état des containers
docker compose ps

# Exécuter une commande dans un container
docker compose exec app php artisan command-name

# Voir tous les logs
docker compose logs -f

# Nettoyer les images inutilisées
docker image prune -a

# Vérifier l'utilisation du disque
docker system df
```

### Maintenance

```bash
# Backup manuel
cd /var/www/portfolio
tar -czf /var/backups/portfolio/manual-backup-$(date +%Y-%m-%d_%H-%M-%S).tar.gz .

# Nettoyer les anciens backups (+30 jours)
find /var/backups/portfolio -name "*.tar.gz" -mtime +30 -delete

# Vérifier les mises à jour Laravel
docker compose exec app composer outdated

# Vérifier les mises à jour NPM
docker compose exec app npm outdated

# Mettre à jour les dépendances
docker compose exec app composer update --no-scripts
docker compose exec app npm update
```

---

## 🎯 Checklist de déploiement initial

- [ ] VPS configuré avec Docker et Docker Compose
- [ ] Git repository cloné sur le VPS
- [ ] Fichier `.env` configuré sur le VPS
- [ ] Répertoires de backup créés
- [ ] Clé SSH générée et configurée
- [ ] Secrets ajoutés à GitHub
- [ ] Premier déploiement testé avec `git push`
- [ ] Application accessible via navigateur
- [ ] Logs vérifiés (pas d'erreurs)
- [ ] Backups vérifiés
- [ ] Notifications Slack configurées (optionnel)

---

## 📞 Support et Monitoring

### Monitoring recommandé

1. **GitHub Actions:** Vérifier les runs échoués
2. **SSH:** Vérifier régulièrement les logs
3. **Docker:** `docker compose ps` pour vérifier l'état
4. **Espace disque:** `df -h` sur le VPS
5. **Backups:** Vérifier que les backups se créent régulièrement

### Configuration optionnelle

```bash
# Installer Portainer pour UI Docker
docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer-ce

# Alors accessible à http://VPS_IP:9000
```

---

**Document créé:** 15 avril 2026  
**Version:** 1.0  
**Auteur:** Portfolio CI/CD Setup
