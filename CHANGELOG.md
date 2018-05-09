# 0.8.4
  * Update windows cookbook version
  * Ensure setting environment default does not break on Chef13 (kimo)
# 0.8.3
  * Allow 3010 as a valid return code for a chocolatey package and add exit_codes to config for custom entries
# 0.8.2
  * Add handling of params (concatenates params with --parameters onto the options)

# 0.8.1
  * Upgrade foodcritic and handle the deprecations.
  * Reintroduce the chocolatey dependency as we need it to install chocolatey.
  
# 0.8.0
  * Chocolatey support now uses the Chef resource.
  * Chef dependency now >=12.7
  * Removed dependency to chocolatey cookbook

# 0.7.0
 * Allow custom acceptable return codes in package installer config (MarkusPalcer)
 * Updated all cookbook and gem dependencies.
 * It's now Chef >12.6
 * Fixed default attribut values (tknerr)
 * Allow setting of options for chockolatey (tknerr)

# 0.6.0
 * Add the auto_chef/remove_auto_chef recipes

# 0.5.1
 * Add return code 3010 (requires reboot) back to the list of acceptable return codes for package installers
 * Update windows cookbook dependency to 2.1.1

# 0.5.0
 * unpack option for installers packaged in zip files
 * updated all development and cookbook dependencies

# 0.4.0
 * Chocolatey integration

# 0.3.3
 * Fixed a bug in the caching of installers

# 0.3.2
 * Conformed to foodcritic warnings
 * Removed some obsolete cruft

# 0.3.1
 * Depot directory creation is now recursive
 * Fixed the license metadata

# 0.3.0
 * Removed the SSL recipe
 * Added the environment recipe
 * Bugfixes in the handling of empty node attributes for cache,packages and drivers

#  0.2.0
 * Caching and driver installation implemented as LWRPs
 * Package installation uses caching and packages are downloaded only when not installed and not already cached

#  0.1.0
Initial release of windev
