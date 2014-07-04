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
