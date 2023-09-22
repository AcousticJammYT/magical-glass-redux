local LightEquipItem, super = Class("LightEquipItem", true)

function LightEquipItem:init()
    super.init(self)

    self.target = "ally"

    self.heal_bonus = 0
    self.inv_bonus = 0

    self.bolt_count = 1

    self.bolt_speed = 11
    self.bolt_speed_variance = 2

    self.bolt_start = -16 -- number or table of where the bolt spawns. if it's a table, a value is chosen randomly
    self.multibolt_variance = {{0, 25, 50}, {100, 125, 150}}

    self.bolt_direction = "right" -- "right", "left", or "random"

    self.bolt_miss_threshold = 296

    self.attack_sprite = "effects/attack/strike"

    -- Sound played when attacking, defaults to laz_c
    self.attack_sound = "laz_c"

    self.attack_pitch = 1
end

function LightEquipItem:getFleeBonus() return 0 end

function LightEquipItem:getHealBonus() return self.heal_bonus end
function LightEquipItem:getInvBonus() return self.inv_bonus end

function LightEquipItem:getBoltCount() return self.bolt_count end

function LightEquipItem:getBoltSpeed()
    if self:getBoltSpeedVariance() then
        return self.bolt_speed + self:getBoltSpeedVariance()
    else
        return self.bolt_speed
    end
end
function LightEquipItem:getBoltSpeedVariance() return self.bolt_speed_variance end

function LightEquipItem:getBoltStart()
    if type(self.bolt_start) == "table" then
        return Utils.pick(self.bolt_start)
    elseif type(self.bolt_start) == "number" then
        return self.bolt_start
    end
end

function LightEquipItem:getMultiboltVariance(index)
    if self.multibolt_variance[index] then
        return Utils.pick(self.multibolt_variance[index])
    else
        local value = Utils.pick(self.multibolt_variance[#self.multibolt_variance])
        value = value + Utils.pick(self.multibolt_variance[(index + 1) - #self.multibolt_variance])
        return value
    end
end

function LightEquipItem:getBoltDirection() 
    if self.bolt_direction == "random" then
        return Utils.pick({"right", "left"})
    else
        return self.bolt_direction
    end
end

function LightEquipItem:getAttackMissZone() return self.bolt_miss_threshold end

function LightEquipItem:getAttackSprite() return self.attack_sprite end

function LightEquipItem:getAttackSound() return self.attack_sound end
function LightEquipItem:getAttackPitch() return self.attack_pitch end

function LightEquipItem:onTurnEnd() end

-- these need to be modified for more than one party member
function LightEquipItem:showEquipText(target)
    Game.world:showText("* " .. target:getNameOrYou() .. " equipped the "..self:getName()..".")
end

function LightEquipItem:onWorldUse(target)
    Assets.playSound("item")
    local replacing = nil
    if self.type == "weapon" then
        if target:getWeapon() then
            replacing = target:getWeapon()
            replacing:onUnequip(target, self)
            Game.inventory:replaceItem(self, replacing)
        end
        target:setWeapon(self)
    elseif self.type == "armor" then
        if target:getArmor(1) then
            replacing = target:getArmor(1)
            replacing:onUnequip(target, self)
            Game.inventory:replaceItem(self, replacing)
        end
        target:setArmor(1, self)
    else
        error("LightEquipItem "..self.id.." invalid type: "..self.type)
    end

    self:onEquip(target, replacing)

    self:showEquipText(target)
    return false
end

function LightEquipItem:onBattleSelect(user, target)
    return false
end

function LightEquipItem:getLightBattleText(user, target)
    return "* ".. target.chara:getNameOrYou() .. " equipped the " .. self:getName() .. "."
end

function LightEquipItem:onLightBattleUse(user, target)
    Assets.playSound("item")
    local chara = target.chara
    local replacing = nil
    if self.type == "weapon" then
        if chara:getWeapon() then
            replacing = chara:getWeapon()
            replacing:onUnequip(chara, self)
            Game.inventory:replaceItem(self, replacing)
        end
        chara:setWeapon(self)
    elseif self.type == "armor" then
        if chara:getArmor(1) then
            replacing = chara:getArmor(1)
            replacing:onUnequip(chara, self)
            Game.inventory:replaceItem(self, replacing)
        end
        chara:setArmor(1, self)
    end

    self:onEquip(chara, replacing)
end

function LightEquipItem:onBoltHit(battler) end
function LightEquipItem:scoreHit(battler, score, eval, close)
    local new_score = score
    new_score = new_score + eval

    if new_score > 430 then
        new_score = new_score * 1.8
    end
    if new_score >= 400 then
        new_score = new_score * 1.25
    end

    return new_score
end

function LightEquipItem:onAttack(battler, enemy, damage, stretch)

    local src = Assets.stopAndPlaySound(self:getAttackSound())
    src:setPitch(self:getAttackPitch() or 1)

    local sprite = Sprite(self:getAttackSprite())
    local scale = (stretch * 2) - 0.5
    sprite:setScale(scale, scale)
    sprite:setOrigin(0.5, 0.5)
    sprite:setPosition(enemy:getRelativePos((enemy.width / 2) - 5, (enemy.height / 2) - 5))
    sprite.layer = BATTLE_LAYERS["above_ui"] + 5
    sprite.color = battler.chara:getLightAttackColor() -- need to swap this to the get function
    enemy.parent:addChild(sprite)
    sprite:play((stretch / 4) / 1.5, false, function(this) -- timing may still be incorrect
        
        local sound = enemy:getDamageSound() or "damage"
        if sound and type(sound) == "string" then
            Assets.stopAndPlaySound(sound)
        end
        enemy:hurt(damage, battler)

        battler.chara:onAttackHit(enemy, damage)
        this:remove()

        Game.battle:endAttack()

    end)

end

function LightEquipItem:onMiss(battler, enemy, finish)
    enemy:hurt(0, battler, on_defeat, {battler.chara:getLightMissColor()})
    if finish then
        Game.battle:endAttack()
    end
end

return LightEquipItem