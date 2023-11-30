// Copyright 2022-2023 Chartboost, Inc.
// 
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

//
//  RewardedAdController.swift
//  ChartboostMediationDemo
//
//  Copyright © 2023 Chartboost. All rights reserved.
//

import UIKit
import ChartboostMediationSDK

/// A basic implementation of a controller for Chartboost Mediation rewarded ads.  It is capable of loading and showing a full screen rewarded ad
/// for a single placement.  This controller is also its own `CHBHeliumRewardedAdDelegate` so that it is in full control
/// of the ad's lifecycle.
class RewardedAdController: NSObject, ObservableObject {
    /// The entry point for the Chartboost Mediation SDK.
    private let chartboostMediation = Helium.shared()

    /// The placement that is controller is for.
    private let placementName: String

    /// An instance of the rewarded ad that this class controls the lifecycle of.
    private var rewardedAd: HeliumRewardedAd?

    /// A state for demo purposes only so that long activity processes can be communicated to a view.
    @Published private(set) var activityState: ActivityState = .idle

    /// A delegate for demo purposes only so that long activity processes can be communicated to a view controller.
    private weak var activityDelegate: ActivityDelegate?

    /// Initializer for the view model.
    /// - Parameter placementName: Placement to use.
    /// - Parameter activityDelegate: A delegate to communicate the start and end of asyncronous activity to.  This is applicable only for this demo.
    init(placementName: String, activityDelegate: ActivityDelegate) {
        self.placementName = placementName
        self.activityDelegate = activityDelegate
    }

    /// Load the rewarded ad.
    /// - Parameter keywords: Optional keywords that can be associated with the advertisement placement.
    func load(keywords: HeliumKeywords? = nil) {
        // Attempt to load the ad only if it has not already been created and requested to load.
        guard rewardedAd == nil else {
            print("[Warning] rewarded advertisement has already been loaded")
            return
        }

        // Create an rewarded ad from the Chartboost Mediation ad provider.
        guard let rewardedAd = chartboostMediation.rewardedAdProvider(with: self, andPlacementName: placementName) else {
            // It could fail if the placement name is invalid.
            print("[Error] failed to create rewarded advertisement for placement '\(placementName)'")
            return
        }
        self.rewardedAd = rewardedAd

        // Notify the demo UI
        activityDelegate?.activityDidStart()
        activityState = .running

        // Associate any provided keywords with the advertisement before it is loaded.
        rewardedAd.keywords = keywords

        // Load the rewarded ad, which will make a request to the network. Upon completion, the
        // delegate method `heliumRewardedAd(withPlacementName:didLoadWithError:)` will be called.
        rewardedAd.load()
    }

    /// Show the rewarded ad if it has been loaded and is ready to show.
    /// - Parameter viewController: The view controller to present the rewarded advertisement over.
    func show(with viewController: UIViewController) {
        // Attempt to show an ad only if it has been loaded.
        guard let rewardedAd = rewardedAd else {
            print("[Error] cannot show an rewarded advertisement that has not yet been loaded")
            return
        }

        // Attempt to show an ad only if it is ready to show. It will not be ready yet if any of the
        // network requests have not yet completed.
        guard rewardedAd.readyToShow() else {
            print("[Warning] not ready to show rewarded advertisement for placement '\(placementName)'")
            return
        }

        // Notify the demo UI
        activityState = .running

        // Show the ad using the specified view controller.  Upon completion, the delegate meethod
        // `heliumRewardedAd(withPlacementName:didShowWithError:)` will be called.
        rewardedAd.show(with: viewController)
    }
}

// MARK: - Lifecycle Delegate

/// Implementation of the Chartboost Mediation rewarded ad delegate.
extension RewardedAdController: CHBHeliumRewardedAdDelegate {

    /// *Required* delegate callback that notifies that the ad finished loading.
    /// - Parameter placementName: The placement associated with the load completion
    /// - Parameter requestIdentifier: A unique identifier for the load request
    /// - parameter winningBidInfo: Bid information JSON.
    /// - Parameter error: An optional error associated with the load completion.
    func heliumRewardedAd(withPlacementName placementName: String, requestIdentifier: String, winningBidInfo: [String: Any]?, didLoadWithError error: ChartboostMediationError?) {
        log(action: "load", placementName: placementName, error: error)

        // An ad that has failed to load could be cleared so that an attempt to load it can be done  on the
        // same ad object again, e.g. `rewardedAd?.clearLoadedAd()`. However, for simplicity, it will be
        // now be destroyed.
        if let error = error {
            rewardedAd = nil

            // Notify the demo UI
            activityDelegate?.activityDidEnd(message: "Failed to load the rewarded advertisement.", error: error)
            activityState = .failed(message: "Failed to load the rewarded advertisement.", error: error)
        }
        else {
            // Notify the demo UI
            activityDelegate?.activityDidEnd()
            activityState = .idle
        }
    }

    /// *Required* delegate callback that notifies that the ad finished showing.
    /// - Parameter placementName: The placement associated with the show completion
    /// - Parameter error: An optional error associated with the show completion.
    func heliumRewardedAd(withPlacementName placementName: String, didShowWithError error: ChartboostMediationError?) {
        log(action: "show", placementName: placementName, error: error)

        // For simplicity, an ad that has failed to show will be destroyed.
        if let error = error {
            rewardedAd = nil

            // Notify the demo UI
            activityDelegate?.activityDidEnd(message: "Failed to show the rewarded advertisement.", error: error)
            activityState = .failed(message: "Failed to show the rewarded advertisement.", error: error)
        }
        else {
            // Notify the demo UI
            activityDelegate?.activityDidEnd()
            activityState = .idle
        }
    }

    /// *Required* delegate callback that notifies that the ad finished closing.
    /// - Parameter placementName: The placement associated with the close completion
    /// - Parameter error: An optional error associated with the close completion.
    func heliumRewardedAd(withPlacementName placementName: String, didCloseWithError error: ChartboostMediationError?) {
        log(action: "close", placementName: placementName, error: error)

        // Since the ad has been closed, it has fulfilled its entire lifecycle and now will be destroyed.
        rewardedAd = nil
    }

    /// *Required* delegate callbat that notifies that the reward is able to be given.
    /// - Parameter placementName: The placement associated with the reward notification
    func heliumRewardedAdDidGetReward(withPlacementName placementName: String) {
        log(action: "reward", placementName: placementName, error: nil)

    }
}

// MARK: - Utility

private extension RewardedAdController {
    /// Log lifecycle information to the console for the rewarded advertisement.
    /// - Parameter action: What action is being logged
    /// - Parameter placementName: The placement name for the rewarded advertisement
    /// - Parameter error: An option error that occurred
    func log(action: String, placementName: String, error: ChartboostMediationError?) {
        if let error = error {
            print("[Error] did \(action) rewarded advertisement for placement '\(placementName)': '\(error.debugDescription)' (name: \(error.chartboostMediationCode.name), code: \(error.code))")
        }
        else {
            print("[Success] did \(action) rewarded advertisement for placement '\(placementName)'")
        }
    }
}
