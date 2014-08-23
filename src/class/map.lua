local class		= require 'lib.middleclass'
local bump		= require 'lib.bump'
local Bob		= require 'entities.bob'
local Block		= require 'entities.block'

local sortByUpdateOrder = function(a,b)
  return a:getUpdateOrder() < b:getUpdateOrder()
end

local sortByCreatedAt = function(a,b)
  return a:getCreated_at() < b:getCreated_at()
end

local Map = class('Map')

function Map:initialize(lx, ly, camera)
	
	self.lx		= lx
	self.ly		= ly
	self.camera	= camera
	self.tileset = love.graphics.newImage( "textures/sol.png" )
	self.tileset:setWrap("repeat","repeat")
	
	self:reset()

	Block:new(	self.world,
				0,
				0,	
				self.lx,        
				32, 
				true,
				self.tileset
			)
	Block:new(	self.world,	
				0,	
				32,	
				32, 
				self.ly-64, 
				true,
				self.tileset
			)
	Block:new(	self.world,
				self.lx-32,
				32,
				32, 
				self.ly-64, 
				true,
				self.tileset
			)
	Block:new(	self.world,
				0,
				self.ly-32,
				self.ly, 
				32, 
				true,
				self.tileset
			)
end

function Map:reset()

  local width, height = self.lx, self.ly
  self.world  = bump.newWorld()
  self.bob = Bob:new(self, self.world, 60, 60)
  
end

function Map:update(dt, x, y, lx, ly)
	
	x, y, lx, ly = x or 0, y or 0, lx or self.lx, ly or self.ly
	local visibleThings, len = self.world:queryRect(x, y, lx, ly)

	table.sort(visibleThings, sortByUpdateOrder)

	for i=1, len do
		print(visibleThings[i].x)
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