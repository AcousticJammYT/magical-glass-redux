local item, super = Class(HealItem, "items/monster_candy")

function item:init(inventory)
    super.init(self)

    -- Display name
    self.name = "Monster Candy"
    self.short_name = "MnstrCndy"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    self.heal_amount = 10

    -- Default shop price (sell price is halved)
    self.price = 25
    -- Whether the item can be sold
    self.can_sell = true

    -- Light world check text
    self.check = "Heals 10 HP\n* Has a distinct,\nnon licorice flavor."

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "party"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false
    
    -- Default dark item conversion for this item
    self.dark_item = "dark_candy"
end

function item:onToss()
    Game.world:showText("* The Monster Candy was\n  yeeted.")
    return false
end

return item