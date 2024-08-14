return {
    susie_punch = function(cutscene, battler, enemy)
        -- Open textbox and wait for completion
        cutscene:text("* Susie threw a punch at\nthe dummy.")

        -- Hurt the target enemy for 1 damage
        Assets.playSound("damage")
        enemy:hurt(1, battler)
        -- Wait 1 second
        cutscene:wait(1)

        -- Susie text
        cutscene:text("* You look uhh...[wait:5] soft.[wait:5]\n* I don't like beating up\npeople like that.", "nervous_side", "susie")

        if cutscene:getCharacter("ralsei") then
            -- Ralsei text, if he's in the party
            cutscene:text("* Aww,[wait:5] Susie![talk:false][react:1][wait:5][react:2][wait:5][react:3][wait:5][react:4]", "blush_pleased", "ralsei", {reactions={
            {"BottomLeft", "left", "bottom", "surprise", "susie"},
            {"RightTop", "right", "top", "blush", "ralsei"},
            {"MidMid", "mid", "mid", "smile", "noelle"},
            {"Right BottomMid", "right", "bottommid", "surprise", "susie"},
        }})
        end
    end
}