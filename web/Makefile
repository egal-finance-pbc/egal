build:
	docker build -t egal/conellas/web:latest .

static: build
	docker run -it --rm \
	--volume $(CURDIR):/opt/conellas/web \
	egal/conellas/web:latest \
	./manage.py collectstatic --noinput

up:
	docker-compose up --build
