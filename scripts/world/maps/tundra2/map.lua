local room, super = Class(Map)

function room:load()
    super.load(self)

    for _,tree in pairs(Game.world.map:getEvents("tree")) do
        tree.wrap_texture_x = false
        tree.parallax_x = 1.7
        tree.x = (tree.x * 1.6) + 50
    end
    
    self.timer:every(2, function()
        local marker1 = self.markers["shooter"]
        self.world:spawnBullet("testbullet", marker1.center_x, Utils.random(marker1.y, marker1.y+marker1.height), false)
    end)
end

return room
