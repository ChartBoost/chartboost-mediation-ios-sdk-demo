// Copyright 2018-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import SwiftUI

/// A view that is relevent for this demo only. It is not applicable to anything specific to the Chartboost Mediation SDK.
struct BusyView: ViewModifier {
    @Binding var isBusy: Bool

    func body(content: Content) -> some View {
        ZStack {
            content

            if isBusy {
                VStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(.circular)
                        .padding(.bottom, 64)
                        .frame(maxWidth: .infinity)
                }
                .background(Color.black.opacity(0.75))
            }
        }
    }
}

extension View {
    func busy(_ isBusy: Binding<Bool>) -> some View {
        modifier(BusyView(isBusy: isBusy))
    }
}
