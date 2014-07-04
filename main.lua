MAX_DT = 1/20
PHYSICS_FPS = 1/60

TILE_WIDTH = 8
TILE_HEIGHT = TILE_WIDTH

FIELD_SIZE_X,FIELD_SIZE_Y = 10,20
DEBUG_DRAW = false

function love.load()
	require "binding"
	require "helpfuncs"
	require "class"
	require "blocks"
	require "menu"
	require "play"
	settings = love.filesystem.load("settings.lua")()

	love.graphics.setBackgroundColor(100,100,100,255)
	SCREEN_X,SCREEN_Y = love.window.getDesktopDimensions(1)
	love.window.setMode(SCREEN_X, SCREEN_Y, {fullscreen=true})
	
	accumulator= 0
	-- keypressed = {}
	i = 0
	game = {play = play,menu = menu}
	mode = "play"
	init = true
end

function love.update(dt)
	-- love.window.setTitle("ponigb - " .. love.timer.getFPS().. " fps")

	if dt > MAX_DT then dt = MAX_DT end
	accumulator = accumulator + dt
	while accumulator > PHYSICS_FPS do
		if init then
			if game[mode].load then game[mode].load() end
			init = false
		end
		if game[mode].update then
			binding.update()
			game[mode].update(dt)
		end 
		if exit then
			if game[mode].exit then game[mode].exit() end 
			exit = false
			init = true
		end
		accumulator = accumulator - PHYSICS_FPS
		i = i+1
	end
end


function love.draw()
	if init or exit then return end
	if game[mode].draw then
		game[mode].draw(DEBUG_DRAW)
	end
end


function love.keypressed(key, unicode)
	if key == "escape" then love.event.quit() end
	-- keypressed[key] = true
	-- if key == "p" then useShader = not useShader end
end

