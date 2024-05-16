SERVICE_NAME = samp_zombie_server
CONTAINER_NAME = samp_zombie_server

.PHONY: build up down logs clean redeploy

build:
	docker-compose build


up:
	docker-compose up -d


down:
	docker-compose down


logs:
	docker-compose logs -f


clean:
	docker system prune -a -f


redeploy: down build up

