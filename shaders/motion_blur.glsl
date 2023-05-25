#version 460 core

precision highp float;

#include <flutter/runtime_effect.glsl>


layout(location = 0) uniform vec2 size;
// layout(location = 1) uniform vec2 position;
// layout(location = 2) uniform vec2 prevSize;
// layout(location = 3) uniform vec2 prevPosition;
layout(location = 1) uniform sampler2D frame;
layout(location = 2) uniform sampler2D prevFrame;
//layout(location = 3) uniform sampler2D prevFrame1;

out vec4 fragColor;

void main() {
  //vec2 uv = FlutterFragCoord().xy / uSize;
 // vec2 puv = round(uv * uPixels) / uPixels;
  //fragColor = texture(uTexture, puv);
  //fragColor = vec4(1.0);
  vec2 uv = FlutterFragCoord().xy/size;
 // vec4 frame = texture(uTexture,uv);
  //vec4 prevFrame0 = texture(prevFrame0,uv);
  //vec4 prevFrame1 = texture(prevFrame1,uv);
  const int n = 50;
  vec4 pixel = vec4(0);
  for(int i=0;i<n;i++){
    pixel+=texture(frame, uv + vec2(float(i)));
  }
  pixel/=n;
  fragColor = pixel;
}
