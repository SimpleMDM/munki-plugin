set -eu

version="$(grep '# Version' SimpleMDMRepo.py|awk -F'Version ' '{print $2}')"

echo "::set-output name=version::${version}"

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
build_dir="$project_root/build"
src_dir="$project_root/src"
files_dir="$src_dir/files"
pkg_path="${build_dir}/simplemdm-munki-plugin-${version}.pkg"

rm -rf "$src_dir"

mkdir -p "$files_dir/usr/local/munki/munkilib/munkirepo"
cp "$project_root/SimpleMDMRepo.py" "$files_dir/usr/local/munki/munkilib/munkirepo/SimpleMDMRepo.py"

mkdir -p "$files_dir/usr/local/simplemdm/munki-plugin"
cp "$project_root/config.plist.example" "$files_dir/usr/local/simplemdm/munki-plugin/config.plist.example"
chmod 666 "$files_dir/usr/local/simplemdm/munki-plugin/config.plist.example"

rm -rf "$build_dir"
mkdir "$build_dir"

mkdir "$src_dir/scripts"
echo "cp -n /usr/local/simplemdm/munki-plugin/config.plist.example /usr/local/simplemdm/munki-plugin/config.plist" > "$src_dir/scripts/postinstall"

pkgbuild --root "$files_dir" \
         --identifier com.simplemdm.munki_plugin \
         --version $version "$pkg_path" \
         --scripts "$src_dir/scripts"

rm -rf "$src_dir"