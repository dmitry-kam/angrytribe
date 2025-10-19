mkdir -p nginx/ssl
mkdir -p .well-known/acme-challenge

docker compose up -d nginx
sleep 2
docker run -it --rm \
  -v $(pwd)/nginx/letsencrypt:/etc/letsencrypt \
  -v $(pwd)/.well-known:/var/www/angrytribe/.well-known \
  certbot/certbot certonly \
  --webroot \
  --webroot-path /var/www/angrytribe \
  -d angrytribe.org \
  -d www.angrytribe.org

docker compose stop nginx