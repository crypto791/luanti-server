FROM alpine:latest

# Instala o pacote atualizado (minetest) usando o repositório correto
RUN apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/v3.20/community/ minetest

# Cria as pastas do mod
RUN mkdir -p /root/.minetest/mods/admin_system

# Copia os arquivos do mod
COPY init.lua /root/.minetest/mods/admin_system/init.lua
COPY mod.conf /root/.minetest/mods/admin_system/mod.conf

# Executa o servidor usando o comando atualizado exposto na porta padrão
CMD ["minetest", "--server", "--port", "30000"]
