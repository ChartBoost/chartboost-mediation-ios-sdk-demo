// Copyright 2022-2023 Chartboost, Inc.
// 
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

//
//  AppDelegate.swift
//  ChartboostMediationDemo
//
//  Copyright © 2023 Chartboost. All rights reserved.
//

import UIKit
import SwiftUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    /// Set to true to run the app with the SwiftUI integration
    let useSwiftUIView = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)

        if #available(iOS 15.0, *), useSwiftUIView {
            // Load SwiftUI View
            let contentView = ChartboostMediationMainView()
            window?.rootViewController = UIHostingController(rootView: contentView)
        } else {
            // Load Storyboard UIKit View
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            window?.rootViewController = storyboard.instantiateInitialViewController()
        }

        window?.makeKeyAndVisible()

        return true
    }
}
