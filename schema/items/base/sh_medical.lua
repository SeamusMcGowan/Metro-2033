ITEM.name = "Medical Stuff"
ITEM.model = "models/healthvial.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.desc = "A Medical Stuff"
ITEM.healAmount = 50
ITEM.healSeconds = 10
ITEM.category = "Medical"

local function healPlayer(client, target, amount, seconds)
	hook.Run("OnPlayerHeal", client, target, amount, seconds)

	if (client:Alive() and target:Alive()) then
		local id = "nutHeal_"..FrameTime()
		timer.Create(id, 1, seconds, function()
			if (!target:IsValid() or !target:Alive()) then
				timer.Destroy(id)	
			end

			target:SetHealth(math.Clamp(target:Health() + (amount/seconds), 0, target:GetMaxHealth()))
		end)
	end
end

local function onUse(item)
	item.player:EmitSound("items/medshot4.wav", 80, 110)
	item.player:ScreenFade(1, Color(0, 255, 0, 100), .4, 0)
end

ITEM:hook("_use", onUse)
ITEM:hook("_usef", onUse)

ITEM.functions._use = { -- sorry, for name order.
	name = "Use",
	tip = "Heal Yourself",
	icon = "icon16/heart.png",
	onRun = function(item)
		if (item.player:Alive()) then
			healPlayer(item.player, item.player, item.healAmount, item.healSeconds)
		end
	end,
}


ITEM.functions._usef = { -- sorry, for name order.
	name = "Heal Target",
	tip = "Heals Who You're Looking At",
	icon = "icon16/eye.png",
	onRun = function(item)
		local client = item.player
		local trace = client:GetEyeTraceNoCursor() -- We don't need cursors.
		local target = trace.Entity

		if (target and target:IsValid() and target:IsPlayer() and target:Alive()) then
			healPlayer(item.player, target, item.healAmount, item.healSeconds)

			return true
		end

		return false
	end,
	onCanRun = function(item)
		return (!IsValid(item.entity))
	end
}
