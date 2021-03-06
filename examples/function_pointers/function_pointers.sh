#!/bin/bash
#   --args="-v4 --configuration-name=default-ALLBRAM-treevectorize --evaluation --compiler=I386_GCC49 --memory-allocation-policy=ALL_BRAM -ftree-vectorize" \
`dirname $0`/../../etc/scripts/test_panda.py -l list --tool=bambu \
   --args="-v4 --configuration-name=default --evaluation --compiler=I386_GCC49 --soft-float" \
   --args="-v4 --configuration-name=default-ALLBRAM --evaluation --compiler=I386_GCC49 --memory-allocation-policy=ALL_BRAM --soft-float" \
   --args="-v4 --configuration-name=default-ALLBRAM-notreevectorize --evaluation --compiler=I386_GCC49 --memory-allocation-policy=ALL_BRAM -fno-tree-vectorize --soft-float" \
   -o output -b`dirname $0` --table=output.tex --stop --name="FunctionPointer" $@
return_value=$?
if test $return_value != 0; then
   exit $return_value
fi

