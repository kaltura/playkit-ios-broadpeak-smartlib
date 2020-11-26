// ===================================================================================================
// Copyright (C) 2020 Kaltura Inc.
//
// Licensed under the AGPLv3 license, unless a different license for a
// particular library is specified in the applicable library path.
//
// You may obtain a copy of the License at
// https://www.gnu.org/licenses/agpl-3.0.html
// ===================================================================================================

import PlayKit
import SmartLib
import KalturaPlayer

@objc public class BroadpeakMediaEntryInterceptor: BasePlugin {
    
    public override class var pluginName: String {
        return "BroadpeakMediaEntryInterceptor/Plugin"
    }
    
    var config: BroadpeakConfig
    
    var completionHandler: ((Error?) -> Void)?
    
    public required init(player: Player, pluginConfig: Any?, messageBus: MessageBus) throws {
        guard let config = pluginConfig as? BroadpeakConfig else {
            PKLog.error("Missing plugin config")
            throw PKPluginError.missingPluginConfig(pluginName: BroadpeakMediaEntryInterceptor.pluginName)
        }
        
        self.config = config
        
        try super.init(player: player, pluginConfig: pluginConfig, messageBus: messageBus)
        
        SmartLib.initSmartLib(self.config.analyticsAddress,
                              nanoCDNHost: self.config.nanoCDNHost,
                              broadpeakDomainNames: self.config.broadpeakDomainNames)
    }
    
    @objc open override func onUpdateMedia(mediaConfig: MediaConfig) {
        super.onUpdateMedia(mediaConfig: mediaConfig)
    }
    
    @objc open override func onUpdateConfig(pluginConfig: Any) {
        super.onUpdateConfig(pluginConfig: pluginConfig)
        
        guard let config = pluginConfig as? BroadpeakConfig else {
            PKLog.error("Wrong plugin config, it is not possible to update Broadpeak plugin")
            let error = PKPluginError.missingPluginConfig(pluginName: BroadpeakMediaEntryInterceptor.pluginName)
            self.messageBus?.post(PluginEvent.Error(nsError: error.asNSError))
            return
        }
        
        self.config = config
        
        SmartLib.stopStreamingSession()
        SmartLib.release()
        
        SmartLib.initSmartLib(self.config.analyticsAddress,
                              nanoCDNHost: self.config.nanoCDNHost,
                              broadpeakDomainNames: self.config.broadpeakDomainNames)
    }
    
    @objc open override func destroy() {
        completionHandler = nil
        SmartLib.stopStreamingSession()
        SmartLib.release()
        
        super.destroy()
    }
    
}

extension BroadpeakMediaEntryInterceptor: PKMediaEntryInterceptor {
    
    @objc public func apply(on mediaEntry: PKMediaEntry, completion: @escaping (Error?) -> Void) {
        
        guard let sources = mediaEntry.sources, !sources.isEmpty else {
            PKLog.error("Missing sources in provided MediaEntry: \(mediaEntry.id)")
            let error = BroadpeakPluginError.invalidMediaEntry
            self.messageBus?.post(PluginEvent.Error(nsError: error.asNSError))
            completion(error)
            return
        }
        
        completionHandler = completion
        
        DispatchQueue.global(qos: .default).async { [weak self] in
            
            for source in sources {
                
                if let contentURL = source.contentUrl,
                   let streamUrl = SmartLib.getURL(contentURL.absoluteString),
                   !streamUrl.isEmpty,
                   let url = URL(string: streamUrl) {
                    
                    source.contentUrl = url
                } else {
                    DispatchQueue.main.async {
                        PKLog.error("Missed MediaEntry source.contentUrl or SmartLib stream URL is incorrect")
                        let error = BroadpeakPluginError.unknown
                        self?.messageBus?.post(PluginEvent.Error(nsError: error.asNSError))
                    }
                }
            }
            
            DispatchQueue.main.async {
                self?.completionHandler?(nil)
            }
        }
    }
    
}
