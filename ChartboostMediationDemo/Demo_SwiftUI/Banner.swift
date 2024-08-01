// Copyright 2018-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import ChartboostMediationSDK
import SwiftUI

/// A SwiftUI host view for a `BannerAdView`
struct Banner: UIViewRepresentable {
    typealias UIViewType = BannerAdView

    let source: BannerAdView

    func makeUIView(context: Context) -> BannerAdView {
        source
    }

    func updateUIView(_ uiView: BannerAdView, context: Context) {
    }
}
