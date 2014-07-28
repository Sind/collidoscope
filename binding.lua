binding = {}
binding.pressed = {}
binding.isDown = {}
binding.map = {p1h = "q",p1s = "tab", p1u = "w", p1d = "s", p1l = "a", p1r= "d", p2h = "rshift",p2s = "rctrl",p2u = "up", p2d = "down", p2l = "left", p2r= "right",start="return"}
function binding.update()
	for k,v in pairs(binding.map) do
		binding.pressed[k] = love.keyboard.isDown(binding.map[k]) and not binding.isDown[k]
		binding.isDown[k] = love.keyboard.isDown(binding.map[k])
	end
end
