// Copyright 2022-2023 Chartboost, Inc.
// 
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

//
//  AdTypeSelectionViewController.swift
//  ChartboostMediationDemo
//
//  Copyright © 2023 Chartboost. All rights reserved.
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

    @IBOutlet private var useFullscreenToggle: UISwitch!
    @IBOutlet private var tableView: UITableView!

    /// An enumeration of each advertisement type.
    enum AdType: String, CaseIterable {
        case banner
        case interstitial
        case rewarded
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
}

extension AdTypeSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let adType = AdType.allCases[indexPath.row]
        let viewController = adType.viewController
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension AdTypeSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        AdType.allCases.count
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

extension AdTypeSelectionViewController.AdType {
    var title: String {
        rawValue.capitalized
    }

    var icon: UIImage? {
        UIImage(named: title)
    }

    var viewController: UIViewController {
        UIStoryboard(name: title, bundle: nil).instantiateViewController(withIdentifier: title)
    }
}
