PROJECT_NAME=angrytribe
DOCKER_RUN_HUGO = docker compose run --rm hugo hugo

# Declare all commands as phony (i.e. not real files)
.PHONY: up down rebuild rebuild-nginx restart logs user new-page build-home build-blog clean hugo-version serve-blog free-port-80 renew-cert

## Stop host nginx if it occupies port 80
free-port-80:
	@if ss -tlnp | grep ':80 ' | grep -q nginx; then \
		echo "Port 80 is occupied by host nginx, stopping it..."; \
		systemctl stop nginx 2>/dev/null || true; \
		systemctl disable nginx 2>/dev/null || true; \
	fi

## Start all containers in detached mode
up: free-port-80
	docker compose up -d

## Stop and remove containers
down:
	docker compose down

rebuild: free-port-80
	docker compose down
	docker compose build --no-cache
	docker compose up -d

rebuild-nginx: free-port-80
	docker compose up -d --force-recreate --build nginx

restart:
	docker compose restart

logs:
	docker compose logs -f nginx

user:
	id -u && id -g

## Renew SSL certificate via certbot webroot
renew-cert:
	@if [ -f nginx/conf.d/angrytribe-ssl.conf ]; then \
		mv nginx/conf.d/angrytribe-ssl.conf nginx/conf.d/angrytribe-ssl.conf.disabled; \
	fi
	docker compose up -d --force-recreate nginx
	sleep 5
	bash scripts/cert.sh
	@if [ -f nginx/conf.d/angrytribe-ssl.conf.disabled ]; then \
		mv nginx/conf.d/angrytribe-ssl.conf.disabled nginx/conf.d/angrytribe-ssl.conf; \
	fi
	docker compose restart nginx

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
