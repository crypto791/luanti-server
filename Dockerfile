FROM alpine:latest

# Instala o minetest e o curl para baixar o jogo base
RUN apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/v3.20/community/ minetest curl

# Cria as pastas necessárias para o jogo e para o mod
RUN mkdir -p /root/.minetest/games /root/.minetest/mods/admin_system

# Baixa o jogo padrão (Minetest Game) para o servidor ter uma base onde rodar
RUN curl -L https://github.com/minetest/minetest_game/archive/refs/heads/master.tar.gz | tar -xz -C /root/.minetest/games/ \
    && mv /root/.minetest/games/minetest_game-master /root/.minetest/games/minetest_game

# Copia os arquivos do seu mod
COPY init.lua /root/.minetest/mods/admin_system/init.lua
COPY mod.conf /root/.minetest/mods/admin_system/mod.conf

# Executa o servidor apontando para o jogo instalado na porta padrão
CMD ["minetest", "--server", "--gameid", "minetest_game", "--port", "30000"]
