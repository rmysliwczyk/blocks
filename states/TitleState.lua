TitleState = Class{__includes = BaseState}

function TitleState:enter()
	self.selectedOption = 1
	Transition("fadeIn")
end

function TitleState:update()
	if love.keyboard.wasPressed("w") or love.keyboard.wasPressed("up") then
		self.selectedOption = self.selectedOption - 1 
	elseif love.keyboard.wasPressed("s") or love.keyboard.wasPressed("down") then
		self.selectedOption = self.selectedOption + 1 
	end

	if self.selectedOption < 1 then
		self.selectedOption = 1
	elseif self.selectedOption > 3 then
		self.selectedOption = 3
	end

	if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
		Transition("fadeOut")
		if self.selectedOption == 1 then	
			Timer.after(TRANSITION_SPEED, function() gStateMachine:change("play") end)
		elseif self.selectedOption == 2 then
			Timer.after(TRANSITION_SPEED, function() gStateMachine:change("highscores") end)
		elseif self.selectedOption == 3 then
			Timer.after(TRANSITION_SPEED, function() gStateMachine:change("credits") end)
		end
	end
end

function TitleState:draw()
    love.graphics.printf("SELECT OPTION:", 0, GAME_HEIGHT / 2 - 16, GAME_WIDTH, "center")
	
    if self.selectedOption == 1 then
	    love.graphics.setColor( 1, 0.5, 0.5, 1)
    else
	    love.graphics.setColor( 1, 1, 1, 1)
    end

    love.graphics.printf("START GAME", 0, GAME_HEIGHT / 2, GAME_WIDTH, "center")

    if self.selectedOption == 2 then
	    love.graphics.setColor( 1, 0.5, 0.5, 1)
    else
	    love.graphics.setColor( 1, 1, 1, 1)
    end

    love.graphics.printf("HIGHSCORES", 0, GAME_HEIGHT / 2 + 16, GAME_WIDTH, "center")

    if self.selectedOption == 3 then
	    love.graphics.setColor( 1, 0.5, 0.5, 1)
    else
	    love.graphics.setColor( 1, 1, 1, 1)
    end

    love.graphics.printf("CREDITS", 0, GAME_HEIGHT / 2 + 16 * 2, GAME_WIDTH, "center")
end
