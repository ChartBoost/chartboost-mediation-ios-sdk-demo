// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

//
//  AdAnchor.swift
//  ChartboostMediationDemo
//
//  Copyright © 2023 Chartboost. All rights reserved.
//

import SwiftUI

extension View {

    /// The Chartboost Mediation SDK requires a `UIViewController` to be provided in its full screen show and banner load APIs.
    /// The purpose of this `AdAnchor` is to be able to provide a `UIViewController` within the scope of a SwiftUI `View` that
    /// will be the host of advertisements.  For any such `View`, add this view modifier to a view within it.  When the view is
    /// presented, the `didMake` callback will provide the instance of a `UIViewController` that can be used to
    /// provide to the Chartboost Mediation SDK APIs,
    func adAnchor(didMake: @escaping (UIViewController) -> ()) -> some View {
        modifier(AdAnchorViewModifier(didMake: didMake))
    }
}

private struct AdAnchor: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController

    let didMake: (UIViewController) -> ()

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        Task {
            await MainActor.run {
                didMake(viewController)
            }
        }
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {

    }
}

private struct AdAnchorViewModifier: ViewModifier {
    let didMake: (UIViewController) -> ()

    func body(content: Content) -> some View {
        ZStack {
            content
            AdAnchor(didMake: didMake)
                .opacity(0)
        }
    }
}
