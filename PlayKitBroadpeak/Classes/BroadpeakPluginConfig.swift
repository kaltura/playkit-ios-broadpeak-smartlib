// ===================================================================================================
// Copyright (C) 2020 Kaltura Inc.
//
// Licensed under the AGPLv3 license, unless a different license for a
// particular library is specified in the applicable library path.
//
// You may obtain a copy of the License at
// https://www.gnu.org/licenses/agpl-3.0.html
// ===================================================================================================

import Foundation

@objc public class BroadpeakConfig: NSObject {
    
    @objc public var analyticsAddress: String = ""
    @objc public var nanoCDNHost: String = ""
    @objc public var broadpeakDomainNames: String = ""
    @objc public var uuid: String = ""
    
    @objc public var deviceType: String?
    @objc public var userAgent: String?
    
    public var nanoCDNResolvingRetryDelay: TimeInterval?
    public var nanoCDNHttpsEnabled: Bool?
    
    @objc public var adCustomReference: String? // Not supported in iOS
    @objc public var adParameters: [String: String]?
    
    @objc public var customParameters: [String: String]?
    @objc public var options: [Int32: Any]?
    
    @discardableResult
    @nonobjc public func set(analyticsAddress: String) -> Self {
        self.analyticsAddress = analyticsAddress
        return self
    }
    
    @discardableResult
    @nonobjc public func set(nanoCDNHost: String) -> Self {
        self.nanoCDNHost = nanoCDNHost
        return self
    }
    
    @discardableResult
    @nonobjc public func set(broadpeakDomainNames: String) -> Self {
        self.broadpeakDomainNames = broadpeakDomainNames
        return self
    }
    
    @discardableResult
    @nonobjc public func set(uuid: String) -> Self {
        self.uuid = uuid
        return self
    }
    
    @discardableResult
    @nonobjc public func set(deviceType: String) -> Self {
        self.deviceType = deviceType
        return self
    }
    
    @discardableResult
    @nonobjc public func set(userAgent: String) -> Self {
        self.userAgent = userAgent
        return self
    }
    
    @discardableResult
    @objc public func set(nanoCDNResolvingRetryDelay: TimeInterval) -> Self {
        self.nanoCDNResolvingRetryDelay = nanoCDNResolvingRetryDelay
        return self
    }
    
    @discardableResult
    @objc public func set(nanoCDNHttpsEnabled: Bool) -> Self {
        self.nanoCDNHttpsEnabled = nanoCDNHttpsEnabled
        return self
    }
    
    @discardableResult
    @nonobjc public func set(adCustomReference: String) -> Self {
        self.adCustomReference = adCustomReference
        return self
    }
    
    @discardableResult
    @nonobjc public func set(adParameters: [String: String]) -> Self {
        self.adParameters = adParameters
        return self
    }
    
    @discardableResult
    @nonobjc public func set(customParameters: [String: String]) -> Self {
        self.customParameters = customParameters
        return self
    }
    
    @discardableResult
    @nonobjc public func set(options: [Int32: Any]?) -> Self {
        self.options = options
        return self
    }
    
}

extension BroadpeakConfig {
    
    @objc public override func isEqual(_ object: Any?) -> Bool {
        
        if let object = object as? BroadpeakConfig {
            return self.analyticsAddress == object.analyticsAddress
                && self.nanoCDNHost == object.nanoCDNHost
                && self.broadpeakDomainNames == object.broadpeakDomainNames
                && self.uuid == object.uuid
        }
        
        return false
    }
    
}
