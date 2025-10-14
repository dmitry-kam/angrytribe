# AngryTribe.org Migration

This repository documents the migration of **[angrytribe.org](https://angrytribe.org)** — my travel website about 
**Kamchatka** — from **Tilda** to a **self-hosted VPS**.
The project also serves as a sandbox to explore **GitHub Actions**, **Hugo**, and 
static site automation workflows.

## 🚀 Goals

- Migrate the existing static website from Tilda to a VPS (and save some money)
- Use GitHub Actions for automatic deployment
- Use Termius (usually I use PuTTY / Solar-PuTTY) - looks really nice!
- Rebuild the site using **Hugo** to enable:
    - A small personal blog
    - A professional portfolio / business card site

## 🧰 Tools & Technologies

- **wget** — for mirroring the original Tilda site
    ```bash
    wget \
      --mirror \
      --convert-links \
      --adjust-extension \
      --page-requisites \
      --no-parent \
      -e robots=off \
      --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \
      https://angrytribe.org/
    ```
- **Hugo** — static site generator for the new version
- **GitHub Actions** — CI/CD for automated builds and deployments
- **Docker** — containerization
- **Nginx** — web server

## 📅 Next Steps
* [x] Set up Docker, configure Nginx
* [x] Migrate content from mirrored HTML
* [x] Remove extra scripts etc. from HTML
* [x] Download images etc. from Tilda, saving structure
* [ ] Configure DNS
* [ ] Set up Hugo project structure
* [ ] Choose and customize a theme
* [ ] Configure GitHub Actions for deployment
* [ ] Launch the new version on VPS
* [ ] Return SSL