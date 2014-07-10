-- hard coded
system = love.graphics.newParticleSystem( love.graphics.newImage("particle.png"), 100 )
system:setPosition( 874, 430 )
system:setOffset( 16, 16 )
system:setBufferSize( 2000 )
system:setEmissionRate( 100 )
system:setEmitterLifetime( -1 )
system:setParticleLifetime( 3.0 )
system:setColors( 0, 0, 0, 0, 255, 255, 255, 255 )
system:setSizes( 1, 6, 0 )
system:setSpeed( 0, 20  )
system:setDirection( math.rad(0) )
system:setSpread( math.rad(360) )
system:setLinearAcceleration( 0, 0 )
system:setRotation( math.rad(0), math.rad(0) )
system:setSpin( math.rad(0.5), math.rad(10), 1 )
system:setRadialAcceleration( 10 )
system:setTangentialAcceleration( 0 )
