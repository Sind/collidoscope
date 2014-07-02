play = {}

function play.load()
	field = {}
	for i = 1,FIELD_SIZE_Y do
		field[i] = {}
		for j = 1,FIELD_SIZE_X do
			field[i][j] = 0
		end
	end
end

function play.update(dt)

end

function play.draw()
	for i = 1,#field do
		for j = 1,#field[i] do
			love.graphics.print(field[i][j],j*8,i*10)
		end
	end

end