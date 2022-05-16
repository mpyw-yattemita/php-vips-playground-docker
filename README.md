# php-vips-playground-docker

## Setup

```bash
docker compose build
docker compose up -d
docker compose exec php composer install
```

## Usage

```bash
./console list
./console example
./console gif:animation:create storage/out.gif storage/frame-*.*
```
