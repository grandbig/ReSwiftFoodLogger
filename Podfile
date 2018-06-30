# Podfile
use_frameworks!
platform :ios, '11.0'

target "ReSwiftSample" do
  # Normal libraries
  pod 'RealmSwift'
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'Moya'
  pod 'AlamofireImage', '~> 3.3'
  pod 'ReSwift'
  pod 'PromiseKit'
  pod 'R.swift'

  abstract_target 'Tests' do
    target "ReSwiftSampleTests"
    target "ReSwiftSampleUITests"
  end
end
