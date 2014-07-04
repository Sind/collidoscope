play = {}

function play.load()
   field = {}
   for i = 1,FIELD_SIZE_Y do
      field[i] = {}
      for j = 1,FIELD_SIZE_X do
	 --field[i][j] = love.math.random(0,1)
	 if (i > FIELD_SIZE_Y/2) then
	    field[i][j] = 1
	 end
      end
   end
   
   curr_block = block()
end

function play.update(dt)
   
end

function play.draw()
   love.graphics.setColor(255,100,100)
   love.graphics.rectangle("line", TILE_WIDTH, TILE_WIDTH, 
			   TILE_WIDTH*FIELD_SIZE_X, TILE_WIDTH*FIELD_SIZE_Y)
   
   love.graphics.setColor(255,255,255)
   for i = 1,#field do
      for j = 1,#field[i] do
	 if field[i][j] == 1 then
	    love.graphics.rectangle("fill", j*TILE_WIDTH, i*TILE_WIDTH, TILE_WIDTH, TILE_WIDTH)
	 end
      end
   end
   
   love.graphics.setColor(255,0,0)
   for i = 1,4 do
      for j = 1,4 do
	 if blocks['t'][curr_block.rot][i][j] == 1 then
	    love.graphics.rectangle("fill", (j + curr_block.location.x)*TILE_WIDTH, 
				    (i + curr_block.location.y)*TILE_WIDTH, TILE_WIDTH, TILE_WIDTH)
	 end
      end
   end
end
