#!/bin/bash


need_pass=236
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
run_test "spec/ARB_draw_instanced/draw-instanced" 0.0 "bin/draw-instanced -auto"
run_test "spec/ARB_draw_instanced/draw-instanced-divisor" 0.0 "bin/draw-instanced-divisor -auto"
run_test "spec/ARB_draw_instanced/draw-non-instanced" 0.0 "bin/shader_runner tests/spec/arb_draw_instanced/execution/draw-non-instanced.shader_test -auto"
run_test "spec/ARB_draw_instanced/elements" 0.0 "bin/arb_draw_instanced-elements -auto -fbo"
run_test "spec/ARB_draw_instanced/instance-array-dereference" 0.0 "bin/shader_runner tests/spec/arb_draw_instanced/execution/instance-array-dereference.shader_test -auto"
run_test "spec/ARB_draw_instanced/negative-arrays-first-negative" 0.0 "bin/arb_draw_instanced-negative-arrays-first-negative -auto -fbo"
run_test "spec/ARB_draw_instanced/negative-elements-type" 0.0 "bin/arb_draw_instanced-negative-elements-type -auto -fbo"
run_test "spec/ARB_draw_instanced/preprocessor/feature-macro-enabled.frag" 0.0 "bin/glslparsertest tests/spec/arb_draw_instanced/preprocessor/feature-macro-enabled.frag pass 1.10 GL_ARB_draw_instanced"
run_test "spec/ARB_draw_instanced/preprocessor/feature-macro-enabled.vert" 0.0 "bin/glslparsertest tests/spec/arb_draw_instanced/preprocessor/feature-macro-enabled.vert pass 1.10 GL_ARB_draw_instanced"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/attribute-01.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/attribute-01.vert fail 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/in-01.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/in-01.frag pass 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/in-01.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/in-01.vert pass 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/in-02.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/in-02.frag fail 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/in-02.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/in-02.vert fail 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/in-03.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/in-03.frag fail 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/in-04.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/in-04.frag fail 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/layout-01.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/layout-01.frag pass 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/layout-01.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/layout-01.vert pass 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/layout-02.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/layout-02.frag fail 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/layout-02.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/layout-02.vert fail 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/layout-03.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/layout-03.frag pass 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/layout-03.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/layout-03.vert pass 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/layout-04.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/layout-04.frag fail 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/layout-04.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/layout-04.vert fail 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/layout-05.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/layout-05.frag fail 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/layout-05.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/layout-05.vert fail 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/layout-06.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/layout-06.frag pass 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/layout-06.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/layout-06.vert pass 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/layout-07.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/layout-07.frag pass 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/layout-07.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/layout-07.vert pass 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/layout-08.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/layout-08.frag pass 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/layout-08.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/layout-08.vert pass 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/layout-09.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/layout-09.frag pass 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/layout-09.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/layout-09.vert pass 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/layout-10.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/layout-10.frag pass 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/layout-10.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/layout-10.vert pass 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/layout-11.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/layout-11.frag fail 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/layout-11.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/layout-11.vert fail 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/out-01.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/out-01.frag pass 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/out-01.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/out-01.vert pass 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/out-02.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/out-02.frag fail 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/out-02.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/out-02.vert fail 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/out-03.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/out-03.vert fail 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/out-04.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/out-04.vert fail 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/varying-01.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/varying-01.frag fail 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/compiler/varying-01.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/compiler/varying-01.vert fail 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/preprocessor/define.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/preprocessor/define.frag pass 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.10/preprocessor/define.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.10/preprocessor/define.vert pass 1.10 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/attribute-01.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/attribute-01.vert fail 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/in-01.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/in-01.frag pass 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/in-01.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/in-01.vert pass 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/in-02.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/in-02.frag fail 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/in-02.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/in-02.vert fail 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/in-03.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/in-03.frag pass 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/in-04.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/in-04.frag fail 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/in-05.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/in-05.frag fail 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/layout-01.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/layout-01.frag pass 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/layout-01.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/layout-01.vert pass 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/layout-02.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/layout-02.frag fail 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/layout-02.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/layout-02.vert fail 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/layout-03.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/layout-03.frag pass 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/layout-03.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/layout-03.vert pass 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/layout-04.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/layout-04.frag fail 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/layout-04.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/layout-04.vert fail 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/layout-05.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/layout-05.frag fail 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/layout-05.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/layout-05.vert fail 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/layout-06.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/layout-06.frag pass 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/layout-06.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/layout-06.vert pass 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/layout-07.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/layout-07.frag pass 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/layout-07.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/layout-07.vert pass 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/layout-08.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/layout-08.frag pass 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/layout-08.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/layout-08.vert pass 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/layout-09.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/layout-09.frag pass 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/layout-09.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/layout-09.vert pass 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/layout-10.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/layout-10.frag pass 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/layout-10.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/layout-10.vert pass 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/layout-11.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/layout-11.frag fail 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/layout-11.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/layout-11.vert fail 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/out-01.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/out-01.frag pass 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/out-01.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/out-01.vert pass 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/out-02.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/out-02.frag fail 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/out-02.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/out-02.vert fail 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/out-03.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/out-03.vert pass 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/out-04.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/out-04.vert fail 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/out-05.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/out-05.vert fail 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/varying-01.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/varying-01.frag fail 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/compiler/varying-01.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/compiler/varying-01.vert fail 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/preprocessor/define.frag" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/preprocessor/define.frag pass 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/1.20/preprocessor/define.vert" 0.0 "bin/glslparsertest tests/spec/arb_explicit_attrib_location/1.20/preprocessor/define.vert pass 1.20 GL_ARB_explicit_attrib_location"
run_test "spec/ARB_explicit_attrib_location/glsl-explicit-location-01" 0.0 "bin/glsl-explicit-location-01 -auto"
run_test "spec/ARB_explicit_attrib_location/glsl-explicit-location-02" 0.0 "bin/glsl-explicit-location-02 -auto"
run_test "spec/ARB_explicit_attrib_location/glsl-explicit-location-03" 0.0 "bin/glsl-explicit-location-03 -auto"
run_test "spec/ARB_explicit_attrib_location/glsl-explicit-location-04" 0.0 "bin/glsl-explicit-location-04 -auto"
run_test "spec/ARB_explicit_attrib_location/glsl-explicit-location-05" 0.0 "bin/glsl-explicit-location-05 -auto"
run_test "spec/ARB_fragment_coord_conventions/fp-arb-fragment-coord-conventions-integer" 0.0 "bin/vpfp-generic -auto tests/shaders/generic/fp-arb-fragment-coord-conventions-integer.vpfp"
run_test "spec/ARB_fragment_coord_conventions/fp-arb-fragment-coord-conventions-none" 0.0 "bin/vpfp-generic -auto tests/shaders/generic/fp-arb-fragment-coord-conventions-none.vpfp"
run_test "spec/ARB_fragment_program/dph" 0.0 "bin/shader_runner tests/spec/arb_fragment_program/dph.shader_test -auto"
run_test "spec/ARB_fragment_program/fdo30337a" 0.0 "bin/vpfp-generic -auto tests/shaders/generic/fdo30337a.vpfp"
run_test "spec/ARB_fragment_program/fdo30337b" 0.0 "bin/vpfp-generic -auto tests/shaders/generic/fdo30337b.vpfp"
run_test "spec/ARB_fragment_program/fdo38145" 0.0 "bin/vpfp-generic -auto tests/shaders/generic/fdo38145.vpfp"
run_test "spec/ARB_fragment_program/fp-abs-01" 0.0 "bin/fp-abs-01 -auto"
run_test "spec/ARB_fragment_program/fp-cmp" 0.0 "bin/vpfp-generic -auto tests/shaders/generic/fp-cmp.vpfp"
run_test "spec/ARB_fragment_program/fp-dst-aliasing-1" 0.0 "bin/vpfp-generic -auto tests/shaders/generic/fp-dst-aliasing-1.vpfp"
run_test "spec/ARB_fragment_program/fp-dst-aliasing-2" 0.0 "bin/vpfp-generic -auto tests/shaders/generic/fp-dst-aliasing-2.vpfp"
run_test "spec/ARB_fragment_program/fp-ex2-sat" 0.0 "bin/vpfp-generic -auto tests/shaders/generic/fp-ex2-sat.vpfp"
run_test "spec/ARB_fragment_program/fp-formats" 0.0 "bin/fp-formats -auto"
run_test "spec/ARB_fragment_program/fp-fragment-position" 0.0 "bin/fp-fragment-position -auto"
run_test "spec/ARB_fragment_program/fp-incomplete-tex" 0.0 "bin/fp-incomplete-tex -auto"
run_test "spec/ARB_fragment_program/fp-indirections" 0.0 "bin/fp-indirections -auto"
run_test "spec/ARB_fragment_program/fp-kil" 0.0 "bin/fp-kil -auto"
run_test "spec/ARB_fragment_program/fp-lit-mask" 0.0 "bin/fp-lit-mask -auto"
run_test "spec/ARB_fragment_program/fp-lit-src-equals-dst" 0.0 "bin/fp-lit-src-equals-dst -auto"
run_test "spec/ARB_fragment_program/fp-set-01" 0.0 "bin/fp-set-01 -auto"
run_test "spec/ARB_fragment_program/fp-two-constants" 0.0 "bin/vpfp-generic -auto tests/shaders/generic/fp-two-constants.vpfp"
run_test "spec/ARB_fragment_program/incomplete-texture-arb_fp" 0.0 "bin/incomplete-texture -auto arb_fp -auto -fbo"
run_test "spec/ARB_fragment_program/lrp_sat" 0.0 "bin/shader_runner tests/spec/arb_fragment_program/lrp_sat.shader_test -auto"
run_test "spec/ARB_fragment_program/minmax" 0.0 "bin/arb_fragment_program-minmax -auto -fbo"
run_test "spec/ARB_fragment_program/texturing/tex-2d" 0.0 "bin/shader_runner tests/spec/arb_fragment_program/texturing/tex-2d.shader_test -auto"
run_test "spec/ARB_fragment_program/texturing/txb-2d" 0.0 "bin/shader_runner tests/spec/arb_fragment_program/texturing/txb-2d.shader_test -auto"
run_test "spec/ARB_fragment_program/texturing/txp-2d" 0.0 "bin/shader_runner tests/spec/arb_fragment_program/texturing/txp-2d.shader_test -auto"
run_test "spec/ARB_fragment_program/trinity-fp1" 0.0 "bin/trinity-fp1 -auto"
run_test "spec/ARB_framebuffer_object/fbo-alpha" 0.0 "bin/fbo-alpha -auto"
run_test "spec/ARB_framebuffer_object/fbo-blit-stretch" 0.0 "bin/fbo-blit-stretch -auto"
run_test "spec/ARB_framebuffer_object/fbo-getframebufferattachmentparameter-01" 0.0 "bin/fbo-getframebufferattachmentparameter-01 -auto"
run_test "spec/ARB_framebuffer_object/fbo-gl_pointcoord" 0.0 "bin/fbo-gl_pointcoord -auto"
run_test "spec/ARB_framebuffer_object/fbo-incomplete-texture-01" 0.0 "bin/fbo-incomplete-texture-01 -auto"
run_test "spec/ARB_framebuffer_object/fbo-incomplete-texture-02" 0.0 "bin/fbo-incomplete-texture-02 -auto"
run_test "spec/ARB_framebuffer_object/fbo-incomplete-texture-03" 0.0 "bin/fbo-incomplete-texture-03 -auto"
run_test "spec/ARB_framebuffer_object/fbo-incomplete-texture-04" 0.0 "bin/fbo-incomplete-texture-04 -auto"
run_test "spec/ARB_framebuffer_object/fbo-scissor-blit fbo" 0.0 "bin/fbo-scissor-blit fbo -auto"
run_test "spec/ARB_framebuffer_object/fbo-scissor-blit window" 0.0 "bin/fbo-scissor-blit window -auto"
run_test "spec/ARB_framebuffer_object/fbo-viewport" 0.0 "bin/fbo-viewport -auto"
run_test "spec/ARB_framebuffer_object/fdo28551" 0.0 "bin/fdo28551 -auto"
run_test "spec/ARB_framebuffer_object/framebuffer-blit-levels draw rgba" 0.0 "bin/framebuffer-blit-levels draw rgba -auto"
run_test "spec/ARB_framebuffer_object/same-attachment-glFramebufferRenderbuffer-GL_DEPTH_STENCIL_ATTACHMENT" 0.0 "bin/same-attachment-glFramebufferRenderbuffer-GL_DEPTH_STENCIL_ATTACHMENT -auto -fbo"
run_test "spec/ARB_framebuffer_object/same-attachment-glFramebufferTexture2D-GL_DEPTH_STENCIL_ATTACHMENT" 0.0 "bin/same-attachment-glFramebufferTexture2D-GL_DEPTH_STENCIL_ATTACHMENT -auto -fbo"
run_test "spec/ARB_framebuffer_sRGB/framebuffer-srgb" 0.0 "bin/framebuffer-srgb -auto"
run_test "spec/ARB_half_float_vertex/draw-vertices-half-float" 0.0 "bin/draw-vertices-half-float -auto"
run_test "spec/ARB_half_float_vertex/draw-vertices-half-float-user" 0.0 "bin/draw-vertices-half-float -auto user"
run_test "spec/ARB_instanced_arrays/instanced_arrays" 0.0 "bin/instanced_arrays -auto"
run_test "spec/ARB_instanced_arrays/instanced_arrays-vbo" 0.0 "bin/instanced_arrays vbo -auto"
run_test "spec/ARB_internalformat_query/misc. API error checks" 0.0 "bin/arb_internalformat_query-api-errors -auto -fbo"
run_test "spec/ARB_map_buffer_range/MAP_INVALIDATE_BUFFER_BIT decrement-offset" 0.0 "bin/map_buffer_range-invalidate MAP_INVALIDATE_BUFFER_BIT decrement-offset -auto -fbo"
run_test "spec/ARB_map_buffer_range/MAP_INVALIDATE_BUFFER_BIT increment-offset" 0.0 "bin/map_buffer_range-invalidate MAP_INVALIDATE_BUFFER_BIT increment-offset -auto -fbo"
run_test "spec/ARB_map_buffer_range/MAP_INVALIDATE_BUFFER_BIT offset=0" 0.0 "bin/map_buffer_range-invalidate MAP_INVALIDATE_BUFFER_BIT offset=0 -auto -fbo"
run_test "spec/ARB_map_buffer_range/MAP_INVALIDATE_RANGE_BIT decrement-offset" 0.0 "bin/map_buffer_range-invalidate MAP_INVALIDATE_RANGE_BIT decrement-offset -auto -fbo"
run_test "spec/ARB_map_buffer_range/MAP_INVALIDATE_RANGE_BIT increment-offset" 0.0 "bin/map_buffer_range-invalidate MAP_INVALIDATE_RANGE_BIT increment-offset -auto -fbo"
run_test "spec/ARB_map_buffer_range/MAP_INVALIDATE_RANGE_BIT offset=0" 0.0 "bin/map_buffer_range-invalidate MAP_INVALIDATE_RANGE_BIT offset=0 -auto -fbo"
run_test "spec/ARB_map_buffer_range/map_buffer_range_error_check" 0.0 "bin/map_buffer_range_error_check -auto"
run_test "spec/ARB_map_buffer_range/map_buffer_range_test" 0.0 "bin/map_buffer_range_test -auto"
run_test "spec/ARB_multisample/beginend" 0.0 "bin/arb_multisample-beginend -auto -fbo"
run_test "spec/ARB_multisample/pushpop" 0.0 "bin/arb_multisample-pushpop -auto -fbo"
run_test "spec/ARB_occlusion_query/occlusion_query_lifetime" 0.0 "bin/occlusion_query_lifetime -auto -fbo"
run_test "spec/ARB_occlusion_query/occlusion_query_order" 0.0 "bin/occlusion_query_order -auto -fbo"
run_test "spec/ARB_occlusion_query2/api" 0.0 "bin/arb_occlusion_query2-api -auto -fbo"
run_test "spec/ARB_pixel_buffer_object/fbo-pbo-readpixels-small" 0.0 "bin/fbo-pbo-readpixels-small -auto"
run_test "spec/ARB_pixel_buffer_object/pbo-drawpixels" 0.0 "bin/pbo-drawpixels -auto"
run_test "spec/ARB_pixel_buffer_object/pbo-read-argb8888" 0.0 "bin/pbo-read-argb8888 -auto"
run_test "spec/ARB_pixel_buffer_object/pbo-readpixels-small" 0.0 "bin/pbo-readpixels-small -auto"
run_test "spec/ARB_pixel_buffer_object/pbo-teximage" 0.0 "bin/pbo-teximage -auto"
run_test "spec/ARB_pixel_buffer_object/pbo-teximage-tiling" 0.0 "bin/pbo-teximage-tiling -auto"
run_test "spec/ARB_pixel_buffer_object/pbo-teximage-tiling-2" 0.0 "bin/pbo-teximage-tiling-2 -auto"
run_test "spec/ARB_point_sprite/point-sprite" 0.0 "bin/point-sprite -auto"
run_test "spec/ARB_robustness/arb_robustness_client-mem-bounds" 0.0 "bin/arb_robustness_client-mem-bounds -auto"
run_test "spec/ARB_sampler_objects/sampler-incomplete" 0.0 "bin/arb_sampler_objects-sampler-incomplete -auto -fbo"
run_test "spec/ARB_sampler_objects/sampler-objects" 0.0 "bin/arb_sampler_objects-sampler-objects -auto -fbo"
run_test "spec/ARB_shader_objects/bindattriblocation-scratch-name" 0.0 "bin/arb_shader_objects-bindattriblocation-scratch-name -auto -fbo"
run_test "spec/ARB_shader_objects/clear-with-deleted" 0.0 "bin/arb_shader_objects-clear-with-deleted -auto -fbo"
run_test "spec/ARB_shader_objects/delete-repeat" 0.0 "bin/arb_shader_objects-delete-repeat -auto -fbo"
run_test "spec/ARB_shader_objects/getactiveuniform-beginend" 0.0 "bin/arb_shader_objects-getactiveuniform-beginend -auto -fbo"
run_test "spec/ARB_shader_objects/getuniform" 0.0 "bin/arb_shader_objects-getuniform -auto"
run_test "spec/ARB_shader_objects/getuniformlocation-array-of-struct-of-array" 0.0 "bin/arb_shader_objects-getuniformlocation-array-of-struct-of-array -auto -fbo"
run_test "spec/ARB_shader_stencil_export/amd-undefined.frag" 0.0 "bin/glslparsertest tests/spec/arb_shader_stencil_export/amd-undefined.frag fail 1.20"
run_test "spec/ARB_sync/repeat-wait" 0.0 "bin/arb_sync-repeat-wait -auto -fbo"
run_test "spec/ARB_sync/sync_api" 0.0 "bin/sync_api -auto"
run_test "spec/ARB_sync/timeout-zero" 0.0 "bin/arb_sync-timeout-zero -auto -fbo"
run_test "spec/ARB_texture_compression/GL_TEXTURE_INTERNAL_FORMAT query" 0.0 "bin/arb_texture_compression-internal-format-query -auto"
run_test "spec/ARB_texture_compression/texwrap formats" 0.0 "bin/texwrap -fbo -auto GL_ARB_texture_compression"
run_test "spec/ARB_texture_compression/unknown formats" 0.0 "bin/arb_texture_compression-invalid-formats unknown"
run_test "spec/ARB_texture_compression_bptc/invalid formats" 0.0 "bin/arb_texture_compression-invalid-formats bptc"
run_test "spec/ARB_texture_cube_map/crash-cubemap-order" 0.0 "bin/crash-cubemap-order -auto"
run_test "spec/ARB_texture_cube_map/cubemap" 0.0 "bin/cubemap -auto"
run_test "spec/ARB_texture_cube_map/cubemap-shader" 0.0 "bin/cubemap-shader -auto"
run_test "spec/ARB_texture_cube_map/cubemap-shader bias" 0.0 "bin/cubemap-shader -auto bias"
run_test "spec/ARB_texture_cube_map/getteximage-targets CUBE" 0.0 "bin/getteximage-targets CUBE -auto -fbo"
run_test "spec/ARB_texture_env_crossbar/crossbar" 0.0 "bin/crossbar -auto"
run_test "spec/ARB_texture_rectangle/1-1-linear-texture" 0.0 "bin/1-1-linear-texture -auto -fbo"
run_test "spec/ARB_texture_rectangle/getteximage-targets RECT" 0.0 "bin/getteximage-targets RECT -auto -fbo"
run_test "spec/ARB_texture_rectangle/glsl-fs-shadow2DRect" 0.0 "bin/shader_runner tests/spec/arb_texture_rectangle/glsl-fs-shadow2DRect.shader_test -auto"
run_test "spec/ARB_texture_rectangle/glsl-fs-shadow2DRect-02" 0.0 "bin/shader_runner tests/spec/arb_texture_rectangle/glsl-fs-shadow2DRect-02.shader_test -auto"
run_test "spec/ARB_texture_rectangle/glsl-fs-shadow2DRect-04" 0.0 "bin/shader_runner tests/spec/arb_texture_rectangle/glsl-fs-shadow2DRect-04.shader_test -auto"
run_test "spec/ARB_texture_rectangle/glsl-fs-shadow2DRect-05" 0.0 "bin/shader_runner tests/spec/arb_texture_rectangle/glsl-fs-shadow2DRect-05.shader_test -auto"
run_test "spec/ARB_texture_rectangle/glsl-fs-shadow2DRect-06" 0.0 "bin/shader_runner tests/spec/arb_texture_rectangle/glsl-fs-shadow2DRect-06.shader_test -auto"
run_test "spec/ARB_texture_rectangle/glsl-fs-shadow2DRect-09" 0.0 "bin/shader_runner tests/spec/arb_texture_rectangle/glsl-fs-shadow2DRect-09.shader_test -auto"
run_test "spec/ARB_texture_rectangle/glsl-fs-shadow2DRectProj" 0.0 "bin/shader_runner tests/spec/arb_texture_rectangle/glsl-fs-shadow2DRectProj.shader_test -auto"
run_test "spec/ARB_texture_rectangle/texrect-many" 0.0 "bin/texrect-many -auto"
run_test "spec/ARB_texture_rectangle/texwrap RECT" 0.0 "bin/texwrap -fbo -auto RECT GL_RGBA8"
run_test "spec/ARB_texture_rectangle/texwrap RECT proj" 0.0 "bin/texwrap -fbo -auto RECT GL_RGBA8 proj"
run_test "spec/ARB_vertex_array_object/isvertexarray" 0.0 "bin/arb_vertex_array-isvertexarray -auto -fbo"
run_test "spec/ARB_vertex_array_object/vao-element-array-buffer" 0.0 "bin/vao-element-array-buffer -auto -fbo"
run_test "spec/ARB_vertex_buffer_object/elements-negative-offset" 0.0 "bin/arb_vertex_buffer_object-elements-negative-offset -auto"
run_test "spec/ARB_vertex_buffer_object/fdo14575" 0.0 "bin/fdo14575 -auto"
run_test "spec/ARB_vertex_buffer_object/fdo22540" 0.0 "bin/fdo22540 -auto"
run_test "spec/ARB_vertex_buffer_object/fdo31934" 0.0 "bin/fdo31934 -auto"
run_test "spec/ARB_vertex_buffer_object/mixed-immediate-and-vbo" 0.0 "bin/arb_vertex_buffer_object-mixed-immediate-and-vbo -auto"
run_test "spec/ARB_vertex_buffer_object/pos-array" 0.0 "bin/pos-array -auto"
run_test "spec/ARB_vertex_buffer_object/vbo-bufferdata" 0.0 "bin/vbo-bufferdata -auto"
run_test "spec/ARB_vertex_buffer_object/vbo-map-remap" 0.0 "bin/vbo-map-remap -auto"
run_test "spec/ARB_vertex_buffer_object/vbo-map-unsync" 0.0 "bin/vbo-map-unsync -auto -fbo"
run_test "spec/ARB_vertex_buffer_object/vbo-subdata-sync" 0.0 "bin/vbo-subdata-sync -auto"
run_test "spec/ARB_vertex_buffer_object/vbo-subdata-zero" 0.0 "bin/vbo-subdata-zero -auto"
run_test "spec/ARB_vertex_program/arl" 0.0 "bin/vpfp-generic -auto tests/shaders/generic/arl.vpfp"
run_test "spec/ARB_vertex_program/clip-plane-transformation arb" 0.0 "bin/clip-plane-transformation arb -auto -fbo"
run_test "spec/ARB_vertex_program/dataflow-bug" 0.0 "bin/vpfp-generic -auto tests/shaders/generic/dataflow-bug.vpfp"
run_test "spec/ARB_vertex_program/fdo24066" 0.0 "bin/fdo24066 -auto"
run_test "spec/ARB_vertex_program/getenv4d-with-error" 0.0 "bin/arb_vertex_program-getenv4d-with-error -auto"
run_test "spec/ARB_vertex_program/getlocal4d-with-error" 0.0 "bin/arb_vertex_program-getlocal4d-with-error -auto"
run_test "spec/ARB_vertex_program/minmax" 0.0 "bin/arb_vertex_program-minmax -auto -fbo"
run_test "spec/ARB_vertex_program/vp-address-01" 0.0 "bin/vp-address-01 -auto"
run_test "spec/ARB_vertex_program/vp-arl-constant-array" 0.0 "bin/vpfp-generic -auto tests/shaders/generic/vp-arl-constant-array.vpfp"
run_test "spec/ARB_vertex_program/vp-arl-constant-array-huge" 0.0 "bin/vpfp-generic -auto tests/shaders/generic/vp-arl-constant-array-huge.vpfp"
run_test "spec/ARB_vertex_program/vp-arl-constant-array-huge-offset" 0.0 "bin/vpfp-generic -auto tests/shaders/generic/vp-arl-constant-array-huge-offset.vpfp"
run_test "spec/ARB_vertex_program/vp-arl-constant-array-huge-offset-neg" 0.0 "bin/vpfp-generic -auto tests/shaders/generic/vp-arl-constant-array-huge-offset-neg.vpfp"
run_test "spec/ARB_vertex_program/vp-arl-constant-array-huge-overwritten" 0.0 "bin/vpfp-generic -auto tests/shaders/generic/vp-arl-constant-array-huge-overwritten.vpfp"
run_test "spec/ARB_vertex_program/vp-arl-constant-array-huge-relative-offset" 0.0 "bin/vpfp-generic -auto tests/shaders/generic/vp-arl-constant-array-huge-relative-offset.vpfp"
run_test "spec/ARB_vertex_program/vp-arl-constant-array-huge-varying" 0.0 "bin/vpfp-generic -auto tests/shaders/generic/vp-arl-constant-array-huge-varying.vpfp"
run_test "spec/ARB_vertex_program/vp-arl-constant-array-varying" 0.0 "bin/vpfp-generic -auto tests/shaders/generic/vp-arl-constant-array-varying.vpfp"
run_test "spec/ARB_vertex_program/vp-arl-env-array" 0.0 "bin/vpfp-generic -auto tests/shaders/generic/vp-arl-env-array.vpfp"
run_test "spec/ARB_vertex_program/vp-arl-local-array" 0.0 "bin/vpfp-generic -auto tests/shaders/generic/vp-arl-local-array.vpfp"
run_test "spec/ARB_vertex_program/vp-arl-neg-array" 0.0 "bin/vpfp-generic -auto tests/shaders/generic/vp-arl-neg-array.vpfp"
run_test "spec/ARB_vertex_program/vp-arl-neg-array-2" 0.0 "bin/vpfp-generic -auto tests/shaders/generic/vp-arl-neg-array-2.vpfp"
run_test "spec/ARB_vertex_program/vp-bad-program" 0.0 "bin/vp-bad-program -auto"
run_test "spec/ARB_vertex_program/vp-constant-array" 0.0 "bin/vpfp-generic -auto tests/shaders/generic/vp-constant-array.vpfp"
run_test "spec/ARB_vertex_program/vp-constant-array-huge" 0.0 "bin/vpfp-generic -auto tests/shaders/generic/vp-constant-array-huge.vpfp"
run_test "spec/ARB_vertex_program/vp-constant-negate" 0.0 "bin/vpfp-generic -auto tests/shaders/generic/vp-constant-negate.vpfp"
run_test "spec/ARB_vertex_program/vp-exp-alias" 0.0 "bin/vpfp-generic -auto tests/shaders/generic/vp-exp-alias.vpfp"
popd

if [ $need_pass == 0 ] ; then
  echo "+---------------------------------------------+"
  echo "| Overall pass, as all 236 tests have passed. |"
  echo "+---------------------------------------------+"
else
  echo "+-----------------------------------------------------------+"
  echo "| Overall failure, as $need_pass tests did not pass and $failures failed. |"
  echo "+-----------------------------------------------------------+"
fi
exit $need_pass

