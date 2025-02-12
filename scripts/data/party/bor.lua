local character, super = Class("bor", true)

function character:init()
    super.init(self)
    
end

function character:getTitle()
    return "Healer\nTrapped in the Void."
end

return character