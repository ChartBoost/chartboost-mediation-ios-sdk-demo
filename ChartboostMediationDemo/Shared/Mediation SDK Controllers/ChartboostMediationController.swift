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

import ChartboostCoreSDK
import ChartboostMediationSDK

/// This class is used by this demo to initialize the Chartboost Mediation SDK, manages the user's various privacy settings, and shows how impression
/// level revenue data (ILRD) can be received within an application.  See `ChartboostMediationInititializationViewController` to see where
/// the `startHelium(completion:)` method is used.
class ChartboostMediationController: NSObject, ObservableObject {
    /// The unique application identifier that is supplied by the Chartboost Mediation developer dashboard.
    let appIdentifier: String = "59c2b75ed7d75f0da04c452f"

    /// A static instance of this class so that it can be easily accessible throughout the application.
    static let instance: ChartboostMediationController = ChartboostMediationController()

    /// The shared instances of the Chartboost Mediation SDK.
    let chartboostMediation = ChartboostMediation.shared()

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
        // Enable test mode to make test ads available.
        // Do not enable test mode in production builds.
        ChartboostMediation.isTestModeEnabled = true

        // * Optional *
        // Register for impression level revenue data notifications. The Chartboost Mediation SDK publishes this data on the `default`
        // instances of the NotificationCenter. In this demo, the method `didReceiveImpressionLevelTrackingData` receives
        // this data, parses it, and logs it to the console.
        let notificationCenter: NotificationCenter = .default
        notificationCenter.addObserver(
            self,
            selector: #selector(didReceiveImpressionLevelTrackingData(notification:)),
            name: .chartboostMediationDidReceiveILRD,
            object: nil
        )

        // * Optional *
        // Provide a configuration data object before initializing the SDK.
        let config = PreinitializationConfiguration(skippedPartnerIdentifiers: ["partner_id"])
        if let error = chartboostMediation.setPreinitializationConfiguration(config) {
            print("[Error] failed to set preinitialization configuration: \(error.debugDescription)")
        }

        // * Required *
        // Start the Chartboost Core SDK using the application identifier, application signature, and
        // an instance of the `ModuleObserver` in order to be notified when Chartboost Core initialization
        // has completed.
        ChartboostCore.initializeSDK(configuration: .init(chartboostAppID: appIdentifier), moduleObserver: self)
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
        guard let ilrd = notification.object as? ImpressionData else {
            return
        }
        print("[ILRD] received impression level tracking data")
        print("[ILRD] %@", ilrd.jsonData.asJsonString)
    }
}

// MARK: - ModuleObserver

/// Implementation for the delegate for receiving Chartboost Core SDK initialization callbacks.
extension ChartboostMediationController: ModuleObserver {
    func onModuleInitializationCompleted(_ result: ChartboostCoreSDK.ModuleInitializationResult) {
        if let error = result.error {
            print("[Error] Chartboost Core module \(result.module.moduleID) initialization failed: \(error.localizedDescription)");
            initializationResult = .failure(error)
            completionHandler?(.failure(error))
        }
        else {
            print("[Success] Chartboost Core module \(result.module.moduleID) initialization succeeded");
            initializationResult = .success(true)
            completionHandler?(.success(true))
        }
        completionHandler = nil
    }
}
