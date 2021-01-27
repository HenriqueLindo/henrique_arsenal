-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")

henrique = {}
Tunnel.bindInterface("henrique_arsenal",henrique)

-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE
-----------------------------------------------------------------------------------------------------------------------------------------
vRP._prepare("vrp/count_arma","SELECT quantidade  FROM vrp_estoquearsenal WHERE modelo = @modelo  ")
vRP._prepare("vrp/update_estoque","UPDATE vrp_estoquearsenal SET quantidade = @quantidade WHERE user_id = @user_id and modelo = @modelo")

-----------------------------------------------------------------------------------------------------------------------------------------
-- CÓDIGO
-----------------------------------------------------------------------------------------------------------------------------------------

globalarmas = {
    glock = "weapon_combatpistol",
    m4a1 =  "weapon_assaultrifle"
}

function henrique.getweapon(arma)
	local source = source
	local user_id = vRP.getUserId(source)
    if user_id then
        local armaencontrada = vRP.query("vRP/count_arma",{ modelo = arma })
        local armaselecionada = armaencontrada[1]
		if armaselecionada.quantidade > 0 then
            vRPclient.giveWeapons(source,{[globalarmas[arma]] = { ammo = 150 }})
            vRP.execute("vRP/update_estoque",{ user_id = user_id, modelo = arma, quantidade = armaselecionada.quantidade - 1  })
            TriggerClientEvent("Notify",source,"sucesso","Equipado(a) "..arma.." com sucesso")
            TriggerClientEvent("Notify",source,"sucesso","Restam "..armaselecionada.quantidade - 1 .." "..arma.." em estoque")
        else
            TriggerClientEvent("Notify",source,"negado","Sem Estoque")
        end
    end
end


armasguardar = {
    glock = "wbody|weapon_combatpistol",
    m4a1 =  "wbody|weapon_assaultrifle"
}


function henrique.guardar(nome)
    local user_id = vRP.getUserId(source)
    if user_id then
        local weapons = vRPclient.replaceWeapons(source,{})
		for k,v in pairs(weapons) do
            vRP.giveInventoryItem(user_id,"wbody|"..k,1)
            --vRP.execute("vRP/update_estoque",{ user_id = user_id, modelo = arma, quantidade = k.quantidade + 1  })
            vRP.tryGetInventoryItem(user_id,armasguardar[nome], 1)
		end
		TriggerClientEvent("Notify",source,"sucesso","Você guardou seu armamento na mochila.")
	end
end








