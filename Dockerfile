FROM alpine:latest
RUN apk add --no-cache minetest-server

# Cria as pastas do mod
RUN mkdir -p /root/.minetest/mods/admin_system

# Copia os arquivos do mod (vamos criá-los a seguir)
COPY init.lua /root/.minetest/mods/admin_system/init.lua
COPY mod.conf /root/.minetest/mods/admin_system/mod.conf

# Executa o servidor na porta padrão expondo o tráfego
CMD ["minetestserver", "--port", "30000"]
