EndState = Class{__includes = BaseState}

function EndState:enter(score)
	self.isSaving = false
	Transition("fadeIn")
	self.score = score
	f = io.open("scores.txt", "a")
	self.name = ""
end

function EndState:update()

	if love.keyboard.wasPressed('backspace') then
		self.name = string.sub(self.name, 1, #self.name - 1)
	else
		for k, letter in pairs(love.textInputed) do
			if letter >= "a" and letter <= "z" then
				self.name = self.name .. letter
			end

			if letter >= "A" and letter <= "Z" then
				self.name = self.name .. letter
			end
		end
	end

	if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
	
		if self.isSaving == false then
			self.isSaving = true
			f:write(self.name .. " " .. self.score .. "\n")
			f:close()
			Transition("fadeOut")
			Timer.after(TRANSITION_SPEED, function()
				gStateMachine:change('title') 
			end)
		end
	end


end

function EndState:draw()
    love.graphics.printf("GAME OVER. SCORE = " .. self.score, 0, GAME_HEIGHT / 2, GAME_WIDTH, "center")
    love.graphics.printf("ENTER NAME:\n", 0, GAME_HEIGHT / 2 + 16 * 1, GAME_WIDTH, "center")
	    love.graphics.printf(self.name, 0, GAME_HEIGHT / 2 + 16 * 2, GAME_WIDTH, "center")

end
