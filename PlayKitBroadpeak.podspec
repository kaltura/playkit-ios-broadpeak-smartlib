suffix = '.0000'   # Dev mode
# suffix = ''       # Release

Pod::Spec.new do |s|
  s.name             = 'PlayKitBroadpeak'
  s.version          = '1.3.1' + suffix
  s.summary          = 'Kaltura PlayKit plugin for the Broadpeak Delivery Platform.'
  
  s.description      = <<-DESC
  Kaltura PlayKit plugin for the Broadpeak Delivery Platform.
  https://delivery-platform.broadpeak.tv/docs/
  DESC
  
  s.homepage         = 'https://github.com/kaltura/playkit-ios-broadpeak-smartlib'
  s.license          = { :type => 'AGPLv3', :file => 'LICENSE' }
  s.author           = { 'Kaltura' => 'community@kaltura.com' }
  s.source           = { :git => 'https://github.com/kaltura/playkit-ios-broadpeak-smartlib.git', :tag => 'v' + s.version.to_s }
  
  s.swift_version     = '5.0'
  
  s.ios.deployment_target = '10.0'
  s.tvos.deployment_target = '10.0'
  
  s.source_files = 'PlayKitBroadpeak/Classes/**/*'
  
  s.dependency 'PlayKit/AnalyticsCommon', '~> 3.23'
  s.dependency 'KalturaPlayer/Interceptor'
  s.ios.dependency 'SmartLib-v3/Kaltura', '04.02.04.1f725a1'
  s.tvos.dependency 'SmartLib-v3/Kaltura+tvOS', '04.02.04.1f725a1'
  
  s.xcconfig = {
### The following is required for Xcode 12 (https://stackoverflow.com/questions/63607158/xcode-12-building-for-ios-simulator-but-linking-in-object-file-built-for-ios)
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64',
    'EXCLUDED_ARCHS[sdk=appletvsimulator*]' => 'arm64'
  }

end
