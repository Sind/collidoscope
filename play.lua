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
   
   field[17][3] = 0
   field[17][4] = 0
   field[16][1] = 1
   field[16][7] = 1
   
   curr_block = block()
end

function play.update(dt)
end

function play.draw()
   -- p1 board
   love.graphics.setColor(0,0,0)
   love.graphics.rectangle("fill", TILE_WIDTH, TILE_WIDTH, 
			   TILE_WIDTH*FIELD_SIZE_X, TILE_WIDTH*FIELD_SIZE_Y)

   love.graphics.setColor(255,255,255)
   for i = 1,FIELD_SIZE_Y do
      for j = 1,FIELD_SIZE_X do
	 if field[i][j] == 1 then
	    love.graphics.rectangle("fill", j*TILE_WIDTH, i*TILE_WIDTH, TILE_WIDTH, TILE_WIDTH)
	 end
      end
   end

   -- p2 board
   love.graphics.setColor(0,0,0)
   love.graphics.rectangle("fill", (TILE_WIDTH*12) + TILE_WIDTH, TILE_WIDTH, 
			   TILE_WIDTH*FIELD_SIZE_X, TILE_WIDTH*FIELD_SIZE_Y)

   love.graphics.setColor(255,255,255)
   for i = 1,FIELD_SIZE_Y do
      for j = 1,FIELD_SIZE_X do
	 if field[i][j] == 1 then
	    love.graphics.rectangle("fill", 
				    (TILE_WIDTH*12) + ((FIELD_SIZE_X + 1)*TILE_WIDTH) - j*TILE_WIDTH,
				    (FIELD_SIZE_Y + 1)*TILE_WIDTH - i*TILE_WIDTH, 
				    TILE_WIDTH, TILE_WIDTH)
	 end
      end
   end
   -- for i = 1,#field do
   --    for j = 1,#field[i] do
   -- 	 print( field[(FIELD_SIZE_Y + 1) - i][(FIELD_SIZE_X + 1) - j] )
   -- 	 if field[FIELD_SIZE_Y + 1 - i][FIELD_SIZE_X + 1 - j] == 1 then
   -- 	    love.graphics.rectangle("fill", (TILE_WIDTH*12) + j*TILE_WIDTH, i*TILE_WIDTH, TILE_WIDTH, TILE_WIDTH)
   -- 	 end
   --    end
   -- end
   
   -- p1 curr_block
   love.graphics.setColor(255,255,255)
   for i = 1,4 do
      for j = 1,4 do
	 if blocks[curr_block.type][curr_block.rot][i][j] == 1 then
	    love.graphics.rectangle("fill", (j + curr_block.location.x)*TILE_WIDTH, 
				    (i + curr_block.location.y)*TILE_WIDTH, TILE_WIDTH, TILE_WIDTH)
	 end
      end
   end
end
