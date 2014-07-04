block = class()

spawn={
	[1] = {

	      },
	[2] = {

	      }
}

function block:init(player,t)
	self.rotation = 1
	self.spawntime = os.clock()
	self.x = spawn[player][1]
	self.y = spawn[player][2]
	self.type = t
end

function block:draw()

end

block_layouts ={
	straight = {
	           {{1},
	            {1},
	            {1},
	            {1}},

	           {{1,1,1,1}}
	          },
	lblock =  {
	           {{0,0,1},
	            {1,1,1}},

	           {{1,0},
	            {1,0},
	            {1,1}},

	           {{1,1,1},
	            {1,0,0}},

	           {{1,1},
	            {0,1},
	            {0,1}}
	          },
	jblock =  {
	           {{1,0,0},
	            {1,1,1}},

	           {{1,1},
	            {1,0},
	            {1,0}},

	           {{1,1,1},
	            {0,0,1}},

	           {{0,1},
	            {0,1},
	            {1,1}}
	           },
	tblock =  {
	           {{0,1,0},
	            {1,1,1}},

	           {{1,0},
	            {1,1},
	            {1,0}},

	           {{1,1,1},
	            {0,1,0}},

	           {{0,1},
	            {1,1},
	            {0,1}}
	          },
	oblock =  {
	           {{1,1},
	            {1,1}}
	          },
	zblock =  { 
	           {{1,1,0},
	            {0,1,1}},

	           {{0,1},
	            {1,1},
	            {1,0}}
	      },
	sblock  = {
	           {{0,1,1},
	            {1,1,0}},

	           {{1,0},
	            {1,1},
	            {0,1}}
	          }
	}