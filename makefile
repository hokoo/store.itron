setup.all:
	bash ./dev-local/setup.sh

setup.wp:
	bash ./dev-local/setup-wp.sh

setup.env:
	bash ./dev-local/setup-env.sh

clear.all:
	bash ./dev-local/clear.sh

docker.up:
	docker-compose up -d

docker.down:
	docker-compose down

connect.php:
	docker-compose exec php bash

connect.nginx:
	docker-compose exec nginx sh

connect.mysql:
	docker-compose exec mysql bash