PlayState = Class{__includes = BaseState}

function PlayState:init()
	self.mapBlocks = {}
	self.linesToRemove = {}
	self.lastRemovedLines = {}
	self.score = 0
	self.level = 0
	self.psystem = love.graphics.newParticleSystem(particle, 64)
	self.psystem:setParticleLifetime(0.2, 1) 
	self.psystem:setEmissionRate(35)
	self.psystem:setEmissionArea("borderrectangle", MAP_SIZE_X * BLOCK_WIDTH/2, BLOCK_HEIGHT/2, 0, true)
	self.psystem:setLinearAcceleration(-2, -2, 2, 2)
	music:play()
end
function PlayState:enter()
	Transition("fadeIn")
	blockomino = Blockomino(math.random(NUMBER_OF_VARIANTS), self.mapBlocks)
	nextBlockomino = Blockomino(math.random(NUMBER_OF_VARIANTS), self.mapBlocks)
end

function PlayState:update(dt)
    
	-- movement controls
	if love.keyboard.wasPressed("a") or love.keyboard.wasPressed("left") then
		blockomino:move("left")
		move:play()
	elseif love.keyboard.wasPressed("d") or love.keyboard.wasPressed("right") then
		blockomino:move("right")
		move:play()
	end

	if love.keyboard.wasPressed("w") or love.keyboard.wasPressed("up") then
		if blockomino:move("rotate") == false then
			if blockomino:move("kickandrotate") == true then
				move:play()
			else
				illegal:play()
			end
		else
			move:play()
		end
	elseif love.keyboard.wasPressed("s") or love.keyboard.wasPressed("down") then
		blockomino:move("down")
		drop:play()
	end


	-- checking if the blockomino is down
    	if blockomino.fallingThreshold >= 1 and blockomino:predictCollision("down") then
		for i, block in pairs(blockomino.blocks) do
			table.insert(self.mapBlocks, block)
		end

		blockomino = nextBlockomino 
		nextBlockomino = Blockomino(math.random(NUMBER_OF_VARIANTS), self.mapBlocks)

		if blockomino:predictCollision("down") then
			Transition("fadeOut")
			Timer.after(TRANSITION_SPEED, function() gStateMachine:change("end", self.score) end)
		end
	end

	self.linesToRemove = {}
	local blocksInLine = 0

	-- checks how many blocks are in one line. Mark as line to be removed if they fill the line
	for y=1, MAP_SIZE_Y do
		for i, block in pairs(self.mapBlocks) do
			if block.y == y then
				blocksInLine = blocksInLine + 1
			end
		end

		if blocksInLine == MAP_SIZE_X then
			table.insert(self.linesToRemove, y)
			table.insert(self.lastRemovedLines, y)
		end
		blocksInLine = 0
	end

	-- flag blocks for removal if they are on the line to be removed
	for k1, block in pairs(self.mapBlocks) do
		for k2, line in pairs(self.linesToRemove) do
			if block.y == line then
				block.remove = true
			end
		end
	end

	-- adding score based on how many lines removed at once
	if #self.linesToRemove == 1 then
		self.score = self.score + 40 * (self.level + 1)
	elseif #self.linesToRemove == 2 then
		self.score = self.score + 100 * (self.level + 1)
	elseif #self.linesToRemove == 3 then
		self.score = self.score + 300 * (self.level + 1)
	elseif #self.linesToRemove == 4 then
		self.score = self.score + 1200 * (self.level + 1)
	end

	-- advancing the level based on score and increasing falling speed with each level
	if self.score >= ((self.level + 1) * 300) * (self.level + 1) / 2 then
		self.level = self.level + 1
		FALLING_SPEED = FALLING_SPEED + 0.1
	end

	-- removing blocks which were marked to be removed
	for i=#self.mapBlocks, 1, -1 do
		if self.mapBlocks[i].remove == true then
			table.remove(self.mapBlocks, i)
		end
	end

	for i=#self.lastRemovedLines, 1, -1 do
		Timer.after(0.3, function() table.remove(self.lastRemovedLines, i) end)
	end

	-- this is to shift all the blocks from above the lines that were removed
	if #self.linesToRemove > 0 then

		if #self.linesToRemove > 1 then
			multiline:play()
		else
			line:play()
		end
		for i=1, #self.linesToRemove do
			for k, block in pairs(self.mapBlocks) do
				if block.y < self.linesToRemove[i] then
					Timer.after(0.3, function() block.y = block.y + 1 end)
				end
			end
		end
	end
	
	self.psystem:update(dt)
	blockomino:update(dt)
end

function PlayState:draw()
    love.graphics.draw(background,0, 0)

	for i, block in pairs(blockomino.blocks) do
		love.graphics.draw(blocksAtlas, blockColors[block.color], block.x * BLOCK_WIDTH + PLAY_AREA_OFFSET_X, block.y * BLOCK_HEIGHT + PLAY_AREA_OFFSET_Y)
	end


	for i, block in pairs(self.mapBlocks) do
		love.graphics.draw(blocksAtlas, blockColors[block.color], block.x * BLOCK_WIDTH + PLAY_AREA_OFFSET_X, block.y * BLOCK_HEIGHT + PLAY_AREA_OFFSET_Y)
	end


	for i=1, #self.lastRemovedLines do	
		love.graphics.setColor(255/255,215/255, 1/255)
		love.graphics.rectangle("line", PLAY_AREA_OFFSET_X, PLAY_AREA_OFFSET_Y + self.lastRemovedLines[i] * BLOCK_HEIGHT, MAP_SIZE_X * BLOCK_WIDTH, BLOCK_HEIGHT * 1)
		love.graphics.draw(self.psystem, PLAY_AREA_OFFSET_X + (MAP_SIZE_X * BLOCK_WIDTH) / 2, PLAY_AREA_OFFSET_Y + self.lastRemovedLines[i] * BLOCK_HEIGHT + (BLOCK_HEIGHT / 2))
		love.graphics.setColor(1,1,1)
	end

	love.graphics.printf("LEVEL:\n" .. self.level .. "\n\nSCORE:\n" .. self.score, PLAY_AREA_OFFSET_X + MAP_SIZE_X * BLOCK_WIDTH + BLOCK_WIDTH * 1, PLAY_AREA_OFFSET_Y, 150, "left")

	love.graphics.printf("NEXT LEVEL:\n" .. (((self.level + 1) * 300) * (self.level + 1) / 2) .. "\n\nNEXT:", PLAY_AREA_OFFSET_X + MAP_SIZE_X * BLOCK_WIDTH + BLOCK_WIDTH * 1, PLAY_AREA_OFFSET_Y + BLOCK_HEIGHT * 6, 150, "left")

	-- displaying what blockomino comes next
	for k, block in pairs(nextBlockomino.blocks) do
		love.graphics.draw(blocksAtlas, blockColors[block.color], block.x * BLOCK_WIDTH + PLAY_AREA_OFFSET_X + BLOCK_WIDTH * 8, block.y * BLOCK_HEIGHT + PLAY_AREA_OFFSET_Y + BLOCK_HEIGHT * 12) 
	end
end
