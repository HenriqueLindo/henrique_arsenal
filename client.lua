local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
henrique = Tunnel.getInterface("henrique_arsenal")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PEGAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("a",function(source,args)
	local ped = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(ped))
	if Vdist(x,y,z,451.74533081055,-978.78570556641,30.684900283813) <= 2 then
		henrique.getweapon(args[1])
	end
end)





RegisterCommand("guardar",function(source,args)
	local ped = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(ped))
	if Vdist(x,y,z,451.74533081055,-978.78570556641,30.684900283813) <= 2 then
		henrique.guardar(args[1])
	end
end)
