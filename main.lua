--libraries and sources
push = require 'push'
Class = require 'class'
require 'globals'
require 'StateMachine'
require 'util'
Timer = require 'timer'

--classes
require 'Blockomino'
require 'Block'

--states
require 'states/BaseState'
require 'states/TitleState'
require 'states/PlayState'
require 'states/EndState'
require 'states/HighScoresState'
require 'states/CreditsState'

--images, sound, fonts
blocksAtlas = love.graphics.newImage('blocks16.png')
background = love.graphics.newImage('background.png')
particle = love.graphics.newImage('particle.png')
font = love.graphics.newFont("PublicPixel.ttf", 16)
move = love.audio.newSource("sounds/move.wav", "static")
drop = love.audio.newSource("sounds/drop.wav", "static")
line = love.audio.newSource("sounds/line.wav", "static")
multiline = love.audio.newSource("sounds/multiline.wav", "static")
illegal = love.audio.newSource("sounds/illegal.wav", "static")
music = love.audio.newSource("sounds/music.mp3", "stream")
music:setLooping(true)
math.randomseed(os.time())

function love.load()
	WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getDesktopDimensions()
	push:setupScreen(GAME_WIDTH, GAME_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {resizable = true})
	love.graphics.setDefaultFilter('nearest', 'nearest')
	love.window.setTitle("CS50 Blocks")
	love.graphics.setFont(font)

	love.keyboard.keysPressed = {}
	love.keyboard.setKeyRepeat(true)
	love.textInputed = {}

	TR = 4/255
	TG = 36/255
	TB = 44/255

	transition = {isActive = false, opacity = 0}
	blockColors = {}
	blockColors = GenerateQuads(blocksAtlas, BLOCK_WIDTH, BLOCK_HEIGHT)

	gStateMachine = StateMachine {
		['title'] = function() return TitleState() end,
		['play'] = function() return PlayState() end,
		['end'] = function() return EndState() end,
		['highscores'] = function() return HighScoresState() end,
		['credits'] = function () return CreditsState() end
	}
	gStateMachine:change('title')
	Timer.clear()
end

function love.update(dt)
	Timer.update(dt)
	gStateMachine:update(dt)
	love.keyboard.keysPressed = {}
	love.textInputed = {}
end

function love.keypressed(key, scancode, isrepeat) 
	love.keyboard.keysPressed[key] = true
	
	if key == 'escape' then
        	love.event.quit()
	end
end

function love.keyboard.wasPressed(key)
	if love.keyboard.keysPressed[key] == true then
        	return true
	else
        	return false
	end
end

function love.textinput(t)
	table.insert(love.textInputed, t)
end

function love.resize(w, h)
	push:resize(w,h)
end

function love.draw()
	push:start()
	gStateMachine:draw()
	love.graphics.setColor(1, 1, 1, transition.opacity/255)

	--alpha blending for window border
	TR = (transition.opacity/255) * (255/255) + (1 - transition.opacity/255) * (4/255)
	TG = (transition.opacity/255) * (255/255) + (1 - transition.opacity/255) * (36/255)
	TB = (transition.opacity/255) * (255/255) + (1 - transition.opacity/255) * (44/255)

    	push:setBorderColor(TR, TG, TB, 255/255)
    	love.graphics.rectangle("fill", 0, 0, GAME_WIDTH, GAME_HEIGHT)
	love.graphics.setColor(1, 1, 1, 1)
	push:finish()
end
