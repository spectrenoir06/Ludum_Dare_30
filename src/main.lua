require 'lib.middleclass'
local gamera = require 'lib.gamera'
local Map = require 'class.map'

local camera, map
local updateRadius = 100

function love.load()

	local width, height = 6400, 6400
	camera = gamera.new(0,0, width, height)
	map = Map:new(width, height, camera)
end


function love.update(dt)
	
	local l,t,w,h = camera:getVisible()
	l, t, w, h = l - updateRadius, t - updateRadius, w + updateRadius * 2, h + updateRadius * 2
	map:update(dt, l, t, w, h)
	camera:setPosition(map.bob:getCenter())

	--camera:update(dt)
end

-- Drawing
function love.draw()
	
	camera:draw(
		function(l,t,w,h)
			map:draw(l,t,w,h)
		end)
		
	local w,h = love.graphics.getDimensions()
	if drawDebug then
		local statistics = ("fps: %d, mem: %dKB\n"):format(love.timer.getFPS(), collectgarbage("count"))
		love.graphics.printf(statistics, w - 200, h - 40, 200, 'right')
	end
end

function love.keypressed(k)
  if k=="escape" then love.event.quit() end
  if k=="tab"    then drawDebug = not drawDebug end
  if k=="delete" then
    collectgarbage("collect")
  end
  if k=="return" then
    --map:reset()
  end
end
