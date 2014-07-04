MAX_DT = 1/20
PHYSICS_FPS = 1/60

TILE_WIDTH = 7
TILE_HEIGHT = TILE_WIDTH

FIELD_SIZE_X,FIELD_SIZE_Y = 10,32

function love.load()
   love.graphics.setDefaultFilter("linear", "linear")
   require "binding"
   require "helpfuncs"
   require "class"
   require "menu"
   require "play"
   require "blocks"
   Vec2 = require "vector"
   settings = love.filesystem.load("settings.lua")()

   scale = 4
   love.graphics.setBackgroundColor(80,80,80,255)

   love.window.setMode(320*scale,240*scale,{ fsaa = 0, vsync = true })
   accumulator= 0
   -- keypressed = {}
   i = 0
   game = { play = play,menu = menu }
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
      love.graphics.draw(mCan,0,0,0,scale)
      -- love.graphics.setShader()
   end
end


function love.keypressed(key, unicode)
   curr_block:remove_bits()

   if key == "escape" then love.event.quit() end

   if key == "r" then
      curr_block.rot = ((curr_block.rot) % #blocks[curr_block.type]) + 1
   end
   if key == " " then
      curr_block.type = blocktypes[math.random(1,7)]
      curr_block.rot = ((curr_block.rot) % #blocks[curr_block.type]) + 1
   end

   if key == "right" then
      curr_block.location.x = curr_block.location.x + 1
   end
   if key == "left" then 
      curr_block.location.x = curr_block.location.x - 1
   end
   if key == "up" then 
      curr_block.location.y = curr_block.location.y - 1
   end
   if key == "down" then 
      curr_block.location.y = curr_block.location.y + 1
   end

   curr_block:add_bits()


   -- keypressed[key] = true
   -- if key == "p" then useShader = not useShader end
end

