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
    @StateObject var viewModel = AdQueueViewModel()

    var body: some View {
        VStack {
            Image("Queued")
                .padding(.vertical, 32)

            Text("Fullscreen ads (both Interstitial and Rewarded) can be pre-loaded in a FullscreenAdQueue")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Button {
                viewModel.toggleRunningState()
            } label: {
                Text(viewModel.runButtonText)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 32)

            HStack(spacing: 0) {
                ForEach(0..<5) { index in
                    Text(viewModel.numberOfAdsReady >= index + 1 ? "🟩" : "🔲")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity)
                }
            }

            Text("As soon as there's at least one loaded ad in the queue, you can begin showing them.")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            if let topViewController = UIApplication.topViewController {
                Button {
                    if let ad = viewModel.getNextAd() {
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
                .disabled(viewModel.numberOfAdsReady == 0)
            }

            Spacer()
        }
        .onAppear {
            viewModel.setDelegate()
        }
    }
}

// A FullscreenAdQueueDelegate can be used to receive updates about queue events.
class QueueDelegate: ObservableObject, FullscreenAdQueueDelegate {
    var viewModel: AdQueueViewModel

    init(viewModel: AdQueueViewModel) {
        self.viewModel = viewModel
    }

    func fullscreenAdQueue(_ adQueue: FullscreenAdQueue, didFinishLoadingWithResult: ChartboostMediationAdLoadResult, numberOfAdsReady: Int) {
        self.viewModel.numberOfAdsReady = numberOfAdsReady
    }

    func fullscreenAdQueueDidRemoveExpiredAd(_ adQueue: FullscreenAdQueue, numberOfAdsReady: Int) {
        print("Expired ad removed from queue, \(numberOfAdsReady) loaded ads remaining.")
        self.viewModel.numberOfAdsReady = numberOfAdsReady
    }
}

class AdQueueViewModel: ObservableObject {
    @Published var numberOfAdsReady: Int = 0
    @Published var runButtonText = "Start"
    let queue: FullscreenAdQueue = FullscreenAdQueue.queue(forPlacement: "CBInterstitial")
    var delegate: QueueDelegate?

    func setDelegate() {
        // If this function is called repeatedly, we don't want to keep recreating the QueueDelegate
        guard delegate == nil else {
            return
        }
        self.delegate = QueueDelegate(viewModel: self)
        queue.delegate = self.delegate
    }

    func toggleRunningState() {
        if queue.isRunning {
            queue.stop()
            runButtonText = "Start"
        } else {
            queue.start()
            runButtonText = "Stop"
        }
    }

    func getNextAd() -> ChartboostMediationFullscreenAd? {
        let ad = queue.getNextAd()
        numberOfAdsReady = queue.numberOfAdsReady
        return ad
    }
}
