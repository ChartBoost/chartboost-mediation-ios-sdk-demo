// Copyright 2022-2024 Chartboost, Inc.
// 
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

//
//  Collection+Extras.swift
//  ChartboostMediationDemo
//
//  Copyright © 2023-2024 Chartboost. All rights reserved.
//

import Foundation

/// An extension that is relevant for this demo only. It is not applicable to anything specific to the Chartboost Mediation SDK.
extension Collection {

    /// Convert self to a JSON String.
    /// Returns: the pretty printed JSON string or an empty string if any error occur.
    var asJsonString: String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
            return String(data: jsonData, encoding: .utf8) ?? "{}"
        } catch {
            print("json serialization error: \(error)")
            return "{}"
        }
    }
}
