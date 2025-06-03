// Copyright 2018-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

/// A protocol that is relevent for this demo only. It is not applicable to anything specific to the Chartboost Mediation SDK.
protocol ActivityDelegate: AnyObject {
    func activityDidStart()
    func activityDidEnd()
    func activityDidEnd(message: String, error: Error?)
}
