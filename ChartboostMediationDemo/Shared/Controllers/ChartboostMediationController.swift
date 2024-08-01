// Copyright 2018-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import ChartboostCoreSDK
import ChartboostMediationSDK

/// This class is used by this demo to initialize the Chartboost Mediation SDK, manages the user's various privacy settings, 
/// and shows how impression level revenue data (ILRD) can be received within an application. See
/// `ChartboostMediationInititializationViewController` to see where the `startHelium(completion:)` method is used.
class ChartboostMediationController: NSObject, ObservableObject {
    /// The unique application identifier that is supplied by the Chartboost Mediation developer dashboard.
    let appIdentifier: String = "59c2b75ed7d75f0da04c452f"

    /// A static instance of this class so that it can be easily accessible throughout the application.
    static let instance = ChartboostMediationController()

    /// The result of initialization.
    @Published private(set) var initializationResult: Result<Bool, Error>?

    /// Before any advertisements can be loaded and shown, the Chartboost Mediation SDK must be initialized.
    /// This method should only be called once.
    /// - Parameter completion: A completion handler that is called once the SDK has completed initialization.
    func startChartboostMediation(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard completionHandler == nil else {
            fatalError("Chartboost Mediation initialization is already in progress")
        }
        self.completionHandler = completion

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
        let config = PreinitializationConfiguration(skippedPartnerIDs: ["partner_id"])
        if let error = ChartboostMediation.setPreinitializationConfiguration(config) {
            print("[Error] failed to set preinitialization configuration: \(error.debugDescription)")
        }

        // * Required *
        // Start the Chartboost Core SDK using the required SDK configuration and a nullable
        // `ChartboostCore.ModuleObserver` in order to be notified when Chartboost Core
        // initialization has completed.
        //
        // The SDK configuration takes a required Chartboost application identifier, an optional
        // array of `ChartboostCore.Module`, and an optional string array `skippedModuleIDs` that
        // contains `ChartboostCore.Module.moduleID`.
        //
        // By default, the Chartboost Mediation SDK is initialized by this `initializeSDK()` call
        // if it's not initialized yet. Provide `ChartboostMediation.coreModuleID` in `skippedModuleIDs`
        // in order to suppress this default behavior.
        //
        // * Required *
        // In order to communicate privacy settings to the Chartboost Mediation SDK you should include
        // a CMP adapter module to the modules list in the `CBCSDKConfiguration`.
        ChartboostCore.initializeSDK(
            configuration: .init(
                chartboostAppID: appIdentifier,
                modules: [], // optional
                skippedModuleIDs: [] // optional
            ),
            moduleObserver: self
        )
    }

    // MARK: - Private

    private var completionHandler: ((Result<Bool, Error>) -> Void)?

    @objc private func didReceiveImpressionLevelTrackingData(notification: Notification) {
        guard let ilrd = notification.object as? ImpressionData else {
            return
        }
        print("[ILRD] received impression level tracking data")
        print("[ILRD] %@", ilrd.jsonData.asJsonString)
    }
}

// MARK: - ModuleObserver

/// Implementation for the delegate for receiving Chartboost Mediation SDK initialization callbacks.
extension ChartboostMediationController: ModuleObserver {
    func onModuleInitializationCompleted(_ result: ModuleInitializationResult) {
        // Chartboost Mediation SDK initialization result is represented by the initialization result of
        // an internal module with module ID `ChartboostMediation.coreModuleID`.
        let moduleName = (result.moduleID == ChartboostMediation.coreModuleID ?
                          "Chartboost Mediation" : "Chartboost Core module \(result.moduleID)")

        if let error = result.error {
            print("[Error] \(moduleName) initialization failed: \(error.localizedDescription)")
            initializationResult = .failure(error)
            completionHandler?(.failure(error))
        } else {
            print("[Success] \(moduleName) initialization succeeded")
            initializationResult = .success(true)
            completionHandler?(.success(true))
        }
    }
}
