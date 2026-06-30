FROM alpine:latest

# Ativa o repositório community e instala o minetest-server
RUN apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community/ minetest-server

# Cria as pastas do mod
RUN mkdir -p /root/.minetest/mods/admin_system

# Copia os arquivos do mod
COPY init.lua /root/.minetest/mods/admin_system/init.lua
COPY mod.conf /root/.minetest/mods/admin_system/mod.conf

# Executa o servidor expondo o tráfego
CMD ["minetestserver", "--port", "30000"]
