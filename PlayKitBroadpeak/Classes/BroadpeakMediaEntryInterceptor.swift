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
import KalturaPlayer

#if os(iOS)
    import SmartLib
#elseif os(tvOS)
    import SmartLib_tvOS
#endif

@objc public class BroadpeakMediaEntryInterceptor: BasePlugin {
    
    public override class var pluginName: String {
        return "BroadpeakMediaEntryInterceptor/Plugin"
    }
    
    var streamingSession: StreamingSession?
    var config: BroadpeakConfig {
        didSet {
            updateSmartLib()
        }
    }
    
    var completionHandler: (() -> Void)?
    
    public required init(player: Player, pluginConfig: Any?, messageBus: MessageBus) throws {
        guard let config = pluginConfig as? BroadpeakConfig else {
            PKLog.error("Missing plugin config")
            throw PKPluginError.missingPluginConfig(pluginName: BroadpeakMediaEntryInterceptor.pluginName)
        }
        
        self.config = config
        
        try super.init(player: player, pluginConfig: pluginConfig, messageBus: messageBus)
        
        // DidSet functionss are not called in the initializers.
        updateSmartLib()
        
        messageBus.addObserver(self, events: [PlayerEvent.error], block: { [weak self] event in
            guard let self = self else { return }
            
            switch event {
            case is PlayerEvent.Error:
                self.streamingSession?.stop()
            default: break
            }
        })
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
        
        if !self.config.isEqual(config) {
            streamingSession?.stop()
            SmartLib.release()
            self.config = config
        }
    }
    
    @objc open override func destroy() {
        self.messageBus?.removeObserver(self, events: [PlayerEvent.error])
        
        completionHandler = nil
        streamingSession?.stop()
        SmartLib.release()
        
        super.destroy()
    }
}

extension BroadpeakMediaEntryInterceptor: PKMediaEntryInterceptor {
    
    @objc public func apply(on mediaEntry: PKMediaEntry, completion: @escaping () -> Void) {
        
        guard let sources = mediaEntry.sources, !sources.isEmpty else {
            PKLog.error("Missing sources in provided MediaEntry: \(mediaEntry.id)")
            self.messageBus?.post(BroadpeakEvent.Error(error: BroadpeakPluginError.invalidMediaEntry))
            completion()
            return
        }
        
        completionHandler = completion
        
        if streamingSession != nil {
            streamingSession?.stop()
        }
        streamingSession = SmartLib.createStreamingSession()
        
        updateSessionOptions()
        
        if let player = self.player {
            self.streamingSession?.attachPlayer(player, listener: self.messageBus)
        }
        
        DispatchQueue.global(qos: .default).async { [weak self] in
            
            if let source = sources.first,
               let contentURL = source.contentUrl,
               let result = self?.streamingSession?.getURL(contentURL.absoluteString) {
                
                DispatchQueue.main.async {
                    
                    if result.isError() {
                        self?.streamingSession?.stop()
                        PKLog.error("SmartLib internal error occurred")
                        self?.messageBus?.post(BroadpeakEvent.Error(error: BroadpeakPluginError.smartLibError(Int(result.getErrorCode()), result.getErrorMessage())))
                    } else {
                        if let url = URL(string: result.getURL()) {
                            //send SourceUrlSwitched event
                            let originalUrl = contentURL.absoluteString
                            let updatedUrl = url.absoluteString
                            if (originalUrl != updatedUrl) {
                                self?.messageBus?.post(InterceptorEvent.SourceUrlSwitched(originalUrl: originalUrl,
                                                                                          updatedUrl: updatedUrl))
                            }
                            source.contentUrl = url
                        } else {
                            self?.streamingSession?.stop()
                            PKLog.error("SmartLib Streaming Session returned incorrect URL")
                            self?.messageBus?.post(BroadpeakEvent.Error(error: BroadpeakPluginError.smartLibBadUrl))
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.streamingSession?.stop()
                    PKLog.error("Missed MediaEntry source.contentUrl or SmartLib stream URL is incorrect")
                    self?.messageBus?.post(BroadpeakEvent.Error(error: BroadpeakPluginError.unknown))
                }
            }
            
            DispatchQueue.main.async {
                self?.completionHandler?()
            }
        }
    }
}

// MARK: - SmartLib

extension BroadpeakMediaEntryInterceptor {
    
    func updateSmartLib() {
        SmartLib.initSmartLib(config.analyticsAddress,
                              nanoCDNHost: config.nanoCDNHost,
                              broadpeakDomainNames: config.broadpeakDomainNames)
        
        if !config.uuid.isEmpty {
            SmartLib.setUUID(config.uuid)
        }
        
        if let type = config.deviceType {
            SmartLib.setDeviceType(type)
        }
        
        if let userAgent = config.userAgent {
            SmartLib.setUserAgent(userAgent)
        }
        
        if let delay = config.nanoCDNResolvingRetryDelay {
            SmartLib.setNanoCDNResolvingRetryDelay(delay)
        }
        
        if let enabled = config.nanoCDNHttpsEnabled {
            SmartLib.setNanoCDNHttpsEnabled(enabled)
        }
    }
    
    func updateSessionOptions() {
        
        /*
        if let adCustomReference = self.config.adCustomReference {
            
        }
        */
        
        self.config.adParameters?.forEach({ (key: String, value: String) in
            streamingSession?.setAdParameter(key, value: value)
        })
        
        self.config.customParameters?.forEach({ (key: String, value: String) in
            streamingSession?.setCustomParameter(key, value: value)
        })
        
        self.config.options?.forEach({ (key: Int32, value: Any) in
            
            if let value = value as? Bool {
                streamingSession?.setOption(key, valueWith: value)
            } else if let value = value as? String {
                streamingSession?.setOption(key, valueWith: value)
            } else if let value = value as? Int32 {
                streamingSession?.setOption(key, valueWith: value)
            }
        })
    }
    
}
