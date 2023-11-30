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

/// A view that demonstrates the loading and showing of a Chartboost Mediation SDK fullscreen advertisement.
@available(iOS 15.0, *)
struct FullscreenAdView: View {
    @StateObject private var controller: FullscreenAdController
    @State private var isBusy = false
    @State private var failureMessage: String?
    private let adType: AdType

    var body: some View {
        VStack {
            if adType == .interstitial {
                Image("Interstitial")
                    .padding(.vertical, 32)
            } else if adType == .rewarded {
                Image("Rewarded")
                    .padding(.vertical, 32)
            }

            Text("A full screen \(adType.title) advertisement must first be loaded.")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Button {
                controller.load()
            } label: {
                Text("Load")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 32)

            if let topViewController = UIApplication.topViewController {
                Image("arrow-down")

                Text("After it has been successfully loaded it can then be shown.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Button {
                    controller.show(with: topViewController)
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
        .busy($isBusy)
        .onChange(of: controller.activityState) { newState in
            switch newState {
            case .running:
                isBusy = true
            case .failed(let message, let error):
                isBusy = false
                failureMessage = "\(message): \(error?.localizedDescription ?? "")"
            default:
                isBusy = false
            }
        }
    }

    init(adType: AdType, placementName: String) {
        self.adType = adType
        self._controller = StateObject(wrappedValue: FullscreenAdController(activityDelegate: nil, placementName: placementName))
    }
}
