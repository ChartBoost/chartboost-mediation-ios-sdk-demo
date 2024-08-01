// Copyright 2018-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import ChartboostMediationSDK
import SwiftUI
import UIKit

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
                            } else {
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
    }
}

class AdQueueViewModel: ObservableObject {
    @Published var numberOfAdsReady: Int = 0
    @Published var runButtonText = "Start"
    let queue = FullscreenAdQueue.queue(forPlacement: "CBInterstitial")

    init() {
        queue.delegate = self
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

    func getNextAd() -> FullscreenAd? {
        let ad = queue.getNextAd()
        numberOfAdsReady = queue.numberOfAdsReady
        return ad
    }
}

// A FullscreenAdQueueDelegate can be used to receive updates about queue events.
extension AdQueueViewModel: FullscreenAdQueueDelegate {
    func fullscreenAdQueue(_ adQueue: FullscreenAdQueue, didFinishLoadingWithResult result: AdLoadResult, numberOfAdsReady: Int) {
        self.numberOfAdsReady = numberOfAdsReady
    }

    func fullscreenAdQueueDidRemoveExpiredAd(_ adQueue: FullscreenAdQueue, numberOfAdsReady: Int) {
        print("Expired ad removed from queue, \(numberOfAdsReady) loaded ads remaining.")
        self.numberOfAdsReady = numberOfAdsReady
    }
}
