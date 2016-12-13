name             'windev'
maintainer       'Vassilis Rizopoulos'
maintainer_email 'var@zuehlke.com'
license          'MIT'
description      'Configures Windows'
long_description 'Configures a Windows installation. Parameters include the list of Windows features to remove and data on the installer packages to be added'
version          '0.5.1'
issues_url 'https://github.com/Zuehlke/cookbook-windev/issues' if respond_to?(:issues_url)
source_url 'https://github.com/Zuehlke/cookbook-windev' if respond_to?(:source_url)

supports 'windows'

depends 'windows',"~>2.1.1"
depends 'chocolatey',"~>1.0.3"
