local class = require 'lib.middleclass'
local Entity = require 'entities.entity'

local Block = class('Block', Entity)

function Block:initialize(world, l,t,w,h, indestructible, tileset)
	Entity.initialize(self, world, l,t,w,h)
	self.indestructible = indestructible
	self.tileset = tileset
	self.quad = love.graphics.newQuad( 0, 0, w, h, 32, 32)
end

function Block:getColor()
	if self.indestructible then return 150,150,220 end
	return 220, 150, 150
end

function Block:draw()
	local r,g,b = self:getColor()
	--love.graphics.rectangle("fill", self.x, self.y, self.lx, self.ly )
	love.graphics.draw( self.tileset, self.quad, self.x, self.y)--self.lx, self.ly)
end

function Block:update(dt)
end

function Block:destroy()
	Entity.destroy(self)
end

return Block