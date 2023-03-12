shader_type canvas_item;

uniform sampler2D mainTex;
uniform float spacing = 0.5;
uniform int rotation = 0;
uniform float scrollSpeed = .1;
uniform bool active;
uniform vec3 color;

void fragment()
{
	float s = sin(float(rotation) / 180.0 * 3.1415);
	float c = cos(float(rotation) / 180.0 * 3.1415);
	mat2 mat = mat2(vec2(c,-s),vec2(s,c));
	
	float value = 0.;
	vec2 realUv = UV / TEXTURE_PIXEL_SIZE;
	realUv = mat * realUv;
	realUv.y -= TIME * scrollSpeed;
	realUv = mod(realUv, 1. + spacing);
	if(realUv.x <= 1. && realUv.y <= 1.)
	{
		value = texture(mainTex, realUv).r;
	}
	
	if(active)
	{
		COLOR = vec4(color * value, 1);
	}
	else
	{
		COLOR = vec4(color * value / 2., value / 2.);
	}
}