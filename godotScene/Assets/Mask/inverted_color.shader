shader_type canvas_item;
render_mode unshaded ;

void fragment() {
	vec4 c = texture(TEXTURE, UV).rgba;
	c.r = 1.0 - c.r;
	c.g = 1.0 - c.g;
	c.b = 1.0 - c.b;
	COLOR.rgba = c;
}