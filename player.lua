player = class()

function player:init(num)
	self.playerNum = num
	self.hasBlock = false
	self.nextBlock = blockTypes[math.random(1,7)]
	self.canHold = true
end

function player:update(dt)
	if not self.hasBlock then
		self:spawnBlock()
		self.hasBlock = true
	else
		self.currentBlock:update(dt)
	end
end

function player:spawnBlock()
	self.currentBlock = block:new(self.nextBlock)
	self.nextBlock = blockTypes[math.random(1,7)]
	self.canHold = true
end

function player:holdBlock()
	if self.canHold == false then return end
	if self.holdBlock then
		local tempBlock = self.holdBlock
		self.holdBlock = self.currentBlock.type
		self.currentBlock = block:new(tempBlock)
	else
		self.holdBlock = self.currentBlock.type
		self.currentBlock = block:new(self.nextBlock)
		self.nextBlock = blockTypes[math.random(1,7)]
		self.canHold = true
	end
	self.canHold = false
end

function player:draw()
	if self.hasBlock then
		self.currentBlock:draw()
	end
end