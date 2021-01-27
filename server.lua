local Tunnel = module("scrp","lib/Tunnel")
local Proxy = module("scrp","lib/Proxy")
scrp = Proxy.getInterface("scrp")
scrpclient = Tunnel.getInterface("scrp")

scRP = {}
Tunnel.bindInterface("henrique_arsenal",scRP)

-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE
-----------------------------------------------------------------------------------------------------------------------------------------
scrp._prepare("scrp/count_arma","SELECT quantidade  FROM scrp_estoquearsenal WHERE modelo = @modelo  ")
scrp._prepare("scrp/update_estoque","UPDATE scrp_estoquearsenal SET quantidade = @quantidade WHERE user_id = @user_id and modelo = @modelo")

-----------------------------------------------------------------------------------------------------------------------------------------
-- CÓDIGO
-----------------------------------------------------------------------------------------------------------------------------------------

globalarmas = {
    glock = "weapon_combatpistol",
    m4a1 =  "weapon_assaultrifle"
}

function scRP.getweapon(arma)
	local source = source
	local user_id = scrp.getUserId(source)
    if user_id then
        local armaencontrada = scrp.query("scrp/count_arma",{ modelo = arma })
        local armaselecionada = armaencontrada[1]
		if armaselecionada.quantidade > 0 then
            scrpclient.giveWeapons(source,{[globalarmas[arma]] = { ammo = 150 }})
            scrp.execute("scrp/update_estoque",{ user_id = user_id, modelo = arma, quantidade = armaselecionada.quantidade - 1  })
            TriggerClientEvent("Notify",source,"sucesso","Equipado(a) "..arma.." com sucesso")
            TriggerClientEvent("Notify",source,"sucesso","Restam "..armaselecionada.quantidade - 1 .." "..arma.." em estoque")
        else
            TriggerClientEvent("Notify",source,"negado","Sem Estoque")
        end
    end
end









--[[function scRP.guardar(arma)
    local source = source
	local user_id = scrp.getUserId(source)
    if user_id then
        local armaencontrada = scrp.query("scrp/count_arma",{ modelo = arma })
        local armaselecionada = armaencontrada[1]
        if armaselecionada.quantidade then
            if scrp.tryGetInventoryItem(user_id,armasguardar[arma], 1) then
                scrp.execute("scrp/update_estoque",{ user_id = user_id, modelo = arma, quantidade = armaselecionada.quantidade + 1  })
                TriggerClientEvent("Notify",source,"sucesso","Guardado(a) "..arma.." com sucesso")
                TriggerClientEvent("Notify",source,"sucesso","Restam "..armaselecionada.quantidade + 1 .." "..arma.." em estoque")
            end
        end
    end
end--]]


armasguardar = {
    glock = "wbody|weapon_combatpistol",
    m4a1 =  "wbody|weapon_assaultrifle"
}


function scRP.guardar(nome)
    local user_id = scrp.getUserId(source)
    if user_id then
        local weapons = scrpclient.replaceWeapons(source,{})
		for k,v in pairs(weapons) do
            scrp.giveInventoryItem(user_id,"wbody|"..k,1)
            --scrp.execute("scrp/update_estoque",{ user_id = user_id, modelo = arma, quantidade = k.quantidade + 1  })
            scrp.tryGetInventoryItem(user_id,armasguardar[nome], 1)
		end
		TriggerClientEvent("Notify",source,"sucesso","Você guardou seu armamento na mochila.")
	end
end








