local character, super = Class("susie", true)

function character:init()
    super.init(self)
    
end

function character:getTitle()
    return "Tank\nTrapped in the Void."
end

return character