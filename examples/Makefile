build:
	docker build -t egal/examples:latest .

keypair: build
	docker run -it --rm \
	--volume $(CURDIR):/opt/egal/examples \
	egal/examples:latest \
	python3 keypair.py

account: build
	docker run -it --rm \
	--volume $(CURDIR):/opt/egal/examples \
	egal/examples:latest \
	python3 account.py

freeze: build
	docker run -it --rm egal/examples:latest \
	python3 -m pip freeze

up:
	docker-compose up --build

down:
	docker-compose down
