player = class()

function player:init(num)
	self.playerNum = num
	self.nextBlock = blockTypes[math.random(1,7)]
	self.canHold = true
end

function player:update(dt)

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