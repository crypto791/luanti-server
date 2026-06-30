FROM alpine:latest

# Instala o minetest, curl e o openssh-client
RUN apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/v3.20/community/ minetest curl openssh-client

# Cria as pastas necessárias
RUN mkdir -p /root/.minetest/games /root/.minetest/mods/admin_system /root/.minetest/worlds/world

# Baixa o jogo base padrão
RUN curl -L https://github.com/minetest/minetest_game/archive/refs/heads/master.tar.gz | tar -xz -C /root/.minetest/games/ \
    && mv /root/.minetest/games/minetest_game-master /root/.minetest/games/minetest_game

# Copia os arquivos do seu mod e a configuração do WebSocket
COPY init.lua /root/.minetest/mods/admin_system/init.lua
COPY mod.conf /root/.minetest/mods/admin_system/mod.conf
COPY minetest.conf /root/.minetest/minetest.conf

# Expõe as portas
EXPOSE 80
EXPOSE 30000

# Executa o servidor HTTP falso em loop, inicia o Luanti com o arquivo de config e abre o túnel SSH
CMD (while true; do echo -e "HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\nOK" | nc -l -p 80; done) & minetest --server --config /root/.minetest/minetest.conf & sleep 7 && ssh -o StrictHostKeyChecking=no -N -R 80:127.0.0.1:30000 nokey@localhost.run
