PROJECT_NAME=angrytribe

# Declare all commands as phony (i.e. not real files)
.PHONY: up down rebuild logs hugo shell clean

## Start all containers in detached mode
up:
	docker compose up -d

## Stop and remove containers
down:
	docker compose down

## Rebuild everything from scratch (no cache)
rebuild:
	docker compose down
	docker compose build --no-cache
	docker compose up -d

logs:
	docker compose logs -f nginx

## Run Hugo build once (generates blog/public)
hugo:
	docker compose run --rm hugo

shell:
	docker compose exec -it nginx /bin/sh

## Clean up all containers, images, and volumes
clean:
	docker compose down -v --rmi all