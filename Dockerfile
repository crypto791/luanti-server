FROM alpine:latest

# Instala o minetest, curl e o openssh-client para fazer o túnel
RUN apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/v3.20/community/ minetest curl openssh-client

# Cria as pastas necessárias
RUN mkdir -p /root/.minetest/games /root/.minetest/mods/admin_system

# Baixa o jogo base padrão
RUN curl -L https://github.com/minetest/minetest_game/archive/refs/heads/master.tar.gz | tar -xz -C /root/.minetest/games/ \
    && mv /root/.minetest/games/minetest_game-master /root/.minetest/games/minetest_game

# Copia os arquivos do seu mod
COPY init.lua /root/.minetest/mods/admin_system/init.lua
COPY mod.conf /root/.minetest/mods/admin_system/mod.conf

# Expõe a porta de mentira do Render e a do Luanti
EXPOSE 80
EXPOSE 30000

# Executa o servidor de mentira na porta 80, o jogo na 30000 e abre o túnel público via SSH
CMD while true; do echo -e "HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\nOK" | nc -l -p 80; done & \
    minetest --server --gameid minetest_game --port 30000 & \
    sleep 5 && ssh -o ReadyTimeout=5 -o StrictHostKeyChecking=no -R 30000:localhost:30000 serveo.net
