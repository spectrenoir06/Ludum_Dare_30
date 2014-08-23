local class  = require 'lib.middleclass'
local Entity = require 'entities.entity'

local Bob = class('Bob', Entity)

Bob.static.updateOrder = 1

local speed		= 500
local brake		= 2000
local jump		= 400
local width		= 32
local height	= 64

function Bob:initialize(map, world, x,y)
	Entity.initialize(self, world, x, y, width, height)
	self.health = 100
	self.img = love.graphics.newImage( "textures/bob.png" )
	self.map = map
end

function Bob:update(dt)
  self:useInput(dt)
  --self:changeVelocityByGravity(dt)
end

function Bob:useInput(dt)

	self.fly = false

	if self.isDead then return end

	local dx = self.dx
	local dy = self.dy
	
	if love.keyboard.isDown("left") then
		dx = dx - dt * (dx > 0 and brake or speed)
	elseif love.keyboard.isDown("right") then
		dx = dx + dt * (dx < 0 and brake or speed)
	else
		local braking = dt * (dx < 0 and brake or -brake)
		if math.abs(braking) > math.abs(dx) then
			dx = 0
		else
			dx = dx + braking
		end
	end

	if love.keyboard.isDown("up") and (self:canFly() or self.onGround) then
		dy = -jump
		self.fly = true
	end

	self.dx = dx
	self.dy = dy
end

function Bob:draw()
	love.graphics.draw( self.img, self.x, self.y)
end

return Bob