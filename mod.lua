function Mod:init()
    print("There is no exit.")
    self:loadHooks()

    Mod.trapped = true
    --hello
    PALETTE["tension_back"] = { 0.5, 0.5, 0.5, 1 }
    PALETTE["tension_decrease"] = { 198/255, 198/255, 198/255, 1 }
    PALETTE["tension_fill"] = { 198/255, 198/255, 198/255, 1 }
    PALETTE["tension_max"] = { 1,1,1, 1 }
    PALETTE["tension_maxtext"] = { 1, 1, 1, 1 }
    PALETTE["tension_desc"] = { 1,1,1, 1 }
    PALETTE["action_strip"] = { .5,.5,.5 }
end

function Mod:addOutline(character)
    character:addFX(OutlineFX({1,1,1}), "VoidOutline") --actor.color
    character:addFX(ColorMaskFX({0,0,0}, 1, 50), "VoidFill")
end

function Mod:refreshOutlines()
    for _,member in ipairs(Game.party) do
        local chara = Game.world:getCharacter(member.id)
        local actor = member:getActor()

        if chara:getFX("VoidOutline") and chara:getFX("VoidFill") then
            chara:removeFX("VoidOutline")
            chara:removeFX("VoidFill")
        end
        Mod:addOutline(chara)
    end
end

function Mod:loadHooks()

    Utils.hook(Map, "onEnter", function(orig, self, ...)
        Mod:refreshOutlines()
        orig(self, ...)
    end)

    Utils.hook(OverworldActionBox, "init", function(orig, self, ...)
        orig(self, ...)
        self.head_sprite.x = -1000
        self.head_sprite.y = -1000

        if self.name_sprite then
            self.name_sprite.x = self.name_sprite.x - 40
        end
    end)

    Utils.hook(PartyBattler, "init", function(orig, self, chara, x, y)
        orig(self, chara, x, y)

        if self.sprite:getFX("VoidOutline") and self:getFX("VoidFill") then
            self.sprite:removeFX("VoidOutline")
            self.sprite:removeFX("VoidFill")
        end
        Mod:addOutline(self.sprite)
    end)

    Utils.hook(Arena, "init", function(orig, self, x, y, shape)
        orig(self, x, y, shape)

        self.color = {1,1,1}
    end)
    
    Utils.hook(Battle, "drawBackground", function(orig, self)
        if not Mod.trapped then
            orig(self)
        else
            Draw.setColor(0, 0, 0, self.transition_timer / 10)
            love.graphics.rectangle("fill", -8, -8, SCREEN_WIDTH+16, SCREEN_HEIGHT+16)

            love.graphics.setLineStyle("rough")
            love.graphics.setLineWidth(1)

            for i = 2, 16 do
                Draw.setColor(0.5, 0.5, 0.5, (self.transition_timer / 10) / 2)
                love.graphics.line(0, -210 + (i * 50) + math.floor(self.offset / 2), 640, -210 + (i * 50) + math.floor(self.offset / 2))
                love.graphics.line(-200 + (i * 50) + math.floor(self.offset / 2), 0, -200 + (i * 50) + math.floor(self.offset / 2), 480)
            end

            for i = 3, 16 do
                Draw.setColor(0.5, 0.5, 0.5, self.transition_timer / 10)
                love.graphics.line(0, -100 + (i * 50) - math.floor(self.offset), 640, -100 + (i * 50) - math.floor(self.offset))
                love.graphics.line(-100 + (i * 50) - math.floor(self.offset), 0, -100 + (i * 50) - math.floor(self.offset), 480)
            end
        end
    end)

    --[[
    Utils.hook(OverworldActionBox, "draw", function(orig, self, ...)
        Object.draw(self)
        -- Draw the line at the top
        if self.selected then
            Draw.setColor({1,1,1})
        else
            Draw.setColor({0.5, 0.5, 0.5})
        end
        
        love.graphics.setLineWidth(2)
        love.graphics.line(0, 1, 213, 1)
        
        if Game:getConfig("oldUIPositions") then
            love.graphics.line(0, 2, 2, 2)
            love.graphics.line(211, 2, 213, 2)
        end
    
        -- Draw health
        Draw.setColor({0.5, 0.5, 0.5})
        love.graphics.rectangle("fill", 128, 24, 76, 9)
    
        local health = (self.chara:getHealth() / self.chara:getStat("health")) * 76
    
        if health > 0 then
            Draw.setColor({1,1,1})
            love.graphics.rectangle("fill", 128, 24, math.ceil(health), 9)
        end
    
        local color = {1,1,1}
        if health <= 0 then
            color = {0.5, 0.5, 0.5}
        else
            color = {1,1,1}
        end
    
        local health_offset = 0
        health_offset = (#tostring(self.chara:getHealth()) - 1) * 8
    
        Draw.setColor(color)
        love.graphics.setFont(self.font)
        love.graphics.print(self.chara:getHealth(), 152 - health_offset, 11)
        Draw.setColor(PALETTE["action_health_text"])
        love.graphics.print("/", 161, 11)
        local string_width = self.font:getWidth(tostring(self.chara:getStat("health")))
        Draw.setColor(color)
        love.graphics.print(self.chara:getStat("health"), 205 - string_width, 11)
    
        local reaction_x = -1
    
        if self.x == 0 then -- lazy check for leftmost party member
            reaction_x = 3
        end
    
        love.graphics.setFont(self.main_font)
        Draw.setColor(1, 1, 1, self.reaction_alpha / 6)
        love.graphics.print(self.reaction_text, reaction_x, 43, 0, 0.5, 0.5)
    end)
    ]]

end