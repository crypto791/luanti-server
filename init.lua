AdminSystem = {}

AdminSystem.version = "1.0"

local files={

"patcher.lua",
"logs.lua",
"api.lua",
"config.lua",

"storage.lua",

"roles.lua",
"players.lua",

"actions.lua",

"engine.lua",

"admin.lua",
"list.lua",

"events.lua",
"plugins.lua",

"timer.lua",
"commands.lua"

}

for _,file in ipairs(files) do

    local path = minetest.get_modpath(minetest.get_current_modname()).."/"..file

    local ok,err = pcall(dofile,path)

    if ok then

        minetest.log("action","[AdminSystem] "..file.." carregado.")

    else

        minetest.log("error","")

        minetest.log("error","===========================")

        minetest.log("error","Erro em "..file)

        minetest.log("error",err)

        minetest.log("error","===========================")

    end

end
