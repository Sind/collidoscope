
TILE_WIDTH = 8
TILE_HEIGHT = TILE_WIDTH

FIELD_SIZE_X,FIELD_SIZE_Y = 10,20
SPAWN_X,SPAWN_Y = math.floor(FIELD_SIZE_X/2)-1,0

MAIN_TIME = 1
SUB_TIME = 0.2

SCREEN_X,SCREEN_Y = love.window.getDesktopDimensions(1)
local xpercent,ypercent = SCREEN_X/16,SCREEN_Y/9
VIRTUAL_X,VIRTUAL_Y = math.min(xpercent,ypercent)*16,math.min(xpercent,ypercent)*9

function love.load(args)
	math.randomseed(os.time())
	DEBUG_DRAW = false
	VSYNC = true
	FULLSCREEN = true
	if #args > 1 then
		for argNum = 2,#args do
			arg = args[argNum]
			if arg == "srod" then DEBUG_DRAW = true end
			if arg == "grid" then GRID_DEBUG_DRAW = true end
			if arg == "nofs" then FULLSCREEN = false end
			if arg == "novsync" then VSYNC = false end
			if arg == "-skin" then skinName = args[argNum+1] end
		end
	end
	skinName = skinName or "clairdelune";
	require "binding"
	require "helpfuncs"
	require "class"
	require "blocks"
	require "player"
	require "menu"
	require "play"
	tween = require "tween"
	settings = love.filesystem.load("settings.lua")()

	love.graphics.setBackgroundColor(100,100,100,255)
	love.window.setMode(SCREEN_X, SCREEN_Y, {fullscreen=FULLSCREEN, vsync=VSYNC})

	play.scheme = {}
	play._load_scheme('clairdelune')
	play._load_scheme('adrift')
	play._load_scheme('sky')
	play._load_scheme('moon')
	play._load_scheme('goldfish')
	play.geometry = {}
	play._load_layer('containers')
	play._load_layer('bg_light')
	play._load_layer('bg_dark')
	play._init_shaders()

	game = {play = play,menu = menu}
	mode = "play"
	init = true
end

last_time = 0
deltas = {}
framecounter = 0
function love.update(dt)
	local now = love.timer.getTime()
	local delta = now - last_time
	table.insert(deltas, 1, delta)
	last_time = now
	framecounter = framecounter + 1

	if framecounter % 400 == 0 then
		local acc = 0
		for i = 1, #deltas do
			acc = acc + deltas[i]
		end
		dbg.info("Update time over the last 400 frames: " .. tostring(1000*acc/400) .. "ms (" .. love.timer.getFPS() .. ")")
		deltas = {}
	end

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
