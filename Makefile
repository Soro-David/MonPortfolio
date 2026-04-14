# ============================================================
#  Makefile — MonPortfolio
#  Application Laravel + Nginx + MySQL + Node (Vite)
# ============================================================

# Couleurs pour les messages
GREEN  := \033[0;32m
YELLOW := \033[1;33m
RED    := \033[0;31m
RESET  := \033[0m

# Conteneur principal Laravel (php-fpm)
APP_CONTAINER := laravel

# ============================================================
#  Aide
# ============================================================
.DEFAULT_GOAL := help

help: ## Affiche cette aide
	@echo ""
	@echo "$(GREEN)MonPortfolio — Commandes disponibles$(RESET)"
	@echo "---------------------------------------"
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ { printf "  $(YELLOW)%-18s$(RESET) %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
	@echo ""

# ============================================================
#  Docker — Cycle de vie
# ============================================================
up: ## Démarre tous les services (build si nécessaire)
	@echo "$(GREEN)▶  Démarrage des services...$(RESET)"
	docker compose up -d --build
	@$(MAKE) fix-perms

start: ## Démarre les services sans rebuild
	@echo "$(GREEN)▶  Démarrage des services...$(RESET)"
	docker compose up -d

stop: ## Arrête tous les services
	@echo "$(YELLOW)■  Arrêt des services...$(RESET)"
	docker compose stop

down: ## Arrête et supprime les conteneurs
	@echo "$(RED)✗  Suppression des conteneurs...$(RESET)"
	docker compose down

restart: ## Redémarre tous les services
	@echo "$(YELLOW)↺  Redémarrage des services...$(RESET)"
	docker compose restart

rebuild: ## Reconstruit les images et redémarre
	@echo "$(GREEN)⟳  Reconstruction des images...$(RESET)"
	docker compose down
	docker compose up -d --build

fix-perms: ## Corrige les permissions storage/ et bootstrap/cache/
	@echo "$(YELLOW)🔧  Correction des permissions...$(RESET)"
	docker exec $(APP_CONTAINER) bash -c "chmod -R 775 storage bootstrap/cache && chown -R www-data:www-data storage bootstrap/cache"
	@echo "$(GREEN)✅  Permissions corrigées$(RESET)"

create-db: ## Crée la base de données si elle n'existe pas
	@echo "$(YELLOW)🗄️  Création de la base de données...$(RESET)"
	docker exec mysql mysql -uroot -proot -e "CREATE DATABASE IF NOT EXISTS portfolio CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
	@echo "$(GREEN)✅  Base de données prête$(RESET)"

# ============================================================
#  Laravel — Commandes Artisan
# ============================================================
migrate: ## Lance les migrations Laravel
	@echo "$(GREEN)⇢  Migration de la base de données...$(RESET)"
	docker exec $(APP_CONTAINER) php artisan migrate

migrate-fresh: ## Recrée toutes les tables + seeders
	@echo "$(RED)⚠  Recréation complète de la BDD...$(RESET)"
	docker exec $(APP_CONTAINER) php artisan migrate:fresh --seed

seed: ## Joue les seeders
	@echo "$(GREEN)⇢  Seeding de la base de données...$(RESET)"
	docker exec $(APP_CONTAINER) php artisan db:seed

cache: ## Vide tous les caches Laravel
	@echo "$(YELLOW)🗑  Vidage des caches...$(RESET)"
	docker exec $(APP_CONTAINER) php artisan cache:clear
	docker exec $(APP_CONTAINER) php artisan config:clear
	docker exec $(APP_CONTAINER) php artisan route:clear
	docker exec $(APP_CONTAINER) php artisan view:clear

optimize: ## Optimise l'application (cache config/routes/views)
	@echo "$(GREEN)✦  Optimisation de l'application...$(RESET)"
	docker exec $(APP_CONTAINER) php artisan optimize

key: ## Génère la clé d'application Laravel
	@echo "$(GREEN)🔑  Génération de la clé...$(RESET)"
	docker exec $(APP_CONTAINER) php artisan key:generate

storage-link: ## Crée le lien symbolique storage
	docker exec $(APP_CONTAINER) php artisan storage:link

# ============================================================
#  Shell / Logs
# ============================================================
bash: ## Ouvre un shell dans le conteneur Laravel
	docker exec -it $(APP_CONTAINER) bash

shell: bash ## Alias de bash

logs: ## Affiche les logs de tous les services
	docker compose logs -f

logs-app: ## Affiche les logs du conteneur Laravel uniquement
	docker compose logs -f app

logs-nginx: ## Affiche les logs Nginx
	docker compose logs -f nginx

logs-db: ## Affiche les logs MySQL
	docker compose logs -f db

# ============================================================
#  Installation / Première utilisation
# ============================================================
install: ## Installation complète (première utilisation)
	@echo "$(GREEN)🚀  Installation complète du projet...$(RESET)"
	@if [ ! -f laravel/.env ]; then \
		cp laravel/.env.example laravel/.env; \
		echo "$(YELLOW)  .env créé depuis .env.example$(RESET)"; \
	fi
	docker compose up -d --build
	@echo "$(YELLOW)  Attente du démarrage MySQL...$(RESET)"
	sleep 10
	@$(MAKE) fix-perms
	docker exec $(APP_CONTAINER) php artisan key:generate
	docker exec $(APP_CONTAINER) php artisan migrate --seed
	docker exec $(APP_CONTAINER) php artisan storage:link
	@echo "$(GREEN)✅  Installation terminée ! App disponible sur http://localhost:8081$(RESET)"

# ============================================================
#  Statut
# ============================================================
ps: ## Affiche l'état des conteneurs
	docker compose ps

.PHONY: help up start stop down restart rebuild \
        fix-perms \
        migrate migrate-fresh seed cache optimize key storage-link \
        bash shell logs logs-app logs-nginx logs-db \
        install ps
