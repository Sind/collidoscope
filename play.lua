require "layout"
require "dbg"

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
	-- player2 = player:new(2)
	-- play.load()
	-- load initial assets, initialize schemes we're going to use.

	play.scheme = {}
	play._load_scheme('clairdelune')
	play.geometry = {}
	play._load_layer('containers')
	play._load_layer('bg_light')
	play._load_layer('bg_dark')
	
end
function play._load_layer(name)

	
	play.geometry[name] = dofile("assets/geometry/" .. name .. ".lua")
	local elements = #play.geometry[name].data
	dbg.info("Loaded layer: '" .. name .. "' (" .. tostring(elements) .. " objects)")	
end

function play._load_scheme(name)
	-- play._load_scheme
	-- internal function for loading a scheme.
	-- schemes are mostly just colors, but can contain some extra
	-- images for backgrounds etc.
	
	dbg.info("Loading scheme: '" .. name .. "'")
	play.scheme[name] = {}
	play.scheme[name].basepath = "assets/schemes/" .. name .. "/"
	play.scheme[name].background = love.graphics.newImage(play.scheme[name].basepath .. "background.png")
	play.scheme[name].colors = dofile(play.scheme[name].basepath .. "colors.lua")
end

function play.update(dt)
	player1:update(dt)
	-- player2:update(dt)
end

function play._debug_draw()
	-- TODO: delete this once the main draw code is good enough
	for i = 1,#field do
		for j = 1,#field[i] do
			love.graphics.setColor(field[i][j]*255,field[i][j]*255,field[i][j]*255)
			love.graphics.rectangle("fill", 50*j, 50*i, 50, 50)
		end
	end
	love.graphics.setColor(255, 255, 255)
	player1:draw()
	-- player2:draw()
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

	-- draw containers
	layout.draw_layer(play.geometry.containers, scheme)
	layout.draw_layer(play.geometry.bg_light, scheme)
	layout.draw_layer(play.geometry.bg_dark, scheme)
	--play._draw_board(field)
	--play.geometry.bg_light = dofile("assets/geometry/bg_light.lua");love.timer.sleep(0.5)
end

function play._draw_board(board)
	-- play._draw_board(board)
	-- draws the actual game board (not including moving pieces)
	-- as passed into the board variable.
	for i = 1,#board do
		for j = 1,#board[i] do
			love.graphics.setColor(field[i][j]*255,field[i][j]*255,field[i][j]*255)
			layout.rectangle()
			--love.graphics.rectangle("fill", 50*j, 50*i, 50, 50)
		end
	end
	love.graphics.setColor(255, 255, 255)
end
