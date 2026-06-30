FROM alpine:latest

# Instala o minetest, curl, openssh-client e socat (para traduzir TCP para UDP)
RUN apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/v3.20/community/ minetest curl openssh-client socat

# Cria as pastas necessárias
RUN mkdir -p /root/.minetest/games /root/.minetest/mods/admin_system /root/.minetest/worlds/world

# Baixa o jogo base padrão
RUN curl -L https://github.com/minetest/minetest_game/archive/refs/heads/master.tar.gz | tar -xz -C /root/.minetest/games/ \
    && mv /root/.minetest/games/minetest_game-master /root/.minetest/games/minetest_game

# Copia os arquivos do seu mod e a configuração
COPY init.lua /root/.minetest/mods/admin_system/init.lua
COPY mod.conf /root/.minetest/mods/admin_system/mod.conf
COPY minetest.conf /root/.minetest/minetest.conf

# Expõe as portas
EXPOSE 80
EXPOSE 30000

# Executa o servidor HTTP falso, o Minetest em UDP, o tradutor socat de TCP para UDP, e abre o túnel SSH
CMD (while true; do echo -e "HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\nOK" | nc -l -p 80; done) & \
    minetest --server --gameid minetest_game --config /root/.minetest/minetest.conf --worldname world & \
    sleep 5 && \
    socat TCP-LISTEN:30000,fork UDP:127.0.0.1:30000 & \
    sleep 2 && \
    ssh -o StrictHostKeyChecking=no -N -R 80:127.0.0.1:30000 nokey@localhost.run
