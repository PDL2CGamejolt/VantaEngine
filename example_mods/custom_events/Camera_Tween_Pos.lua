function onEvent(n, value1, va2)
if n == "Camera Tween Pos" or n== "Camera_Tween_Pos" then --checking the event name. checks for the discord renamed one too 
v1 = stringSplit(value1, ",")

ve2 = stringSplit(va2, ",")
v2 = ve2[1] or 0 --defaults v2 (delayUntilBack) to 0 if nothing is inputted
if ve2[2] then --if second argument of value2 exists (isnt nil)
    if stringTrim(string.lower(ve2[2])) == 'false' then --checks for "false" as a valid no response
        h = false
    else
        h = true
    end
else
    h = false
end

if v1[5] then --same thing above but for additive pos
    if stringTrim(string.lower(v1[5])) == 'false' then
        e = false
    else
        e = true
    end
else
    e = false
end


if e then
    v1[1] = v1[1] + cameraX --is this how math works is this gonna work properly and shit or
    v1[2] = v1[2] + cameraY
end


--i cant be bothered to comment the hscript it's probably ass anyway
--"tag" is defined below, in onCreatePost, by the way.
runHaxeCode([[
    dummy.revive();
    camx = game.camFollowPos.x;
    camy = game.camFollowPos.y;
    dummy.x = camx;
    dummy.y = camy;
    if(PlayState.instance.modchartTweens.exists(tag)) {
        PlayState.instance.modchartTweens.get(tag).cancel();
        PlayState.instance.modchartTweens.get(tag).destroy();
        PlayState.instance.modchartTweens.remove(tag);
    }
    game.isCameraOnForcedPos = true;
    game.modchartTweens.set(tag, FlxTween.tween(dummy, {x: ]]..tostring(v1[1])..[[, y: ]]..tostring(v1[2])..[[}, ]]..tostring(v1[3])..[[, {ease: FlxEase.]]..stringTrim(v1[4])..[[, onUpdate: function(twn:FlxTween){
        FlxG.camera.follow(dummy);
        FlxG.camera.target = dummy;
        FlxG.camera.snapToTarget();},
        onComplete: function(twn:FlxTween){
            PlayState.instance.modchartTweens.remove(tag);
            dummy.kill();
            game.camFollowPos.x = ]]..tostring(v1[1])..[[;
            game.camFollowPos.y = ]]..tostring(v1[2])..[[;
            game.camFollow.x = ]]..tostring(v1[1])..[[;
            game.camFollow.y = ]]..tostring(v1[2])..[[;
            FlxG.camera.follow(game.camFollowPos);
            FlxG.camera.target = game.camFollowPos;
            game.callOnLuas("onMyBallsItching", []]..tostring(v1[1])..[[, ]]..tostring(v1[2])..[[, ]]..tostring(h)..[[, ]]..tostring(v2)..[[]);
        }
}));
]])
end
end

function onCreatePost()
addHaxeLibrary("FlxObject", "flixel")
runHaxeCode("dummy = new FlxObject(); game.add(dummy);tag = 'Camera Tween Pos';")
end


function onMyBallsItching(v1,v2, stick, timah)
    timah = timah or 0
    if not stick then
        if timah == 0 then
            runHaxeCode([[
                game.isCameraOnForcedPos = true;
                if (!PlayState.SONG.notes[game.curSection].gfSection)
                    game.moveCamera(!PlayState.SONG.notes[game.curSection].mustHitSection);
                else   
                    if (game.gf != null){
                        //no promises on the gfSection thing working lmao
			game.camFollow.set(game.gf.getMidpoint().x, game.gf.getMidpoint().y);
			game.camFollow.x += game.gf.cameraPosition[0] + game.girlfriendCameraOffset[0];
			game.camFollow.y += game.gf.cameraPosition[1] + game.girlfriendCameraOffset[1];
		
        }

            ]])
            triggerEvent("Camera Follow Pos", "", "")
        else
        runTimer("hi xd lol idk", timah)
        end
    else
        triggerEvent("Camera Follow Pos", tostring(v1), tostring(v2))
    end
    
end

function onTimerCompleted(tag, loops, loopsLeft)
if tag == "hi xd lol idk" then
    triggerEvent("Camera Follow Pos", "", "")
end
end
