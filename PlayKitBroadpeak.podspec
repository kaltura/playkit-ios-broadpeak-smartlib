Pod::Spec.new do |s|
  s.name             = 'PlayKitBroadpeak'
  s.version          = '0.0.1'
  s.summary          = 'Kaltura PlayKit plugin for the Broadpeak Delivery Platform.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Kaltura PlayKit plugin for the Broadpeak Delivery Platform.
https://delivery-platform.broadpeak.tv/docs/
                       DESC

  s.homepage         = 'https://github.com/kaltura/playkit-ios-broadpeak-smartlib'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'AGPLv3', :file => 'LICENSE' }
  s.author           = { 'Kaltura' => 'community@kaltura.com' }
  s.source           = { :git => 'https://github.com/kaltura/playkit-ios-broadpeak-smartlib.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.tvos.deployment_target = '10.0'
  
  s.source_files = 'PlayKitBroadpeak/Classes/**/*'
  
  # s.resource_bundles = {
  #   'playkit-ios-broadpeak' => ['playkit-ios-broadpeak/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'PlayKit/AnalyticsCommon', '~> 3.8'
  s.dependency 'KalturaPlayer/Interceptor'
  s.ios.dependency 'SmartLib-v3/Generic', '03.02.00.3318'
  s.tvos.dependency 'SmartLib-v3/Generic+tvOS', '03.02.00.3318'
  
end
