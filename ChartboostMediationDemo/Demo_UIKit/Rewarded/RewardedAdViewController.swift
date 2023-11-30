// Copyright 2022-2023 Chartboost, Inc.
// 
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

//
//  RewardedAdViewController.swift
//  ChartboostMediationDemo
//
//  Copyright © 2023 Chartboost. All rights reserved.
//

import UIKit

/// An example view controller that can load and show an full screen rewarded advertisements on the screen.
///
/// Take a look at `RewardedAdController` for details on how to load and show a rewarded advertisement.
///
class RewardedAdViewController: UIViewController {

    /// An instance of the `RewardedAdController` that is configured to use the placement "AllNetworkRewarded"
    lazy var controller = RewardedAdController(activityDelegate: self, placementName: "AllNetworkRewarded")

    /// The handler for when the load button is pushed.  Pushing it results in the rewarded ad being loaded.
    /// After it has successfully loaded, it can then be shown.
    @IBAction func loadButtonPushed() {
        controller.load()
    }

    /// The handler for when the show button is pushed.  Pushing it results in the rewarded ad being shown if it was successfully loaded.
    @IBAction func showButtonPushed() {
        controller.show(with: self)
    }
}
