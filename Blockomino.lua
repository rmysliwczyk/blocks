Blockomino = Class{}

function Blockomino:init(variant, mapBlocks)

	self.fallingThreshold = 0
	self.mapBlocks = mapBlocks
	self.blocks = {}
	self.color = math.random(NUMBER_OF_COLORS)
	self.variant = variant
	if variant == 1 then -- L
		self.blocksShape =
		{ 1, 0, 0, 0,
		  1, 0, 0, 0,
		  1, 1, 0, 0,
		  0, 0, 0, 0 }
	elseif variant == 2 then -- J
		self.blocksShape = 
		{ 0, 1, 0, 0,
		  0, 1, 0, 0,
		  1, 1, 0, 0,
		  0, 0, 0, 0 }
	elseif variant == 3 then -- SQR
		self.blocksShape = 
		{ 1, 1, 0, 0,
		  1, 1, 0, 0,
		  0, 0, 0, 0,
		  0, 0, 0, 0 }
	elseif variant == 4 then -- I
		self.blocksShape = 
		{ 1, 0, 0, 0,
		  1, 0, 0, 0,
		  1, 0, 0, 0,
		  1, 0, 0, 0 }
	elseif variant == 5 then -- S
		self.blocksShape = 
		{ 1, 0, 0, 0,
		  1, 1, 0, 0,
		  0, 1, 0, 0,
		  0, 0, 0, 0 }
	elseif variant == 6 then -- Z
		self.blocksShape = 
		{ 0, 1, 0, 0,
		  1, 1, 0, 0, 
		  1, 0, 0, 0,
		  0, 0, 0, 0 }
	elseif variant == 7 then -- T
		self.blocksShape =
		{ 1, 0, 0, 0,
		  1, 1, 0, 0,
		  1, 0, 0, 0,
		  0, 0, 0, 0 }
	end

	local y = 0
	local x = MAP_SIZE_X / 2 - 1 
	for i, block in pairs(self.blocksShape) do
		if block == 1 then
			table.insert(self.blocks, Block(x, y, self.color))
		elseif block == 0 then
			table.insert(self.blocks, nil)
		end
	
		if x < (MAP_SIZE_X / 2 - 1) + 3 then
			x = x + 1
		else
			x = MAP_SIZE_X / 2 - 1
			y = y + 1
		end
	end
end

function Blockomino:update(dt)
	self.fallingThreshold = self.fallingThreshold + FALLING_SPEED * dt
	if self:predictCollision("down") == false then
		if self.fallingThreshold >=1 then 
			for i, block in pairs(self.blocks) do
				block.y = block.y + 1
			end
			self.fallingThreshold = 0 
		end
	end
end

function Blockomino:move(direction)

	if (direction == "left") then
		--move all the blocks inside blockomino left
		if self:predictCollision(direction) == false then
			for k, block in pairs(self.blocks) do
				block.x = block.x - 1
			end
			return true
		end
		return false
	end
	if (direction == "right") then
		-- move all the blocks inside blockomino right
		if self:predictCollision(direction) == false then
			for k, block in pairs(self.blocks) do
				block.x = block.x + 1
			end
			return true
		end
		return false
	end
	if (direction == "down") then
		while self:predictCollision(direction) == false do
			for k, block in pairs(self.blocks) do 
				block.y = block.y + 1
			end
		end
		self.fallingThreshold = 0 --gives time to slide the block
		return true
	end

	if (direction == "rotate") then
		if self:predictCollision(direction) == false then
			self:rotate()
			return true
		end
		return false
	end

	if (direction == "kickandrotate") then
		if self:move("left") == true then
			if self:move("rotate") == true then
				return true
			else 
				if self:move("left") == true then
					if self:move("rotate") == true then
						return true
					end
				else 
					self:move("right")
					self:move("right")
				end
			end
		end

		if self:move("right") == true then
			if self:move("rotate") == true then
				return true
			else 
				if self:move("right") == true then
					if self:move("rotate") == true then
						return true
					end
				else
					self:move("left")
					self:move("left")
				end
			end
		end

		return false
	end

end

function Blockomino:rotate()

	if self.variant == 3 then -- no need to rotate if it is the square
		return true
	end

	local centralPosX = self.blocks[round(#self.blocks / 2)].x 
	local centralPosY = self.blocks[round(#self.blocks / 2)].y

	for k, block in pairs(self.blocks) do
		local oldX = block.x - centralPosX
		local oldY = block.y - centralPosY
		block.x = oldX * 0 - oldY * 1
		block.y = oldX * 1 + oldY * 0
		block.x = block.x + centralPosX
		block.y = block.y + centralPosY
	end

end

function Blockomino:collides()

	for k, block in pairs(self.blocks) do
		for k2, mapBlock in pairs(self.mapBlocks) do
			if block.y == mapBlock.y and block.x == mapBlock.x then
				return true
			end
		end

		if block.y < 0 or block.y >= MAP_SIZE_Y then
			return true
		end

		if block.x < 0 or block.x >= MAP_SIZE_X then
			return true
		end
	end

	return false
end

function Blockomino:predictCollision(move)

	local temporaryBlockomino = CopyTable(self)

	if move == "left" then
		for k, block in pairs(temporaryBlockomino.blocks) do
			block.x = block.x - 1
		end
		if temporaryBlockomino:collides() then
			return true
		end

		return false
	end

	if move == "right" then 
		for k, block in pairs(temporaryBlockomino.blocks) do
			block.x = block.x + 1
		end
		if temporaryBlockomino:collides() then
			return true
		end

		return false
	end

	if move == "down" then
		for k, block in pairs(temporaryBlockomino.blocks) do
			block.y = block.y + 1
		end
		if temporaryBlockomino:collides() then
			return true
		end

		return false
	end

	if move == "rotate" then
		temporaryBlockomino:rotate()
		if temporaryBlockomino:collides() then
			return true
		end

		return false
	end


end

function Blockomino:draw()
    
end
