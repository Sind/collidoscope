block = class()

blockTypes = {[1]="iblock",[2]="lblock",[3]="jblock",[4]="tblock",[5]="oblock",[6]="zblock",[7]="sblock"}

spawn={
	[1] = {

	      },
	[2] = {

	      }
}

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

	if binding.pressed["p1r"] then
		self.x = self.x+1
		if self:collides() then
			self.x = self.x-1
		end
	end
	if binding.pressed["p1l"] then
		self.x = self.x-1
		if self:collides() then
			self.x = self.x+1
		end
	end

	if binding.pressed["p1u"] then
		self.rotation = self.rotation%#block_layouts[self.type]+1
	end

	if binding.isDown["p1d"] and self.subTime > SUB_TIME then
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
			if u == 1 and field[self.y+i-1] and field[self.y+i-1][self.x+j-1] and field[self.y+i-1][self.x+j-1] == 1 then return true end
		end
	end
	return false
end

function block:merge()
	local cblock = block_layouts[self.type][self.rotation]
	for i,v in ipairs(cblock) do
		for j,u in ipairs(v) do
			if u == 1 then
				field[self.y+i-1][self.x+j-1] = 1
			end
		end
	end
	self.parent.hasBlock = false
end

function block:draw()
	local cblock = block_layouts[self.type][self.rotation] 
	for i,v in ipairs(cblock) do
		for j,u in ipairs(v) do
			if u == 1 then
				love.graphics.rectangle("fill", (self.x+j-1)*50, (self.y+i-1)*50, 50, 50)
			end
		end
	end
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