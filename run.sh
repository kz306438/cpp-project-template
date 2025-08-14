#!/usr/bin/env bash
set -e
#!/usr/bin/env bash
set -e

IMAGE_NAME=my_cpp_dev_env

# Сборка образа
docker build -t $IMAGE_NAME .

# Запуск контейнера
docker run -it --rm \
    -v "$(pwd)":/workspace \
    -w /workspace \
    --name cpp_dev_container \
    $IMAGE_NAME /bin/bash