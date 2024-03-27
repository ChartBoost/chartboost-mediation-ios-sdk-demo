// Copyright 2022-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

//
//  FullscreenAdViewController.swift
//  ChartboostMediationDemo
//
//  Copyright © 2023-2024 Chartboost. All rights reserved.
//

import UIKit

/// An example view controller that can load and show a full screen advertisement on the screen.
///
/// Take a look at `FullscreenAdController` for details on how to load and show a fullscreen advertisement.
///
class FullscreenAdViewController: UIViewController {

    /// Both interstitial and rewarded ads use the FullscreenAd API.
    /// If adType is not set to one of these before self.controller is accessed, no ad will load
    var adType: AdType?

    /// An instance of the `FullscreenAdController` that is configured to use the placement "AllNetworkFullscreen"
    lazy var controller = FullscreenAdController(
        activityDelegate: self,
        placementName: adType == .interstitial ? "CBInterstitial" : "CBRewarded"
    )

    /// The handler for when the load button is pushed.  Pushing it results in the insterstitial ad being loaded.
    /// After it has successfully loaded, it can then be shown.
    @IBAction func loadButtonPushed() {
        controller.load()
    }

    /// The handler for when the show button is pushed.  Pushing it results in the fullscreen ad being shown if it was successfully loaded.
    @IBAction func showButtonPushed() {
        controller.show(with: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        title = adType?.title ?? "Fullscreen Ad"
    }
}
