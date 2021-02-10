down:
	docker-compose down

up: down
	docker-compose build && docker-compose up --scale worker=1
