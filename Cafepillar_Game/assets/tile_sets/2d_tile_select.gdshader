shader_type canvas_item;

varying flat vec2 vertexPos[2];

uniform vec2 globalMousePos;
uniform vec4 selectionColor = vec4(0, 0, 0, 0);


void vertex() {
	vertexPos[0] = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	float isWithinY= step(vertexPos[0].y, globalMousePos.y) * step(globalMousePos.y, vertexPos[0].y +16.);
	float isWithinX= step(vertexPos[0].x, globalMousePos.x) * step(globalMousePos.x, vertexPos[0].x +16.);
	float isWithin = isWithinX * isWithinY;
	
	vec4 textureColor = texture(TEXTURE, UV);
	COLOR = mix(textureColor, selectionColor, 0.7*isWithin);
}