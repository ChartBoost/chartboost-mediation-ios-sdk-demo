// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

//
//  InterstitialAdController.swift
//  ChartboostMediationDemo
//
//  Copyright © 2023 Chartboost. All rights reserved.
//

import UIKit
import ChartboostMediationSDK

/// A basic implementation of a controller for Chartboost Mediation interstitial ads.  It is capable of loading and showing a full screen interstitial ad
/// for a single placement.  This controller is also its own `CHBHeliumInterstitialAdDelegate` so that it is in full control
/// of the ad's lifecycle.
class FullscreenAdController: NSObject, ObservableObject {
    /// The entry point for the Chartboost Mediation SDK.
    private let chartboostMediation = Helium.shared()

    /// The placement that this controller is for.
    private let placementName: String

    /// An instance of the fullscreen ad that this class controls the lifecycle of when using the new API.
    private var fullscreenAd: ChartboostMediationFullscreenAd?

    /// A state for demo purposes only so that long activity processes can be communicated to a view.
    @Published private(set) var activityState: ActivityState = .idle

    /// Initializer for the view model.
    /// - Parameter placementName: Placement to use.
    init(placementName: String) {
        self.placementName = placementName
    }

    /// Load the interstitial ad.
    /// - Parameter keywords: Optional keywords that can be associated with the advertisement placement.
    func load(keywords: HeliumKeywords? = nil) {
        // Attempt to load the ad only if it has not already been created and requested to load.
        guard interstitialAd == nil else {
            print("[Warning] interstitial advertisement has already been loaded")
            return
        }

        // Notify the demo UI
        activityState = .running

        // loadFullscreenAd expects keywords to be `[String : String]` instead of `HeliumKeywords?`.
        let keywords = keywords?.dictionary ?? [:]
        let request = ChartboostMediationAdLoadRequest(placement: placementName, keywords: keywords)
        // Load the fullscreen ad, which will make a request to the network. Upon completion, a
        // ChartboostMediationFullscreenAdLoadResult will be passed to the completion block.
        chartboostMediation.loadFullscreenAd(with: request) { [weak self] result in
            guard let self = self else { return }
            if let ad = result.ad {
                ad.delegate = self
                self.fullscreenAd = ad

                log(action: "load", placementName: placementName, error: result.error)
                // Notify the demo UI
                activityState = .idle
            } else {
                fullscreenAd = nil
                self.log(action: "Load error", placementName: placementName, error: result.error)

                // `.failed` requires a non-optional error type
                let error = result.error ?? NSError(domain: "com.chartboost.mediation.demo", code: 0)
                // Notify the demo UI
                activityState = .failed(message: "Failed to load the interstitial advertisement.", error: error)
            }
        }
    }

    /// Show the interstitial ad if it has been loaded and is ready to show.
    /// - Parameter viewController: The view controller to present the interstitial over.
    func show(with viewController: UIViewController) {
        // Attempt to show a fullscreen ad only if it has been loaded.
        guard let fullscreenAd = fullscreenAd else {
            print("[Error] cannot show a fullscreen advertisement that has not yet been loaded")
            return
        }

        // ChartboostMediationFullscreenAd does not have an equivalent to HeliumInterstitialAd's readyToShow().

        // Notify the demo UI.
        activityState = .running

        // Show the ad using the specified view controller.  Upon completion, instead of using a delegate
        // method a ChartboostMediationAdShowResult will be passed to the completion block.
        fullscreenAd.show(with: viewController, completion: { [weak self] result in
            guard let self = self else { return }
            self.log(action: "show", placementName: self.placementName, error: result.error)

            // For simplicity, an ad that has failed to show will be destroyed.
            if let error = result.error {
                self.fullscreenAd = nil

                // Notify the demo UI
                self.activityState = .failed(message: "Failed to show the fullscreen advertisement.", error: error)
            }
            else {
                // Notify the demo UI
                self.activityState = .idle
            }
        })
    }
}

// MARK: - Lifecycle Delegate

/// Implementation of the Chartboost Mediation fullscreen ad delegate.
extension InterstitialAdController: ChartboostMediationFullscreenAdDelegate {
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

private extension InterstitialAdController {
    /// Log lifecycle information to the console for the interstitial advertisement.
    /// - Parameter action: What action is being logged
    /// - Parameter placementName: The placement name for the interstitial advertisement
    /// - Parameter error: An option error that occurred
    func log(action: String, placementName: String, error: ChartboostMediationError?) {
        if let error = error {
            print("[Error] did \(action) interstitial advertisement for placement '\(placementName)': '\(error.debugDescription)' (name: \(error.chartboostMediationCode.name), code: \(error.code))")
        }
        else {
            print("[Success] did \(action) interstitial advertisement for placement '\(placementName)'")
        }
    }
}
