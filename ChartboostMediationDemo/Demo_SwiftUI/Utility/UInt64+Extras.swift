// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

//
//  UInt64+Extras.swift
//  ChartboostMediationDemo
//
//  Copyright © 2023 Chartboost. All rights reserved.
//

import Foundation

/// A n extension that is relevent for this demo only. It is not applicable to anything specific to the Chartboost Mediation SDK.
extension UInt64 {
    /// Convert a time interval to a `UInt64` of nanoseconds.
    static func nanoseconds(_ interval: TimeInterval) -> UInt64 {
        UInt64(1_000_000_000 * interval)
    }
}
