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

	virtual_x = virtual_x - virtual_width
	virtual_y = virtual_y - virtual_height
	
	phys_x, phys_y = layout._virtual_to_physical(virtual_x, virtual_y)
	phys_width, phys_height = layout._virtual_to_physical_dimensions(virtual_width, virtual_height)
	love.graphics.rectangle("fill", phys_x, phys_y, phys_width, phys_height)
end
