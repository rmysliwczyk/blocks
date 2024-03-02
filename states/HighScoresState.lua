HighScoresState = Class{__includes = BaseState}

function HighScoresState:does_file_exist()
	local f = assert(io.open("scores.txt", "r"))
end

function HighScoresState:enter()

	Transition("fadeIn")
	if not pcall(self.does_file_exist) then
		print("here")
		self.f = io.open("scores.txt", "w")
	end
	self.f = io.open("scores.txt", "r")

	self.highscores = "" 
	self.highscores = self.f:read("*all")

	self.highscoresTable = {}
	self.highscoresTableProcessed = {}
	local i = 0
	local j = 0
	while i ~= nil do
		j = i
		i = string.find(self.highscores, "\n", i+1)
		if i ~= nil then
			table.insert(self.highscoresTable, string.sub(self.highscores, j+1, i-1))
		end
	end

	for k, entry in ipairs(self.highscoresTable) do
		i = string.find(entry, " ")
		self.highscoresTableProcessed[k] =  {name = string.sub(entry, 1, i), score = tonumber(string.sub(entry, i+1, -1))}
	end

	table.sort(self.highscoresTableProcessed, function(i1, i2) return i1.score > i2.score end)
end

function HighScoresState:update()

	if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
		Transition("fadeOut")
		Timer.after(TRANSITION_SPEED, function() gStateMachine:change("title") end)
	end

end

function HighScoresState:exit()
	self.f:close()
end

function HighScoresState:draw()
    love.graphics.printf("HIGHSCORES:", 0, GAME_HEIGHT / 2 - 16 * 7, GAME_WIDTH, "center")

    local i = 0 
    for k, entry in ipairs(self.highscoresTableProcessed) do
	i = i + 1
	if i > 5 then
		break
	end
    	love.graphics.printf(entry.name .. entry.score, 0, GAME_HEIGHT / 2 - 16 * 6 + k * 16, GAME_WIDTH, "center")
    end
end
