-- radialacc_min = 0,
-- linear_acceleration_ymax = 0,
-- tangential_acceleration_max = 0,
---- area_spread_distribution = "Uniform",
-- speed_min = 0,
---- buffer_size = 1000,
---- offsety = 0,
---- area_spread_dx = 70,
---- area_spread_dy = 0,
-- tangential_acceleration_min = 0,
-- rotation_min = 0,
-- plifetime_min = 0,
-- insert_mode = "Top",
-- speed_max = 50,
-- size_variation = 0,
---- emission_rate = 500,
-- image = "circle.png",
---- offsetx = 0,
-- emitter_lifetime = -1,
-- linear_acceleration_xmin = 0,
-- spin_max = 0,
-- linear_acceleration_ymin = 0,
-- rotation_max = 0,
-- plifetime_max = 1,
-- name = "testsys",
-- colors = {255, 255, 255, 255, 255, 255, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
-- spread = 360,
-- direction = 0,
-- radialacc_max = 0,
-- linear_acceleration_xmax = 0,
-- sizes = {0, 0, 0, 0, 0, 0, 0, 0, },
-- spin_min = 0,
-- spin_variation = 0
smoke = {}
function smoke.create(x, y, align, block_width, block_height)
	local smoke = love.graphics.newParticleSystem( love.graphics.newImage("smoke.png"), 2000)

	if align == "horizontal" then
		smoke:setPosition(x - block_width/2, y)
		smoke:setAreaSpread("uniform", block_width/2, 0)
	else
		smoke:setPosition(x, y - block_height/2)
		smoke:setAreaSpread("uniform", 0, block_height/2)
	end
	--smoke:setOffset(0, 0)
	smoke:setEmissionRate(200)
	smoke:setEmitterLifetime(-1)
	smoke:setParticleLifetime(0.9)
	smoke:setColors(255, 255, 255, 60, 255, 255, 255, 60, 255, 255, 255, 255)
	smoke:setSizes(0.8, 0.15, 0.15, 0.1, 0)
	smoke:setSpeed(0.01, 40.1)
	--smoke:setDirection(math.rad(0))
	smoke:setSpread(math.rad(360))
	smoke:setLinearAcceleration(1, 1, 1, 1)
	smoke:setRotation(math.rad(0), math.rad(0) )
	smoke:setSpin(math.rad(0.5), math.rad(10), 1)
	smoke:setRadialAcceleration(10)
	smoke:setTangentialAcceleration(0)
	return smoke
end
