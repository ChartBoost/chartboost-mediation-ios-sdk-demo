// Copyright 2022-2023 Chartboost, Inc.
// 
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

//
//  ChartboostMediationController.swift
//  ChartboostMediationDemo
//
//  Copyright © 2023 Chartboost. All rights reserved.
//

import ChartboostMediationSDK

/// This class is used by this demo to initialize the Chartboost Mediation SDK, manages the user's various privacy settings, and shows how impression
/// level revenue data (ILRD) can be received within an application.  See `ChartboostMediationInititializationViewController` to see where
/// the `startHelium(completion:)` method is used.
class ChartboostMediationController: NSObject, ObservableObject {
    /// The unique application identifier that is supplied by the Chartboost Mediation developer dashboard.
    let appIdentifier: String = "59c04299d989d60fc5d2c782"

    /// The unique application signature that is supplied by the Chartboost Mediation developer dashboard.
    let appSignature: String = "6deb8e06616569af9306393f2ce1c9f8eefb405c"

    /// A static instance of this class so that it can be easily accessible throughout the application.
    static let instance: ChartboostMediationController = ChartboostMediationController()

    /// The shared instances of the Chartboost Mediation SDK.
    let chartboostMediation = Helium.shared()

    /// A convenient structure that defines a user's GDPR privacy settings.
    /// For more information about GDPR, see: https://answers.chartboost.com/en-us/articles/115001489613
    struct GDPR {
        /// Indicates that the user is subject to GDPR.
        let isSubject: Bool

        /// If the user is subject to GDPR, this flag indicates that the user
        /// has or has not given consent to allow the collection of Personally Identifiable Information.
        let hasGivenConsent: Bool

        /// The default GDPR value for the application.
        static let `default`: GDPR = .init(isSubject: false, hasGivenConsent: true)
    }

    /// The result of initialization.
    @Published private(set) var initializationResult: Result<Bool, Error>?

    /// A property that can be used to define and update the user's GDPR settings.
    /// For more information about GDPR, see: https://answers.chartboost.com/en-us/articles/115001489613
    var gdpr: GDPR = .default {
        didSet {
            // When the property is modified, the SDK needs to be notified of the changes.
            update(gdpr: gdpr)
        }
    }

    /// A property that can be used to define and update if the user is subject to COPPA.
    /// For more information about COPPA, see: https://answers.chartboost.com/en-us/articles/115001488494
    var coppa: Bool = false {
        didSet {
            // When the property is modified, the SDK needs to be notified of the changes.
            update(coppa: coppa)
        }
    }

    /// A property that can be used to define and update if the CCPA-applicable user has granted consent to the collection of Personally Identifiable Information.
    /// For more information about CCPA, see: https://answers.chartboost.com/en-us/articles/115001490031
    var ccpa: Bool? {
        didSet {
            // When the property is modified, the SDK needs to be notified of the changes.
            update(ccpa: ccpa)
        }
    }

    /// Before any advertisements can be loaded and shown, the Chartboost Mediation SDK must be initialized. This method should only be called once.
    /// - Parameter completion: A completion handler that is called once the SDK has completed initialization.
    func startChartboostMediation(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard completionHandler == nil else {
            fatalError("Chartboost Mediation initialization is already in progress")
        }
        self.completionHandler = completion

        // * Required *
        // Communicate user privacy settings to the Chartboost Mediation SDK
        update(gdpr: gdpr)
        update(coppa: coppa)
        update(ccpa: ccpa)

        // * Optional *
        // Register for impression level revenue data notifications. The Chartboost Mediation SDK publishes this data on the `default`
        // instances of the NotificationCenter. In this demo, the method `didReceiveImpressionLevelTrackingData` receives
        // this data, parses it, and logs it to the console.
        let notificationCenter: NotificationCenter = .default
        notificationCenter.addObserver(self, selector: #selector(didReceiveImpressionLevelTrackingData(notification:)), name: .heliumDidReceiveILRD, object: nil)

        // * Required *
        // Start the Chartboost Mediation SDK using the application identifier, application signature, and
        // an instance of the `HeliumSdkDelegate` in order to be notified when Chartboost Mediation initialization
        // has completed.
        chartboostMediation.start(withAppId: appIdentifier, andAppSignature: appSignature, options: nil, delegate: self)
    }

    // MARK: - Private

    private var completionHandler: ((Result<Bool, Error>) -> Void)?

    private func update(gdpr: GDPR) {
        chartboostMediation.setSubjectToGDPR(gdpr.isSubject)
        if gdpr.isSubject {
            chartboostMediation.setUserHasGivenConsent(gdpr.hasGivenConsent)
        }
    }

    private func update(coppa: Bool) {
        chartboostMediation.setSubjectToCoppa(coppa)
    }

    private func update(ccpa: Bool?) {
        guard let ccpa = ccpa else {
            return
        }
        chartboostMediation.setCCPAConsent(ccpa)
    }

    @objc private func didReceiveImpressionLevelTrackingData(notification: Notification) {
        guard let ilrd = notification.object as? HeliumImpressionData else {
            return
        }
        print("[ILRD] received impression level tracking data")
        print("[ILRD] %@", ilrd.jsonData.asJsonString)
    }
}

// MARK: - HeliumSdkDelegate

/// Implementation for the delegate for receiving Chartboost Mediation SDK initialization callbacks.
extension ChartboostMediationController: HeliumSdkDelegate {

    /// Chartboost Mediation SDK has finished initializing.
    /// @param error Optional error if the Chartboost Mediation SDK did not initialize properly.
    func heliumDidStartWithError(_ error: ChartboostMediationError?) {
        if let error = error {
            print("[Error] failed to start Chartboost Mediation: '\(error.debugDescription)'")
            initializationResult = .failure(error)
            completionHandler?(.failure(error))
        }
        else {
            print("[Success] Chartboost Mediation has successfully started")
            initializationResult = .success(true)
            completionHandler?(.success(true))
        }
        completionHandler = nil
    }
}
