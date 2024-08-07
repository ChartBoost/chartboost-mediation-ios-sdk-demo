// Copyright 2018-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import SwiftUI

/// A view that is shown while the Chartboost Mediation SDK is initializaing.
struct ChartboostMediationInititializationView: View {
    @StateObject private var chartboostMediationController = ChartboostMediationController.instance

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()

                HStack {
                    Spacer()
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.65, height: 69, alignment: .center)
                        .padding(.bottom, 14)
                    Spacer()
                }

                let initializationResult = chartboostMediationController.initializationResult
                ProgressView()
                    .progressViewStyle(.circular)
                    .padding()
                    .opacity(initializationResult == nil ? 1 : 0)

                Group {
                    if case .failure(let error) = initializationResult {
                        Text("Failed to initialize Chartboost Mediation SDK:\n\n\(error.localizedDescription)")
                    } else if case .success = initializationResult {
                        Text("Chartboost Mediation SDK initialization complete!")
                    } else {
                        Text("Initializing the Chartboost Mediation SDK...")
                    }
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                .frame(height: 48)

                Spacer()
            }
        }
    }
}
