// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

//
//  FullscreenAdView.swift
//  ChartboostMediationDemo
//
//  Copyright © 2023 Chartboost. All rights reserved.
//

import UIKit
import SwiftUI
import ChartboostMediationSDK

/// A view that demonstrates the loading and showing of a Chartboost Mediation SDK fullscreen advertisement.
struct QueuedAdView: View {
    @ObservedObject private var delegate: QueueDelegate
    @State private var failureMessage: String?
    @State private var runButtonText: String = "Start"
    private let queue: FullscreenAdQueue

    var body: some View {
        VStack {
            Image("Queued")
                .padding(.vertical, 32)

            Text("Fullscreen ads (both Interstitial and Rewarded) can be pre-loaded in a FullscreenAdQueue")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Button {
                if queue.isRunning {
                    queue.stop()
                    runButtonText = "Start"
                } else {
                    queue.start()
                    runButtonText = "Stop"
                }
            } label: {
                // FullscreenAdQueue does some work in a background thread when starting or stopping,
                // so if we try to update the button label by checking queue.isRunning it will not
                // have changed in time. We have to keep track of the correct label text ourself.
                Text(runButtonText)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 32)

            HStack(spacing: 0) { // Adjust spacing to your preference
                ForEach(0..<5) { index in
                    Text(delegate.numberOfAdsReady >= index + 1 ? "🟩" : "🔲")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity)
                }
            }

            Text("As soon as there's at least one loaded ad in the queue, you can begin showing them.")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)


            if let topViewController = UIApplication.topViewController {
                Button {
                    if let ad = queue.getNextAd() {
                        ad.show(with: topViewController) { result in
                            if let error = result.error {
                                print("[Error] showing fullscreen advertisement (name: \(error.chartboostMediationCode.name), code: \(error.code))")
                            }
                            else {
                                print("[Success] did show fullscreen advertisement for placement")
                            }
                        }
                    }
                } label: {
                    Text("Show")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(height: 48)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal, 32)
            }

            if let failureMessage = failureMessage {
                Text(failureMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            Spacer()
        }
    }

    init(queue: FullscreenAdQueue) {
        let delegate = QueueDelegate()
        queue.delegate = delegate
        self.delegate = delegate
        self.queue = queue
    }
}

// A FullscreenAdQueueDelegate can be used to receive updates about queue events.
class QueueDelegate: ObservableObject, FullscreenAdQueueDelegate {
    @Published var numberOfAdsReady: Int = 0

    func fullscreenAdQueue(_ adQueue: FullscreenAdQueue, didFinishLoadingWithResult: ChartboostMediationAdLoadResult, numberOfAdsReady: Int) {
        self.numberOfAdsReady = numberOfAdsReady
    }
    func fullscreenAdQueueDidRemoveExpiredAd(_ adQueue: FullscreenAdQueue, numberOfAdsReady: Int) {
        print("Expired ad removed from queue, \(numberOfAdsReady) loaded ads remaining.")
    }
}
