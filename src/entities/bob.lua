local class  = require 'lib.middleclass'
local Entity = require 'entities.entity'

local Bob = class('Bob', Entity)

Bob.static.updateOrder = 1

local speed		= 500
local brake		= 2000
local jump		= 400
local width		= 31
local height	= 64

local bobFilter = function(other)
  local cname = other.class.name
  return cname == 'Block'
end

function Bob:initialize(map, world, x,y)
	Entity.initialize(self, world, x, y, width, height)
	self.health = 100
	self.img = love.graphics.newImage( "textures/bob.png" )
	self.map = map
end

function Bob:update(dt)
	self:useInput(dt)
	self:changeVelocityByGravity(dt)
	self:moveColliding(dt)
	self:changeVelocityByBeingOnGround(dt)
	print("dx",self.dx,"dy",self.dy)
end

function Bob:changeVelocityByBeingOnGround()
	if self.onGround then
		self.dy = math.min(self.dy, 0)
	end
end

function Bob:moveColliding(dt)
  self.onGround = false
  local world = self.world

  local new_x = self.x + self.dx * dt
  local new_y = self.y + self.dy * dt

  local cols, len = world:check(self, new_x, new_y, bobFilter)
  if len == 0 then
    self:move(new_x, new_y)
  else
    local col, tl, tt, nx, ny, sl, st
    local visited = {}
    while len > 0 do
      col = cols[1]
      tl,tt,nx,ny,sl,st = col:getSlide()

      self:changeVelocityByCollisionNormal(nx, ny,0.4)
      self:checkIfOnGround(ny)

      self:move(tl,tt)

      if visited[col.other] then return end
      visited[col.other] = true

      cols, len = world:check(self, sl, st, bobFilter)
      if len == 0 then
        self:move(sl, st)
      end
    end
  end
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

function Bob:checkIfOnGround(ny)
  if ny < 0 then self.onGround = true end
end

function Bob:draw()
	love.graphics.draw( self.img, self.x, self.y)
end

function Bob:canFly()
  return false
end

return Bob