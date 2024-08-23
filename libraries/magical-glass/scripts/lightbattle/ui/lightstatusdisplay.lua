local LightStatusDisplay, super = Class(Object, "LightStatusDisplay")

function LightStatusDisplay:init(x, y, story)
    super.init(self, x, y, SCREEN_WIDTH + 1, 43)
    
    self.story = story
end

function LightStatusDisplay:getHPGaugeLengthCap()
    return Kristal.getLibConfig("magical-glass", "hp_gauge_length_cap")
end

function LightStatusDisplay:draw()
    if self.story and Game.battle.party[1] then
        self:drawStatusStripStory()
    else
        self:drawStatusStrip()
    end
end

function LightStatusDisplay:drawStatusStripStory()
    local x, y = 200, 10
    
    local karma_mode = Game.battle.encounter.karma_mode
    local karma_mode_offset = karma_mode and 20 or 0
    
    local level = Game:isLight() and Game.battle.party[1].chara:getLightLV() or Game.battle.party[1].chara:getLevel()

    love.graphics.setFont(Assets.getFont("namelv", 24))
    love.graphics.setColor(COLORS["white"])
    love.graphics.print("LV " .. level, x - karma_mode_offset, y)

    love.graphics.draw(Assets.getTexture("ui/lightbattle/hp"), x + 74 - karma_mode_offset, y + 5)

    local max = Game.battle.party[1].chara:getStat("health")
    local current = Game.battle.party[1].chara:getHealth()
    local karma = Game.battle.party[1].karma
    
    local limit = self:getHPGaugeLengthCap()
    if limit == true then
        limit = 99
    end
    local size = max
    if limit and size > limit then
        size = limit
        limit = true
    end
    
    if karma_mode then
        love.graphics.draw(Assets.getTexture("ui/lightbattle/kr"), x + 110 + size * 1.2 + 1 + 9 - karma_mode_offset, y + 5)
    end

    love.graphics.setColor(karma_mode and MagicalGlassLib.PALETTE["player_karma_health_bg"] or MagicalGlassLib.PALETTE["player_health_bg"])
    love.graphics.rectangle("fill", x + 110 - karma_mode_offset, y, size * 1.2 + 1, 21)
    if current > 0 then
        love.graphics.setColor(MagicalGlassLib.PALETTE["player_karma_health"])
        love.graphics.rectangle("fill", x + 110 - karma_mode_offset, y, (limit == true and math.ceil((Utils.clamp(current, 0, max + (karma_mode and 5 or 10)) / max) * size) * 1.2 + 1 or Utils.clamp(current, 0, max + (karma_mode and 5 or 10)) * 1.2 + 1) + (karma_mode and karma == 0 and current > 0 and current < max and 1 or 0), 21)
        love.graphics.setColor(MagicalGlassLib.PALETTE["player_health"])
        love.graphics.rectangle("fill", x + 110 - karma_mode_offset, y, (limit == true and math.ceil((Utils.clamp(current - karma, 0, max + 10) / max) * size) * 1.2 + 1 or Utils.clamp(current - karma, 0, max + 10) * 1.2 + 1) - (karma_mode and (karma == 0 or current - karma >= max) and current > 0 and current >= max and 1 or 0), 21)
    end

    if max < 10 and max >= 0 then
        max = "0" .. tostring(max)
    end

    if current < 10 and current >= 0 then
        current = "0" .. tostring(current)
    end

    local color = COLORS.white
    if not Game.battle.party[1].is_down and not Game.battle.forced_victory then
        if Game.battle.party[1].sleeping then
            color = MagicalGlassLib.PALETTE["player_sleeping_text"]
        elseif Game.battle:getActionBy(Game.battle.party[1]) and Game.battle:getActionBy(Game.battle.party[1]).action == "DEFEND" then
            color = MagicalGlassLib.PALETTE["player_defending_text"]
        elseif karma > 0 then
            color = MagicalGlassLib.PALETTE["player_karma_text"]
        end
    end
    love.graphics.setColor(color)
    love.graphics.print(current .. " / " .. max, x + 115 + size * 1.2 + 1 + 14 + (karma_mode and Assets.getTexture("ui/lightbattle/kr"):getWidth() + 12 or 0) - karma_mode_offset, y)
end

function LightStatusDisplay:drawStatusStrip()
    for index,battler in ipairs(Game.battle.party) do
        if not Game.battle.multi_mode then
            local x, y = 30, 10
            
            local karma_mode = Game.battle.encounter.karma_mode
            local karma_mode_offset = karma_mode and 20 or 0
            
            local name = battler.chara:getName()
            local level = Game:isLight() and battler.chara:getLightLV() or battler.chara:getLevel()
            
            local current = battler.chara:getHealth()
            local max = battler.chara:getStat("health")
            local karma = battler.karma

            love.graphics.setFont(Assets.getFont("namelv", 24))
            love.graphics.setColor(COLORS["white"])
            love.graphics.print(name .. "   LV " .. level, x, y)
            
            love.graphics.draw(Assets.getTexture("ui/lightbattle/hp"), x + 214 - karma_mode_offset, y + 5)
            
            local limit = self:getHPGaugeLengthCap()
            if limit == true then
                limit = 99
            end
            local size = max
            if limit and size > limit then
                size = limit
                limit = true
            end
            
            if karma_mode then
                love.graphics.draw(Assets.getTexture("ui/lightbattle/kr"), x + 245 + size * 1.2 + 1 + 9 - karma_mode_offset, y + 5)
            end

            love.graphics.setColor(karma_mode and MagicalGlassLib.PALETTE["player_karma_health_bg"] or MagicalGlassLib.PALETTE["player_health_bg"])
            love.graphics.rectangle("fill", x + 245 - karma_mode_offset, y, size * 1.2 + 1, 21)
            if current > 0 then
                love.graphics.setColor(MagicalGlassLib.PALETTE["player_karma_health"])
                love.graphics.rectangle("fill", x + 245 - karma_mode_offset, y, (limit == true and math.ceil((Utils.clamp(current, 0, max + (karma_mode and 5 or 10)) / max) * size) * 1.2 + 1 or Utils.clamp(current, 0, max + (karma_mode and 5 or 10)) * 1.2 + 1) + (karma_mode and karma == 0 and current > 0 and current < max and 1 or 0), 21)
                love.graphics.setColor(MagicalGlassLib.PALETTE["player_health"])
                love.graphics.rectangle("fill", x + 245 - karma_mode_offset, y, (limit == true and math.ceil((Utils.clamp(current - karma, 0, max + (karma_mode and 5 or 10)) / max) * size) * 1.2 + 1 or Utils.clamp(current - karma, 0, max + (karma_mode and 5 or 10)) * 1.2 + 1) - (karma_mode and (karma == 0 or current - karma >= max) and current > 0 and current >= max and 1 or 0), 21)
            end

            if max < 10 and max >= 0 then
                max = "0" .. tostring(max)
            end

            if current < 10 and current >= 0 then
                current = "0" .. tostring(current)
            end

            local color = COLORS.white
            if not battler.is_down and not Game.battle.forced_victory then
                if battler.sleeping then
                    color = MagicalGlassLib.PALETTE["player_sleeping_text"]
                elseif Game.battle:getActionBy(battler) and Game.battle:getActionBy(battler).action == "DEFEND" then
                    color = MagicalGlassLib.PALETTE["player_defending_text"]
                elseif karma > 0 then
                    color = MagicalGlassLib.PALETTE["player_karma_text"]
                end
            end
            love.graphics.setColor(color)
            love.graphics.print(current .. " / " .. max, x + 245 + size * 1.2 + 1 + 14 + (karma_mode and Assets.getTexture("ui/lightbattle/kr"):getWidth() + 12 or 0) - karma_mode_offset, y)
        else
            local x, y = 22 + (3 - #Game.battle.party - (#Game.battle.party == 2 and 0.4 or 0)) * 102 + (index - 1) * 102 * 2 * (#Game.battle.party == 2 and (1 + 0.4) or 1), 10
            
            local name = battler.chara:getShortName()
            local level = Game:isLight() and battler.chara:getLightLV() or battler.chara:getLevel()
            
            local current = battler.chara:getHealth()
            local max = battler.chara:getStat("health")
            local karma = battler.karma
            
            love.graphics.setFont(Assets.getFont("namelv", 24))
            love.graphics.setColor(COLORS["white"])
            love.graphics.print(name, x, y - 7)
            love.graphics.setFont(Assets.getFont("namelv", 16))
            love.graphics.print("LV " .. level, x, y + 13)
            
            love.graphics.draw(Assets.getTexture("ui/lightbattle/hp"), x + 66, y + 15)
            
            local small = false
            for _,party in ipairs(Game.battle.party) do
                if party.chara:getStat("health") >= 100 then
                    small = true
                end
            end
            
            local karma_mode = Game.battle.encounter.karma_mode
            if karma_mode then
                love.graphics.draw(Assets.getTexture("ui/lightbattle/kr"), x + 95 + (small and 20 or 32) * 1.2 + 1, y + 15)
            end
            
            love.graphics.setColor(karma_mode and MagicalGlassLib.PALETTE["player_karma_health_bg"] or MagicalGlassLib.PALETTE["player_health_bg"])
            love.graphics.rectangle("fill", x + 92, y, (small and 20 or 32) * 1.2 + 1, 21)
            if current > 0 then
                love.graphics.setColor(MagicalGlassLib.PALETTE["player_karma_health"])
                love.graphics.rectangle("fill", x + 92, y, math.ceil((Utils.clamp(current, 0, max) / max) * (small and 20 or 32)) * 1.2 + 1 + (karma_mode and karma == 0 and current > 0 and current < max and 1 or 0), 21)
                love.graphics.setColor(MagicalGlassLib.PALETTE["player_health"])
                love.graphics.rectangle("fill", x + 92, y, math.ceil((Utils.clamp(current - karma, 0, max) / max) * (small and 20 or 32)) * 1.2 + 1 - (karma_mode and (karma == 0 or current - karma >= max) and current > 0 and current >= max and 1 or 0), 21)
            end
            
            love.graphics.setFont(Assets.getFont("namelv", 16))
            if max < 10 and max >= 0 then
                max = "0" .. tostring(max)
            end

            if current < 10 and current >= 0 then
                current = "0" .. tostring(current)
            end
            
            local color = COLORS.white
            if not Game.battle.forced_victory then
                if battler.is_down then 
                    color = MagicalGlassLib.PALETTE["player_down_text"]
                elseif battler.sleeping then
                    color = MagicalGlassLib.PALETTE["player_sleeping_text"]
                elseif Game.battle:getActionBy(battler) and Game.battle:getActionBy(battler).action == "DEFEND" then
                    color = MagicalGlassLib.PALETTE["player_defending_text"]
                elseif Game.battle:getActionBy(battler) and Utils.containsValue({"ACTIONSELECT", "MENUSELECT", "ENEMYSELECT", "PARTYSELECT"}, Game.battle:getState()) then
                    color = MagicalGlassLib.PALETTE["player_action_text"]
                elseif karma > 0 then
                    color = MagicalGlassLib.PALETTE["player_karma_text"]
                end
            end
            love.graphics.setColor(color)
            Draw.printAlign(current .. "/" .. max, x + 197, y + 3 - (karma_mode and 2 or 0), "right")
            
            if Game.battle.current_selecting == index or DEBUG_RENDER and Input.alt() then
                love.graphics.setColor(battler.chara:getLightColor())
                love.graphics.setLineWidth(2)
                love.graphics.rectangle("line", x - 3, y - 7, 201, 35)
            end
        end
    end
end

return LightStatusDisplay