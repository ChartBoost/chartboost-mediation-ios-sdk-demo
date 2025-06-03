// Copyright 2018-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import UIKit

/// This demo uses a view controller as a means to demonstrate the initialization of the Chartboost Mediation SDK.
/// There is no requirement that a view controller must be used, but it is convenient for this demo to do so.
class ChartboostMediationInititializationViewController: UIViewController {
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private var progressLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        progressLabel.text = "Initializing the Chartboost Mediation SDK ..."
    }

    /// When the view appears, start the Chartboost Mediation SDK.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // In this demo, Chartboost Mediation initialization and general control is performed
        // within the class `ChartboostMediationController`.
        let chartboostMediationController = ChartboostMediationController.instance

        // Start up the Chartboost Mediation SDK using the `startChartboostMediation` method in the
        // example `ChartboostMediationController` class. Initialization completion is
        // communicated back using a completion handler.
        chartboostMediationController.startChartboostMediation { [weak self] result in
            self?.didCompleteInitialization(result: result)
        }
    }

    /// Method to process the result of the Chartboost Mediation initialization callback.
    private func didCompleteInitialization(result: Result<Bool, Error>) {
        activityIndicatorView.stopAnimating()
        switch result {
        case .failure(let error):
            progressLabel.text = "Failed to initialize Chartboost Mediation SDK:\n\n\(error.localizedDescription)"

        case .success:
            progressLabel.text = "Chartboost Mediation SDK initialization complete!"
            UIView.animate(withDuration: 0.5, delay: 1.0, options: []) {
                self.contentView.alpha = 0
            } completion: { _ in
                self.showAdTypeSelectionViewController()
            }
        }
    }

    /// Once initialization has completed successfully, the user interface of the demo is shown the
    /// `AdTypeSelectionViewController`.
    private func showAdTypeSelectionViewController() {
        let vc = AdTypeSelectionViewController.make()
        navigationController?.pushViewController(vc, animated: false)
    }
}
