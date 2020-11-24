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
    
    static let codeKey = "code"
    static let messageKey = "message"
    
    @objc public static let broadpeakError: BroadpeakEvent.Type = BroadpeakEvent.BroadpeakError.self
    
    class BroadpeakError : BroadpeakEvent {
        convenience init(code: String?, message: String?) {
            self.init([BroadpeakEvent.codeKey: code ?? "", BroadpeakEvent.messageKey: message ?? ""])
        }
    }
    
}

extension PKEvent {
    /// Broadpeak Event message value, PKEvent Data Accessor
    @objc public var broadpeakEventMessage: String? {
        return self.data?[BroadpeakEvent.messageKey] as? String
    }
}
