shader_type canvas_item;

uniform vec4 Color : hint_color;

void fragment()
{
	vec4 color = texture(TEXTURE, UV);
	COLOR = vec4(Color.rgb, color.a);
}