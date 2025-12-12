set -ex

export EUPSPKG_NJOBS=2

# needed by scarlet apparently
ln -s ${PREFIX}/include/eigen3/Eigen ${PREFIX}/include/Eigen

stackvana-build ${eups_product}
