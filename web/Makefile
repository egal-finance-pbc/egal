build:
	docker build -t egal/conellas/web:latest .

static: build
	docker run -it --rm \
	--volume $(CURDIR):/opt/conellas/web \
	egal/conellas/web:latest \
	./manage.py collectstatic --noinput

shell: build
	docker run -it --rm \
	--volume $(CURDIR):/opt/conellas/web \
	egal/conellas/web:latest \
	./manage.py shell

test: build
	docker run -it --rm \
	--volume $(CURDIR):/opt/conellas/web \
	egal/conellas/web:latest \
	./manage.py test -v2

up:
	docker-compose up --build

########################################################################################
##  The following helper targets need the docker compose setup up and running, since  ##
##  they perform runtime operations that affect more than a single container.         ##
########################################################################################

migrations:
	docker exec -it $(shell docker ps --filter name=web_web -q) \
	./manage.py makemigrations

migrate:
	docker exec -it $(shell docker ps --filter name=web_web -q) \
	./manage.py migrate

cache:
	docker exec -it $(shell docker ps --filter name=web_web -q) \
	./manage.py createcachetable

admin:
	docker exec -it $(shell docker ps --filter name=web_web -q) \
	./manage.py createsuperuser --username=admin --email=admin@localhost

reload:
	docker-compose restart web
