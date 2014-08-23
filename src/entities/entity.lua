local class = require 'lib.middleclass'
local Entity = class('Entity')

local G = 500

function Entity:initialize(world, x,y,lx,ly)

	self.world			= world
	self.x, self.y		= x, y
	self.lx, self.ly	= lx, ly
	self.dx, self.dy	= 0,0
	
	self.world:add(self, x,y,lx,ly)
	self.created_at = love.timer.getTime()
end

function Entity:move(x,y)
  self.x, self.y = x,y
  self.world:move(self, x, y)
end

function Entity:getCenter()
  return self.x + self.lx / 2,
  return self.x + self.lx / 2,
         self.y + self.ly / 2
end

function Entity:destroy()
  self.world:remove(self)
end

function Entity:getCreated_at()
	return self.created_at
end

return Entity