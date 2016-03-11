require "layout"
require "dbg"
require "smoke"

play = {}
field = {}


function play._init_shaders()
	tile_shader = love.graphics.newShader([[
	extern Image pattern;

	vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
	{
		// TODO: the scaling here is just made up for testing, fix it.
		vec2 st_coords = screen_coords / vec2(1920, 1080)*vec2(8*3, 4*3);
		return Texel(pattern, st_coords);
	}
	]])
	local warnings = tile_shader:getWarnings()
	if warnings ~= "" and warnings ~= "\n" and warnings ~= "pixel shader:\n"then
		dbg.debug("Tile shader output: '" .. tile_shader:getWarnings() .. "'")
	end
	play._tile_shader = tile_shader

	smoke_shader = love.graphics.newShader([[
	vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
	{
		return Texel(texture, texture_coords)*color;
	}
	]])
	local warnings = smoke_shader:getWarnings()
	if warnings ~= "" and warnings ~= "\n" and warnings ~= "pixel shader:\n"then
		dbg.debug("Smoke shader output: '" .. smoke_shader:getWarnings() .. "'")
	end
	play._smoke_shader = smoke_shader
end

function play.load()
	field = {}
	for i = 1,FIELD_SIZE_Y do
		field[i] = {}
		for j = 1,FIELD_SIZE_X do
			field[i][j] = (i <= FIELD_SIZE_Y/2) and 0 or 1
		end
	end

	play.images = {}

	player1 = player:new(1)
	player2 = player:new(2)
	-- play.load()
	-- load initial assets, initialize schemes we're going to use.



	-- if DEBUG_DRAW then
	-- 	mcan = love.graphics.newCanvas(1920/2, 1080)
	-- end
	-- particle scaler scales emission rate, size (to a lesser degree)
	-- and particle lifetime.
	-- Screen resolution is used as rough estimate. This works okay because
	-- particle size and intensity should scale with screen-size anyway, and
	-- because systems with smaller screens are likely somewhat less powerful
	-- anyway (netbooks etc)

	-- experimentally determined values that work good:
	--
	-- 1920 - 1
	-- 1280 - 0.8
	-- 1024 - 0.5
	-- width/1920
	play._particle_scaler = (SCREEN_X/1920)*0.73 + 0.27
	if SCREEN_X > 2500 then -- mostly for iMacs, which have huge screens and shit GPUs
		play._particle_scaler = 1.0
	end

	-- play.clear_field()
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
	if(player1.ended and player2.ended and love.keyboard.isDown(" ")) then exit = true end
	--update particle systems
	local size_x = 0.0256
	local size_y = 0.02534

	local offset_x = -0.5947 + player1.currentBlock.x*size_x*2
	local offset_y = -0.532 + player1.currentBlock.y*size_y*2

	for k,v in pairs(horizontal_particles) do
		v:update(dt)
		if (not v:isActive()) and (v:getCount() == 0) then
			horizontal_particles[k] = nil
		end
	end
	for k,v in pairs(vertical_particles) do
		v:update(dt)
		if (not v:isActive()) and (v:getCount() == 0) == 0 then
			vertical_particles[k] = nil
		end
	end
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
		play._do_draw(skinName)
	end

	-- todo, put the winometer draws somewhere :D
	-- play.debug_draw_winometer()

end

function play._contains_coordinates(tab, element)
	for _, value in ipairs(tab) do
		if value[1] == element[1] and value[2] == element[2] then
			return true
		end
	end
	return false
end
function play._indexof_coordinates(tab, element)
	for i, value in ipairs(tab) do
		if value[1] == element[1] and value[2] == element[2] then
			return i
		end
	end
	return false
end
function play._remove_coordinates(tab, element)
	local index = play._indexof_coordinates(tab, element)
	table.remove(tab, index)
end


horizontal_particles = {}
vertical_particles = {}
horizontal_edges = {}
vertical_edges = {}

counter = 0
function play._do_draw(scheme_name)
	counter = counter+1
	-- play._do_draw(scheme_name)
	-- takes care of all the drawing for the gamefield
	-- takes a scheme name, which will determine
	-- what scheme/color palette is used to draw everything.
	-- the schema has to have been previously initialized
	-- using play._load_scheme().

	-- extract the scheme "folder" table
	local scheme = play.scheme[scheme_name]

	-- draw background
	love.graphics.draw(scheme.background, 0, 0, 0, love.graphics.getWidth()/scheme.background:getWidth(), love.graphics.getHeight()/scheme.background:getHeight())

	-- draw containers
	layout.draw_layer(play.geometry.containers, scheme)
	layout.draw_layer(play.geometry.bg_light, scheme)
	layout.draw_layer(play.geometry.bg_dark, scheme)
	local x, y, w, h = layout.place_canvas(-0.312, 0, 0.27-0.01, 0.52-0.01)

	-- draw board
	local board = play._draw_board(field, scheme, w, h, player1, player2, horizontal_append_buffer, vertical_append_buffer)

	-- todo: refactor all this shit, its pretty awful.
	local new_horizontal_edges, new_vertical_edges = play._compute_edges(field)
	for _, e in ipairs(new_horizontal_edges) do
		if not play._contains_coordinates(horizontal_edges, e) then
			table.insert(horizontal_edges, 1, e)
			local x1 = (e[1]+1) * (w/#field[1])
			local y1 = (e[2]) * (h/#field)
			local index_string = tostring(e[1]) .. "," .. tostring(e[2])
			stuff = smoke.create(x1, y1, "horizontal", w/#field[1], h/#field, play._particle_scaler)
			horizontal_particles[index_string] = stuff
			-- this edge did not exist previously, add it
		end
	end
	for _, e in ipairs(horizontal_edges) do
		if not play._contains_coordinates(new_horizontal_edges, e) then
			local x1 = (e[1]+1) * (w/#field[1])
			local y1 = (e[2]) * (h/#field)
			local index_string = tostring(e[1]) .. "," .. tostring(e[2])
			-- this edge has ceased existing, remove it
			local expired_system = horizontal_particles[index_string]:stop()
			play._remove_coordinates(horizontal_edges, e)
		end
	end
	for _, e in ipairs(new_vertical_edges) do
		if not play._contains_coordinates(vertical_edges, e) then
			table.insert(vertical_edges, 1, e)
			local x1 = (e[1]) * (w/#field[1])
			local y1 = (e[2]+1) * (h/#field)
			local index_string = tostring(e[1]) .. "," .. tostring(e[2])
			stuff = smoke.create(x1, y1, "vertical", w/#field[1], h/#field, play._particle_scaler)
			vertical_particles[index_string] = stuff
			-- this edge did not exist previously, add it
		end
	end
	for _, e in ipairs(vertical_edges) do
		if not play._contains_coordinates(new_vertical_edges, e) then
			local x1 = (e[1]) * (w/#field[1])
			local y1 = (e[2]+1) * (h/#field)
			local index_string = tostring(e[1]) .. "," .. tostring(e[2])
			-- this edge has ceased existing, remove it
			local expired_system = vertical_particles[index_string]:stop()
			play._remove_coordinates(vertical_edges, e)
		end
	end

	love.graphics.setCanvas(board)
	love.graphics.setShader(play._smoke_shader)
	for k,v in pairs(horizontal_particles) do
		love.graphics.draw(v)
	end
	for k,v in pairs(vertical_particles) do
		love.graphics.draw(v)
	end
	love.graphics.setShader()
	love.graphics.setCanvas()

	love.graphics.draw(board, x, y)
	local x, y, w, h = layout.place_canvas(0.312, 0, 0.27-0.01, 0.52-0.01)
	love.graphics.draw(board, x + w, y + h, math.pi)


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

-- global canvas cache
canvas = nil

function play._draw_board(board, scheme, w, h, player1, player2, horizontal_append_buffer, vertical_append_buffer)
	local width = w
	local height = h
	local block_width = width / #board[1]
	local block_height = height / #board

	-- don't recreate this canvas every time, cache it
	-- field size can never change in one game.
	if not canvas then
		canvas = love.graphics.newCanvas(width, height)
		dbg.debug("Created " .. width .. "x" .. height .. " canvas.")
	end

	love.graphics.setCanvas(canvas)
	love.graphics.clear(255, 0, 0, 255)
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
		local v = cblock[i]
		for j = 1,#cblock[i] do
			local u = cblock[i][j]
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
		local v = cblock[i]
		for j = #cblock[i],1,-1 do -- column
			local u = cblock[i][j]
			if u == 1 then
				love.graphics.rectangle("fill", offset_x + (1-j)*block_width, offset_y + (1-i)*block_height, block_width, block_height)
			end
		end
	end
	love.graphics.setShader()
	love.graphics.setCanvas()

	-- Draw p1s nextblock
	love.graphics.setShader(play._tile_shader)
	local cblock = block_layouts[player1.nextBlock][1]
	play._tile_shader:send("pattern", scheme.pattern_light)

	local offset_x, offset_y = 0, 0
	--print(player1.nextBlock)
	if player1.nextBlock == "iblock" then
		offset_x, offset_y = layout._virtual_to_physical(-0.725, -0.44)
	else
		offset_x, offset_y = layout._virtual_to_physical(-0.723, -0.427)
	end
	local block_width, block_height = block_width*0.5, block_height*0.5

	for i = 1,#cblock do
		local v = cblock[i]
		for j = 1,#cblock[i] do
			local u = cblock[i][j]
			if u == 1 then
				love.graphics.rectangle("fill", offset_x + (j-2)*block_width, offset_y + (i-2)*block_height, block_width, block_height)
			end
		end
	end

	return canvas
end




function play._compute_edges(board)
	local board_width = #board[1]
	local board_height = #board
	vertical_append_buffer = {} -- contains vertical edges
	horizontal_append_buffer = {} -- contains horizontal edges
	for y = 1,(board_height) do
		for x = 1,(board_width) do
			if not (board[y][x] == board[y][x+1]) and not (x == #board[1]) then
				table.insert(vertical_append_buffer, 1, {x, y-1})
			end
			if y ~= board_height then
				if not (board[y][x] == board[y+1][x]) then
					table.insert(horizontal_append_buffer, 1, {x-1, y})
				end
			end
		end
	end
	return horizontal_append_buffer, vertical_append_buffer
end


-- function play.restart()
-- 	play.clear_field()
-- 	player1:spawnBlock()
-- 	player2:spawnBlock()
-- 	dbg.debug("winometer: "..play.winometer)
-- end

-- :D
-- function play.debug_draw_winometer()
-- 	love.graphics.setColor(0,0,0,255)
-- 	love.graphics.rectangle("fill", 120, 540, 50, 1+(50*play.winometer))
-- 	love.graphics.setColor(255,255,255,255)
-- end
