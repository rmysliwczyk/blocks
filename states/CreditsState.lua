CreditsState = Class{__includes = BaseState}

function CreditsState:enter()
	Transition("fadeIn")
end

function CreditsState:update()

	if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
		Transition("fadeOut")
		Timer.after(TRANSITION_SPEED, function() gStateMachine:change("title")end)
	end

end

function CreditsState:exit()
end

function CreditsState:draw()
    love.graphics.printf([[Programmed by: Rafał Myśliwczyk

    Music by: Steven O'Brien
https://www.steven-obrien.net/

80s Synthpop Experiment

(Used for free under a Creative Commons Attribution-NoDerivatives 4.0 License: https://creativecommons.org/licenses/by-nd/4.0/)

]], 5, GAME_HEIGHT / 2 - 16 * 7, GAME_WIDTH - 5, "center")
end
