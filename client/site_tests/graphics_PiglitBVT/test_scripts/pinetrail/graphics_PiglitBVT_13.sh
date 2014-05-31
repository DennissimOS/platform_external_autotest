#!/bin/bash


need_pass=188
failures=0
PIGLIT_PATH=/usr/local/autotest/deps/piglit/piglit/
export PIGLIT_SOURCE_DIR=/usr/local/autotest/deps/piglit/piglit/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PIGLIT_PATH/lib
export DISPLAY=:0
export XAUTHORITY=/home/chronos/.Xauthority


function run_test()
{
  local name="$1"
  local time="$2"
  local command="$3"
  echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  echo "+ Running test "$name" of expected runtime $time sec: $command"
  sync
  $command
  if [ $? == 0 ] ; then
    let "need_pass--"
    echo "+ Return code 0 -> Test passed. ($name)"
  else
    let "failures++"
    echo "+ Return code not 0 -> Test failed. ($name)"
  fi
}


pushd $PIGLIT_PATH
run_test "spec/glsl-1.10/execution/built-in-functions/vs-op-uplus-ivec3" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-op-uplus-ivec3.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-op-uplus-ivec4" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-op-uplus-ivec4.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-op-uplus-mat2" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-op-uplus-mat2.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-op-uplus-mat3" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-op-uplus-mat3.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-op-uplus-mat4" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-op-uplus-mat4.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-op-uplus-vec2" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-op-uplus-vec2.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-op-uplus-vec3" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-op-uplus-vec3.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-op-uplus-vec4" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-op-uplus-vec4.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-op-xor-bool-bool" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-op-xor-bool-bool.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-op-xor-bool-bool-using-if" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-op-xor-bool-bool-using-if.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-pow-vec2-vec2" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-pow-vec2-vec2.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-pow-vec3-vec3" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-pow-vec3-vec3.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-pow-vec4-vec4" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-pow-vec4-vec4.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-radians-float" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-radians-float.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-radians-vec2" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-radians-vec2.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-radians-vec3" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-radians-vec3.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-radians-vec4" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-radians-vec4.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-reflect-float-float" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-reflect-float-float.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-reflect-vec2-vec2" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-reflect-vec2-vec2.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-reflect-vec3-vec3" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-reflect-vec3-vec3.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-reflect-vec4-vec4" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-reflect-vec4-vec4.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-refract-float-float-float" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-refract-float-float-float.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-refract-vec2-vec2-float" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-refract-vec2-vec2-float.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-refract-vec3-vec3-float" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-refract-vec3-vec3-float.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-refract-vec4-vec4-float" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-refract-vec4-vec4-float.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-sign-float" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-sign-float.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-sign-vec2" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-sign-vec2.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-sign-vec3" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-sign-vec3.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-sign-vec4" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-sign-vec4.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-sin-float" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-sin-float.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-sin-vec2" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-sin-vec2.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-sin-vec3" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-sin-vec3.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-sin-vec4" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-sin-vec4.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-smoothstep-float-float-float" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-smoothstep-float-float-float.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-smoothstep-float-float-vec2" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-smoothstep-float-float-vec2.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-smoothstep-float-float-vec3" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-smoothstep-float-float-vec3.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-smoothstep-float-float-vec4" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-smoothstep-float-float-vec4.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-smoothstep-vec2-vec2-vec2" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-smoothstep-vec2-vec2-vec2.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-smoothstep-vec3-vec3-vec3" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-smoothstep-vec3-vec3-vec3.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-smoothstep-vec4-vec4-vec4" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-smoothstep-vec4-vec4-vec4.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-sqrt-float" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-sqrt-float.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-sqrt-vec2" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-sqrt-vec2.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-sqrt-vec3" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-sqrt-vec3.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-sqrt-vec4" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-sqrt-vec4.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-step-float-float" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-step-float-float.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-step-float-vec2" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-step-float-vec2.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-step-float-vec3" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-step-float-vec3.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-step-float-vec4" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-step-float-vec4.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-step-vec2-vec2" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-step-vec2-vec2.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-step-vec3-vec3" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-step-vec3-vec3.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-step-vec4-vec4" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-step-vec4-vec4.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-tan-float" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-tan-float.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-tan-vec2" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-tan-vec2.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-tan-vec3" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-tan-vec3.shader_test -auto"
run_test "spec/glsl-1.10/execution/built-in-functions/vs-tan-vec4" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/built-in-functions/vs-tan-vec4.shader_test -auto"
run_test "spec/glsl-1.10/execution/clipping/clip-plane-transformation clipvert_pos" 0.0 "bin/clip-plane-transformation clipvert_pos -auto -fbo"
run_test "spec/glsl-1.10/execution/clipping/clip-plane-transformation fixed" 0.0 "bin/clip-plane-transformation fixed -auto -fbo"
run_test "spec/glsl-1.10/execution/clipping/clip-plane-transformation pos_clipvert" 0.0 "bin/clip-plane-transformation pos_clipvert -auto -fbo"
run_test "spec/glsl-1.10/execution/fs-bool-less-compare-false" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/fs-bool-less-compare-false.shader_test -auto"
run_test "spec/glsl-1.10/execution/fs-bool-less-compare-true" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/fs-bool-less-compare-true.shader_test -auto"
run_test "spec/glsl-1.10/execution/fs-inline-notequal" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/fs-inline-notequal.shader_test -auto"
run_test "spec/glsl-1.10/execution/fs-saturate-exp2" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/fs-saturate-exp2.shader_test -auto"
run_test "spec/glsl-1.10/execution/fs-saturate-pow" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/fs-saturate-pow.shader_test -auto"
run_test "spec/glsl-1.10/execution/fs-saturate-sqrt" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/fs-saturate-sqrt.shader_test -auto"
run_test "spec/glsl-1.10/execution/fs-vector-indexing-kills-all-channels" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/fs-vector-indexing-kills-all-channels.shader_test -auto"
run_test "spec/glsl-1.10/execution/interpolation/interpolation-none-gl_FrontColor-flat-fixed" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/interpolation/interpolation-none-gl_FrontColor-flat-fixed.shader_test -auto"
run_test "spec/glsl-1.10/execution/interpolation/interpolation-none-gl_FrontColor-flat-none" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/interpolation/interpolation-none-gl_FrontColor-flat-none.shader_test -auto"
run_test "spec/glsl-1.10/execution/interpolation/interpolation-none-gl_FrontColor-flat-vertex" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/interpolation/interpolation-none-gl_FrontColor-flat-vertex.shader_test -auto"
run_test "spec/glsl-1.10/execution/interpolation/interpolation-none-gl_FrontSecondaryColor-flat-fixed" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/interpolation/interpolation-none-gl_FrontSecondaryColor-flat-fixed.shader_test -auto"
run_test "spec/glsl-1.10/execution/interpolation/interpolation-none-gl_FrontSecondaryColor-flat-none" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/interpolation/interpolation-none-gl_FrontSecondaryColor-flat-none.shader_test -auto"
run_test "spec/glsl-1.10/execution/interpolation/interpolation-none-gl_FrontSecondaryColor-flat-vertex" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/interpolation/interpolation-none-gl_FrontSecondaryColor-flat-vertex.shader_test -auto"
run_test "spec/glsl-1.10/execution/interpolation/interpolation-none-other-flat-fixed" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/interpolation/interpolation-none-other-flat-fixed.shader_test -auto"
run_test "spec/glsl-1.10/execution/interpolation/interpolation-none-other-flat-none" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/interpolation/interpolation-none-other-flat-none.shader_test -auto"
run_test "spec/glsl-1.10/execution/interpolation/interpolation-none-other-flat-vertex" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/interpolation/interpolation-none-other-flat-vertex.shader_test -auto"
run_test "spec/glsl-1.10/execution/interpolation/interpolation-none-other-smooth-fixed" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/interpolation/interpolation-none-other-smooth-fixed.shader_test -auto"
run_test "spec/glsl-1.10/execution/interpolation/interpolation-none-other-smooth-none" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/interpolation/interpolation-none-other-smooth-none.shader_test -auto"
run_test "spec/glsl-1.10/execution/interpolation/interpolation-none-other-smooth-vertex" 0.0 "bin/shader_runner generated_tests/spec/glsl-1.10/execution/interpolation/interpolation-none-other-smooth-vertex.shader_test -auto"
run_test "spec/glsl-1.10/execution/maximums/gl_MaxClipPlanes" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/maximums/gl_MaxClipPlanes.shader_test -auto"
run_test "spec/glsl-1.10/execution/maximums/gl_MaxCombinedTextureImageUnits" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/maximums/gl_MaxCombinedTextureImageUnits.shader_test -auto"
run_test "spec/glsl-1.10/execution/maximums/gl_MaxDrawBuffers" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/maximums/gl_MaxDrawBuffers.shader_test -auto"
run_test "spec/glsl-1.10/execution/maximums/gl_MaxFragmentUniformComponents" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/maximums/gl_MaxFragmentUniformComponents.shader_test -auto"
run_test "spec/glsl-1.10/execution/maximums/gl_MaxLights" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/maximums/gl_MaxLights.shader_test -auto"
run_test "spec/glsl-1.10/execution/maximums/gl_MaxTextureCoords" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/maximums/gl_MaxTextureCoords.shader_test -auto"
run_test "spec/glsl-1.10/execution/maximums/gl_MaxTextureImageUnits" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/maximums/gl_MaxTextureImageUnits.shader_test -auto"
run_test "spec/glsl-1.10/execution/maximums/gl_MaxTextureUnits" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/maximums/gl_MaxTextureUnits.shader_test -auto"
run_test "spec/glsl-1.10/execution/maximums/gl_MaxVaryingFloats" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/maximums/gl_MaxVaryingFloats.shader_test -auto"
run_test "spec/glsl-1.10/execution/maximums/gl_MaxVertexAttribs" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/maximums/gl_MaxVertexAttribs.shader_test -auto"
run_test "spec/glsl-1.10/execution/maximums/gl_MaxVertexTextureImageUnits" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/maximums/gl_MaxVertexTextureImageUnits.shader_test -auto"
run_test "spec/glsl-1.10/execution/maximums/gl_MaxVertexUniformComponents" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/maximums/gl_MaxVertexUniformComponents.shader_test -auto"
run_test "spec/glsl-1.10/execution/samplers/glsl-fs-shadow1D" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/samplers/glsl-fs-shadow1D.shader_test -auto"
run_test "spec/glsl-1.10/execution/samplers/glsl-fs-shadow1D-02" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/samplers/glsl-fs-shadow1D-02.shader_test -auto"
run_test "spec/glsl-1.10/execution/samplers/glsl-fs-shadow1D-04" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/samplers/glsl-fs-shadow1D-04.shader_test -auto"
run_test "spec/glsl-1.10/execution/samplers/glsl-fs-shadow1D-05" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/samplers/glsl-fs-shadow1D-05.shader_test -auto"
run_test "spec/glsl-1.10/execution/samplers/glsl-fs-shadow1D-06" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/samplers/glsl-fs-shadow1D-06.shader_test -auto"
run_test "spec/glsl-1.10/execution/samplers/glsl-fs-shadow1D-09" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/samplers/glsl-fs-shadow1D-09.shader_test -auto"
run_test "spec/glsl-1.10/execution/samplers/glsl-fs-shadow1D-bias" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/samplers/glsl-fs-shadow1D-bias.shader_test -auto"
run_test "spec/glsl-1.10/execution/samplers/glsl-fs-shadow1DProj" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/samplers/glsl-fs-shadow1DProj.shader_test -auto"
run_test "spec/glsl-1.10/execution/samplers/glsl-fs-shadow1DProj-bias" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/samplers/glsl-fs-shadow1DProj-bias.shader_test -auto"
run_test "spec/glsl-1.10/execution/samplers/glsl-fs-shadow2D" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/samplers/glsl-fs-shadow2D.shader_test -auto"
run_test "spec/glsl-1.10/execution/samplers/glsl-fs-shadow2D-02" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/samplers/glsl-fs-shadow2D-02.shader_test -auto"
run_test "spec/glsl-1.10/execution/samplers/glsl-fs-shadow2D-04" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/samplers/glsl-fs-shadow2D-04.shader_test -auto"
run_test "spec/glsl-1.10/execution/samplers/glsl-fs-shadow2D-05" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/samplers/glsl-fs-shadow2D-05.shader_test -auto"
run_test "spec/glsl-1.10/execution/samplers/glsl-fs-shadow2D-06" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/samplers/glsl-fs-shadow2D-06.shader_test -auto"
run_test "spec/glsl-1.10/execution/samplers/glsl-fs-shadow2D-09" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/samplers/glsl-fs-shadow2D-09.shader_test -auto"
run_test "spec/glsl-1.10/execution/samplers/glsl-fs-shadow2D-bias" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/samplers/glsl-fs-shadow2D-bias.shader_test -auto"
run_test "spec/glsl-1.10/execution/samplers/glsl-fs-shadow2DProj" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/samplers/glsl-fs-shadow2DProj.shader_test -auto"
run_test "spec/glsl-1.10/execution/samplers/glsl-fs-shadow2DProj-bias" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/samplers/glsl-fs-shadow2DProj-bias.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-temp-array-mat2-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-temp-array-mat2-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-temp-array-mat2-row-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-temp-array-mat2-row-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-temp-array-mat3-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-temp-array-mat3-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-temp-array-mat3-row-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-temp-array-mat3-row-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-temp-array-mat4-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-temp-array-mat4-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-temp-array-mat4-row-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-temp-array-mat4-row-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-temp-mat2-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-temp-mat2-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-temp-mat2-row-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-temp-mat2-row-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-temp-mat3-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-temp-mat3-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-temp-mat3-row-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-temp-mat3-row-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-temp-mat4-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-temp-mat4-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-temp-mat4-row-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-temp-mat4-row-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-uniform-array-mat2-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-uniform-array-mat2-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-uniform-array-mat2-row-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-uniform-array-mat2-row-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-uniform-array-mat3-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-uniform-array-mat3-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-uniform-array-mat3-row-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-uniform-array-mat3-row-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-uniform-array-mat4-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-uniform-array-mat4-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-uniform-array-mat4-row-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-uniform-array-mat4-row-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-uniform-mat2-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-uniform-mat2-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-uniform-mat2-row-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-uniform-mat2-row-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-uniform-mat3-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-uniform-mat3-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-uniform-mat3-row-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-uniform-mat3-row-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-uniform-mat4-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-uniform-mat4-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-uniform-mat4-row-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-uniform-mat4-row-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-varying-array-mat2-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-varying-array-mat2-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-varying-array-mat2-row-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-varying-array-mat2-row-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-varying-array-mat3-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-varying-array-mat3-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-varying-array-mat3-row-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-varying-array-mat3-row-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-varying-mat2-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-varying-mat2-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-varying-mat2-row-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-varying-mat2-row-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-varying-mat3-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-varying-mat3-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-varying-mat3-row-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-varying-mat3-row-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-varying-mat4-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-varying-mat4-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/fs-varying-mat4-row-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/fs-varying-mat4-row-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat2-col-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat2-col-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat2-col-row-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat2-col-row-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat2-col-row-wr" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat2-col-row-wr.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat2-col-wr" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat2-col-wr.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat2-index-col-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat2-index-col-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat2-index-col-row-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat2-index-col-row-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat2-index-col-row-wr" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat2-index-col-row-wr.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat2-index-col-wr" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat2-index-col-wr.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat2-index-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat2-index-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat2-index-row-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat2-index-row-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat2-index-row-wr" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat2-index-row-wr.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat2-index-wr" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat2-index-wr.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat2-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat2-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat2-row-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat2-row-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat2-row-wr" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat2-row-wr.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat2-wr" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat2-wr.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat3-col-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat3-col-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat3-col-row-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat3-col-row-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat3-col-row-wr" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat3-col-row-wr.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat3-col-wr" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat3-col-wr.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat3-index-col-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat3-index-col-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat3-index-col-row-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat3-index-col-row-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat3-index-col-row-wr" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat3-index-col-row-wr.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat3-index-col-wr" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat3-index-col-wr.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat3-index-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat3-index-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat3-index-row-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat3-index-row-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat3-index-row-wr" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat3-index-row-wr.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat3-index-wr" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat3-index-wr.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat3-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat3-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat3-row-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat3-row-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat3-row-wr" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat3-row-wr.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat3-wr" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat3-wr.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat4-col-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat4-col-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat4-col-row-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat4-col-row-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat4-col-row-wr" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat4-col-row-wr.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat4-col-wr" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat4-col-wr.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat4-index-col-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat4-index-col-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat4-index-col-row-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat4-index-col-row-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat4-index-col-row-wr" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat4-index-col-row-wr.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat4-index-col-wr" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat4-index-col-wr.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat4-index-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat4-index-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat4-index-row-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat4-index-row-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat4-index-row-wr" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat4-index-row-wr.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat4-index-wr" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat4-index-wr.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat4-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat4-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat4-row-rd" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat4-row-rd.shader_test -auto"
run_test "spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat4-row-wr" 0.0 "bin/shader_runner tests/spec/glsl-1.10/execution/variable-indexing/vs-temp-array-mat4-row-wr.shader_test -auto"
popd

if [ $need_pass == 0 ] ; then
  echo "+---------------------------------------------+"
  echo "| Overall pass, as all 188 tests have passed. |"
  echo "+---------------------------------------------+"
else
  echo "+-----------------------------------------------------------+"
  echo "| Overall failure, as $need_pass tests did not pass and $failures failed. |"
  echo "+-----------------------------------------------------------+"
fi
exit $need_pass

