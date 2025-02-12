return {
    ---@param cutscene WorldCutscene
    main = function(cutscene, map, partyleader)
        if map == "the_void/void_1" then
            cutscene:text("* (You tried to speak out...)")
            cutscene:text("[speed:0.8]* (...)\n[wait:10](...)\n[wait:10](...)")
            cutscene:text("* (But your voice echoed aimlessly.)")
        else
            cutscene:text("* (But your voice echoed aimlessly.)")
        end
    end,
}