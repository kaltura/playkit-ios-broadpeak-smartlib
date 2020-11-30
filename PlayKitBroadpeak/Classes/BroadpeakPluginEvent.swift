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
import PlayKit

@objc public class BroadpeakEvent: PKEvent {
    
    struct BroadpeakEventDataKeys {
        static let codeKey = "code"
        static let messageKey = "message"
        static let error = "error"
    }
    
    @objc public static let error: BroadpeakEvent.Type = BroadpeakEvent.Error.self
    
    class Error: BroadpeakEvent {
        convenience init(nsError: NSError) {
            self.init([BroadpeakEventDataKeys.error: nsError])
        }
        
        convenience init(error: BroadpeakPluginError) {
            self.init([BroadpeakEventDataKeys.error: error.asNSError,
                       BroadpeakEventDataKeys.codeKey: error.code,
                       BroadpeakEventDataKeys.messageKey: error.errorDescription])
        }
    }
    
}

extension PKEvent {
    /// Broadpeak Event message value, PKEvent Data Accessor
    @objc public var broadpeakEventMessage: String? {
        return self.data?[BroadpeakEvent.BroadpeakEventDataKeys.messageKey] as? String
    }
}
