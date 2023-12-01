// Copyright 2022-2023 Chartboost, Inc.
// 
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

//
//  Colors.swift
//  ChartboostMediationDemo
//
//  Copyright © 2023 Chartboost. All rights reserved.
//

import SwiftUI
import UIKit

/// An extension that is relevant for this demo only. It is not applicable to anything specific to the Chartboost Mediation SDK.
extension UIColor {
    static let chartboost = UIColor(red: 123/255, green: 190/255, blue: 56/255, alpha: 1)
}

@available(iOS 13.0, *)
extension Color {
    static let chartboost = Color(red: 123/255, green: 190/255, blue: 56/255)
}
