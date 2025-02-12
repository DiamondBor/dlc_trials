local character, super = Class("hero", true)

function character:init()
    super.init(self)
    
end

function character:getTitle()
    return "Warrior\nTrapped in the Void."
end

return character