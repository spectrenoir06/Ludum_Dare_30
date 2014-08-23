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
         self.y + self.ly / 2
end

function Entity:destroy()
  self.world:remove(self)
end

function Entity:getCreated_at()
	return self.created_at
end

function Entity:getUpdateOrder()
  return self.class.updateOrder or 10000
end

function Entity:changeVelocityByGravity(dt)
  self.dy = self.dy + G * dt
end

function Entity:changeVelocityByCollisionNormal(nx, ny, bounciness)
  bounciness = bounciness or 0
  local dx, dy = self.dx, self.dy

  if (nx < 0 and dx > 0) or (nx > 0 and dx < 0) then
    dx = -dx * bounciness
  end

  if (ny < 0 and dy > 0) or (ny > 0 and dy < 0) then
    dy = -dy * bounciness
  end

  self.dx, self.dy = dx, dy
end

return Entity