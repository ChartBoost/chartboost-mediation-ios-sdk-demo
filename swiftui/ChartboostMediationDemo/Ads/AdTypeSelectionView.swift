// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

//
//  AdTypeSelectionView.swift
//  ChartboostMediationDemo
//
//  Copyright © 2023 Chartboost. All rights reserved.
//

import SwiftUI

/// A view that lists the different Chartboost Mediation SDK advertisement types. Selecting one will
/// navigate to a view that can be used to load and show that type of advertisement.
struct AdTypeSelectionView: View {
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    HStack {
                        Spacer()
                        Image("Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width * 0.65, height: 69, alignment: .center)
                            .padding(.vertical, 8)
                        Spacer()
                    }

                    List {
                        ForEach(AdType.allCases, id: \.self) { adType in
                            NavigationLink(destination: adType.destination) {
                                HStack {
                                    adType.icon
                                    Text(adType.title)
                                        .font(.title2)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .listRowSeparatorTint(.accentColor)
                }
            }
        }
    }
}

extension AdType {
    @ViewBuilder var destination: some View {
        GeometryReader { geometry in
            ScrollView {
                Group {
                    switch self {
                    case .banner:
                        BannerAdView()
                    case .interstitial:
                        InterstitialAdView()
                    case .rewarded:
                        RewardedAdView()
                    }
                }
                .frame(minHeight: geometry.size.height)
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .edgesIgnoringSafeArea([.leading, .trailing, .bottom])
    }
}
