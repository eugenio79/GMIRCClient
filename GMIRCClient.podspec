#
# Be sure to run `pod lib lint GMIRCClient.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "GMIRCClient"
  s.version          = "0.1.0"
  s.summary          = "GMIRCClient is a lightweight iOS IRC client, entirely written in Swift."

  s.homepage         = "https://github.com/eugenio79/GMIRCClient"
  s.license          = 'MIT'
  s.author           = { "Giuseppe Morana aka Eugenio" => "giuseppe.morana.79@gmail.com" }
  s.source           = { :git => "https://github.com/eugenio79/GMIRCClient.git" }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'GMIRCClient' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
end
