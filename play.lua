play = {}

function play.load()
   field = {}
   for i = 1,FIELD_SIZE_Y do
      field[i] = {}
      for j = 1,FIELD_SIZE_X do
	 field[i][j] = 0
      end
   end

   rot = 1
end

function play.update(dt)
   
end

function play.draw()
   love.graphics.setColor(255,255,255)

   for i = 1,#field do
      for j = 1,#field[i] do
	 love.graphics.print(field[i][j],j*8,i*5)
      end
   end
   
   love.graphics.setColor(255,0,0)
   for i = 1,4 do
      for j = 1,4 do
	 if blocks['t'][rot][i][j] == 1 then
	    love.graphics.rectangle("fill", j*8, i*10, 10, 10)
	 end
      end
   end
end
