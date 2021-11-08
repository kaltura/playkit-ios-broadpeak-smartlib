//
//  PlayerViewController.swift
//  playkit-ios-broadpeak_Example
//
//  Created by Sergii Chausov on 01.12.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import PlayKit
import KalturaPlayer
import PlayKitBroadpeak
import PlayKitYoubora

class PlayerViewController: UIViewController {
    
    #error("Please set playerKS, urlType, streamerType, assetId, mediaFormats, networkProtocol to relevant values.")
    let playerKS: String? = ""

    let autoPlay: Bool = true
    let preload: Bool = false
    
    let urlType: String? = "DIRECT"
    let streamerType: String? = "applehttp"
    let assetId: String = ""
    let mediaFormats: [String] = ["HLS_FP"]
    let networkProtocol: String = "https"
    let fileIds: [String]? = [""]
    
    @IBOutlet weak var kalturaPlayerView: KalturaPlayerView!
    
    var kalturaOTTPlayer: KalturaOTTPlayer!
    
    deinit {
        kalturaOTTPlayer.destroy()
        kalturaOTTPlayer = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let playerOptions = self.playerOptions()
        
        kalturaOTTPlayer = KalturaOTTPlayer(options: playerOptions)
        kalturaOTTPlayer.view = kalturaPlayerView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        registerPlayerEvents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        kalturaOTTPlayer.loadMedia(options: mediaOptions()) { [weak self] (error) in
            guard let self = self else { return }
            if error != nil {
                let alert = UIAlertController(title: "Media not loaded", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alert) in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                // If the autoPlay and preload was set to false, prepare will not be called automatically
                if self.autoPlay == false && self.preload == false {
                    self.kalturaOTTPlayer.prepare()
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if kalturaOTTPlayer.isPlaying {
            kalturaOTTPlayer.pause()
        }
        
        kalturaOTTPlayer.removeObserver(self, events: KPPlayerEvent.allEventTypes)
        kalturaOTTPlayer.removeObserver(self, events: BroadpeakEvent.allEventTypes)
        kalturaOTTPlayer.removeObserver(self, events: InterceptorEvent.allEventTypes)
    }
    
    private func mediaOptions() -> OTTMediaOptions {
        let mediaOptions = OTTMediaOptions()
        
        mediaOptions.ks = playerKS
        mediaOptions.assetId = assetId
        mediaOptions.assetType = .media
        mediaOptions.assetReferenceType = .media
        mediaOptions.playbackContextType = .playback
        mediaOptions.formats = mediaFormats
        mediaOptions.networkProtocol = networkProtocol
        mediaOptions.urlType = urlType
        mediaOptions.streamerType = streamerType
        mediaOptions.fileIds = fileIds
        
        return mediaOptions
    }
    
    private func playerOptions() -> PlayerOptions {
        let playerOptions = PlayerOptions()
        
        playerOptions.ks = playerKS
        playerOptions.autoPlay = autoPlay
        playerOptions.preload = preload
        
        let bpConfig = BroadpeakConfig()
        bpConfig.analyticsAddress = ""
        bpConfig.nanoCDNHost = ""
        bpConfig.broadpeakDomainNames = "*"
        bpConfig.uuid = UIDevice.current.identifierForVendor?.uuidString ?? "" // Can be any unique id
                
        let youboraPluginParams: [String: Any] = [
            "accountCode": "kalturatest"
        ]
        let analyticsConfig = AnalyticsConfig(params: youboraPluginParams)
        
        playerOptions.pluginConfig = PluginConfig(config: [YouboraPlugin.pluginName: analyticsConfig, BroadpeakMediaEntryInterceptor.pluginName: bpConfig])
        
        return playerOptions
    }
    
    private func registerPlayerEvents() {
        handleError()
        
        kalturaOTTPlayer.addObserver(self, events: [InterceptorEvent.sourceUrlSwitched]) { event in
            
            PKLog.debug("InterceptorEvent.sourceUrlSwitched originalUrl :: \(event.originalUrl ?? "")")
            PKLog.debug("InterceptorEvent.sourceUrlSwitched updatedUrl:: \(event.updatedUrl ?? "")")
            
            let youboraPluginParams: [String: Any] = [
                "accountCode": "kalturatest",
                "contentCustomDimensions": [
                              "contentCustomDimension1": "customDimension1",
                              "contentCustomDimension2": event.updatedUrl ?? ""
                ]
            ]
            let analyticsConfig = AnalyticsConfig(params: youboraPluginParams)
            self.kalturaOTTPlayer.updatePluginConfig(pluginName: YouboraPlugin.pluginName, config: analyticsConfig)
            
//            if let event = event as? InterceptorEvent.SourceUrlSwitched,
//               let originalUrl = event.originalUrl,
//               let updatedUrl = event.updatedUrl {
//
//                PKLog.debug("InterceptorEvent.sourceUrlSwitched originalUrl :: \(originalUrl)")
//                PKLog.debug("InterceptorEvent.sourceUrlSwitched updatedUrl:: \(updatedUrl)")
//            }
        }

    }
    
    private func handleError() {
        
        kalturaOTTPlayer.addObserver(self, events: [KPPlayerEvent.error]) { [weak self] event in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: event.error?.description, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alert) in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        kalturaOTTPlayer.addObserver(self, events: [BroadpeakEvent.error]) { [weak self] event in
            // Handle Broadpeak SmartLib error here.
            if let error = event.error {
                // error here is NSError
                guard let self = self else { return }
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Broadpeak SmartLib Error", message: error.description, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alert) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
