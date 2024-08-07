// Copyright 2018-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import ChartboostMediationSDK
import UIKit

/// An extenstion that is relevant for this demo only. It is not applicable to anything specific to the Chartboost Mediation SDK.
extension UIViewController {
    func presentAlert(message: String, error: Error?) {
        let alertMessage: String
        if let chartboostMediationError = error as? ChartboostMediationError {
            alertMessage = "\(message)\n\n\(chartboostMediationError.localizedFailureReason ?? "Reason unspecified.")\n\n\(chartboostMediationError.chartboostMediationCode.name)"
        } else {
            alertMessage = "\(message)\n\n\(String(describing: error))"
        }
        let alert = UIAlertController(title: "Error", message: alertMessage, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
