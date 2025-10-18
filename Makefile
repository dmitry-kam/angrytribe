PROJECT_NAME=angrytribe
DOCKER_RUN_HUGO = docker compose run --rm hugo hugo

# Declare all commands as phony (i.e. not real files)
.PHONY: up down rebuild logs hugo shell clean

## Start all containers in detached mode
up:
	docker compose up -d

## Stop and remove containers
down:
	docker compose down

rebuild:
	docker compose down
	docker compose build --no-cache
	docker compose up -d

rebuild-nginx:
	docker compose up -d --force-recreate --build nginx

restart:
	docker compose restart

logs:
	docker compose logs -f nginx

user:
	id -u && id -g

# make new-page dir=example name=example part=blog
new-page:
	@if [ -z "$(name)" ]; then \
		echo "Error: Please specify name="; \
		exit 1; \
	fi
	@if [ -z "$(dir)" ]; then \
		$(DOCKER_RUN_HUGO) new --source $(if $(part),$(part),"blog") $(name).md; \
		echo "Created: content/$(name).md"; \
	else \
		$(DOCKER_RUN_HUGO) new --source $(if $(part),$(part),"blog") $(dir)/$(name).md; \
		echo "Created: content/$(dir)/$(name).md"; \
	fi

build-home:
	$(DOCKER_RUN_HUGO) --source /src/homepage --destination /output/homepage

build-blog:
	$(DOCKER_RUN_HUGO) --source /src/blog --destination /output/blog

clean:
	docker compose down -v --rmi all

hugo-version:
	docker compose run --rm hugo hugo version

serve-blog:
	docker compose run --rm -p 813:1313 hugo hugo server --source /src/blog --bind 0.0.0.0 --port 1313
