mkdir -p nginx/ssl
mkdir -p nginx/.well-known/acme-challenge

docker compose stop nginx

docker run -it --rm \
  -v $(pwd)/letsencrypt:/etc/letsencrypt \
  -v $(pwd)/nginx/.well-known:/var/www/html/.well-known \
  certbot/certbot certonly \
  --webroot \
  --webroot-path /var/www/html \
  -d angrytribe.org \
  -d www.angrytribe.org