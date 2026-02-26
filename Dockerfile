FROM ubuntu:24.04

RUN echo "Устанавливаем зависимости"
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    mc \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN echo "Установка Node.js LTS"
# RUN curl -fsSL https://deb.nodesource.com/setup_lts.x && \
RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get install -y nodejs

RUN echo " Установка Qwen Code (глобально для пользователя)"
RUN npm install -g @qwen-code/qwen-code@latest

RUN echo "Создаём непривилегированного пользователя"
RUN useradd -m -u 77 qwen && echo "qwen ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN echo "Переключаемся на пользователя"
USER qwen
WORKDIR /home/qwen

CMD ["tail", "-f", "/dev/null"]

RUN echo "готово!"
