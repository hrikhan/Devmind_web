// shaders/aurora.glsl
// Aurora / Gradient Noise shader for Flutter runtime effect
#version 460 core
#include <flutter/runtime_effect.glsl>

precision highp float;

// Uniform ordering must match the indices used in Dart (setFloat 0,1,2)
layout(location = 0) uniform vec2 u_resolution;
layout(location = 1) uniform float u_time;

out vec4 fragColor;

// ---------- Simple pseudo-random & noise ----------
float hash(vec2 p) {
  p = 50.0 * fract(p * 0.3183099 + vec2(0.71,0.113));
  return fract(p.x * p.y * (p.x + p.y));
}

float noise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  float a = hash(i);
  float b = hash(i + vec2(1.0, 0.0));
  float c = hash(i + vec2(0.0, 1.0));
  float d = hash(i + vec2(1.0, 1.0));
  vec2 u = f * f * (3.0 - 2.0 * f);
  return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 p) {
  float v = 0.0;
  float a = 0.5;
  float m = 2.0;
  for (int i = 0; i < 5; i++) {
    v += a * noise(p);
    p *= m;
    a *= 0.5;
  }
  return v;
}

// ---------- color palette helper ----------
vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
  return a + b * cos(6.28318*(c * t + d));
}

void main() {
  vec2 fragCoord = FlutterFragCoord();

  // normalize coordinates -1..1
  vec2 uv = (fragCoord / u_resolution) * 2.0 - 1.0;
  uv.x *= u_resolution.x / u_resolution.y;

  // base moving coordinate
  vec2 p = uv * 2.0;
  float t = u_time * 0.70;  // faster, roughly 2.5x speed

  // flow field
  float q = fbm(p * 0.6 + vec2(t * 0.35, -t * 0.2));
  float r = fbm(p * 1.8 + q * 1.5 + vec2(-t * 0.45, t * 0.15));
  float f = fbm(p * 3.0 + r * 0.8);

  // soft bands + noise
  float bands = smoothstep(0.1, 0.9, sin((p.y + r * 0.8) * 3.0 + f * 2.5));
  float glow = exp(-length(uv * vec2(1.0, 0.6)) * 1.8);
  float curtain = smoothstep(0.35, -0.05, uv.y) + smoothstep(0.35, -0.05, -uv.y);

  // combine layers
  float intensity = mix(f * 0.6 + r * 0.4, bands, 0.6) * 0.9;
  intensity *= (0.65 + 0.6 * q) + 0.35 * curtain;
  float midDip = mix(0.35, 1.0, smoothstep(0.08, 0.35, abs(uv.y)));
  intensity *= midDip;
  intensity = clamp(intensity, 0.0, 1.25);
  float tone = pow(intensity, 0.88);

  // ---------- COLOR PALETTE (Muted Sky-like: Grey-Green Mix) ----------
  vec3 col = palette(
    tone + 0.08,
    vec3(0.15, 0.18, 0.20),  // soft grey base
    vec3(0.20, 0.35, 0.25),  // subtle green sweep
    vec3(0.25, 0.40, 0.30),  // band frequency
    vec3(0.10, 0.15, 0.10)   // phase shift
  );

  // final color blending with glow
  vec3 finalColor = col * (0.75 + 1.25 * glow);
  finalColor = mix(finalColor, vec3(0.22, 0.25, 0.30), 0.20 * smoothstep(0.25, 0.85, glow)); // soft muted fringe
  finalColor = mix(finalColor, vec3(0.28, 0.45, 0.32), 0.25 * glow * tone); // subtle crest highlights
  finalColor = mix(vec3(0.05, 0.05, 0.08), finalColor, 1.0);

  // subtle vignetting
  float vign = smoothstep(1.3, 0.6, length(uv) * 1.2);
  finalColor *= vign;

  fragColor = vec4(finalColor, 1.0);
}