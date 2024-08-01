// Copyright 2018-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import UIKit

/// An enumeration of each advertisement type.
enum AdType: String, CaseIterable {
    case banner
    case interstitial
    case rewarded
    case queued

    var title: String {
        rawValue.capitalized
    }
}
