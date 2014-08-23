local class		= require 'lib.middleclass'
local bump		= require 'lib.bump'
local Bob		= require 'entities.bob'

local sortByUpdateOrder = function(a,b)
  return a:getUpdateOrder() < b:getUpdateOrder()
end

local sortByCreatedAt = function(a,b)
  return a.getCreated_at() < b.getCreated_at()
end

local Map = class('Map')

function Map:initialize(lx, ly, camera)
	
	self.lx		= lx
	self.ly		= ly
	self.camera	= camera
	self:reset()

end

function Map:update(dt, x, y,lx,ly)
	
	x, y, lx, ly = x or 0, y or 0, lx or self.width, ly or self.height
	local visibleThings, len = self.world:queryRect(x, y, lx, ly)

	table.sort(visibleThings, sortByUpdateOrder)

	for i=1, len do
		visibleThings[i]:update(dt)
	end

end
  
function Map:draw(x, y, lx, ly)

	local visibleThings, len = self.world:queryRect(x, y, lx, ly)

	table.sort(visibleThings, sortByCreatedAt)

	for i=1, len do
		visibleThings[i]:draw()
	end
end

return Map