=begin
extconf.rb for Ruby/VTE extention library
=end

require 'pathname'

base_dir = Pathname(__FILE__).dirname.expand_path
top_dir = base_dir.parent.expand_path
mkmf_gnome2_dir = top_dir + "glib" + 'lib'
top_build_dir = Pathname(".").parent.expand_path

$LOAD_PATH.unshift(mkmf_gnome2_dir.to_s)

module_name = "vte"
package_id = "vte"

require 'mkmf-gnome2'

setup_win32(module_name, base_dir)

PKGConfig.have_package(package_id, 0, 12, 1) or exit(false)

[["glib", "glib2"],
 ["gtk", "gtk2"],
 ["atk", "atk"]].each do |directory, library_name|
  build_dir = "#{directory}/tmp/#{RUBY_PLATFORM}/#{library_name}/#{RUBY_VERSION}"
  add_depend_package(library_name, "#{directory}/ext/#{library_name}",
                     top_dir.to_s,
                     :top_build_dir => top_build_dir.to_s,
                     :target_build_dir => build_dir)
end

vte_headers = ["vte/vte.h"]
have_type("VteTerminalCursorBlinkMode", vte_headers)

unless have_macro("VTE_CHECK_VERSION", vte_headers)
  make_version_header("VTE", package_id)
end

create_pkg_config_file("Ruby/VTE", package_id)
create_makefile_at_srcdir(module_name, (base_dir + "src").to_s,
                          "-DRUBY_VTE_COMPILATION")
create_top_makefile
