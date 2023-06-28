{
  "sksl": "// This SkSL shader is autogenerated by spirv-cross.\n\nfloat4 flutter_FragCoord;\n\nuniform vec2 size;\nuniform vec2 prevSize;\nuniform vec2 deltaPosition;\nuniform float intensity;\nuniform shader frame;\nuniform half2 frame_size;\n\nvec4 fragColor;\n\nvec2 FLT_flutter_local_FlutterFragCoord()\n{\n    return flutter_FragCoord.xy;\n}\n\nvoid FLT_main()\n{\n    vec2 uv = FLT_flutter_local_FlutterFragCoord() / size;\n    vec2 deltaPositionUv = deltaPosition / size;\n    vec2 sizeRatio = size / prevSize;\n    vec4 pixel = vec4(0.0);\n    for (int i = 0; i < 60; i++)\n    {\n        vec2 scaled = uv + (((((uv * sizeRatio) - uv) * float(i)) / vec2(60.0)) * intensity);\n        vec2 translated = scaled - ((((deltaPositionUv * intensity) * sizeRatio) * float(i)) / vec2(60.0));\n        pixel += frame.eval(frame_size *  translated);\n    }\n    pixel /= vec4(60.0);\n    fragColor = pixel;\n}\n\nhalf4 main(float2 iFragCoord)\n{\n      flutter_FragCoord = float4(iFragCoord, 0, 0);\n      FLT_main();\n      return fragColor;\n}\n",
  "stage": 1,
  "target_platform": 2,
  "uniforms": [
    {
      "array_elements": 0,
      "bit_width": 32,
      "columns": 1,
      "location": 0,
      "name": "size",
      "rows": 2,
      "type": 10
    },
    {
      "array_elements": 0,
      "bit_width": 32,
      "columns": 1,
      "location": 1,
      "name": "prevSize",
      "rows": 2,
      "type": 10
    },
    {
      "array_elements": 0,
      "bit_width": 32,
      "columns": 1,
      "location": 2,
      "name": "deltaPosition",
      "rows": 2,
      "type": 10
    },
    {
      "array_elements": 0,
      "bit_width": 32,
      "columns": 1,
      "location": 3,
      "name": "intensity",
      "rows": 1,
      "type": 10
    },
    {
      "array_elements": 0,
      "bit_width": 0,
      "columns": 1,
      "location": 4,
      "name": "frame",
      "rows": 1,
      "type": 12
    }
  ]
}