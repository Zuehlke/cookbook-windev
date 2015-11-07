name             'windev'
maintainer       'Vassilis Rizopoulos'
maintainer_email 'var@zuehlke.com'
license          'MIT'
description      'Configures Windows'
long_description 'Configures a Windows installation. Parameters include the list of Windows features to remove and data on the installer packages to be added'
version          '0.4.0'

supports 'windows'

depends 'windows',"~>1.38.2"
depends 'chocolatey',"~>0.4.0"
