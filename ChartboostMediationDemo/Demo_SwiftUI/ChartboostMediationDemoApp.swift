// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import SwiftUI

@main
struct ChartboostMediationDemoApp: App {
    @StateObject private var chartboostMediationController = ChartboostMediationController.instance
    @State private var chartboostMediationIsInitialized = false

    var body: some Scene {
        WindowGroup {
            if chartboostMediationIsInitialized {
                AdTypeSelectionView()
                    .tint(Color.chartboost)
            } else {
                ChartboostMediationInititializationView()
                    .onAppear {
                        chartboostMediationController.startChartboostMediation { result in
                            if case .success = result {
                                Task {
                                    try await Task.sleep(nanoseconds: .nanoseconds(1))
                                    await MainActor.run {
                                        withAnimation {
                                            chartboostMediationIsInitialized = true
                                        }
                                    }
                                }
                            }
                        }
                    }
            }
        }
    }
}
