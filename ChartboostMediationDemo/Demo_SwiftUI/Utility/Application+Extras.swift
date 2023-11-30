// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

//
//  Application+Extras.swift
//  ChartboostMediationDemo
//
//  Copyright © 2023 Chartboost. All rights reserved.
//

import UIKit

@available(iOS 15.0, *)
extension UIApplication {
    class var topViewController: UIViewController? {
        guard
            let windowScene = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).first,
            let keyWindow = windowScene.keyWindow,
            var rootViewController = keyWindow.rootViewController
        else {
            return nil
        }
        while let presentedViewController = rootViewController.presentedViewController {
            rootViewController = presentedViewController
        }
        return rootViewController
    }
}
