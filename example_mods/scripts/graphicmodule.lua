local graphicmodule = {}

function graphicmodule.createhudgraphic(tag, scale, color, over)
    makeLuaSprite(tag, nil, 0, 0)
    makeGraphic(tag, scale[1], scale[2], color)
    setObjectCamera(tag, 'camHUD')
    addLuaSprite(tag, over)
end

function graphicmodule.setProps(tag, pos, scale)
    if pos[1] then
        setProperty(tag .. '.x', pos[1])
    end
    if pos[2] then
        setProperty(tag .. '.y', pos[2])
    end
end

return graphicmodule