// Copyright 2022-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

//
//  QueuedAdViewControllerAdViewController.swift
//  ChartboostMediationDemo
//
//  Copyright © 2024 Chartboost. All rights reserved.
//

import UIKit
import ChartboostMediationSDK

/// An example view controller that can queue and display fullscreen ads
///
class QueuedAdViewController: UIViewController {
    let queue: FullscreenAdQueue = FullscreenAdQueue.queue(forPlacement: "CBInterstitial")
    var queueDelegate: QueueDelegate?

    @IBOutlet weak var runButton: UIButton!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet var adSlots: [UILabel]!

    /// The handler for when the load button is pushed.  Pushing it results in the insterstitial ad being loaded.
    /// After it has successfully loaded, it can then be shown.
    @IBAction func loadButtonPushed() {
        if queue.isRunning {
            queue.stop()
        } else {
            queue.start()
        }
        updateUI()
    }

    /// The handler for when the show button is pushed.  Pushing it results in the fullscreen ad being shown if it was successfully loaded.
    @IBAction func showButtonPushed() {
        if let ad = queue.getNextAd() {
            ad.show(with: self) { _ in
            }
        }
    }

    override func viewDidLoad() {
        queueDelegate = QueueDelegate(controller: self)
        queue.delegate = queueDelegate
        updateUI()
    }

    func updateUI() {
        if queue.isRunning {
            runButton.setTitle("Stop Queue", for: .normal)
        } else {
            runButton.setTitle("Start Queue", for: .normal)
        }
        
        for (index, label) in adSlots.enumerated() {
            if index < queue.numberOfAdsReady {
                label.text = "🟩"
            } else {
                label.text = "🔲"
            }
        }

        showButton.isEnabled = queue.hasNextAd
    }

    class QueueDelegate: FullscreenAdQueueDelegate {
        let queuedAdViewController: QueuedAdViewController
        init(controller: QueuedAdViewController) {
            self.queuedAdViewController = controller
        }
        func fullscreenAdQueue(_ adQueue: FullscreenAdQueue, didFinishLoadingWithResult: ChartboostMediationAdLoadResult, numberOfAdsReady: Int) {
            queuedAdViewController.updateUI()
        }
    }

}
