--<<Teleport Sellback | Mod by HiRusSai>>
require("libs.Utils")
require("libs.ScriptConfig")

local config = ScriptConfig.new()
config:SetParameter("Hotkey", "U", config.TYPE_HOTKEY)
config:Load()

local Screen = client.screenSize.x/1600
local Active = false
local Hotkey = config.Hotkey
local registered  = false

local F14 = drawMgr:CreateFont("F14","Tahoma",14*Screen,550*Screen)
local statusText = drawMgr:CreateText(1500*Screen,695*Screen,-1,"TP Sellback: OFF",F14)

function onLoad()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if not me then
			script:Disable()
		else
			registered = true
			script:RegisterEvent(EVENT_TICK,Tick)
			script:RegisterEvent(EVENT_KEY,Key)
			script:UnregisterEvent(onLoad)
		end
	end
end

function Key(msg,code)
	if client.chat or client.console or client.loading then return end
	if IsKeyDown(Hotkey) then
		Active = not Active
		if Active then
			statusText.text = "TP Sellback: ON"
		elseif not Active then
			statusText.text = "TP Sellback: OFF"
		end
	end
end


function Tick( tick )
	if not client.connected or client.loading or client.console or not SleepCheck() then
		return
	end
	if not Active then return end
	local me = entityList:GetMyHero()
	local mp = entityList:GetMyPlayer()

	local tp = me:FindItem("item_tpscroll")
	local tping = me:FindModifier("modifier_teleporting")

	if tping and tping.remainingTime < ((client.latency)/1000) then
	    mp:SellItem(tp)
	end

end

function onClose()
	collectgarbage("collect")
	if registered then
		script:UnregisterEvent(Key)
		script:UnregisterEvent(Tick)
		statusText.visible = false
		registered = false
	end
end

script:RegisterEvent(EVENT_CLOSE,onClose)
script:RegisterEvent(EVENT_TICK,onLoad)