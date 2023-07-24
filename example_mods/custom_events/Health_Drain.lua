local eventsStuff = {
	drainAmount = {0, 0},
	mainDrain = false,
	oppoDrain = false
}
function onEvent(name, value1, value2)
	if name == 'Health Drain' then
		contents = {v1 = {}, v2 = {}}
		contents.v1, contents.v2 = Split(value1, ','), Split(value2, ',')
		
		contents.v1[1], contents.v2[1] = ((contents.v1[1] ~= nil or contents.v1[1] ~= '') and toboolean(contents.v1[1]) or contents.v1[1]), ((contents.v2[1] ~= nil or contents.v2[1] ~= '') and toboolean(contents.v2[1]) or contents.v2[1])
		contents.v1[2], contents.v2[2] = ((contents.v1[2] ~= nil or contents.v1[2] ~= '') and tonumber(contents.v1[2]) or contents.v1[2]), ((contents.v2[2] ~= nil or contents.v2[2] ~= '') and tonumber(contents.v2[2]) or contents.v2[2])
		
		eventsStuff.mainDrain = contents.v1[1]
		eventsStuff.drainAmount[1] = contents.v1[2]
		
		eventsStuff.oppoDrain = contents.v2[1]
		eventsStuff.drainAmount[2] = contents.v2[2]
	end
end

function onUpdatePost(elapsed)
	if eventsStuff.mainDrain and getHealth() >= 0.5 then
		addHealth(-eventsStuff.drainAmount[1])
	end
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
	if not isSustainNote and eventsStuff.oppoDrain and getHealth() >= 0.5 then
		addHealth(-eventsStuff.drainAmount[2])
	end
end

function Split(s, delimiter)
	result = {}
	for match in (s..delimiter):gmatch('(.-)'..delimiter) do
		table.insert(result, tostring(match))
	end
	return result
end

function toboolean(str)
	local bool = false
	if str == "true" then
		bool = true
	end
	return bool
end