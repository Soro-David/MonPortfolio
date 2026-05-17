# =============================================================
#  Makefile — MonPortfolio
#  Stack : Laravel (Inertia/Vue3) + Nginx + MySQL + Vite
# =============================================================

GREEN  := \033[0;32m
YELLOW := \033[1;33m
RED    := \033[0;31m
CYAN   := \033[0;36m
RESET  := \033[0m

COMPOSE      := docker compose
APP          := monportfolio-app
EXEC         := $(COMPOSE) exec -T app
EXEC_IT      := $(COMPOSE) exec app
EXEC_DB      := $(COMPOSE) exec -T mysql
APP_URL      ?= http://localhost:8000

.DEFAULT_GOAL := help

# =============================================================
#  Aide
# =============================================================
help: ## Affiche cette aide
	@echo ""
	@echo "$(GREEN)MonPortfolio — Commandes disponibles$(RESET)"
	@echo "================================================="
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ { printf "  $(YELLOW)%-20s$(RESET) %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
	@echo ""

# =============================================================
#  🐳  Docker — Cycle de vie
# =============================================================
up: ## Démarre toute la stack (build + run)
	@echo "$(GREEN)▶  Démarrage de la stack...$(RESET)"
	@$(COMPOSE) up -d --build --remove-orphans
	@echo "$(YELLOW)⏳  Attente de la disponibilité de l'app...$(RESET)"
	@sleep 5
	@echo "$(GREEN)✅  App disponible sur $(APP_URL)$(RESET)"

up-core: ## Démarre uniquement MySQL + app (sans Vite ni Nginx)
	@echo "$(GREEN)▶  Démarrage core (mysql + app)...$(RESET)"
	@$(COMPOSE) up -d --build --remove-orphans mysql app

up-dev: ## Démarre la stack complète avec Vite HMR
	@echo "$(GREEN)▶  Démarrage stack dev complète...$(RESET)"
	@$(COMPOSE) up -d --build --remove-orphans
	@echo "$(GREEN)✅  App      → $(APP_URL)$(RESET)"
	@echo "$(CYAN)✅  Vite HMR → http://localhost:5173$(RESET)"

start: ## Démarre les conteneurs déjà buildés (sans rebuild)
	@$(COMPOSE) up -d --remove-orphans

stop: ## Arrête tous les conteneurs (sans les supprimer)
	@echo "$(YELLOW)■  Arrêt des conteneurs...$(RESET)"
	@$(COMPOSE) stop

down: ## Arrête et supprime les conteneurs
	@echo "$(RED)✗  Suppression des conteneurs...$(RESET)"
	@$(COMPOSE) down --remove-orphans

restart: ## Redémarre tous les conteneurs
	@echo "$(YELLOW)↺  Redémarrage...$(RESET)"
	@$(COMPOSE) restart

rebuild: ## Rebuild complet depuis zéro (down + up)
	@echo "$(RED)⟳  Rebuild complet...$(RESET)"
	@$(COMPOSE) down --remove-orphans
	@$(MAKE) up

ps: ## Affiche l'état des conteneurs
	@$(COMPOSE) ps

# =============================================================
#  🔧  Maintenance
# =============================================================
fix-perms: ## Corrige les permissions storage/ et bootstrap/cache/
	@echo "$(YELLOW)🔧  Correction des permissions...$(RESET)"
	@$(EXEC) sh -c "mkdir -p storage/framework/{sessions,views,cache} bootstrap/cache \
		&& chmod -R 775 storage bootstrap/cache \
		&& chown -R www-data:www-data storage bootstrap/cache"
	@echo "$(GREEN)✅  Permissions OK$(RESET)"

create-db: ## Crée la base de données si elle n'existe pas
	@echo "$(YELLOW)🗄️   Création de la base de données...$(RESET)"
	@$(EXEC_DB) mysql -uroot -proot -e \
		"CREATE DATABASE IF NOT EXISTS portfolio CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
	@echo "$(GREEN)✅  Base 'portfolio' prête$(RESET)"

# =============================================================
#  🛠️  Laravel — Artisan
# =============================================================
migrate: ## Lance les migrations
	@echo "$(GREEN)⇢  Migration...$(RESET)"
	@$(EXEC) php artisan migrate --seed

migrate-fresh: ## Recrée toutes les tables + seeders
	@echo "$(RED)⚠   Recréation complète de la BDD (perte de données !)...$(RESET)"
	@$(EXEC) php artisan migrate:fresh --seed

seed: ## Joue les seeders
	@echo "$(GREEN)⇢  Seeding...$(RESET)"
	@$(EXEC) php artisan db:seed

key: ## Génère la clé d'application
	@echo "$(GREEN)🔑  Génération de la clé APP_KEY...$(RESET)"
	@$(EXEC) php artisan key:generate

storage-link: ## Crée le lien symbolique public/storage
	@$(EXEC) php artisan storage:link --force

cache-clear: ## Vide tous les caches Laravel
	@echo "$(YELLOW)🗑   Vidage des caches...$(RESET)"
	@$(EXEC) php artisan cache:clear
	@$(EXEC) php artisan config:clear
	@$(EXEC) php artisan route:clear
	@$(EXEC) php artisan view:clear
	@echo "$(GREEN)✅  Caches vidés$(RESET)"

optimize: ## Optimise l'application (cache config/routes/views)
	@echo "$(GREEN)✦  Optimisation...$(RESET)"
	@$(EXEC) php artisan optimize

# =============================================================
#  📋  Logs
# =============================================================
logs: ## Logs de tous les services (suivi en temps réel)
	@$(COMPOSE) logs -f

logs-app: ## Logs du conteneur Laravel/PHP-FPM
	@$(COMPOSE) logs -f app

logs-nginx: ## Logs Nginx
	@$(COMPOSE) logs -f nginx

logs-vite: ## Logs Vite
	@$(COMPOSE) logs -f vite

logs-db: ## Logs MySQL
	@$(COMPOSE) logs -f mysql

# =============================================================
#  🖥️  Shell
# =============================================================
bash: ## Ouvre un shell bash dans le conteneur Laravel
	@$(EXEC_IT) bash

shell: bash ## Alias pour bash

bash-nginx: ## Ouvre un shell dans le conteneur Nginx
	@$(COMPOSE) exec nginx sh

bash-db: ## Ouvre un client MySQL
	@$(COMPOSE) exec mysql mysql -uroot -proot portfolio

# =============================================================
#  🚀  Installation (première utilisation)
# =============================================================
install: ## Installation complète du projet (première fois)
	@echo "$(GREEN)🚀  Installation de MonPortfolio...$(RESET)"
	@echo ""
	@# Copier .env si besoin
	@if [ ! -f laravel/.env ]; then \
		cp laravel/.env.example laravel/.env; \
		echo "$(YELLOW)  .env créé depuis .env.example$(RESET)"; \
	fi
	@echo "$(YELLOW)▶  Build et démarrage des conteneurs...$(RESET)"
	@$(COMPOSE) up -d --build --remove-orphans
	@echo "$(YELLOW)⏳  Attente de MySQL (30s max)...$(RESET)"
	@for i in $$(seq 1 15); do \
		$(EXEC_DB) mysqladmin ping -uroot -proot --silent 2>/dev/null && break || sleep 2; \
	done
	@echo "$(YELLOW)🗄️   Création de la base de données...$(RESET)"
	@$(EXEC_DB) mysql -uroot -proot -e \
		"CREATE DATABASE IF NOT EXISTS portfolio CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>/dev/null || true
	@echo "$(YELLOW)🔑  Génération de la clé...$(RESET)"
	@$(EXEC) php artisan key:generate --force
	@echo "$(YELLOW)🗄️   Migrations + seeders...$(RESET)"
	@$(EXEC) php artisan migrate --seed --force
	@echo "$(YELLOW)🔗  Lien symbolique storage...$(RESET)"
	@$(EXEC) php artisan storage:link --force
	@$(MAKE) fix-perms
	@echo ""
	@echo "$(GREEN)========================================$(RESET)"
	@echo "$(GREEN)✅  Installation terminée !$(RESET)"
	@echo "$(GREEN)   App   → $(APP_URL)$(RESET)"
	@echo "$(CYAN)   Vite  → http://localhost:5173$(RESET)"
	@echo "$(GREEN)========================================$(RESET)"

# =============================================================
#  🩺  Diagnostic
# =============================================================
doctor: ## Diagnostic de l'état de la stack
	@echo "$(YELLOW)🩺  Diagnostic MonPortfolio...$(RESET)"
	@echo ""
	@echo "$(CYAN)── État des conteneurs ──$(RESET)"
	@$(COMPOSE) ps
	@echo ""
	@echo "$(CYAN)── PHP-FPM dans app ──$(RESET)"
	@$(EXEC) php -v 2>/dev/null || echo "$(RED)  PHP non disponible$(RESET)"
	@echo ""
	@echo "$(CYAN)── Connexion MySQL ──$(RESET)"
	@$(EXEC) php artisan db:show 2>/dev/null || \
		$(EXEC_DB) mysqladmin ping -uroot -proot 2>/dev/null || \
		echo "$(RED)  MySQL non joignable$(RESET)"
	@echo ""
	@echo "$(CYAN)── Derniers logs app (20 lignes) ──$(RESET)"
	@$(COMPOSE) logs --tail=20 app
	@echo ""
	@echo "$(CYAN)── Derniers logs nginx (10 lignes) ──$(RESET)"
	@$(COMPOSE) logs --tail=10 nginx

.PHONY: help \
        up up-core up-dev start stop down restart rebuild ps \
        fix-perms create-db \
        migrate migrate-fresh seed key storage-link cache-clear optimize \
        logs logs-app logs-nginx logs-vite logs-db \
        bash shell bash-nginx bash-db \
        install doctor
