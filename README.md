# All-in-one Windows development environments

[![Build Status](https://travis-ci.org/Zuehlke/cookbook-windev.svg)](http://travis-ci.org/Zuehlke/cookbook-windev)

One cookbook with recipes and resources for setting up a Windows development environment.

## Why not use [chocolatey](https://github.com/chocolatey/chocolatey-cookbook)?

Please do. windev offers a convenience wrapper for chocolatey just like it does for plain installers and zip archives. Check the doc for choco_packages. - it only depends on the availability of the packages you need.

## [auto_chef](recipes/auto_chef.rb)

auto_chef works around the need to reboot Windows multiple times during a Chef run.

It creates a temporary admin user and registers an auto logon script so that in case of a reboot the run can continue.

The auto logon script is controlled via the environment variables CHEF_SCRIPT and CHEF_CONFIG.

CHEF_SCRIPT is the script and CHEF_CONFIG is passed as a parameter to it.

The remove_auto_chef recipe undoes all changes effected by auto_chef.

The idea is you use auto_chef in the beginning, add any recipes that require or cause reboots and as long as you don't get yourself in an endless reboot loop you clean up at the end with remove_auto_chef.

*NOTE for users of vagrant*: if you are running your scripts from c:\vagrant then auto_chef will inexplicably do nothing.

This happens because Windows runs the startup scripts before mounting the network shares, so the startup fails to find the script.

## [depot.rb](recipes/depot.rb)

This recipe just sets up the local software cache. It is used by all recipes that install software.

The location of the local software is specified in the 'software_depot' attribute.

The default value for 'software_depot' is 'software', which will create the directory at the point of chef's execution.

Example:

```ruby
{"software_depot": "software"}
```

You can define a node attribute 'cache' to specify packages to download and cache locally in software_depot.
'cache' is an array of hashes:

```ruby
{
  "software_depot": "software",
  "cache":[{"source":"http://bin.repo/foo.zip","save_as":"foo.zip"}]
}
```

*This is a helper feature for downloading packages that are later manually installed (as is the case with unsigned drivers). Generally it is not needed if the installers are well behaved (but many are not).*

## [features.rb](recipes/features.rb)

The features recipe:

 * Creates a GodMode folder<sup>1</sup>
 * Deactivates the action center
 * Deactivates the Windows firewall

and uninstalls a list of Windows features provided in `node['windows_features']['remove']`

Example:

```ruby
{"windows_features": {
    "remove": ["MediaPlayback","WindowsMediaPlayer","MediaCenter","TabletPCOC","FaxServicesClientPackage",
        "Xps-Foundation-Xps-Viewer","Printing-XPSServices-Features","Internet-Explorer-Optional-amd64"]}
}
```

## [drivers.rb](recipes/drivers.rb)

Installs Windows drivers using dpinst.

The way it works is that it expects a zip file with the driver files (the .inf and .cat file etc.) that also contains the dpinst utility. The LWRP is relatively smart and will match several versions of the dpinst filename (dpinst_amd64, dpinst_x64 etc.). It will also create an automation configuration (dpinst.xml) if one is not provided.

Optionally you can provide a certificate (add it to the files/default in the cookbook) to be added to the trusted publishers in the windows certificate store.

The certificate should either be a part of the driver package or provided in the cookbook's files.

```ruby
"drivers":[
    {"name":"Driver","source":"http://bin.repo/driver.zip","save_as":"driver.zip","certificate":"cert.cer","version":"0.01"},
#If no save_as is defined then expect the file relative to software_depot
    {"name":"Driver","source":"driver.zip","certificate":"cert.cer","version":"0.01"}
  ]
```

*This recipe is for the moment specific to 64bit Windows installations. For drivers whose publisher is untrusted you will need to include the publisher's certificate in the cookbook. It will not work at all with unsigned drivers*

## [packages.rb](recipes/packages.rb)

This recipe provides three ways for software installation: installer-driven, from a zip file or through [chocolatey](https://chocolatey.org/).

Each method is also usable separately (installer_packages, zip_packages and choco_packages respectively).

### Installer driven

The `installer_packages` attribute expects an array of installer definitions.

Each installer definition is a hash with parameters:

  * name - Must match the name appearing in "Uninstall Programs" in the Control Panel.
  * source & save_as - The URL from where the installer can be downloaded and the filename for the downloaded content (relative to `sofware_depot`)
  * unpack - Sometimes installers are packaged in zip files (even with HTTP compression people still do that!). 'unpack' defines a relative path to put the zip contents in so that we can get to the installer
  * installer - if no cache is used (source & save_as are ommited) installer should be the name to the installer executable. Relative paths are relative to `software_depot`
  * version - The software version
  * options - command line options to pass to the installer
  * type - when "custom" then Chef will not try to guess the type and use the path options only.
  * timeout - Time in seconds to wait for the installer to finish. Default is 600
  * exit_codes - An optional list of additional exit codes allowed. If given an exit code within the list it will be interpreted as successful installation. Default is an empty list.

The installers need to be capable of operating unattended (silent or quiet mode).

```json
{
  "installer_packages": [
#This entry will download the installer and cache it locally
    {"name":"Microsoft .NET Framework 4.5",
      "source":"ftp://bin.repo/dotnetfx45_full_x86_x64.exe","save_as":"dotnetfx45_full_x86_x64.exe",
      "version":"4.5.50709","options":"/passive /norestart","type":"custom"
    },
#This entry expects the installer at software/VisualStudio2013/vs_professional.exe and will fail if it is not present
    {"name":"Microsoft Visual Studio Professional 2013 with Update 4",
      "installer":"VisualStudio2013\\vs_professional.exe",
      "version":"12.0.31101","type":"custom","timeout":60000,"options":"/Passive /LOG C:\\VS_2013_U3.log /NoRestart /NoWeb /NoRefresh /CustomInstallPath C:\\tools\\VisualStudio2013\\"
    },
#This entry downloads an installer wrapped in a .zip file, unpacks and then executes
    {"name":"Slik Subversion 1.9.4 (x64)",
      "source":"https://sliksvn.com/pub/Slik-Subversion-1.9.4-x64.zip","save_as":"Slik-Subversion-1.9.4-x64.zip",
      "unpack":"Slik-Subversion-1.9.4-x64/","installer":"Slik-Subversion-1.9.4-x64/Slik-Subversion-1.9.4-x64.msi",
      "version":"1.9.4139"
    }
  ]
}
```

### Zip files

The `zip_packages` attribute expects an array of zip definitions.

Each zip definition is a hash with parameters:

  * archive - defines the filename for the package if no cache is used (source & save_as are ommited). Relative to `sofware_depot`
  * source & save_as - The URL from where the package can be downloaded and the filename for the downloaded content (relative to `sofware_depot`)
  * unpack - location to unpack the archive
  * version - the version of the software

Example:

```json
{
  "zip_packages": [
####This entry downloads the file and caches it in software_depot before unpacking
    {"source":"ftp://bin.repo/foo.zip","save_as":"foo.zip",
      "version":"0.0","unpack":"c:/tools/foo"
    },
####This entry expects the package in the software_depot directory
    {"archive":"foo.zip",
      "version":"0.0","unpack":"c:/tools/foo"
    }
  ]
}
```

### Chocolatey

The `choco_packages` attribute expects an array of chocolatey package definitions.

Each package definition is a hash with parameters:

  * name - name of the package
  * source - the source from which to install the package (choco `--source` flag)
  * version - version of the package to use
  * options - commandline options to be passed to chocolatey directly
  * params - options to be passed to the package installer (the --package option).
  * exit_codes - An optional list of additional exit codes allowed. If given an exit code within the list it will be interpreted as successful installation. Default is an empty list.
  
All parameters but `name` are optional.

Example: 
```json
{
  "name":"Ruby",
  "version":"2.4.3.1",
  "params":"/InstallDir=c:\\tools\\ruby"
}
```

## [environment.rb](recipes/environment.rb)

Provides an easy way to define environment variables in JSON configurations.

Provide an _environment_ attribute that points to a hash of 'name'->'value' for the environment variables you want to define.

Example:

```json
"environment":{
  "PATH":"C:\\Windows\\system32;C:\\Windows;C:\\Windows\\System32\\Wbem;C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\",
  "GIT_SSL_NO_VERIFY":"true",
  "devmgr_show_nonpresent_devices":"1"
    }
```

# Resource providers

The cookbook offers two LWRPs:

cache_package will download a package from a URL to a local directory. It is used heavily in the [packages](recipes/packages.rb) recipe

install_driver performs Windows driver installations. As an example look in the [drivers](recipes/drivers.rb) recipe

----
<sup>1</sup>GodMode is a special Windows folder providing access to all configuration options
