shader_type canvas_item;

uniform float height = 5.0;
uniform float frecuency = 10.0;
uniform float speed = 5.0;
// mx+b
void vertex() {
	VERTEX.y += height * sin((frecuency * UV.x) + (speed * TIME));
}
