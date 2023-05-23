#version 460 core

precision highp float;

#include <flutter/runtime_effect.glsl>

//layout(location = 0) uniform vec2 uPixels;
layout(location = 0) uniform vec2 uSize;
layout(location = 1) uniform sampler2D uTexture;
layout(location = 2) uniform sampler2D prevFrame0;
layout(location = 3) uniform sampler2D prevFrame1;

out vec4 fragColor;

void main() {
  //vec2 uv = FlutterFragCoord().xy / uSize;
 // vec2 puv = round(uv * uPixels) / uPixels;
  //fragColor = texture(uTexture, puv);
  //fragColor = vec4(1.0);
  vec2 uv = FlutterFragCoord().xy/uSize;
  vec4 frame = texture(uTexture,uv);
  vec4 prevFrame0 = texture(prevFrame0,uv);
  vec4 prevFrame1 = texture(prevFrame1,uv);
  const int n = 50;
  vec4 pixel = vec4(0);
  for(int i=0;i<n;i++){
    pixel+=texture(uTexture, uv + vec2(float(i)));
  }
  pixel/=n;
  fragColor = pixel;
}
