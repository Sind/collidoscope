require "layout"
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

	player1 = player:new(1)
	player2 = player:new(2)
	-- play.load()
	-- load initial assets, initialize schemes we're going to use.

	play.scheme = {}
	play._load_scheme('clairdelune')
	play.geometry = {}
	play.geometry.containers = dofile("assets/geometry/containers.lua")
	
end
function play._load_scheme(name)
	-- play._load_scheme
	-- internal function for loading a scheme.
	-- schemes are mostly just colors, but can contain some extra
	-- images for backgrounds etc.
	
	print("Loading scheme: '" .. name .. "'")
	play.scheme[name] = {}
	play.scheme[name].basepath = "assets/schemes/" .. name .. "/"
	play.scheme[name].background = love.graphics.newImage(play.scheme[name].basepath .. "background.png")
	play.scheme[name].colors = dofile(play.scheme[name].basepath .. "colors.lua")
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
	-- play.draw
	-- invoked from main.lua to
	-- perform all drawing of the gamestate.
	
	if debug_draw then
		play._debug_draw()
	else
		play._do_draw('clairdelune')
	end

end


function play._do_draw(scheme_name)
	-- play._do_draw(scheme_name)
	-- takes care of all the drawing for the gamefield
	-- takes a scheme name, which will determine
	-- what scheme/color palette is used to draw everything.
	-- the schema has to have been previously initialized
	-- using play._load_scheme().
	
	-- extract the scheme "folder" table
	scheme = play.scheme[scheme_name]
	
	-- draw background
	love.graphics.draw(scheme.background)

	-- draw decorations
	for k,v in ipairs(play.geometry.containers) do
		layout.rect(v[1], v[2], v[3], v[4])
	end
	--layout.rect(0, 0, 2, 0.0208) -- middle bar
	--layout.rect(-0.8531, 0, 0.0286, 0.52) -- left scorebar
	--layout.rect(0.8531, 0, 0.0286, 0.52) -- right scorebar
end
