# Configuration des Secrets GitHub Actions

## 📋 Secrets à configurer

Accédez à: **Repository → Settings → Secrets and variables → Actions → New repository secret**

### Tableau récapitulatif

| Variable | Type | Exemple | Description |
|----------|------|---------|-------------|
| `VPS_HOST` | Secret | `203.0.113.42` ou `vps.mondomaine.com` | Adresse IP ou domaine du VPS |
| `VPS_USER` | Secret | `ubuntu` ou `deployer` | Utilisateur SSH sur le VPS |
| `VPS_SSH_KEY` | Secret | (clé privée ed25519) | Clé SSH privée pour l'authentification |
| `VPS_SSH_PORT` | Secret | `22` | Port SSH (par défaut: 22) |
| `VPS_APP_PATH` | Secret | `/var/www/portfolio` | Chemin absolu de l'application |
| `SLACK_WEBHOOK` | Secret | (URL webhook) | **Optionnel** - Notifications Slack |

---

## 🔐 Génération des secrets

### 1. Générer la clé SSH

Sur votre machine locale:

```bash
# Générer une paire de clés SSH
ssh-keygen -t ed25519 \
  -C "github-actions-portfolio" \
  -f ./github_actions_key \
  -N ""

# Afficher le contenu des fichiers
echo "=== CLÉ PRIVÉE (pour le secret VPS_SSH_KEY) ==="
cat ./github_actions_key

echo ""
echo "=== CLÉ PUBLIQUE (pour le VPS) ==="
cat ./github_actions_key.pub
```

### 2. Configurer la clé publique sur le VPS

Sur le VPS:

```bash
# Ajouter la clé publique aux clés autorisées
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Coller le contenu de github_actions_key.pub
cat >> ~/.ssh/authorized_keys << 'EOF'
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO... github-actions-portfolio
EOF

# Définir les bonnes permissions
chmod 600 ~/.ssh/authorized_keys

# Vérifier que tout est correct
ls -la ~/.ssh/
```

### 3. Ajouter les secrets à GitHub

#### Via l'interface web:

1. Allez sur: **https://github.com/Soro-David/MonPortfolio/settings/secrets/actions**
2. Cliquez sur **New repository secret**
3. Remplissez les champs:

**Secret 1: VPS_HOST**
- Name: `VPS_HOST`
- Secret: `203.0.113.42` (remplacer par votre IP ou domaine)

**Secret 2: VPS_USER**
- Name: `VPS_USER`
- Secret: `ubuntu` (ou votre utilisateur SSH)

**Secret 3: VPS_SSH_KEY**
- Name: `VPS_SSH_KEY`
- Secret: (contenu entier de `./github_actions_key` - la clé **privée**)

```
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUtbm9uZS1ub25lAAAAAEVkMjU1MTkAAAA...
...contenu complet...
-----END OPENSSH PRIVATE KEY-----
```

**Secret 4: VPS_SSH_PORT**
- Name: `VPS_SSH_PORT`
- Secret: `22` (ou votre port SSH personnalisé)

**Secret 5: VPS_APP_PATH**
- Name: `VPS_APP_PATH`
- Secret: `/var/www/portfolio` (ou votre chemin d'application)

**Secret 6 (Optionnel): SLACK_WEBHOOK**
- Name: `SLACK_WEBHOOK`
- Secret: `https://hooks.slack.com/services/T00000000/B00000000/...`

#### Via GitHub CLI:

```bash
# Installer gh si pas déjà fait
# https://cli.github.com/

# Se connecter à GitHub
gh auth login

# Configurer les secrets
gh secret set VPS_HOST -b "203.0.113.42"
gh secret set VPS_USER -b "ubuntu"
gh secret set VPS_SSH_KEY < ./github_actions_key
gh secret set VPS_SSH_PORT -b "22"
gh secret set VPS_APP_PATH -b "/var/www/portfolio"

# Vérifier les secrets (sans afficher les valeurs)
gh secret list
```

---

## 🔑 Gestion des clés SSH

### Rotation des clés (recommandé annuellement)

```bash
# 1. Générer une nouvelle clé
ssh-keygen -t ed25519 \
  -C "github-actions-portfolio-v2" \
  -f ./github_actions_key_new \
  -N ""

# 2. Ajouter la nouvelle clé publique au VPS
cat ./github_actions_key_new.pub >> ~/.ssh/authorized_keys

# 3. Mettre à jour le secret dans GitHub
gh secret set VPS_SSH_KEY < ./github_actions_key_new

# 4. Attendre un déploiement réussi
# 5. Supprimer l'ancienne clé du VPS
# 6. Nettoyer les fichiers locaux
rm ./github_actions_key ./github_actions_key.pub
mv ./github_actions_key_new ./github_actions_key
mv ./github_actions_key_new.pub ./github_actions_key.pub
```

### ⚠️ Sécurité - À faire

- ✅ Générer les clés avec `ed25519` (plus sécurisé que RSA)
- ✅ Ne **JAMAIS** mettre les clés privées dans Git
- ✅ Ajouter le fichier à `.gitignore`:

```bash
# Ajouter au .gitignore
echo "github_actions_key*" >> .gitignore
echo "*.pem" >> .gitignore
```

- ✅ Limiter les permissions SSH si possible:
  
```bash
# Restreindre la clé à certaines commandes (optionnel mais recommandé)
# Éditer ~/.ssh/authorized_keys et préfixer la clé avec:
# command="/var/www/portfolio/scripts/deploy.sh" ssh-ed25519 AAAA...
```

---

## 🔗 Configuration Slack (Optionnel)

Pour recevoir des notifications de déploiement:

### 1. Créer un webhook Slack

1. Allez sur: **https://api.slack.com/apps**
2. Créez une nouvelle application
3. Allez à: **Incoming Webhooks**
4. Cliquez: **Add New Webhook to Workspace**
5. Sélectionnez le canal `#deployments`
6. Copiez l'URL générée

### 2. Ajouter le secret

```bash
gh secret set SLACK_WEBHOOK -b "https://hooks.slack.com/services/..."
```

### 3. Exemple de notification

Le workflow enverra automatiquement:

```
✅ Déploiement Portfolio réussi
Date: 2026-04-15 14:30:00
```

---

## 📊 Vérification des secrets

### Lister les secrets (sans valeurs)

```bash
gh secret list
```

**Résultat attendu:**
```
VPS_HOST              Updated 2026-04-15
VPS_USER              Updated 2026-04-15
VPS_SSH_KEY           Updated 2026-04-15
VPS_SSH_PORT          Updated 2026-04-15
VPS_APP_PATH          Updated 2026-04-15
SLACK_WEBHOOK         Updated 2026-04-15
```

### Modifier un secret

```bash
# Supprimer l'ancien
gh secret delete VPS_HOST

# Ajouter le nouveau
gh secret set VPS_HOST -b "nouveau_host"
```

---

## 🚀 Test de connexion SSH

Avant de commencer les déploiements, testez la connexion:

```bash
# Test de connexion
ssh -i ./github_actions_key \
    -p 22 \
    ubuntu@203.0.113.42 \
    "echo 'SSH connection successful!'"

# Résultat attendu:
# SSH connection successful!
```

Si vous avez une erreur:

```bash
# Ajouter la clé publique au agent SSH
ssh-add ./github_actions_key

# Essayer de nouveau
ssh ubuntu@203.0.113.42 "echo 'SSH connection successful!'"
```

---

## 📝 Checklist final

- [ ] Clé SSH générée avec `ed25519`
- [ ] Clé publique ajoutée au `.ssh/authorized_keys` du VPS
- [ ] SSH connexion testée avec succès
- [ ] `VPS_HOST` configuré
- [ ] `VPS_USER` configuré
- [ ] `VPS_SSH_KEY` configuré
- [ ] `VPS_SSH_PORT` configuré
- [ ] `VPS_APP_PATH` configuré
- [ ] Fichier `.gitignore` mis à jour
- [ ] Secrets listés dans GitHub: `gh secret list`

---

## 🎯 Prochaines étapes

1. Configurer les secrets
2. Effectuer un test de déploiement: `git push origin main`
3. Monitorer le workflow: **Actions** tab
4. Vérifier les logs sur le VPS
5. Accéder à l'application déployée

---

**Guide créé:** 15 avril 2026  
**Version:** 1.0
