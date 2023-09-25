local item, super = Class(LightEquipItem, "armors/stained_apron")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Stained Apron"
    self.short_name = "StainApro"
    self.serious_name = "Apron"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Whether this item is for the light world
    self.light = true

    -- Light world check text
    self.check = "Armor DF 11\n* Heals 1 HP every other\nturn."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil

    self.bonuses = {
        defense = 11
    }

end

function item:onTurnEnd(battler)
    if Game.battle.turn_count % 2 == 0 then
        battler:heal(1)
        Assets.stopAndPlaySound("power")
    end
end

function item:showEquipText()
    Game.world:showText("* You equipped the apron.")
end

return item