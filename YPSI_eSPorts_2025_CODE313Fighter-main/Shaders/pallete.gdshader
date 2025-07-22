shader_type canvas_item;

uniform sampler2D palette: filter_nearest;
uniform bool enabled;

void fragment() {
	if (enabled){
		float alpha = COLOR.a;
		COLOR = texture(palette, vec2(COLOR.b));
		COLOR.a *= alpha;
	}
}
//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
