#!/bin/bash
script=`readlink -e $0`
root_dir=`dirname $script`
export PATH=../../src:../../../src:/opt/panda/bin:$PATH

mkdir -p constrained_synth_altera_5
cd constrained_synth_altera_5
echo "# Quartus II synthesis and ICARUS simulation"
bambu -v4 $root_dir/module.c --generate-tb=$root_dir/test.xml --simulator=ICARUS --device-name=EP2C70F896C6-R --evaluation --experimental-setup=BAMBU --generate-interface=WB4 --clock-period=5 $root_dir/constraints_STD.xml --cprf=0.9 --skip-pipe-parameter=1
return_value=$?
if test $return_value != 0; then
   exit $return_value
fi
cd ..
