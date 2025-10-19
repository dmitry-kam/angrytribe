mkdir -p nginx/ssl
mkdir -p nginx/.well-known/acme-challenge

docker compose stop nginx

docker run -it --rm \
  -v $(pwd)/nginx/letsencrypt:/etc/nginx/letsencrypt \
  -v $(pwd)/.well-known:/var/www/angrytribe/.well-known \
  certbot/certbot certonly \
  --webroot \
  --webroot-path /var/www/angrytribe \
  -d angrytribe.org \
  -d www.angrytribe.org