shader_type canvas_item;
render_mode unshaded;

uniform int blurSize : hint_range(0,45) = 35;

void fragment() {
    vec4 blurred = textureLod(SCREEN_TEXTURE, SCREEN_UV, float(blurSize)/10.0);
    COLOR = vec4(0.0, 0.0, 0.0, 1.0);

    float average = (blurred.r + blurred.g + blurred.b) / 3.0;

    if (average > 0.2) {
        COLOR = blurred;
    }

}