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

function play._draw_first_block(blocktype, x, y, rotation, scheme)
	local size_x = 0.0256
	local size_y = 0.02534

	local offset_x = -0.5947 + x*size_x*2
	local offset_y = -0.532 + y*size_y*2
	
	local cblock = block_layouts[blocktype][rotation]
	for i,v in ipairs(cblock) do
                for j,u in ipairs(v) do
			if u == 1 then
				love.graphics.setShader(play._tile_shader)
				play._tile_shader:send("pattern", scheme.pattern_light)
				layout.rect(offset_x + (j-1)*size_x*2, offset_y + (i-1)*size_y*2, size_x, size_y)
				love.graphics.setShader()
			end
		end
	end
end
function play._draw_second_block(blocktype, x, y, rotation, scheme, field_width, field_height)
	local size_x = 0.0256
	local size_y = 0.02534

	local offset_x = 0.05947 + size_x*(field_width*2 + 1) + (x - field_width - 1)*size_x*2
	local offset_y = -0.0532 + size_y*(field_height + 3) + (y - field_height - 1)*size_y*2
	
	local cblock = block_layouts[blocktype][rotation]
	for i,v in ipairs(cblock) do
                for j,u in ipairs(v) do
			if u == 1 then
				love.graphics.setShader(play._tile_shader)
				play._tile_shader:send("pattern", scheme.pattern_dark)
				layout.rect(offset_x + ((j-1))*size_x*2, offset_y + ((i-1))*size_y*2, size_x, size_y)
				love.graphics.setShader()
			end
		end
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
	play._draw_first_board(field, scheme)
	play._draw_second_board(field, scheme)
	--play.geometry.bg_light = dofile("assets/geometry/bg_light.lua");love.timer.sleep(0.5)


	play._draw_first_block(player1.currentBlock.type, player1.currentBlock.x, player1.currentBlock.y, player1.currentBlock.rotation, scheme)
	play._draw_second_block(player2.currentBlock.type, player2.currentBlock.x, player2.currentBlock.y, player2.currentBlock.rotation, scheme, #field[1], #field)
	--play._draw_block(player2.currentBlock.type, player1.currentBlock.position, player1.currentBlock.rotation)
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


function play._draw_second_board(board, scheme)
	local size_x = 0.0256
	local size_y = 0.02534

	local offset_x = 0.05947 + size_x*(#board[1]*2 + 1)
	local offset_y = -0.0532 + size_y*(#board + 3)
	
	for i = #board,1,-1 do
		for j = #board[i],1,-1 do
			love.graphics.setColor(field[i][j]*255,field[i][j]*255,field[i][j]*255)
			if field[i][j] == 1 then
				love.graphics.setShader(play._tile_shader)
				play._tile_shader:send("pattern", scheme.pattern_light)
				layout.rect(offset_x - j*size_x*2, offset_y - i*size_y*2, size_x, size_y)
				love.graphics.setShader()
			else
				love.graphics.setShader(play._tile_shader)
				play._tile_shader:send("pattern", scheme.pattern_dark)
				layout.rect(offset_x - j*size_x*2, offset_y - i*size_y*2, size_x, size_y)
				love.graphics.setShader()
				--layout.rect(offset_x - j*size_x*2, offset_y - i*size_y*2, size_x, size_y)
			end
			--love.graphics.rectangle("fill", 50*j, 50*i, 50, 50)
		end
	end
	love.graphics.setColor(255, 255, 255)
end

function play._draw_first_board(board, scheme)
	-- play._draw_board(board)
	-- draws the actual game board (not including moving pieces)
	-- as passed into the board variable.
	local offset_x = -0.5947
	local offset_y = -0.532
	local size_x = 0.0256
	local size_y = 0.02534
	
	for i = 1,#board do
		for j = 1,#board[i] do
			love.graphics.setColor(field[i][j]*255,field[i][j]*255,field[i][j]*255)
			if field[i][j] == 1 then
				love.graphics.setShader(play._tile_shader)
				play._tile_shader:send("pattern", scheme.pattern_light)
				layout.rect(offset_x + j*size_x*2, offset_y + i*size_y*2, size_x, size_y)
				love.graphics.setShader()
			else
				love.graphics.setShader(play._tile_shader)
				play._tile_shader:send("pattern", scheme.pattern_dark)
				layout.rect(offset_x + j*size_x*2, offset_y + i*size_y*2, size_x, size_y)
				love.graphics.setShader()
				--layout.rect(offset_x + j*size_x*2, offset_y + i*size_y*2, size_x, size_y)
			end
			--layout.rect(offset_x + j*size_x*2, offset_y + i*size_y*2, size_x, size_y)
			--love.graphics.rectangle("fill", 50*j, 50*i, 50, 50)
		end
	end
	
	love.graphics.setColor(255, 255, 255)
end
