set -eu

version="$(grep '# Version' SimpleMDMRepo.py|awk -F'Version ' '{print $2}')"

echo "::set-output name=version::${version}"

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
build_dir="$project_root/build"
src_dir="$project_root/src"
pkg_path="${build_dir}/simplemdm-munki-plugin-${version}.pkg"

rm -rf "$src_dir"
mkdir "$src_dir"

mkdir -p "$src_dir/usr/local/munki/munkilib/munkirepo"
cp "$project_root/SimpleMDMRepo.py" "$src_dir/usr/local/munki/munkilib/munkirepo/SimpleMDMRepo.py"
mkdir -p "$src_dir/usr/local/simplemdm/munki-plugin"
cp -n "$project_root/config.plist" "$src_dir/usr/local/simplemdm/munki-plugin/config.plist"

rm -rf "$build_dir"
mkdir "$build_dir"

pkgbuild --root "$src_dir" --identifier com.simplemdm.munki_plugin --version $version "$pkg_path"

rm -rf "$src_dir"