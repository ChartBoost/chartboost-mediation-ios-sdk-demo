// Copyright 2022-2023 Chartboost, Inc.
// 
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

//
//  FullscreenAdController.swift
//  ChartboostMediationDemo
//
//  Copyright © 2023 Chartboost. All rights reserved.
//

import UIKit
import ChartboostMediationSDK

/// A basic implementation of a controller for Chartboost Mediation fullscreen ads.  It is capable of loading and showing a full screen fullscreen ad
/// for a single placement.  This controller is also its own `CHBHeliumFullscreenAdDelegate` so that it is in full control
/// of the ad's lifecycle.
class FullscreenAdController: NSObject {
    /// The entry point for the Chartboost Mediation SDK.
    private let chartboostMediation = Helium.shared()

    /// Which type of fullscreen ad is managed by this controller
    private let adType: AdType?

    /// The placement that is controller is for.
    private var placementName: String

    /// An instance of the fullscreen ad that this class controls the lifecycle of.
    private var fullscreenAd: ChartboostMediationFullscreenAd?

    /// A delegate for demo purposes only so that long activity processes can be communicated to a view controller.
    private weak var activityDelegate: ActivityDelegate?

    /// Initializer for the view model.
    /// - Parameter placementName: Placement to use.
    /// - Parameter activityDelegate: A delegate to communicate the start and end of asyncronous activity to.  This is applicable only for this demo.
    init(adType: AdType?, activityDelegate: ActivityDelegate) {
        self.adType = adType
        self.activityDelegate = activityDelegate

        switch adType {
        case .interstitial:
            placementName = "AllNetworkInterstitial"
        case .rewarded:
            placementName = "AllNetworkRewarded"
        // If adType is nil or not a fullscreen type, give an empty placement name that won't load
        default:
            placementName = ""
        }
    }

    /// Load the fullscreen ad.
    /// - Parameter keywords: Optional keywords that can be associated with the advertisement placement.
    func load() {
        // Attempt to load the ad only if it has not already been created and requested to load.
        guard fullscreenAd == nil else {
            print("[Warning] fullscreen advertisement has already been loaded")
            return
        }

        // Notify the demo UI
        activityDelegate?.activityDidStart()

        let request = ChartboostMediationAdLoadRequest(placement: placementName, keywords: [:])
        // Load the fullscreen ad, which will make a request to the network. Upon completion, a
        // ChartboostMediationFullscreenAdLoadResult will be passed to the completion block.
        chartboostMediation.loadFullscreenAd(with: request) { [weak self] result in
            guard let self = self else { return }
            if let ad = result.ad {
                ad.delegate = self
                self.fullscreenAd = ad

                log(action: "load", placementName: placementName, error: result.error)
                // Notify the demo UI
                activityDelegate?.activityDidEnd()
            } else {
                fullscreenAd = nil
                self.log(action: "Load error", placementName: placementName, error: result.error)

                // `.failed` requires a non-optional error type
                let error = result.error ?? NSError(domain: "com.chartboost.mediation.demo", code: 0)
                // Notify the demo UI
                activityDelegate?.activityDidEnd(message: "Failed to load the advertisement.", error: error)
            }
        }
    }

    /// Show the fullscreen ad if it has been loaded and is ready to show.
    /// - Parameter viewController: The view controller to present the fullscreen over.
    func show(with viewController: UIViewController) {
        // Attempt to show an ad only if it has been loaded.
        guard let fullscreenAd = fullscreenAd else {
            print("[Error] cannot show an fullscreen advertisement that has not yet been loaded")
            return
        }

        // Once you've loaded a ChartboostMediationFullscreenAd, it can be shown immediately.

        // Notify the demo UI.
        activityDelegate?.activityDidStart()

        // Show the ad using the specified view controller.  Upon completion, a ChartboostMediationAdShowResult will be passed to the completion block.
        fullscreenAd.show(with: viewController, completion: { [weak self] result in
            guard let self = self else { return }
            self.log(action: "show", placementName: self.placementName, error: result.error)

            // For simplicity, an ad that has failed to show will be destroyed.
            if let error = result.error {
                self.fullscreenAd = nil

                // Notify the demo UI
                activityDelegate?.activityDidEnd(message: "Failed to load the advertisement.", error: error)
            }
            else {
                // Notify the demo UI
                activityDelegate?.activityDidEnd()
            }
        })
    }
}

// MARK: - Lifecycle Delegate

/// Implementation of the Chartboost Mediation fullscreen ad delegate.
extension FullscreenAdController: ChartboostMediationFullscreenAdDelegate {
    func didRecordImpression(ad: ChartboostMediationFullscreenAd) {
        log(action: "Did record impression", placementName: placementName, error: nil)
    }

    func didClick(ad: ChartboostMediationFullscreenAd) {
        log(action: "Did click", placementName: placementName, error: nil)
    }

    func didReward(ad: ChartboostMediationFullscreenAd) {
        log(action: "Did get reward", placementName: placementName, error: nil)
    }

    func didClose(ad: ChartboostMediationFullscreenAd, error: ChartboostMediationError?) {
        if let error = error {
            log(action: "Close error", placementName: placementName, error: error)
        }
        else {
            log(action: "Did close", placementName: placementName, error: nil)
        }
    }

    func didExpire(ad: ChartboostMediationFullscreenAd) {
        log(action: "Did expire", placementName: placementName, error: nil)
    }
}

// MARK: - Utility

private extension FullscreenAdController {
    /// Log lifecycle information to the console for the fullscreen advertisement.
    /// - Parameter action: What action is being logged
    /// - Parameter placementName: The placement name for the fullscreen advertisement
    /// - Parameter error: An option error that occurred
    func log(action: String, placementName: String, error: ChartboostMediationError?) {
        if let error = error {
            print("[Error] did \(action) fullscreen advertisement for placement '\(placementName)': '\(error.debugDescription)' (name: \(error.chartboostMediationCode.name), code: \(error.code))")
        }
        else {
            print("[Success] did \(action) fullscreen advertisement for placement '\(placementName)'")
        }
    }
}
