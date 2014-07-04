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
function layout.rect(percent_x, percent_y, percent_width, percent_height)
	-- draws a rectangle at screen-position and dimensions given in percentages.
	-- the position given is interpreted as the center of the rectangle.
	
	pixel_width = layout.percent_x(percent_width)
	pixel_height = layout.percent_y(percent_height)
	
	love.graphics.rectangle("fill", layout.percent_x(percent_x) - pixel_width/2, layout.percent_y(percent_y) - pixel_height/2, pixel_width, pixel_height)
end
