#version 460 core

precision highp float;

#include <flutter/runtime_effect.glsl>


layout(location = 0) uniform vec2 size;
layout(location = 1) uniform vec2 prevSize;
layout(location = 2) uniform vec2 deltaPosition;
layout(location = 3) uniform sampler2D frame;
// layout(location = 4) uniform sampler2D prevFrame;
//layout(location = 3) uniform sampler2D prevFrame1;

out vec4 fragColor;

void main() {
 
  vec2 uv = FlutterFragCoord().xy/size;
  vec2 deltaPositionUv = deltaPosition/size;
  vec2 sizeRatio = size/prevSize;

  const int numSteps = 20;
  vec4 pixel = vec4(0);
  const float intensity = 2.0;

  //frame interpolation
  // for(int i=0;i<numSteps;i++){
  //   float currentStep = float(i)/float( numSteps );
  //   float stepInv = 1.0 - currentStep;
  //   vec4 framePart = texture(frame, uv + deltaPositionUv * currentStep);
  //   vec4 prevFamePart = texture(prevFrame, uv + deltaPositionUv * stepInv);
  //   pixel+= (framePart + prevFamePart)/2.0;
  // }

  //simple radial blur

  // for(int i=0;i<numSteps;i++){
  //   pixel += texture(frame, uv - float(i)* deltaPosition/float(numSteps) * intensity);
  // }

  //scaling and translating blur

  vec2 scaled = uv*sizeRatio;
  vec2 translated = scaled - deltaPositionUv*sizeRatio;

  if(texture(frame, uv).w !=0.0 || texture(frame,translated).w!=0.0){
      for(int i=0;i<numSteps;i++){
        vec2 scaled = uv+(uv*sizeRatio-uv)*float(i)/float(numSteps);
        vec2 translated = scaled - deltaPositionUv*sizeRatio*float(i)/float(numSteps);
        pixel+=texture(frame,translated);
      }

      pixel/=numSteps;
  }
  
 

  // const int n = 50;
  // for(int i=0;i<n;i++){
  //   pixel+=texture(frame, uv + vec2(float(i)));
  // }
  // pixel/=n;
  fragColor = pixel;
}
