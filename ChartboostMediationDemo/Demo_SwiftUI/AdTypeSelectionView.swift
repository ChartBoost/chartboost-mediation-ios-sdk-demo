// Copyright 2018-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import ChartboostMediationSDK
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
                            NavigationLink(destination: adView(forAdType: adType)) {
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

    @ViewBuilder
    func adView(forAdType adType: AdType) -> some View {
        GeometryReader { geometry in
            ScrollView {
                Group {
                    switch adType {
                    case .banner:
                        BannerView(placementName: "CBAdaptiveBanner")
                    case .interstitial:
                        FullscreenAdView(adType: adType, placementName: "CBInterstitial")
                    case .rewarded:
                        FullscreenAdView(adType: adType, placementName: "CBRewarded")
                    case .queued:
                        QueuedAdView()
                    }
                }
                .frame(minHeight: geometry.size.height)
            }
        }
        .navigationTitle(adType.title)
        .navigationBarTitleDisplayMode(.inline)
        .edgesIgnoringSafeArea([.leading, .trailing, .bottom])
    }
}

extension AdType {
    /// An icon that represents the ad type.
    fileprivate var icon: Image {
        Image(title)
    }
}
