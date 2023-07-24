notehitlol = 0
sadfasd = 0 -- unused
font = "vcr.ttf" -- the font that the text will use.
cmoffset = -4
cmy = 20
tnhx = -10
function onCreate()
makeLuaText("tnh", 'Notes Hit: 0', 235, tnhx, 259);
setTextFont('tnh', font)
makeLuaText("cm", 'Combo: 0', 200, -getProperty('tnh.x') + cmoffset, getProperty('tnh.y') + cmy + 10);
makeLuaText("sick", 'Funkies: 0', 200, getProperty('cm.x'), getProperty('cm.y') + 30);
makeLuaText("good", 'OKs: 0', 200, getProperty('cm.x'), getProperty('sick.y') + 30);
makeLuaText("bad", 'Mehs: 0', 200, getProperty('cm.x'), getProperty('good.y') + 30);
makeLuaText("shit", 'Ughs: 0', 200, getProperty('cm.x'), getProperty('bad.y') + 30);
makeLuaText("miss", 'Combo Breaks: 0', 200, getProperty('cm.x'), getProperty('shit.y') + 30);
setObjectCamera("tnh", 'camHUD');
setTextSize('tnh', 20);
addLuaText("tnh");
setObjectCamera("cm", 'camHUD');
setTextSize('cm', 20);
addLuaText("cm");
setTextFont('cm', font)
setTextAlignment('cm', 'center')
setObjectCamera("sick", 'camHUD');
setTextSize('sick', 20);
addLuaText("sick");
setTextFont('sick', font)
setTextAlignment('sick', 'center')
setObjectCamera("good", 'camHUD');
setTextSize('good', 20);
addLuaText("good");
setTextFont('good', font)
setTextAlignment('good', 'center')
setObjectCamera("bad", 'camHUD');
setTextSize('bad', 20);
addLuaText("bad");
setTextFont('bad', font)
setTextAlignment('bad', 'center')
setObjectCamera("shit", 'camHUD');
setTextSize('shit', 20);
addLuaText("shit");
setTextFont('shit', font)
setTextAlignment('shit', 'center')
setObjectCamera("miss", 'camHUD');
setTextSize('miss', 20);
setTextColor('miss', 'ff0000');
addLuaText("miss");
setTextFont('miss', font)
setTextAlignment('miss', 'center')
end

function goodNoteHit(id, direction, noteType, isSustainNote)
-- Function called when you hit a note (after note hit calculations)
-- id: The note member id, you can get whatever variable you want from this note, example: "getPropertyFromGroup('notes', id, 'strumTime')"
-- noteData: 0 = center, 1 = Down, 2 = Up, 3 = Right
-- noteType: The note type string/tag
-- isSustainNote: If it's a hold note, can be either true or false
if not isSustainNote then
notehitlol = notehitlol + 1;
setTextString('tnh', 'Notes Hit: ' .. tostring(notehitlol))
end -- NOTE I DID NOT MAKE THIS FRANTASTIC24 MADE THIS!

end

function onUpdate(elapsed)
notehitloltosting = tostring(notehitlol)
setTextString('cm', 'Combo: ' .. getProperty('combo'))
setTextString('sick', 'Funkies: ' .. getProperty('sicks'))
setTextString('good', 'OKs: ' .. getProperty('goods'))
setTextString('bad', 'Mehs: ' .. getProperty('bads'))
setTextString('shit', 'Ughs: ' .. getProperty('shits'))
setTextString('miss', 'Combo Breaks: ' .. getProperty('songMisses'))
-- start of "update", some variables weren't updated yet
-- setTextString('tnh', 'Notes Hit: ' + 1)
end
