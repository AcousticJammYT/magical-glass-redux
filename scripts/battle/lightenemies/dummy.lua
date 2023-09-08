local Dummy, super = Class(LightEnemyBattler)

function Dummy:init()
    super:init(self)

    -- Enemy name
    self.name = "Dummy"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("dummy")

    -- Enemy health
    self.max_health = 10
    self.health = 10
    -- Enemy attack (determines bullet damage)
    self.attack = 7
    -- Enemy defense (usually 0)
    self.defense = 0
    -- Enemy reward
    self.money = 69
    self.experience = 1

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 0

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        "basic",
        "movingarena"
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {
        "[wave:2].[wait:5].[wait:5].[wait:5]"
    }

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = "ATK Some DEF Probably\n* Cotton heart and button eye\n* You are the apple of my eye"

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* The dummy gives you a soft\nsmile.",
        "* The power of fluffy boys is\nin the air.",
        "* Smells like cardboard.",
    }
    -- Text displayed at the bottom of the screen when the enemy has low health
    self.low_health_text = "* The dummy looks like it's\nabout to fall over."

    -- Register act called "Smile"
    self:registerAct("Smile")
    self:registerAct("deltarune")
    self:registerAct("Susie")

    -- Register party act with Ralsei called "Tell Story"
    -- (second argument is description, usually empty)
    self:registerAct("Tell Story", "", {"noelle"})

    -- can be a table or a number. if it's a number, it determines the width, and the height will be 13 (the ut default).
    -- if it's a table, the first value is the width, and the second is the height
    self.gauge_size = 150

    self.damage_offset = {5, -70}
end

function Dummy:onAct(battler, name)
    if name == "Smile" then
        -- Give the enemy 100% mercy
        self:addMercy(100)
        -- Change this enemy's dialogue for 1 turn
        self.dialogue_override = "... ^^"
        -- Act text (since it's a list, multiple textboxes)
        return {
            "* You smile.[wait:5]\n* The dummy smiles back.",
            "* It seems the dummy just wanted\nto see you happy."
        }

    elseif name == "Tell Story" then
        -- Loop through all enemies
        for _,enemy in ipairs(Game.battle.enemies) do
            -- Make the enemy tired
            enemy:setTired(true)
        end
        return "* You and Ralsei told the dummy\na bedtime story.\n* The enemies became [color:blue]TIRED[color:reset]..."

    elseif name == "deltarune" then
        local fuck = self:getAct("deltarune")
        fuck.name = "undertale"
        Game.battle.encounter:setFlag("deltarune", true)
        Game:setFlag("enable_lw_tp", true)
        Game:setFlag("enable_focus", true)
        Game.battle.tension_bar = LightTensionBar(-25, 53, false)
        Game.battle.tension_bar:show()
        Game.battle:addChild(Game.battle.tension_bar)
        return "* deltrarune"

    elseif name == "undertale" then
        local fuck = self:getAct("undertale")
        fuck.name = "deltarune"
        Game.battle.encounter:setFlag("deltarune", false)
        Game:setFlag("enable_lw_tp", false)
        Game:setFlag("enable_focus", false)

        Game.battle.tension_bar:hide()
--[[         Game.battle.timer:after(1, function()
            Game.battle.tension_bar = nil
        end) ]]
        Game.battle:addChild(Game.battle.tension_bar)
        return "* udnertal"
    elseif name == "Susie" then
        Game.battle:startActCutscene("dummy", "susie_punch")
        return 
    elseif name == "Standard" then --X-Action
        -- Give the enemy 50% mercy
        self:addMercy(50)
        if battler.chara.id == "ralsei" then
            -- R-Action text
            return "* Ralsei bowed politely.\n* The dummy spiritually bowed\nin return."
        elseif battler.chara.id == "susie" then
            -- S-Action: start a cutscene (see scripts/battle/cutscenes/dummy.lua)
            Game.battle:startActCutscene("dummy", "susie_punch")
            return
        else
            -- Text for any other character (like Noelle)
            return "* "..battler.chara:getName().." straightened the\ndummy's hat."
        end
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super:onAct(self, battler, name)
end

return Dummy