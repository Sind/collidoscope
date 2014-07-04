
TILE_WIDTH = 8
TILE_HEIGHT = TILE_WIDTH

FIELD_SIZE_X,FIELD_SIZE_Y = 10,20
SPAWN_X,SPAWN_Y = math.floor(FIELD_SIZE_X/2)-1,-2

MAIN_TIME = 1
SUB_TIME = 0.2

SCREEN_X,SCREEN_Y = love.window.getDesktopDimensions(1)
local xpercent,ypercent = SCREEN_X/16,SCREEN_Y/9
VIRTUAL_X,VIRTUAL_Y = math.min(xpercent,ypercent)*16,math.min(xpercent,ypercent)*9

function love.load(args)
	math.randomseed(os.time())
	DEBUG_DRAW = true
	if #args > 1 then
		for argNum = 2,#args do
			arg = args[argNum]
			if arg == "amadiro" then DEBUG_DRAW = false end
			if arg == "grid" then GRID_DEBUG_DRAW = true end
		end
	end
	require "binding"
	require "helpfuncs"
	require "class"
	require "blocks"
	require "player"
	require "menu"
	require "play"
	settings = love.filesystem.load("settings.lua")()

	love.graphics.setBackgroundColor(100,100,100,255)
	love.window.setMode(SCREEN_X, SCREEN_Y, {fullscreen=true})
	
	game = {play = play,menu = menu}
	mode = "play"
	init = true
end

function love.update(dt)
	-- love.window.setTitle("ponigb - " .. love.timer.getFPS().. " fps")

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

