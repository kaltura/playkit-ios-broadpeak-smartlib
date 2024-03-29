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

enum BroadpeakPluginError: PKError {
    
    case smartLibError(Int, String)
    case smartLibBadUrl
    case invalidMediaEntry
    case unknown
    
    static let domain = "com.kaltura.playkit.error.broadpeak"
    
    var code: Int {
        switch self {
        case .smartLibError: return PKErrorCode.broadpeakPluginInvalidSmartLibEntry
        case .smartLibBadUrl: return PKErrorCode.broadpeakPluginInvalidStreamURL
        case .invalidMediaEntry: return PKErrorCode.broadpeakPluginInvalidMediaEntry
        case .unknown: return PKErrorCode.broadpeakUnknownError
        }
    }
    
    var errorDescription: String {
        switch self {
        case .smartLibError(_, let errorMessage): return errorMessage
        case .smartLibBadUrl: return "SmartLib Stream URL is empty."
        case .invalidMediaEntry: return "Provided MediaEntry can not be modified. Check MediaEntry Sources."
        case .unknown: return "BroadpeakPlugin unknown error."
        }
    }
    
    var userInfo: [String: Any] {
        
        switch self {
        case .smartLibError(let errorCode, let errorMessage): return ["BPErrorCode": errorCode, "BPErrorMessage": errorMessage]
        default: return [:]
        }
    }
    
}

extension PKErrorDomain {
    @objc(Broadpeak) public static let broadpeak = BroadpeakPluginError.domain
}

extension PKErrorCode {
    @objc(BroadpeakUnknownError) public static let broadpeakUnknownError = 10000
    @objc(BroadpeakPluginInvalidMediaEntry) public static let broadpeakPluginInvalidMediaEntry = 10001
    @objc(BroadpeakPluginInvalidSmartLibEntry) public static let broadpeakPluginInvalidSmartLibEntry = 10002
    @objc(BroadpeakPluginInvalidStreamURL) public static let broadpeakPluginInvalidStreamURL = 10003
}
