// Copyright 2018-2025 Chartboost, Inc.
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
                    .task {
                        chartboostMediationController.startChartboostMediation { result in
                            if case .success = result {
                                Task {
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
