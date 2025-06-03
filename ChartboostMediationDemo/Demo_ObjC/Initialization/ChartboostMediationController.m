// Copyright 2018-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

#import <ChartboostCoreSDK/ChartboostCoreSDK-Swift.h>
#import <ChartboostMediationSDK/ChartboostMediationSDK-Swift.h>
#import "ChartboostMediationController.h"

@interface ChartboostMediationController ()

@property (nonatomic, copy) ChartboostMediationControllerCompletionBlock completionHandler;

@end

@interface ChartboostMediationController (CBCModuleObserver) <CBCModuleObserver>
@end

@implementation ChartboostMediationController

+ (instancetype)sharedInstance
{
    static ChartboostMediationController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ChartboostMediationController alloc] init];
    });
    return sharedInstance;
}

- (void)startChartboostMediationWithCompletion:(ChartboostMediationControllerCompletionBlock)completionHandler {
    self.completionHandler = completionHandler;

    // * Optional *
    // Enable test mode to make test ads available.
    // Do not enable test mode in production builds.
    ChartboostMediation.isTestModeEnabled = TRUE;

    // * Optional *
    // Register for impression level revenue data notifications. The Chartboost Mediation SDK publishes this data on the `default`
    // instances of the NotificationCenter. In this demo, the method `didReceiveImpressionLevelTrackingData` receives
    // this data, parses it, and logs it to the console.
    NSNotificationCenter *notificationCenter = NSNotificationCenter.defaultCenter;
    [notificationCenter addObserver:self
                           selector:@selector(didReceiveImpressionLevelTrackingData:)
                               name:NSNotification.chartboostMediationDidReceiveILRD
                             object:nil];

    // * Optional *
    // Provide a configuration data object before initializing the SDK.
    CBMPreinitializationConfiguration *mediationConfig =
        [[CBMPreinitializationConfiguration alloc] initWithSkippedPartnerIDs:@[@"partner_id"]];
    [ChartboostMediation setPreinitializationConfiguration:mediationConfig];

    // * Required *
    // Start the Chartboost Core SDK using the required SDK configuration and a nullable
    // `ChartboostCore.CBCModuleObserver` in order to be notified when Chartboost Core
    // initialization has completed.
    //
    // The SDK configuration takes a required Chartboost application identifier, an
    // array of `ChartboostCore.CBCModule`, and an string array `skippedModuleIDs` that
    // contains `ChartboostCore.CBCModule.moduleID`.
    //
    // By default, the Chartboost Mediation SDK is initialized by this `initializeSDK()` call
    // if it's not initialized yet. Provide `ChartboostMediation.coreModuleID` in `skippedModuleIDs`
    // in order to suppress this default behavior.
    //
    // * Required *
    // In order to communicate privacy settings to the Chartboost Mediation SDK you should include
    // a CMP adapter module to the modules list in the `CBCSDKConfiguration`.
    CBCSDKConfiguration *coreConfig = [[CBCSDKConfiguration alloc] initWithChartboostAppID:@"59c2b75ed7d75f0da04c452f"
                                                                                   modules:@[]
                                                                          skippedModuleIDs:@[]];
    [ChartboostCore initializeSDKWithConfiguration:coreConfig moduleObserver:self];
}

- (void)didReceiveImpressionLevelTrackingData:(NSNotification *)notification {
    CBMImpressionData *ilrd = (CBMImpressionData *)notification.object;
    if (ilrd) {
        NSLog(@"[ILRD] received impression level tracking data");
        NSLog(@"[ILRD] %@", ilrd.jsonData);
    }
}

@end

@implementation ChartboostMediationController (CBCModuleObserver)

- (void)onModuleInitializationCompleted:(CBCModuleInitializationResult * _Nonnull)result {
    // Chartboost Mediation SDK initialization result is represented by the initialization result of
    // an internal module with module ID `ChartboostMediation.coreModuleID`.
    NSString *moduleName = ([result.moduleID isEqualToString:ChartboostMediation.coreModuleID] ?
                            @"Chartboost Mediation" :
                            [NSString stringWithFormat:@"Chartboost Core module %@", result.moduleID]);

    if (result.error != nil) {
        NSLog(@"[Error] %@ initialization failed: %@", moduleName, result.error.localizedDescription);
        self.completionHandler(NO, result.error);
    } else {
        NSLog(@"[Success] %@ initialization succeeded", moduleName);
        self.completionHandler(YES, nil);
    }
}

@end
