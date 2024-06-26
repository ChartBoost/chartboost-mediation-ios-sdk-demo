// Copyright 2022-2024 Chartboost, Inc.
// 
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

//
//  InterstitialAdViewController.swift
//  ChartboostMediationDemo
//
//  Copyright © 2023-2024 Chartboost. All rights reserved.
//

import UIKit

/// An example view controller that can load and show an full screen interstitial on the screen.
///
/// Take a look at `InterstitialAdController` for details on how to load and show an interstitial advertisement.
///
class InterstitialAdViewController: UIViewController {

    /// An instance of the `InterstitialAdController` that is configured to use the placement "CBInterstitial"
    lazy var controller = InterstitialAdController(activityDelegate: self, placementName: "CBInterstitial")

    /// The handler for when the load button is pushed.  Pushing it results in the insterstitial ad being loaded.
    /// After it has successfully loaded, it can then be shown.
    @IBAction func loadButtonPushed() {
        controller.load()
    }

    /// The handler for when the show button is pushed.  Pushing it results in the interstitial ad being shown if it was successfully loaded.
    @IBAction func showButtonPushed() {
        controller.show(with: self)
    }
}
