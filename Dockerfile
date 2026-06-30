FROM alpine:latest

# Instala as dependências, minetest, curl e ferramentas de rede
RUN apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/v3.20/community/ minetest curl libc6-compat

# Cria as pastas necessárias
RUN mkdir -p /root/.minetest/games /root/.minetest/mods/admin_system

# Baixa o jogo base padrão
RUN curl -L https://github.com/minetest/minetest_game/archive/refs/heads/master.tar.gz | tar -xz -C /root/.minetest/games/ \
    && mv /root/.minetest/games/minetest_game-master /root/.minetest/games/minetest_game

# Copia os arquivos do mod
COPY init.lua /root/.minetest/mods/admin_system/init.lua
COPY mod.conf /root/.minetest/mods/admin_system/mod.conf

# Instala o ngrok para criar o túnel TCP bypass
RUN curl -s https://bin.equinox.io/c/b342h65qm65/ngrok-stable-linux-amd64.tgz | tar -xz -C /usr/local/bin

# Expõe as portas necessárias no container
EXPOSE 80
EXPOSE 30000

# Executa um servidor HTTP na porta 80 para enganar o Render, inicia o jogo e o túnel do ngrok
CMD while true; do echo -e "HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\nOK" | nc -l -p 80; done & \
    minetest --server --gameid minetest_game --port 30000 & \
    sleep 5 && ngrok tcp 30000
