// Copyright 2022-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

//
//  Banner.swift
//  ChartboostMediationDemo
//
//  Copyright © 2023-2024 Chartboost. All rights reserved.
//

import ChartboostMediationSDK
import SwiftUI

/// A SwiftUI host view for a `ChartboostMediationBannerView`
struct Banner: UIViewRepresentable {
    typealias UIViewType = ChartboostMediationBannerView

    let source: ChartboostMediationBannerView

    func makeUIView(context: Context) -> ChartboostMediationBannerView {
        source
    }

    func updateUIView(_ uiView: ChartboostMediationBannerView, context: Context) {

    }
}
