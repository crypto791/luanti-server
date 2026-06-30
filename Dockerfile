FROM alpine:latest

# Instala o minetest, curl e dependências necessárias
RUN apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/v3.20/community/ minetest curl libc6-compat

# Cria as pastas do jogo e do mod
RUN mkdir -p /root/.minetest/games /root/.minetest/mods/admin_system

# Baixa o jogo padrão (Minetest Game)
RUN curl -L https://github.com/minetest/minetest_game/archive/refs/heads/master.tar.gz | tar -xz -C /root/.minetest/games/ \
    && mv /root/.minetest/games/minetest_game-master /root/.minetest/games/minetest_game

# Copia os arquivos do seu mod de administração
COPY init.lua /root/.minetest/mods/admin_system/init.lua
COPY mod.conf /root/.minetest/mods/admin_system/mod.conf

# Instala o ngrok para fazer o túnel de conexão
RUN curl -s https://bin.equinox.io/c/b342h65qm65/ngrok-stable-linux-amd64.tgz | tar -xz -C /usr/local/bin

# Comando para iniciar o Minetest e abrir o túnel do ngrok juntos
# NOTA: O Render precisa de uma porta HTTP para ficar "Live", então fingimos uma com o nc
CMD (nc -lkp 80 -e echo -e "HTTP/1.1 200 OK\r\n\r\nOK") & \
    minetest --server --gameid minetest_game --port 30000 & \
    sleep 5 && ngrok tcp 30000
