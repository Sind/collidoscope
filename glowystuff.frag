precision mediump float;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 sind(vec2 pos, float amp, float freq, float wavw, float pown, vec3 col){

	float xd = pow(wavw - (abs(pos.y - sin(pos.x * freq) * amp)),pown);
	
	return xd * col;
}

float d(vec2 pos, float wavw){
	return wavw - abs(pos.y - pos.x);
}


vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
  return 
}

void main( void ) {

	vec2 p = (gl_FragCoord.xy * 2. - resolution) / max(resolution.x, resolution.y);

	vec3 col =	sind(vec2(time*.3 + p.x, p.y), .4, 10. , 1.01, 30., vec3(.6,1.,1.));
	col +=		sind(vec2(time*.4+ p.x, p.y),  .2, 6.  , 1.01, 30., vec3(.6,.3,1.));

	col +=		sind(vec2(time*.4+ p.y, p.y),  .2, 20.  , 1.001, 30., vec3(.2,.7,.5));
	col +=		sind(vec2(time*.4+ p.x, p.x),  1., 20.  , 1.001, 30., vec3(.2,.7,.5));


	col +=		sind(vec2(time*.3 + pow(p.x + 1., .1), p.y),  .2, 6.  , 1.01, 30., vec3(.1,1.,.7));
	col +=	sind(vec2(time*.3 + p.x, p.y + p.x), .3, 10. , 1.01, 30., vec3(.6,1.,1.));

	

	col +=		sind(vec2(time*.2 + p.y, mod(time * .2, p.x) * p.x), .3, 10. , 1.01, 30., vec3(1.,.5,1.));
	col +=		sind(vec2(time*.2+ p.y, p.x),  .2, 6.  , 1.01, 30., vec3(1.,1.,.2));

	col +=		sind(vec2(p.x, p.y)          , 1., 200., 1.01, 20., vec3(.6,1.,.8));
	col +=		sind(vec2(p.y, p.x)          , 1., 200., 1.01, 20., vec3(.6,1.,.8));
	
	gl_FragColor = vec4(vec3(col), 1.);

}
