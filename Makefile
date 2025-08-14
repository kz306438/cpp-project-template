IMAGE_NAME := my_cpp_dev_env
CONTAINER_NAME := cpp_dev_container
WORKDIR := /workspace

.PHONY: build run shell clean

# Сборка Docker-образа
build:
	docker build -t $(IMAGE_NAME) .

# Запуск контейнера с монтированием текущей папки
run:
	docker run -it --rm \
		-v $(PWD):$(WORKDIR) \
		-w $(WORKDIR) \
		--name $(CONTAINER_NAME) \
		$(IMAGE_NAME) /bin/bash

# Открыть shell в уже запущенном контейнере
shell:
	docker exec -it $(CONTAINER_NAME) /bin/bash

# Удалить контейнер (если остался в фоне)
clean:
	-docker rm -f $(CONTAINER_NAME) || true
