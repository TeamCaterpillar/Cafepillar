shader_type canvas_item;

uniform vec2 globalMousePos;
uniform vec4 selectionColor = vec4(0, 0, 0, 0);

// Rotation matrix for 45 degrees
const mat2 rotation = mat2(
    vec2(0.7071, -0.7071),
	vec2(0.7071,  0.7071)
);



// Scale factors for isometric projection
uniform vec2 scaleFactor = vec2(1.0, 0.5);

varying vec2 rotatedVertexPos;

void vertex() {
    // Transform the vertex position to world space
    vec2 worldPos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;

    // Apply rotation and scaling
    rotatedVertexPos = (rotation * worldPos) * scaleFactor;

    // Keep the original vertex position for rendering
}

void fragment() {
    // Rotate and scale the global mouse position
    vec2 transformedMousePos = (rotation * globalMousePos) * scaleFactor;

    // Define the size of the selection diamond (half-width and half-height)
    float halfWidth = 16.0;
    float halfHeight = 8.0;

    // Check if the mouse position is within the selection bounds
    float isWithinX = step(rotatedVertexPos.x - halfWidth, transformedMousePos.x) * step(transformedMousePos.x, rotatedVertexPos.x + halfWidth);
    float isWithinY = step(rotatedVertexPos.y - halfHeight, transformedMousePos.y) * step(transformedMousePos.y, rotatedVertexPos.y + halfHeight);
    float isWithin = isWithinX * isWithinY;

    // Fetch the texture color
    vec4 textureColor = texture(TEXTURE, UV);

    // Blend the texture color with the selection color based on the selection condition
    COLOR = mix(textureColor, selectionColor, 0.7 * isWithin);
}
