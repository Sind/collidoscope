block = class()

blocktypes = {'o','i', 'z', 's', 'j', 'l', 't'}

blocks = { 
   o = {
      { 
	 {0,0,0,0},
	 {0,1,1,0},
	 {0,1,1,0},
	 {0,0,0,0}
      }
   },
   i = {
      { 
	 {0,0,0,0},
	 {1,1,1,1},
	 {0,0,0,0},
	 {0,0,0,0}
      },
      { 
	 {0,1,0,0},
	 {0,1,0,0},
	 {0,1,0,0},
	 {0,1,0,0}
      }
   },
   z = {
      { 
	 {0,0,0,0},
	 {1,1,0,0},
	 {0,1,1,0},
	 {0,0,0,0}
      },
      { 
	 {0,0,1,0},
	 {0,1,1,0},
	 {0,1,0,0},
	 {0,0,0,0}
      }
   },
   s = {
      { 
	 {0,0,0,0},
	 {0,1,1,0},
	 {1,1,0,0},
	 {0,0,0,0}
      },
      { 
	 {0,1,0,0},
	 {0,1,1,0},
	 {0,0,1,0},
	 {0,0,0,0}
      }
   },
   l = {
      { 
	 {0,0,1,0},
	 {1,1,1,0},
	 {0,0,0,0},
	 {0,0,0,0}
      },
      { 
	 {0,1,0,0},
	 {0,1,0,0},
	 {0,1,1,0},
	 {0,0,0,0}
      },
      { 
	 {0,0,0,0},
	 {1,1,1,0},
	 {1,0,0,0},
	 {0,0,0,0}
      },
      { 
	 {1,1,0,0},
	 {0,1,0,0},
	 {0,1,0,0},
	 {0,0,0,0}
      },
   },
   j = {
      { 
	 {1,0,0,0},
	 {1,1,1,0},
	 {0,0,0,0},
	 {0,0,0,0}
      },
      { 
	 {0,1,1,0},
	 {0,1,0,0},
	 {0,1,0,0},
	 {0,0,0,0}
      },
      { 
	 {0,0,0,0},
	 {1,1,1,0},
	 {0,0,1,0},
	 {0,0,0,0}
      },
      { 
	 {0,1,0,0},
	 {0,1,0,0},
	 {1,1,0,0},
	 {0,0,0,0}
      },
   },
   t = {
      { 
	 {0,1,0,0},
	 {1,1,1,0},
	 {0,0,0,0},
	 {0,0,0,0}
      },
      { 
	 {0,1,0,0},
	 {0,1,1,0},
	 {0,1,0,0},
	 {0,0,0,0}
      },
      { 
	 {0,0,0,0},
	 {1,1,1,0},
	 {0,1,0,0},
	 {0,0,0,0}
      },
      { 
	 {0,1,0,0},
	 {1,1,0,0},
	 {0,1,0,0},
	 {0,0,0,0}
      },
   },
}

function block:init()
   self.location = Vec2(3,2)
   self.rot = 1
   self.type = blocktypes[love.math.random(1, 7)]
end

function block:draw()
end

function block:add_bits()
   for i = 1,4 do
      for j = 1,4 do
	 if blocks[self.type][self.rot][i][j] == 1 then
	    field[i + self.location.y][j + self.location.x] = 1
	 end
      end
   end
end

function block:remove_bits()
   for i = 1,4 do
      for j = 1,4 do
	 if blocks[self.type][self.rot][i][j] == 1 then
	    field[i + self.location.y][j + self.location.x] = 0
	 end
      end
   end
end

-- true if collide, false if not!
-- between curr_block and field
function block:collide_check()
   local colliding = false

   for i = 1,4 do
      for j = 1,4 do
	 if (field[i+self.location.y][j + self.location.x]) ~= nil then
	    io.write((field[i+self.location.y][j + self.location.x]))
	 else
	    io.write('-')
	 end

	 if blocks[self.type][self.rot][i][j] == 1 and 
	 field[i + self.location.y][j + self.location.x] == 1 then
	    colliding = true
	 end
      end
      io.write("\n")
   end
   if colliding then
      print("COLLIDED^")
   end

   io.write("\n")

   return colliding
end
