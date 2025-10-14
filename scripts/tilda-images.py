import os
import re
import requests
from urllib.parse import urlparse

def process_html_files():
    old_folder = "old"
    download_folder = "old/downloaded_files"

    for root, dirs, files in os.walk(old_folder):
        for file in files:
            if file.endswith('.html'):
                file_path = os.path.join(root, file)

                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()

                # Находим все внешние ссылки
                url_pattern = r'https?://[^\s"\'<>()]+'
                urls = re.findall(url_pattern, content)

                print(f"Обрабатывается: {file_path}, найдено URL: {len(urls)}")

                for url in urls:
                    parsed_url = urlparse(url)
                    url_path = parsed_url.path.lstrip('/')

                    if not re.search(r'\.(?:pdf|doc|docx|xls|xlsx|jpg|jpeg|png|gif|zip|rar|css|js|svg)$', parsed_url.path, re.IGNORECASE):
                        print(f"  Пропускаем: {url}")
                        continue

                    if url_path:  # Проверяем что путь не пустой
                        local_path = os.path.join(download_folder, url_path)

                        # Скачиваем файл
                        os.makedirs(os.path.dirname(local_path), exist_ok=True)
                        try:
                            response = requests.get(url)
                            response.raise_for_status()
                            with open(local_path, 'wb') as f:
                                f.write(response.content)

                            # Заменяем URL в содержимом
                            new_path = f"/{download_folder}/{url_path}"
                            content = content.replace(url, new_path)
                            print(f"  Заменен: {url} -> {new_path}")
                        except Exception as e:
                            print(f"  Ошибка скачивания {url}: {e}")

                # Сохраняем измененный файл
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(content)

if __name__ == "__main__":
    process_html_files()