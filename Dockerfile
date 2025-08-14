FROM ubuntu:22.04

# Обновление и установка базовых инструментов
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    ninja-build \
    python3-pip \
    git \
    gdb \
    && rm -rf /var/lib/apt/lists/*

# Установка Conan
RUN pip3 install conan==2.4.0

# Установка Clang (опционально, для кросс-компиляции)
RUN apt-get update && apt-get install -y clang lldb lld && rm -rf /var/lib/apt/lists/*

# Настройка Conan
RUN conan profile detect --force

# Рабочая директория внутри контейнера
WORKDIR /workspace
