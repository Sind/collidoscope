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
	{0,0,0,0,0,0,0,0,0,0},
	{1,1,1,1,1,1,1,1,1,1},
	{1,1,1,1,1,1,1,1,1,1},
	{1,1,1,1,1,1,1,1,1,1},
	{1,1,1,1,1,1,1,1,1,1},
	{1,1,1,1,1,1,1,1,1,1},
	{1,1,1,1,1,1,1,1,1,1},
	{1,1,1,1,1,1,1,1,1,1},
	{1,1,1,1,1,1,1,1,1,1},
	{1,1,1,1,1,1,1,1,1,1},
	{1,1,1,1,1,1,1,1,1,1}
}

function play._init_shaders()
	tile_shader = love.graphics.newShader([[
	extern Image pattern;

        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
        {
		vec2 st_coords = screen_coords / vec2(1920, 1080)*vec2(8*3, 4*3);
        	return Texel(pattern, st_coords);
        }
	]])
	local warnings = tile_shader:getWarnings()
	if warnings ~= "" and warnings ~= "\n" and warnings ~= "pixel shader:\n"then
		dbg.debug("Tile shader output: '" .. tile_shader:getWarnings() .. "'")
	end
	play._tile_shader = tile_shader
end

function play.load()
	play.images = {}
	
	player1 = player:new(1)
	player2 = player:new(2)
	-- play.load()
	-- load initial assets, initialize schemes we're going to use.

	play.scheme = {}
	play._load_scheme('clairdelune')
	play.geometry = {}
	play._load_layer('containers')
	play._load_layer('bg_light')
	play._load_layer('bg_dark')
	play._init_shaders()

	if DEBUG_DRAW then
		mcan = love.graphics.newCanvas(1920/2, 1080)
	end

	-- particle system stuff
	require "particlesystem1"
	require "particlesystem2"
	system:start()
	system2:start()
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
	play.scheme[name].pattern_light = love.graphics.newImage(play.scheme[name].basepath .. "pattern-light.png")
	play.scheme[name].pattern_light:setWrap('repeat', 'repeat')
	play.scheme[name].pattern_dark = love.graphics.newImage(play.scheme[name].basepath .. "pattern-dark.png")
	play.scheme[name].pattern_dark:setWrap('repeat', 'repeat')
end
function play.update(dt)
	player1:update(dt)
	player2:update(dt)

	--update particle systems
	local size_x = 0.0256
	local size_y = 0.02534

	local offset_x = -0.5947 + player1.currentBlock.x*size_x*2
	local offset_y = -0.532 + player1.currentBlock.y*size_y*2
	
	--layout.rect(offset_x + (j-1)*size_x*2, offset_y + (i-1)*size_y*2, size_x, size_y)
	system:setPosition( player1.currentBlock.x*50 + 450, player1.currentBlock.y*50 + 80 )
	system2:setPosition( player1.currentBlock.x*50 + 450, player1.currentBlock.y*50 + 80 )
	--system:setPosition(offset_x + (2)*size_x*2 , offset_y + (2)*size_y*2 )
	system:update(dt) 
	system2:update(dt) 
end

function play._debug_draw()
	-- TODO: delete this once the main draw code is good enough
	mcan:clear()
	love.graphics.setCanvas(mcan)
	for i = 1,#field do
		for j = 1,#field[i] do
			love.graphics.setColor(field[i][j]*255,field[i][j]*255,field[i][j]*255)
			love.graphics.rectangle("fill", 50*j, 50*i, 50, 50)
		end
	end
	love.graphics.setColor(255, 255, 255)
	player1:draw()
	player2:draw()
	love.graphics.setCanvas()
	love.graphics.draw(mcan)
	love.graphics.draw(mcan, 1920, 1080, math.pi)
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
	local scheme = play.scheme[scheme_name]
	
	-- draw background
	love.graphics.draw(scheme.background)

	-- draw containers
	layout.draw_layer(play.geometry.containers, scheme)
	layout.draw_layer(play.geometry.bg_light, scheme)
	layout.draw_layer(play.geometry.bg_dark, scheme)

	local x, y, w, h = layout.place_canvas(-0.312, 0, 0.27-0.01, 0.52-0.01)
	local board = play._draw_board(field, scheme, w, h, player1, player2)
	love.graphics.draw(board, x, y)
	local x, y, w, h = layout.place_canvas(0.312, 0, 0.27-0.01, 0.52-0.01)
	love.graphics.draw(board, x + w, y + h, math.pi)


	-- particle system for player 1
	--love.graphics.draw(system)
	--love.graphics.draw(system2)
	
	--play.geometry.bg_light = dofile("assets/geometry/bg_light.lua");love.timer.sleep(0.5)


	-- player 1 is on the left
	--player1.currentBlock has info for current block(type, position,rotation)
	--same for player2
	--player1.nextBlock had info for next block(type only)
	--same for player2
	--player1.holdBlock has info for held block(type only)
	--same for player2
	
	--types are as follows:{[1]="iblock",[2]="lblock",[3]="jblock",[4]="tblock",[5]="oblock",[6]="zblock",[7]="sblock"}
	--this shouldn't matter to you at all, but oh well

	--to access the block structure you use 'block_layouts[playerx.currentBlock.type][playerx.currentBlock.rotation]'
	--block position is described as playerx.currentBlock.x and playerx.currentBlock.y
end

function play._draw_board(board, scheme, w, h, player1, player2)
	local width = w
	local height = h
	local block_width = width / #board[1]
	local block_height = height / #board
	
	-- todo: don't recreate this canvas every time, cache it
	local canvas = love.graphics.newCanvas(width, height)
	canvas:clear(255, 0, 0, 255)
	love.graphics.setCanvas(canvas)
	love.graphics.setShader(play._tile_shader)

	-- draw the actual playfield
	for i = #board,1,-1 do
		for j = #board[i],1,-1 do
			if field[i][j] == 1 then
				play._tile_shader:send("pattern", scheme.pattern_light)
				love.graphics.rectangle("fill", (j-1)*block_width, (i-1)*block_height, block_width, block_height)
			else
				play._tile_shader:send("pattern", scheme.pattern_dark)
				love.graphics.rectangle("fill", (j-1)*block_width, (i-1)*block_height, block_width, block_height)
			end
		end
	end

	-- draw player1s block
	local cblock = block_layouts[player1.currentBlock.type][player1.currentBlock.rotation]
	play._tile_shader:send("pattern", scheme.pattern_light)

	local offset_x = player1.currentBlock.x*block_width
	local offset_y = player1.currentBlock.y*block_height
	for i = 1,#cblock do
		v = cblock[i]
                for j = 1,#cblock[i] do
			u = cblock[i][j]
			if u == 1 then
				love.graphics.rectangle("fill", offset_x + (j-2)*block_width, offset_y + (i-2)*block_height, block_width, block_height)
			end
		end
	end

	-- draw player2s block
	local cblock = block_layouts[player2.currentBlock.type][player2.currentBlock.rotation]

	play._tile_shader:send("pattern", scheme.pattern_dark)

	local offset_x = (#board[1] - player2.currentBlock.x)*block_width
	local offset_y = (#board - player2.currentBlock.y)*block_height
	for i = #cblock,1,-1 do -- row
		v = cblock[i]
		for j = #cblock[i],1,-1 do -- column
			u = cblock[i][j]
			if u == 1 then
				love.graphics.rectangle("fill", offset_x + (1-j)*block_width, offset_y + (1-i)*block_height, block_width, block_height)
			end
		end
	end

	
	love.graphics.setShader()
	love.graphics.setCanvas()
	return canvas
end

