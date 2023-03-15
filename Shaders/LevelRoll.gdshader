shader_type canvas_item;

uniform float left : hint_range(0, 1) = 0;
uniform float right : hint_range(0, 1) = 1;
uniform vec4 color : source_color = vec4(0,0,0,1);

varying float _left;
varying float _right;

const float pi = 3.1415;

void vertex()
{
	_left = .5 - cos(left*pi)*.5;
	_right = .5 - cos(right*pi)*.5;
}

void fragment()
{
	float t = 1. - (2.*UV.y-1.)*(2.*UV.y-1.);
	float x = pow(-(cos(UV.x*pi) / 2.) + .5, t + 1.);
	if(x < _left || x > _right)
	{
		discard;
	}
	COLOR = color;
}