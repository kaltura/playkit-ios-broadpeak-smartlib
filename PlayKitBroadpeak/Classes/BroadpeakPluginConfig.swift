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
