// Copyright 2022-2023 Chartboost, Inc.
// 
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

//
//  BannerAdViewController.swift
//  ChartboostMediationDemo
//
//  Copyright © 2023 Chartboost. All rights reserved.
//

import UIKit

/// An example view controller that can load and show a banner on the screen.  The banner is shown within
/// a UIView that acts as the container in the view hierachy to place the banner adverisement into, as a subview.
/// In this demo, the `standard` banner size is used and is thus 320x50 in size.
///
/// Take a look at `BannerAdController` for details on how to load and show a banner advertisement.
///
class BannerAdViewController: UIViewController {

    /// The banner's container view. In the storyboard, it is constrained to be 320x50 for the sake of this
    /// demo, which only uses the fixed `standard` size.
    @IBOutlet private var bannerContainer: UIView!

    /// An instance of the `BannerAdController` that is configured to use the placement "CBBanner"
    lazy var controller = BannerAdController(placementName: "CBBanner", activityDelegate: self)

    /// The handler for when the load button is pushed.  Pushing it results in the banner ad being loaded.
    /// After it has successfully loaded, it can then be shown.
    @IBAction func loadButtonPushed() {
        controller.load(with: self)
    }

    /// The handler for when the show button is pushed.  Pushing it results in the banner ad being shown if it was successfully loaded.
    /// The banner ad view will become a subview of the `bannerContainer` owned by this view controller.
    @IBAction func showButtonPushed() {
        controller.show(within: bannerContainer)
    }
}
