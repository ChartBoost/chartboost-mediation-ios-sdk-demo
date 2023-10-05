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
class InterstitialAdController: NSObject, ObservableObject {
    /// The entry point for the Chartboost Mediation SDK.
    private let chartboostMediation = Helium.shared()

    /// The placement that is controller is for.
    private let placementName: String

    /// An instance of the interstitial ad that this class controls the lifecycle of when using the deprecated API.
    private var interstitialAd: HeliumInterstitialAd?

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

        // Create an interstitial ad using the deprecated Chartboost Mediation ad provider.
        self.interstitialAd = chartboostMediation.interstitialAdProvider(with: self, andPlacementName: placementName)
        guard let interstitialAd = interstitialAd else {
            // Ad creation could have failed if the placement name is invalid.
            print("[Error] failed to create interstitial advertisement for placement '\(placementName)'")
            return
        }
        // Associate any provided keywords with the advertisement before it is loaded.
        interstitialAd.keywords = keywords
        // Load the interstitial ad, which will make a request to the network. Upon completion, the
        // delegate method `heliumInterstitialAd(withPlacementName:didLoadWithError:)` will be called.
        interstitialAd.load()
    }

    /// Show the interstitial ad if it has been loaded and is ready to show.
    /// - Parameter viewController: The view controller to present the interstitial over.
    func show(with viewController: UIViewController) {
        // Attempt to show an interstitial ad only if it has been loaded.
        guard let interstitialAd = interstitialAd else {
            print("[Error] cannot show an interstitial advertisement that has not yet been loaded")
            return
        }

        // Attempt to show an ad only if it is ready to show. It will not be ready yet if any of the
        // network requests have not yet completed.
        guard interstitialAd.readyToShow() else {
            print("[Warning] not ready to show interstitial advertisement for placement '\(placementName)'")
            return
        }

        // Notify the demo UI
        activityState = .running

        // Show the ad using the specified view controller.  Upon completion, the delegate meethod
        // `heliumInterstitialAd(withPlacementName:didShowWithError:)` will be called.
        interstitialAd.show(with: viewController)
    }
}

// MARK: - Lifecycle Delegate

/// Implementation of the Chartboost Mediation interstitial ad delegate.
extension InterstitialAdController: CHBHeliumInterstitialAdDelegate {

    /// *Required* delegate callback that notifies that the ad finished loading.
    /// - Parameter placementName: The placement associated with the load completion
    /// - Parameter requestIdentifier: A unique identifier for the load request
    /// - parameter winningBidInfo: Bid information JSON.
    /// - Parameter error: An optional error associated with the load completion.
    func heliumInterstitialAd(withPlacementName placementName: String, requestIdentifier: String, winningBidInfo: [String: Any]?, didLoadWithError error: ChartboostMediationError?) {
        log(action: "load", placementName: placementName, error: error)

        // An ad that has failed to load could be cleared so that an attempt to load it can be done  on the
        // same ad object again, e.g. `interstitialAd?.clearLoadedAd()`. However, for simplicity, it will be
        // now be destroyed.
        if let error = error {
            interstitialAd = nil

            // Notify the demo UI
            activityState = .failed(message: "Failed to load the interstitial advertisement.", error: error)
        }
        else {
            // Notify the demo UI
            activityState = .idle
        }
    }

    /// *Required* delegate callback that notifies that the ad finished showing.
    /// - Parameter placementName: The placement associated with the show completion
    /// - Parameter error: An optional error associated with the show completion.
    func heliumInterstitialAd(withPlacementName placementName: String, didShowWithError error: ChartboostMediationError?) {
        log(action: "show", placementName: placementName, error: error)

        // For simplicity, an ad that has failed to show will be destroyed.
        if let error = error {
            interstitialAd = nil

            // Notify the demo UI
            activityState = .failed(message: "Failed to show the interstitial advertisement.", error: error)
        }
        else {
            // Notify the demo UI
            activityState = .idle
        }
    }

    /// *Required* delegate callback that notifies that the ad finished closing.
    /// - Parameter placementName: The placement associated with the close completion
    /// - Parameter error: An optional error associated with the close completion.
    func heliumInterstitialAd(withPlacementName placementName: String, didCloseWithError error: ChartboostMediationError?) {
        log(action: "close", placementName: placementName, error: error)

        // Since the ad has been closed, it has fulfilled its entire lifecycle and now will be destroyed.
        interstitialAd = nil
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
