block = class()

blockTypes = {[1]="iblock",[2]="lblock",[3]="jblock",[4]="tblock",[5]="oblock",[6]="zblock",[7]="sblock"}

swoosh = love.audio.newSource("assets/audio/sounds/swoosh.ogg")
swoosh:setVolume(0.8)

function block:init(t,parent)
	self.rotation = 1
	self.parent = parent
	self.x = SPAWN_X
	self.y = SPAWN_Y
	self.type = t
	self.mainTime = 0
	self.subTime = 0
end

function block:update(dt)
	self.mainTime = self.mainTime + dt
	self.subTime = self.subTime + dt


	if binding.pressed["p"..self.parent.playerNum.."r"] then
		self.x = self.x+1
		if self:collides() then
			self.x = self.x-1
		end
	end
	if binding.pressed["p"..self.parent.playerNum.."l"] then
		self.x = self.x-1
		if self:collides() then
			self.x = self.x+1
		end
	end

	if binding.pressed["p"..self.parent.playerNum.."u"] then
		self.rotation = self.rotation%#block_layouts[self.type]+1
		if self:collides() then
			self.x = self.x+1
			if self:collides() then
				self.x = self.x - 2
				if self:collides() then
					self.x = self.x + 1
					self.rotation = (self.rotation-2)%#block_layouts[self.type] + 1
				end
			end
		end
	end

	if binding.pressed["p"..self.parent.playerNum.."s"] then
		while true do
			self.y = self.y+1;
			if self:collides() then self.y = self.y-1; self:merge(); return end
		end
	end


	if binding.isDown["p"..self.parent.playerNum.."d"] and self.subTime > SUB_TIME then
		while self.subTime > SUB_TIME do self.subTime = self.subTime - SUB_TIME end
		self.mainTime = self.subTime
		self.y = self.y+1
		if self:collides() then self.y = self.y-1;self:merge() end
	end
	if self.mainTime > MAIN_TIME then
		self.mainTime = self.mainTime - MAIN_TIME
		self.y = self.y + 1
		if self:collides() then self.y = self.y-1;self:merge() end
	end

end

function block:collides()
	local cblock = block_layouts[self.type][self.rotation]
	for i,v in ipairs(cblock) do
		for j,u in ipairs(v) do
			if u == 1 then
				if self.parent.playerNum == 1 then
					if self.y+i-1 > FIELD_SIZE_Y or self.x+j-1 < 1 or self.x+j-1 > FIELD_SIZE_X then return true end
					if field[self.y+i-1] then
						if not field[self.y+i-1][self.x+j-1] or field[self.y+i-1][self.x+j-1] == 1 then return true end
					end
				else
					if FIELD_SIZE_Y-self.y-i+2 < 1 or FIELD_SIZE_X-self.x-j+2 < 1 or FIELD_SIZE_X-self.x-j+2 > FIELD_SIZE_X then return true end
					if field[FIELD_SIZE_Y-self.y-i+2] then
						if not field[FIELD_SIZE_Y-self.y-i+2][FIELD_SIZE_X-self.x-j+2] or field[FIELD_SIZE_Y-self.y-i+2][FIELD_SIZE_X-self.x-j+2] == 0 then return true end
					end
				end
			end
			-- if u == 1 and field[self.y+i-1] and field[self.y+i-1][self.x+j-1] and field[self.y+i-1][self.x+j-1] == 1 then return true end
		end
	end
	return false
end

function block:merge()
	local cblock = block_layouts[self.type][self.rotation]
	for i,v in ipairs(cblock) do
		for j,u in ipairs(v) do
			if u == 1 then
				if field[self.y+i-1] == nil then
					-- if self.parent.playerNum == 1 then
					-- 	play.winometer = play.winometer + 1
					-- else
					-- 	play.winometer = play.winometer - 1
					-- end
					-- play.restart()
					-- exit = true
					-- return
					self.parent.ended = true
				elseif self.parent.playerNum == 1 then
					field[self.y+i-1][self.x+j-1] = 1
				else
					field[FIELD_SIZE_Y-self.y-i+2][FIELD_SIZE_X-self.x-j+2] = 0
				end
			end
		end
	end
	self.parent.hasBlock = false
	playtimer = playtimer + 10
	love.audio.play(swoosh)
end

function block:draw()
	block.draw(self.x, self.y, self.type, self.parent.playerNum)
end

function block.draw(x, y, blocktype, rotation, offset, playerNum)
	local c = (2 - playerNum) * 255
	love.graphics.setColor(c,c,c)
	local cblock = block_layouts[blocktype][rotation]
	for i,v in ipairs(cblock) do
		for j,u in ipairs(v) do
			if u == 1 then
				if playerNum == 1 then
					love.graphics.rectangle("fill", (x + j - 1)*50, (y + i - 1)*50, 50, 50)
				else
					love.graphics.rectangle("fill", (FIELD_SIZE_X - x - j + 2)*50, (FIELD_SIZE_Y - y - i + 2)*50, 50, 50)
				end
			end
		end
	end
	love.graphics.setColor(255,255,255)
end

block_layouts ={
	iblock = {
		{{0,1,0,0},
			{0,1,0,0},
			{0,1,0,0},
			{0,1,0,0}},

		{{0,0,0,0},
			{1,1,1,1},
			{0,0,0,0},
			{0,0,0,0}}
	},
	lblock =  {
		{{0,0,1,0},
			{1,1,1,0},
			{0,0,0,0},
			{0,0,0,0}},

		{{0,1,0,0},
			{0,1,0,0},
			{0,1,1,0},
			{0,0,0,0}},

		{{0,0,0,0},
			{1,1,1,0},
			{1,0,0,0},
			{0,0,0,0}},

		{{1,1,0,0},
			{0,1,0,0},
			{0,1,0,0},
			{0,0,0,0}}
	},
	jblock =  {
		{{1,0,0,0},
			{1,1,1,0},
			{0,0,0,0},
			{0,0,0,0}},

		{{0,1,1,0},
			{0,1,0,0},
			{0,1,0,0},
			{0,0,0,0}},

		{{0,0,0,0},
			{1,1,1,0},
			{0,0,1,0},
			{0,0,0,0}},

		{{0,1,0,0},
			{0,1,0,0},
			{1,1,0,0},
			{0,0,0,0}}
	},
	tblock =  {
		{{0,1,0,0},
			{1,1,1,0},
			{0,0,0,0},
			{0,0,0,0}},

		{{0,1,0,0},
			{0,1,1,0},
			{0,1,0,0},
			{0,0,0,0}},

		{{0,0,0,0},
			{1,1,1,0},
			{0,1,0,0},
			{0,0,0,0}},

		{{0,1,0,0},
			{1,1,0,0},
			{0,1,0,0},
			{0,0,0,0}}
	},
	oblock =  {
		{{0,1,1,0},
			{0,1,1,0},
			{0,0,0,0},
			{0,0,0,0}}
	},
	zblock =  {
		{{1,1,0,0},
			{0,1,1,0},
			{0,0,0,0},
			{0,0,0,0}},

		{{0,0,1,0},
			{0,1,1,0},
			{0,1,0,0},
			{0,0,0,0}}
	},
	sblock  = {
		{{0,1,1,0},
			{1,1,0,0},
			{0,0,0,0},
			{0,0,0,0}},

		{{0,1,0,0},
			{0,1,1,0},
			{0,0,1,0},
			{0,0,0,0}}
	}
}
