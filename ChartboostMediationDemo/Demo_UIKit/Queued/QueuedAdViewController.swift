// Copyright 2018-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import ChartboostMediationSDK
import UIKit

/// An example view controller that can queue and display fullscreen ads
///
class QueuedAdViewController: UIViewController {
    // A FullscreenAdQueue can only load ads for a single mediation placement, and
    // for each placement ID there can only be one FullscreenAdQueue.
    let queue = FullscreenAdQueue.queue(forPlacement: "CBInterstitial")

    @IBOutlet weak var runButton: UIButton!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet var adSlots: [UILabel]!

    /// The handler for when the run button is pushed. Pushing it starts or stops the queue.
    @IBAction func runButtonPushed() {
        if queue.isRunning {
            queue.stop()
        } else {
            queue.start()
        }
        updateUI()
    }

    /// The handler for when the show button is pushed. Pushing it results in the fullscreen ad being shown if it was successfully loaded.
    @IBAction func showButtonPushed() {
        // getNextAd() returns the oldest ad in the queue, or nil if the queue is empty.
        if let ad = queue.getNextAd() {
            // Update the UI now that an ad has been removed from the queue
            updateUI()
            ad.show(with: self) { _ in
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting a delegate so we can react when ads are loaded.
        queue.delegate = self
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
}

// A FullscreenAdQueueDelegate can be used to receive updates about queue events.
extension QueuedAdViewController: FullscreenAdQueueDelegate {
    func fullscreenAdQueue(_ adQueue: FullscreenAdQueue, didFinishLoadingWithResult result: AdLoadResult, numberOfAdsReady: Int) {
        updateUI()
    }

    func fullscreenAdQueueDidRemoveExpiredAd(_ adQueue: FullscreenAdQueue, numberOfAdsReady: Int) {
        print("Expired ad removed from queue, \(numberOfAdsReady) loaded ads remaining.")
    }
}
