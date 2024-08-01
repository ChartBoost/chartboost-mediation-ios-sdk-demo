// Copyright 2018-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

/// A enumeration that is relevent for this demo only. It is not applicable to anything specific to the Chartboost Mediation SDK.
enum ActivityState {
    case idle
    case running
    case failed(message: String, error: Error?)
}

extension ActivityState: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.running, .running):
            return true
        default:
            return false
        }
    }
}
