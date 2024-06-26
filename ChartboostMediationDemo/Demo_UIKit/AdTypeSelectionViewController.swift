// Copyright 2022-2024 Chartboost, Inc.
// 
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

//
//  AdTypeSelectionViewController.swift
//  ChartboostMediationDemo
//
//  Copyright © 2023-2024 Chartboost. All rights reserved.
//

import UIKit

/// This demo uses this view controller as the entry point for selecting the different advertisement types that the
/// Chartboost Mediation SDK provides.  These include:
/// - Banners
/// - Full screen interstitials
/// - Full screen rewarded videos
///
/// To see how to utilize banner advertisements, look at the following classes:
/// - `BannerAdController`
/// - `BannerAdViewController`
///
/// To see how to utilize interstitial advertisements, look at the following classes:
/// - `InterstitialAdController`
/// - `InterstitialAdViewController`
///
/// To see how to utilize rewarded advertisemetns, look at the following classes:
/// - `RewardedAdController`
/// - `RewardedAdViewController`
/// 
class AdTypeSelectionViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!
    @IBOutlet var apiToggle: UISwitch!

    @IBAction func apiToggleDidChange(_ sender: UISwitch) {
        // The "queued" option should be hidden when not using the Fullscreen API
        tableView.reloadData()
    }

    // MARK: - Lifecycle

    /// Make an instace of this view controller.
    class func make() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "AdTypeSelection")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AdTypeSelectionCell")
        tableView.separatorColor = .chartboost
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func adView(forAdType adType: AdType) -> UIViewController? {
        let title = adType.title
        if apiToggle.isOn {
            // If we're using the fullscreen API, we need to set the ad type for Rewarded & Interstitial
            switch adType {
            case .banner:
                // For banner, we do exactly the same thing as in the non-useFullscreeenAPI case
                return UIStoryboard(name: title, bundle: nil).instantiateViewController(withIdentifier: title)
            // The FullscreenAd API is used for both interstitial and rewarded ads
            case .interstitial:
                // A cast to FullscreenAdViewController is necessary so we can set .adType
                let interstitialViewController = UIStoryboard(name: "Fullscreen", bundle: nil)
                    .instantiateViewController(withIdentifier: "Fullscreen") as? FullscreenAdViewController
                interstitialViewController?.adType = adType
                return interstitialViewController
            case .rewarded:
                // A cast to FullscreenAdViewController is necessary so we can set .adType
                let rewardedViewController = UIStoryboard(name: "Fullscreen", bundle: nil)
                    .instantiateViewController(withIdentifier: "Fullscreen") as? FullscreenAdViewController
                rewardedViewController?.adType = adType
                return rewardedViewController
            case .queued:
                let queuedAdViewController = UIStoryboard(name: "Queued", bundle: nil)
                    .instantiateViewController(withIdentifier: "Queued") as? QueuedAdViewController
                return queuedAdViewController
            }
        } else {
            return UIStoryboard(name: title, bundle: nil).instantiateViewController(withIdentifier: title)
        }
    }
}

extension AdTypeSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let adType = AdType.allCases[indexPath.row]
        // The cast in adView(forAdType:) should always succeed, but since we have to unwrap the
        // optional at some point we might as well catch it if there's a problem.
        guard let viewController = adView(forAdType: adType) else {
            assertionFailure("Could not create view for Ad")
            return
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension AdTypeSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If we're not using the Fullscreen API, hide the final AdType (which we expect to be "queued")
        if apiToggle.isOn {
            return AdType.allCases.count
        } else {
            return AdType.allCases.count - 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let adType = AdType.allCases[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdTypeSelectionCell", for: indexPath)
        cell.imageView?.image = adType.icon
        cell.textLabel?.font = .preferredFont(forTextStyle: .title1, compatibleWith: nil)
        cell.textLabel?.text = adType.title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

private extension AdType {
    var icon: UIImage? {
        UIImage(named: title)
    }
}
