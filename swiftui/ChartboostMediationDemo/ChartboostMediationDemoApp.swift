// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

//
//  ChartboostMediationDemoApp.swift
//  ChartboostMediationDemo
//
//  Copyright © 2023 Chartboost. All rights reserved.
//

import SwiftUI

@main
struct ChartboostMediationDemoApp: App {
    @StateObject private var chartboostMediationController = ChartboostMediationController.instance
    @State private var chartboostMediationIsInitialized = false

    var body: some Scene {
        WindowGroup {
            if chartboostMediationIsInitialized {
                AdTypeSelectionView()
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
