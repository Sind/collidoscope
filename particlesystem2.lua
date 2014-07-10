-- hard coded
system2 = love.graphics.newParticleSystem( love.graphics.newImage("particle2.png"), 50 )
system2:setPosition( 942, 423 )
system2:setOffset( 16, 16 )
system2:setBufferSize( 2000 )
system2:setEmissionRate( 20 )
system2:setEmitterLifetime( -1 )
system2:setParticleLifetime( 1.5 )
system2:setColors( 255, 100, 0, 10, 255, 255, 100, 170 )
system2:setSizes( 12, 1, 0 )
system2:setSpeed( 0, 100  )
system2:setDirection( math.rad(0) )
system2:setSpread( math.rad(360) )
system2:setLinearAcceleration( 0, 0 )
system2:setRotation( math.rad(0), math.rad(360) )
system2:setSpin( math.rad(0), math.rad(0), 1 )
system2:setRadialAcceleration( 0 )
system2:setTangentialAcceleration( 0 )

