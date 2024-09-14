function Mod:init()
    print("Loaded "..self.info.name.."!")
end

function Mod:load(new_file)
    if new_file then
        Game.money = Kristal.getLibConfig("magical-glass", "debug") and 1000 or 0
        Game.lw_money = Kristal.getLibConfig("magical-glass", "debug") and 1000 or 0
        MagicalGlassLib:setLightBattleShakingText(true)
    end
    Game.world:registerCall("Dimensional Box A", "cell.box_a", false)
    Game.world:registerCall("Dimensional Box B", "cell.box_b", false)
end

-- function Mod:getLightActionButtons(battler, buttons)
    -- return {"fight", "act"}
-- end