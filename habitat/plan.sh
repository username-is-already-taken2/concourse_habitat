pkg_name=concourse
pkg_origin=digitalgaz
pkg_version="5.4.1"
pkg_maintainer="Gary Bright <digitalgaz@hotmail.com>"
pkg_license=('Apache-2.0')
pkg_description="CI that scales with your project"
pkg_upstream_url="https://concourse.ci"
pkg_source="https://github.com/${pkg_name}/${pkg_name}/releases/download/v${pkg_version}/${pkg_name}-${pkg_version}-linux-amd64.tgz"
pkg_filename="${pkg_name}-linux-amd64.tgz"
pkg_shasum="74711d5825ac831fbbe6c3e7dbce81d661da1c565bed382da75acfaae8c92ff7"

pkg_deps=(
  core/glibc
)
pkg_build_deps=(
  core/patchelf
)
pkg_bin_dirs=(bin)

do_unpack() {
  pushd "${HAB_CACHE_SRC_PATH}"
    tar -zxf ${pkg_filename}
  popd
}

do_build(){
  return 0
}

do_install(){
  # The package now includes more then a binary (resources etc)
  cp -r ${HAB_CACHE_SRC_PATH}/concourse/* ${pkg_prefix}/
  # ldd ./bin/concourse shows that it references libraries outside of habitat so patching the binaries
  # >> https://forums.habitat.sh/t/when-to-patchelf/1099
  patchelf --interpreter "$(pkg_path_for glibc)/lib64/ld-linux-x86-64.so.2" "${pkg_prefix}/bin/concourse"
#  patchelf --set-rpath "$(pkg_path_for glibc)/lib64":/lib64 "${pkg_prefix}/bin/concourse"
  # Garden is now its own binary in v5+ so patching that as well
  patchelf --interpreter "$(pkg_path_for glibc)/lib64/ld-linux-x86-64.so.2" "${pkg_prefix}/bin/gdn"
#  patchelf --set-rpath "$(pkg_path_for glibc)/lib64":/lib64 "${pkg_prefix}/bin/gdn"
}
