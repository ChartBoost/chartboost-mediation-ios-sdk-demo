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
class FullscreenAdController: NSObject, ObservableObject {
    /// The entry point for the Chartboost Mediation SDK.
    private let chartboostMediation = Helium.shared()

    /// The placement that this controller is for.
    private let placementName: String

    /// An instance of the fullscreen ad that this class controls the lifecycle of when using the new API.
    private var fullscreenAd: ChartboostMediationFullscreenAd?

    /// A state for demo purposes only so that long activity processes can be communicated to a view.
    @Published private(set) var activityState: ActivityState = .idle

    /// A delegate for demo purposes only so that long activity processes can be communicated to a view controller.
    private weak var activityDelegate: ActivityDelegate?

    /// Initializer for the view model.
    /// - Parameter activityDelegate: A delegate to communicate the start and end of asyncronous activity to.  This is applicable only for this demo.
    /// - Parameter placementName: Placement to use.
    init(activityDelegate: ActivityDelegate?, placementName: String) {
        self.placementName = placementName
        self.activityDelegate = activityDelegate
    }

    /// Load the fullscreen ad.
    /// - Parameter keywords: Optional keywords that can be associated with the advertisement placement.
    func load(keywords: HeliumKeywords? = nil) {
        // Attempt to load the ad only if it has not already been created and requested to load.
        guard fullscreenAd == nil else {
            print("[Warning] fullscreen advertisement has already been loaded")
            return
        }

        // Notify the demo UI
        activityDelegate?.activityDidStart()
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

                self.log(action: "Load", placementName: self.placementName, error: result.error)
                // Notify the demo UI
                self.activityDelegate?.activityDidEnd()
                self.activityState = .idle
            } else {
                self.fullscreenAd = nil
                self.log(action: "Load error", placementName: self.placementName, error: result.error)

                // Notify the demo UI
                self.activityDelegate?.activityDidEnd(message: "Failed to load the advertisement.", error: result.error)
                // `.failed` requires a non-optional error type
                let error = result.error ?? NSError(domain: "com.chartboost.mediation.demo", code: 0)
                self.activityState = .failed(message: "Failed to load the fullscreen advertisement.", error: error)
            }
        }
    }

    /// Show the fullscreen ad if it has been loaded and is ready to show.
    /// - Parameter viewController: The view controller to present the fullscreen over.
    func show(with viewController: UIViewController) {
        // Attempt to show a fullscreen ad only if it has been loaded.
        guard let fullscreenAd = fullscreenAd else {
            print("[Error] cannot show a fullscreen advertisement that has not yet been loaded")
            return
        }

        // Once you've loaded a ChartboostMediationFullscreenAd, it can be shown immediately.

        // Notify the demo UI.
        activityState = .running

        // Show the ad using the specified view controller.  Upon completion, a ChartboostMediationAdShowResult will be passed to the completion block.
        fullscreenAd.show(with: viewController, completion: { [weak self] result in
            guard let self = self else { return }
            self.log(action: "show", placementName: self.placementName, error: result.error)

            // For simplicity, an ad that has failed to show will be destroyed.
            if let error = result.error {
                self.fullscreenAd = nil

                // Notify the demo UI
                self.activityDelegate?.activityDidEnd(message: "Failed to load the advertisement.", error: error)
                self.activityState = .failed(message: "Failed to show the fullscreen advertisement.", error: error)
            }
            else {
                // Notify the demo UI
                self.activityDelegate?.activityDidEnd()
                self.activityState = .idle
            }
        })
    }
}

// MARK: - Lifecycle Delegate

/// Implementation of the Chartboost Mediation fullscreen ad delegate.
extension FullscreenAdController: ChartboostMediationFullscreenAdDelegate {
    func didRecordImpression(ad: ChartboostMediationFullscreenAd) {
        log(action: "record impression", placementName: placementName, error: nil)
    }

    func didClick(ad: ChartboostMediationFullscreenAd) {
        log(action: "click", placementName: placementName, error: nil)
    }

    func didReward(ad: ChartboostMediationFullscreenAd) {
        log(action: "get reward", placementName: placementName, error: nil)
    }

    func didClose(ad: ChartboostMediationFullscreenAd, error: ChartboostMediationError?) {
        log(action: "close", placementName: placementName, error: error)
    }

    func didExpire(ad: ChartboostMediationFullscreenAd) {
        log(action: "expire", placementName: placementName, error: nil)
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
