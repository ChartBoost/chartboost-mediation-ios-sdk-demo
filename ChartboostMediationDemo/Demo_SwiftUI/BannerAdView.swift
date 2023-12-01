// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

//
//  BannerAdView.swift
//  ChartboostMediationDemo
//
//  Copyright © 2023 Chartboost. All rights reserved.
//

import UIKit
import SwiftUI

/// A view that demonstrates the loading and showing of a Chartboost Mediation SDK banner advertisement.
struct BannerAdView: View {
    @StateObject private var controller: BannerAdController
    @State private var isBusy = false
    @State private var failureMessage: String?
    @State private var shouldShow = false

    var body: some View {
        VStack {
            Image("Banner")
                .padding(.vertical, 32)

            if let topViewController = UIApplication.topViewController {
                Text("A banner advertisement must first be loaded.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Button {
                    controller.load(with: topViewController, width: topViewController.view.frame.width)
                } label: {
                    Text("Load")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(height: 48)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal, 32)

                Image("arrow-down")

                Text("After it has been successfully loaded it can then be shown by adding it anywhere in the view hierarchy.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Button {
                    shouldShow = true
                } label: {
                    Text("Show")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(height: 48)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal, 32)

                if shouldShow, let bannerAd = controller.bannerAd, let size = bannerAd.size?.size {
                    Spacer()
                    HStack {
                        Banner(source: bannerAd)
                            .frame(width: size.width, height: size.height)
                    }
                }
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
                failureMessage = message + (error.map { ": \($0.localizedDescription)" } ?? "")
            default:
                isBusy = false
            }
        }
    }

    init(placementName: String) {
        self._controller = StateObject(wrappedValue: BannerAdController(placementName: placementName, activityDelegate: nil))
    }
}
