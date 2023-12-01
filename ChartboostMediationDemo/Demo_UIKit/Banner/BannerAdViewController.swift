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

    /// An instance of the `BannerAdController` that is configured to use the placement "AllNetworkAdaptiveBanner"
    lazy var controller = BannerAdController(placementName: "AllNetworkAdaptiveBanner", activityDelegate: self)

    /// The handler for when the load button is pushed.  Pushing it results in the banner ad being loaded.
    /// After it has successfully loaded, it can then be shown.
    @IBAction func loadButtonPushed() {
        controller.load(with: self, width: view.frame.width)
    }

    /// The handler for when the show button is pushed.  Pushing it results in the banner ad being shown if it was successfully loaded.
    /// The banner ad view will become a subview of the `bannerContainer` owned by this view controller.
    @IBAction func showButtonPushed() {
        // Attempt to show an ad only if it has been loaded.
        guard let bannerAd = controller.bannerAd else {
            print("[Error] cannot show an banner advertisement that has not yet been loaded")
            return
        }

        // Remove the banner ad from its super view if it was previously added to one.
        bannerAd.removeFromSuperview()

        // Place the banner ad view within the provided view container.
        bannerAd.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerAd)

        // If using auto-layout, the banner view will automatically resize when new ads are loaded.
        // The banner view can also be manually sized, see `willAppear` below.
        NSLayoutConstraint.activate([
            bannerAd.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            bannerAd.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
