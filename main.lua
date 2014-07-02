MAX_DT = 1/20
PHYSICS_FPS = 1/60

TILE_WIDTH = 8
TILE_HEIGHT = TILE_WIDTH

FIELD_SIZE_X,FIELD_SIZE_Y = 10,20 

function love.load()
	require "binding"
	require "helpfuncs"
	require "class"
	require "blocks"
	require "menu"
	require "play"
	settings = love.filesystem.load("settings.lua")()

	love.graphics.setBackgroundColor(100,100,100,255)


	resetView()
	accumulator= 0
	-- keypressed = {}
	i = 0
	game = {play = play,menu = menu}
	mode = "play"
	init = true
	mCan = love.graphics.newCanvas(320,240)
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
		mCan:clear()
		love.graphics.setCanvas(mCan)
		game[mode].draw()
		love.graphics.setCanvas()
		-- if useShader then love.graphics.setShader(shader) end
		-- if android then
		-- 	love.graphics.setColor(188,185,180,255)
		-- 	love.graphics.rectangle("fill", 0, 0, xSize, ySize)
		-- 	love.graphics.setColor(83,85,97,255)
		-- 	roundRectangle( 0, 0, xSize, xOffset+144*scale,xOffset/2,2)
		-- 	love.graphics.setColor(14,33,5,255)
		-- 	roundRectangle(xOffset-scale, xOffset/2-scale, 160*scale+scale*2, 144*scale+scale*2,scale,0)
		-- 	love.graphics.setColor(255,255,255,255)
		-- 	abCross.draw()
		-- end
		-- love.graphics.setColor(255,100,134,255)
		love.graphics.setColor(255,255,255,255)
		love.graphics.draw(mCan,0,0,0,settings.scale)
		-- love.graphics.setShader()
	end
end


function love.keypressed(key, unicode)
	if key == "escape" then love.event.quit() end
	-- keypressed[key] = true
	-- if key == "p" then useShader = not useShader end
end

