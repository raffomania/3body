shader_type particles;

uniform vec2 target;
uniform float beat;
uniform float energy;

/*
 * GLSL HSV to RGB+A conversion. Useful for many effects and shader debugging.
 *
 * Copyright (c) 2012 Corey Tabaka
 *
 * Hue is in the range [0.0, 1.0] instead of degrees or radians.
 * Alpha is simply passed through for convenience.
 */

vec4 hsv_to_rgb(float h, float s, float v, float a)
{
	float c = v * s;
	h = mod((h * 6.0), 6.0);
	float x = c * (1.0 - abs(mod(h, 2.0) - 1.0));
	vec4 color;

	if (0.0 <= h && h < 1.0) {
		color = vec4(c, x, 0.0, a);
	} else if (1.0 <= h && h < 2.0) {
		color = vec4(x, c, 0.0, a);
	} else if (2.0 <= h && h < 3.0) {
		color = vec4(0.0, c, x, a);
	} else if (3.0 <= h && h < 4.0) {
		color = vec4(0.0, x, c, a);
	} else if (4.0 <= h && h < 5.0) {
		color = vec4(x, 0.0, c, a);
	} else if (5.0 <= h && h < 6.0) {
		color = vec4(c, 0.0, x, a);
	} else {
		color = vec4(0.0, 0.0, 0.0, a);
	}

	color.rgb += v - c;

	return color;
}

float rand_from_seed(in uint seed) {
  int k;
  int s = int(seed);
  if (s == 0)
    s = 305420679;
  k = s / 127773;
  s = 16807 * (s - k * 127773) - 2836 * k;
  if (s < 0)
    s += 2147483647;
  seed = uint(s);
  return float(seed % uint(65536)) / 65535.0;
}

uint hash(uint x) {
  x = ((x >> uint(16)) ^ x) * uint(73244475);
  x = ((x >> uint(16)) ^ x) * uint(73244475);
  x = (x >> uint(16)) ^ x;
  return x;
}

void vertex() {
	if (RESTART) {
		uint alt_seed1 = hash(NUMBER + uint(1) + RANDOM_SEED);
		uint alt_seed2 = hash(NUMBER + uint(27) + RANDOM_SEED);
		uint alt_seed3 = hash(NUMBER + uint(43) + RANDOM_SEED);
    CUSTOM.x = rand_from_seed(alt_seed1);
    vec2 position = vec2((rand_from_seed(alt_seed2) * 2.0 - 1.0) * 400.0,
                         (rand_from_seed(alt_seed3) * 2.0 - 1.0));
    TRANSFORM[3].xy = position;
	} else {
    float heavy_beat = beat + 1.0;
    float distance = distance(target, TRANSFORM[3].xy);

    TRANSFORM[0].x = (0.2 * CUSTOM.x + 0.1);
    TRANSFORM[1].y = (0.2 * CUSTOM.x + 0.1);

    VELOCITY.xy += ((target - TRANSFORM[3].xy) * (CUSTOM.x * 0.2 + 0.4)) * DELTA * pow(heavy_beat, 2);

    if (distance < 100.0) {
      vec2 to_target = TRANSFORM[3].xy - target;
      vec2 perpendicular = vec2(to_target.y, -to_target.x) * DELTA * (CUSTOM.x * 10.0 + 60.0) * pow(heavy_beat, 13);
      VELOCITY.xy = (VELOCITY.xy * 0.99) + (perpendicular * 0.01);
    }

    if (length(VELOCITY) > 200.0) {
      VELOCITY *= 0.95;
    }

    // Set colors based on velocity and mix in a little green based on the random seed.
    float rescaled_y = abs(sin(VELOCITY.y / 100.0));
    float rescaled_x = abs(sin(VELOCITY.x / 100.0));
    float green = mix(0.01, 0.3, sin(CUSTOM.x * 6.141) * 0.5 + 0.5);
    float red = mix(0.2, 0.6, rescaled_y) - green * 0.5;
    float blue = mix(0.2, 0.6, rescaled_x) - green * 0.5;
    COLOR = vec4(red, green, blue, 1.0) * heavy_beat;
	}
}