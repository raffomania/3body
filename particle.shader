shader_type particles;

uniform vec2 target;

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
    TRANSFORM *= (0.2 * CUSTOM.x + 0.1);
    TRANSFORM[3].xy = position;
	} else {
    VELOCITY.xy += ((target - TRANSFORM[3].xy) * (CUSTOM.x * 0.1 + 0.4)) * DELTA;
    float distance = distance(target, TRANSFORM[3].xy);
    if (distance < 100.0) {
      vec2 to_target = TRANSFORM[3].xy - target;
      vec2 perpendicular = vec2(to_target.y, -to_target.x) * DELTA * (CUSTOM.x * 10.0 + 60.0);
      VELOCITY.xy = (VELOCITY.xy * 0.99) + (perpendicular * 0.01);
    }

    if (length(VELOCITY) > 200.0) {
      VELOCITY *= 0.95;
    }

    // Set colors based on velocity and mix in a little green based on the random seed.
    float rescaled_y = abs(sin(VELOCITY.y / 100.0));
    float rescaled_x = abs(sin(VELOCITY.x / 100.0));
    float red = mix(0.1, 0.7, rescaled_y);
    float blue = mix(0.1, 0.7, rescaled_x);
    float green = mix(0.01, 0.4, sin(CUSTOM.x * 6.141) * 0.5 + 0.5);
    COLOR = vec4(red, green, blue, 1.0);
	}
}