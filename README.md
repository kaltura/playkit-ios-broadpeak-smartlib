# PlayKitBroadpeak
![Swift 3.0+](https://img.shields.io/badge/Swift-3.0+-orange.svg)
[![CI Status](https://github.com/kaltura/playkit-ios-broadpeak-smartlib/actions/workflows/ci.yml/badge.svg)](https://github.com/kaltura/playkit-ios-broadpeak-smartlib/actions/workflows/ci.yml)


Kaltura Player iOS plugin for Broadpeak SmartLib

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

**PlayKitBroadpeak** is not published to main [CocoaPods](https://cocoapods.org) Specs repo, but you can manage it via CocoaPods tools. 
To install it, simply add the following lines to your Podfile:

```ruby
pod 'PlayKitBroadpeak', :git => 'https://github.com/kaltura/playkit-ios-broadpeak-smartlib', :tag => 'v1.0.1' # Make sure this is the latest one!
pod 'SmartLib-v3/Generic', '03.02.05.3568' # Make sure this is the latest one!
```
Also nees to add folloving to your Podfile:
```ruby
load 'plugin-credentials.rb'
# Broadpeak private Cocoapods sources
source "https://#{@@broadpeak_platform_login}:#{@@broadpeak_platform_password}@delivery-platform.broadpeak.tv/ios/broadpeak/specs.git"
```
Broadpeak SmartLib dependency hosted in the private repository, that requires authorisation. You have to specify Broadpeak platform credentials in the plugin-credentials.rb file. In the Example folder of Kaltura plugin repository you can find file [Template_plugin-credentials.rb](https://github.com/kaltura/playkit-ios-broadpeak-smartlib/blob/develop/Example/Template_plugin-credentials.rb) Rename it to plugin-credentials.rb and add it to .gitignore if you don't like to share credentials in your repository. You can follow same implementation like in PlayKitBroadpeak Example.

[Example of the podfile you can find by following this link](https://github.com/kaltura/playkit-ios-broadpeak-smartlib/blob/develop/Example/Podfile)  

Once you setup everything run command
```ruby
pod install
```

#### Original installation guide for iOS and tvOS Broadpeak SmartLib.
Follow the steps of how to add Broadpeak private repo to CocoaPods on your Mac.  

[iOS & tvOS Generic](https://delivery-platform.broadpeak.tv/docs/?solution=ios-tvos-generic)    

## Usage
### In the AppDelegate:

```swift
import PlayKit
import PlayKitBroadpeak
```
in the ```application(_:didFinishLaunchingWithOptions:)``` needs to add registration plugin to PlayKit manager:
```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
// Override point for customization after application launch.
PlayKitManager.shared.registerPlugin(BroadpeakMediaEntryInterceptor.self)
return true
}
```
### Create plugin config and add it to player:
Create plugin config parameters can be different than shown on example, it depends on your integration with Broadpeak.
```swift
import PlayKit
import KalturaPlayer
import PlayKitBroadpeak
```

```swift
var kalturaOTTPlayer: KalturaOTTPlayer

let bpConfig = BroadpeakConfig()
bpConfig.analyticsAddress = ""
// Set nanoCDNHost only if you are using the Broadpeak nanoCDN device, othervise set an empty string ""
bpConfig.nanoCDNHost = ""
bpConfig.broadpeakDomainNames = "*"

// Add PluginConfig to KalturaPlayer
let playerOptions = PlayerOptions()
playerOptions.pluginConfig = PluginConfig(config: [BroadpeakMediaEntryInterceptor.pluginName: bpConfig])
        
kalturaOTTPlayer = KalturaOTTPlayer(options: playerOptions)

```
It is possible to update player with new options if needed.
```swift
kalturaOTTPlayer.updatePlayerOptions(playerOptions)
```


### iOS 14 and local network privacy:
Since iOS 14, the system requires a specific permission to allow the nanoCDN discovery used by SmartLib.
#### Make your declaration
[Bonjour services](https://developer.apple.com/documentation/bundleresources/information_property_list/nsbonjourservices)  
Declare the nanoCDN service name “_nanocdn._tcp” in your app’s Info.plist.
```xml
<key>NSBonjourServices</key>
<array>
<string>_nanocdn._tcp</string>
</array>
```

#### Provide context
[Privacy - Local Network Usage Description](https://developer.apple.com/documentation/bundleresources/information_property_list/nslocalnetworkusagedescription)  
After declaring this service, you also need to provide a reason string, which provides context to someone when your app attempts to access a local network. Make sure this text clearly explains what your app is doing with the information it discovers from the local network and how receiving this data enables a necessary experience in your app.
```xml
<key>NSLocalNetworkUsageDescription</key>
<string>Description example</string>
```

#### Additional resouces
[Protect privacy during device discovery](https://developer.apple.com/news/?id=0oi77447)  
[Support local network privacy in your app](https://developer.apple.com/videos/play/wwdc2020/10110/)


## Errors handling

On the ```kalturaOTTPlayer``` object you have to subscribe to an event ```BroadpeakEvent.error``` to recieve errors rised by plugin.

```swift
kalturaOTTPlayer.addObserver(self, events: [BroadpeakEvent.error]) { event in
            // Handle Broadpeak SmartLib error here.
            if let error = event.error {
                // error here is NSError
                print(error.localizedDescription)
            }
        }
```

## License and Copyright Information

All code in this project is released under the [AGPLv3 license](http://www.gnu.org/licenses/agpl-3.0.html) unless a different license for a particular library is specified in the applicable library path.   

Copyright © Kaltura Inc. All rights reserved.   
Authors and contributors: See [GitHub contributors list](https://github.com/kaltura/playkit-ios-broadpeak-smartlib/graphs/contributors).
