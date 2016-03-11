smoke = {}
-- particle system for board edges

function smoke.create(x, y, align, block_width, block_height, emission_scaler)
	local smoke = love.graphics.newParticleSystem(love.graphics.newImage("assets/particle.png"),
						      2000*emission_scaler)

	if align == "horizontal" then
		smoke:setPosition(x - block_width/2, y)
		smoke:setAreaSpread("uniform", block_width/2, 0)
	else
		smoke:setPosition(x, y - block_height/2)
		smoke:setAreaSpread("uniform", 0, block_height/2)
	end
	--smoke:setOffset(0, 0)
	smoke:setEmissionRate(400*emission_scaler)
	smoke:setEmitterLifetime(-1)
	smoke:setParticleLifetime(1.9*emission_scaler)
	local adjusted = emission_scaler+0.15
	smoke:setColors(255, 255, 255, 60*adjusted, 255, 255, 255, 60*adjusted, 255, 255, 255, 255)
	smoke:setSizes(0.8*adjusted, 0.15*adjusted, 0.15*adjusted, 0.1*adjusted, 0.04*adjusted, 0.01*adjusted, 0)
	smoke:setSpeed(0.01, 40.1*adjusted)
	--smoke:setDirection(math.rad(0))
	smoke:setSpread(math.rad(360))
	smoke:setLinearAcceleration(1, 1, 1, 1)
	smoke:setRotation(math.rad(0), math.rad(0) )
	smoke:setSpin(math.rad(0.5), math.rad(10), 1)
	smoke:setRadialAcceleration(10)
	smoke:setTangentialAcceleration(0)
	return smoke
end
