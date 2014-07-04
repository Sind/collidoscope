play = {}
field = {
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,0,0},
	{0,0,0,0,0,0,0,0,1,0},
	{0,0,0,1,0,0,1,1,0,0},
	{0,1,1,1,0,1,1,0,0,1},
	{0,1,1,1,0,0,1,0,0,1},
	{1,1,1,1,1,1,1,1,1,1},
	{1,1,1,1,1,1,1,1,1,1},
	{1,1,1,1,1,1,1,1,1,1},
	{1,1,1,1,1,1,1,1,1,1},
	{1,1,1,1,1,1,1,1,1,1},
	{1,1,1,1,1,1,1,1,1,1},
	{1,1,1,1,1,1,1,1,1,1}
}

function play.load()
	play.images = {}
	play.images.background = love.graphics.newImage("assets/board-design.png")
end

function play.update(dt)

end

function play._debug_draw()
	for i = 1,#field do
		for j = 1,#field[i] do
			love.graphics.print(field[i][j],j*8,i*10)
		end
	end
end


function play.draw(debug_draw)
	if debug_draw then
		play._debug_draw()
	else
		play._do_draw()
	end

end

function play._do_draw()
   love.graphics.draw(play.images.background)
end
