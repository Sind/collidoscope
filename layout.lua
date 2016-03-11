layout = {}

layout.end_x = SCREEN_X
layout.end_y = SCREEN_Y

layout.center_x = layout.end_x/2
layout.center_y = layout.end_y/2

function layout.percent_x(number)
	return SCREEN_X*(number/100)
end

function layout.percent_y(number)
	return SCREEN_Y*(number/100)
end

function layout._physical_to_virtual(physical_x, physical_y)
	return (physical_x - SCREEN_X/2.0)/(SCREEN_X/2), (physical_y - SCREEN_Y/2)/(SCREEN_X/2)
end

function layout._virtual_to_physical(virtual_x, virtual_y)
	-- layout._virtual_to_physical(virtual_x, virtual_y)
	-- convert from normalized device coordinates
	-- to "physical" screen coordinates

	return virtual_x*(SCREEN_X/2) + SCREEN_X/2.0, virtual_y*(SCREEN_X/2) + SCREEN_Y/2.0
end

function layout._virtual_to_physical_dimensions(virtual_x, virtual_y)
	-- layout._virtual_to_physical_dimensions(virtual_x, virtual_y)
	-- convert virtual coordinates to physical screen coordinates

	return virtual_x*SCREEN_X, virtual_y*SCREEN_X
end

function layout.rect(virtual_x, virtual_y, virtual_width, virtual_height)
	-- layout.rect(virtual_x, virtual_y, virtual_width, virtual_height)
	-- draw a rectangle onto the screen in virtual coordinates. The
	-- rectangles position is interpreted as its center.

	local virtual_x = virtual_x - virtual_width
	local virtual_y = virtual_y - virtual_height

	local phys_x, phys_y = layout._virtual_to_physical(virtual_x, virtual_y)
	phys_width, phys_height = layout._virtual_to_physical_dimensions(virtual_width, virtual_height)
	if GRID_DEBUG_DRAW then
		love.graphics.rectangle("line", phys_x, phys_y, phys_width, phys_height)
	else
		love.graphics.rectangle("fill", phys_x, phys_y, phys_width, phys_height)
	end
end

function layout.place_canvas(virtual_x, virtual_y, virtual_width, virtual_height)
	-- helper function that returns physical x, y, w, h coordinates,
	-- specifically for drawing the canvas.
	local virtual_x = virtual_x - virtual_width
	local virtual_y = virtual_y - virtual_height

	local phys_x, phys_y = layout._virtual_to_physical(virtual_x, virtual_y)
	phys_width, phys_height = layout._virtual_to_physical_dimensions(virtual_width, virtual_height)
	return phys_x, phys_y, phys_width, phys_height
end

function layout.draw_layer(layer, scheme)
	-- layout.draw_layer(layer)
	-- draws an entire layer of geometry at once.
	-- a layer is a set of 4-ples that describe
	-- rectangles x, y, width, height in virtual
	-- coordinates.
	love.graphics.setColor(scheme.colors[layer.color])
	for k,v in ipairs(layer.data) do
		layout.rect(v[1], v[2], v[3], v[4])
	end
	love.graphics.setColor(255, 255, 255, 255)
end

function layout.img(virtual_x, virtual_y, virtual_width, virtual_height, image)

	local virtual_x = virtual_x - virtual_width
	local virtual_y = virtual_y - virtual_height

	local phys_x, phys_y = layout._virtual_to_physical(virtual_x, virtual_y)
	phys_width, phys_height = layout._virtual_to_physical_dimensions(virtual_width, virtual_height)

	q_tr = love.graphics.newQuad(phys_x, phys_y, phys_width, phys_height, 200, 200)
	q_bl = love.graphics.newQuad(phys_x, phys_y, phys_width, phys_height, 200, 200)


	if GRID_DEBUG_DRAW then
		love.graphics.draw("line", phys_x, phys_y, phys_width, phys_height)
	else
		love.graphics.rectangle("fill", phys_x, phys_y, phys_width, phys_height)
	end
end

function layout.print(text,virtual_x,virtual_y)
	local font = love.graphics.getFont()
	local phys_x, phys_y = layout._virtual_to_physical(virtual_x,virtual_y)
	local phys_width, phys_height = font:getWidth(text), font:getHeight(text)
	local scale = 1 --40/phys_height
	-- if GRID_DEBUG_DRAW then
	-- 	love.graphics.rectangle("line",phys_x,phys_y,phys_width,phys_height)
	-- end

	love.graphics.print(text,phys_x,phys_y,0,1,1,phys_width/2,phys_height/2)
end