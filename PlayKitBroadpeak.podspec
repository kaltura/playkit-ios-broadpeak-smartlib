Pod::Spec.new do |s|
  s.name             = 'PlayKitBroadpeak'
  s.version          = '0.0.1'
  s.summary          = 'Kaltura PlayKit plugin for the Broadpeak Delivery Platform.'
  
  s.description      = <<-DESC
  Kaltura PlayKit plugin for the Broadpeak Delivery Platform.
  https://delivery-platform.broadpeak.tv/docs/
  DESC
  
  s.homepage         = 'https://github.com/kaltura/playkit-ios-broadpeak-smartlib'
  s.license          = { :type => 'AGPLv3', :file => 'LICENSE' }
  s.author           = { 'Kaltura' => 'community@kaltura.com' }
  s.source           = { :git => 'https://github.com/kaltura/playkit-ios-broadpeak-smartlib.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '10.0'
  s.tvos.deployment_target = '10.0'
  
  s.source_files = 'PlayKitBroadpeak/Classes/**/*'
  
  s.dependency 'PlayKit/AnalyticsCommon', '~> 3.19'
  s.dependency 'KalturaPlayer/Interceptor'
  s.ios.dependency 'SmartLib-v3/Generic', '03.02.00.3318'
  s.tvos.dependency 'SmartLib-v3/Generic+tvOS', '03.02.00.3318'
  
end
