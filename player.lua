player = class()

function player:init(num)
	self.playerNum = num
	self.hasblock = false
	self.nextBlock = blockTypes[math.random(1,7)]
	self.canHold = true
end

function player:update(dt)
	if not self.hasblock then
		
	else
		
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