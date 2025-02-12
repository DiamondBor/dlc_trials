local character, super = Class("jerdly", true)

function character:init()
    super.init(self)
    
end

function character:getTitle()
    return "Wizard\nTrapped in the Void."
end

return character