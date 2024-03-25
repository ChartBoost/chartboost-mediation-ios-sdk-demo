// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

//
//  Banner.swift
//  ChartboostMediationDemo
//
//  Copyright © 2023 Chartboost. All rights reserved.
//

import ChartboostMediationSDK
import SwiftUI

/// A SwiftUI host view for a `ChartboostMediationBannerView`
struct Banner: UIViewRepresentable {
    typealias UIViewType = BannerView

    let source: BannerView

    func makeUIView(context: Context) -> BannerView {
        source
    }

    func updateUIView(_ uiView: BannerView, context: Context) {

    }
}
