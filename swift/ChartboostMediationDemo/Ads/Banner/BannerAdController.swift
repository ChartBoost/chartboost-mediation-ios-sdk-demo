// Copyright 2022-2023 Chartboost, Inc.
// 
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

//
//  BannerAdController.swift
//  ChartboostMediationDemo
//
//  Copyright © 2023 Chartboost. All rights reserved.
//

import UIKit
import ChartboostMediationSDK

/// A basic implementation of a controller for Chartboost Mediation banner ads.  It is capable of loading and showing a banner ad
/// for a single placement.  This controller is also its own `HeliumBannerAdDelegate` so that it is in full control
/// of the ad's lifecycle.
class BannerAdController: NSObject {
    /// The entry point for the Chartboost Mediation SDK.
    private let chartboostMediation = Helium.shared()

    /// The placement that is controller is for.
    private let placementName: String

    /// An instance of the banner ad that this class controls the lifecycle of.
    private var bannerAd: ChartboostMediationBannerView?

    /// A delegate for demo purposes only so that long activity processes can be communicated to a view controller.
    private weak var activityDelegate: ActivityDelegate?

    /// Initializer for the view model.
    /// - Parameter placementName: Placement to use.
    /// - Parameter activityDelegate: A delegate to communicate the start and end of asyncronous activity to.  This is applicable only for this demo.
    init(placementName: String, activityDelegate: ActivityDelegate) {
        self.placementName = placementName
        self.activityDelegate = activityDelegate
    }

    /// Load the banner ad.
    /// - Parameter viewController: The view controller that will be the viewer for the banner advertisement.
    /// - Parameter width: The max width of ad to load.
    /// - Parameter keywords: Optional keywords that can be associated with the advertisement placement.
    func load(with viewController: UIViewController, width: CGFloat, keywords: [String: String]? = nil) {
        // Attempt to load the ad only if it has not already been created and requested to load.
        guard bannerAd == nil else {
            print("[Warning] banner advertisement has already been loaded")
            return
        }

        bannerAd = ChartboostMediationBannerView()
        bannerAd?.delegate = self

        // In this demo, we will load a 6x1 banner with the max width of the screen.
        // If you are instead loading a fixed size banner placement, you can do that with:
        // ChartboostMediationBannerSize.standard, ChartboostMediationBannerSize.medium, or
        // ChartboostMediationBannerSize.leaderboard.
        let size = ChartboostMediationBannerSize.adaptive6x1(width: width)
        let request = ChartboostMediationBannerLoadRequest(
            placement: placementName,
            size: size
        )

        // Notify the demo UI
        activityDelegate?.activityDidStart()

        // Associate any provided keywords with the advertisement before it is loaded.
        bannerAd?.keywords = keywords

        // Load the banner ad, which will make a request to the network. Upon completion, the
        // completion block will be called.
        bannerAd?.load(with: request, viewController: viewController, completion: { [weak self] result in
            guard let self else { return }

            self.log(action: "load", placementName: self.placementName, error: result.error)

            // An ad that has failed to load could be cleared so that an attempt to load it can be done  on the
            // same ad object again, e.g. `bannerAd?.clear()`. However, for simplicity, it will be
            // now be destroyed.
            if let error = result.error {
                self.bannerAd = nil

                // Notify the demo UI
                self.activityDelegate?.activityDidEnd(message: "Failed to load the banner advertisement.", error: error)
            }
            else {
                // Notify the demo UI
                self.activityDelegate?.activityDidEnd()
            }
        })
    }

    /// Show the banner ad within a specific view.
    /// - Parameter view: The view to place the banner within.
    func show(within view: UIView) {
        // Attempt to show an ad only if it has been loaded.
        guard let bannerAd = bannerAd else {
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

// MARK: - Lifecycle Delegate

/// Implementation of the Chartboost Mediation banner view delegate.
extension BannerAdController: ChartboostMediationBannerViewDelegate {

    func willAppear(bannerView: ChartboostMediationBannerView) {
        // Called when a new ad is about to appear inside of `bannerView`. This method can be used
        // to manually size `bannerView` if desired:
        // if let size = bannerView.size?.size {
        //     bannerView.frame.size = size
        // }
        // This method can also be used to check other updated properties of `bannerView`.
    }
}

// MARK: - Utility

private extension BannerAdController {
    /// Log lifecycle information to the console for the banner advertisement.
    /// - Parameter action: What action is being logged
    /// - Parameter placementName: The placement name for the banner advertisement
    /// - Parameter error: An option error that occurred
    func log(action: String, placementName: String, error: ChartboostMediationError?) {
        if let error = error {
            print("[Error] did \(action) banner advertisement for placement '\(placementName)': '\(error.localizedDescription)' (name: \(error.chartboostMediationCode.name), code: \(error.code))")
        }
        else {
            print("[Success] did \(action) banner advertisement for placement '\(placementName)'")
        }
    }
}
