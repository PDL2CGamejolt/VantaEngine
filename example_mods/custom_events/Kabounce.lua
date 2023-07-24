-- Inspired by the "Kaboom" event from Madness Vandalization from BBPanzu!! Check it here --> (https://gamebanana.com/mods/327032)


--[[
    UPDATE LOG!!!!!

    V1: Initial Release
    V1.5: Optimizations!! by @BlueColorsin on discord
    V2 [CURRENT]: Added a "cinematic bars" toggle!
]]

local graphicmodule = require 'mods/scripts/graphicmodule'

function onEvent(tag, var1, var2)
    if tag == 'Kabounce' then
        toggle = tonumber(splitStr(var1, ',')[1])
        bars = tonumber(splitStr(var1, ',')[2])

        angle = tonumber(splitStr(var2, ',')[1])
        intensity = tonumber(splitStr(var2, ',')[2])
        bounceY = tonumber(splitStr(var2, ',')[3])

        local moveTo = {
            720 - thick_half,
            -thick_half
        }

        for i = 1, 2 do
            if bars == 1 then
                setProperty('bar' .. i .. '.visible', true)
                doTweenY('barmove' .. i, 'bar' .. i, moveTo[i], 2, 'circOut')
            else
                doTweenY('baraway' .. i, 'bar' .. i, positionsY[i], 2, 'circOut')
            end
        end

        if toggle == 0 then
            local x = { 'angleGame', 'angleHUD', 'XGame', 'YHUD' }
            for i = 1, 4 do cancelTween(x[i]) end

            doTweenAngle('resetgame', 'camGame', 0, Cro, 'cubeOut');
            doTweenAngle('resetHUD', 'camHUD', 0, Cro, 'cubeOut');
            doTweenX('resetgame2', 'camGame', 0, Cro, 'linear');
            doTweenX('resetHUD2', 'camHUD', 0, Cro, 'linear');
        end
    end
end

function onCreatePost()
    thickness = 200
    thick_half = thickness / 2

    positionsY = {
        720,
        -thickness
    }

    for i = 1, 2 do
        graphicmodule.createhudgraphic('bar' .. i, { 2650, thickness }, '000000', false);
        graphicmodule.setProps('bar' .. i, { screenCenter('bar' .. i, 'x'), positionsY[i] });
        setProperty('bar' .. i .. '.visible', false)
    end
end

function onBeatHit()
    Cro = crochet / 1000
    if toggle == 1 then
        if curBeat % 2 == 0 then
            AngleBitch = angle
        else
            AngleBitch = -angle
        end
        setProperty('camGame.angle', AngleBitch * intensity);
        setProperty('camHUD.angle', -AngleBitch * intensity);
        doTweenAngle('angleGame', 'camGame', AngleBitch, Cro);
        doTweenAngle('angleHUD', 'camHUD', -AngleBitch, Cro);
        doTweenX('YHUD', 'camHUD', AngleBitch * 8, Cro, 'linear');
        doTweenX('XGame', 'camGame', -AngleBitch * 8, Cro, 'linear');

        doTweenY('YHUD1', 'camHUD', -bounceY, Cro * 0.5, "cubeOut");

        triggerEvent("Add Camera Zoom", 0.02, 0.05);
    end
end

function onTweenCompleted(tag)
    if tag == 'YHUD1' then
        doTweenY('YHUD2', 'camHUD', 0, Cro * 0.5, "cubeIn");
    end
    for i = 1, 2 do
        if tag == 'baraway' .. i then
            setProperty('bar' .. i .. '.visible', false)
        end
    end
end

function splitStr(inputstr, sep)
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end

    return t
end
