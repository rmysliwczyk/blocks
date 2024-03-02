function GenerateQuads(atlas, tileWidth, tileHeight)

    local tiles = {}
    nTiles_horizontaly = atlas:getPixelWidth() / tileWidth
    nTiles_verticaly = atlas:getPixelHeight() / tileHeight

    for h=0, nTiles_verticaly do
        for w=0, nTiles_horizontaly do
            table.insert(tiles, love.graphics.newQuad(tileWidth * w, tileHeight * h, tileWidth, tileHeight, atlas))
        end
    end

    return tiles

end

function CopyTable(source, copies) 
	
	copies = copies or {}
	local sourceType = type(source)
	local copy
	if sourceType == "table" then
		if copies[source] then
			copy = copies[source]
		else
			copy = {}
			copies[source] = copy
			for sourceKey, sourceValue in next, source, nil do
				copy[CopyTable(sourceKey, copies)] = CopyTable(sourceValue, copies)
			end
			setmetatable(copy, CopyTable(getmetatable(source)))
		end
	else 
		copy = source
	end
	return copy

end

function Transition(variety)
	local targetOpacity
	if variety == "fadeOut" then
		targetOpacity = 255
	elseif variety == "fadeIn" then
		targetOpacity = 0
	end

	Timer.tween(TRANSITION_SPEED, {[transition] = {opacity = targetOpacity}})
end

function round(n)
	if n % 1 >= 0.5 then
		return math.ceil(n)
	else
		return math.floor(n)
	end
end
