// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

#import "ChartboostMediationController.h"
#import <ChartboostCoreSDK/ChartboostCoreSDK-Swift.h>
#import <ChartboostMediationSDK/ChartboostMediationSDK-Swift.h>

@interface ChartboostMediationController ()

/// The shared instances of the Chartboost Mediation SDK.
@property (nonatomic, class, readonly) ChartboostMediation *chartboostMediation;

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
        sharedInstance.gdpr = defaultGDPR;
        sharedInstance.coppa = NO;
        sharedInstance.ccpa = nil;
    });
    return sharedInstance;
}

+ (ChartboostMediation *)chartboostMediation {
    return ChartboostMediation.shared;
}

- (void)startChartboostMediationWithCompletion:(ChartboostMediationControllerCompletionBlock)completionHandler {
    self.completionHandler = completionHandler;

    // * Required *
    // Communicate user privacy settings to the Chartboost Mediation SDK
    [self setGdpr:self.gdpr];
    [self setCoppa:self.coppa];
    [self setCcpa:self.ccpa];

    // * Optional *
    // Register for impression level revenue data notifications. The Chartboost Mediation SDK publishes this data on the `default`
    // instances of the NotificationCenter. In this demo, the method `didReceiveImpressionLevelTrackingData` receives
    // this data, parses it, and logs it to the console.
    NSNotificationCenter *notificationCenter = NSNotificationCenter.defaultCenter;
    [notificationCenter addObserver:self
                           selector:@selector(didReceiveImpressionLevelTrackingData:)
                               name:NSNotification.chartboostMediationDidReceiveILRD
                             object:nil];

    // * Required *
    // Start the Chartboost Mediation SDK using the application identifier, application signature, and
    // an instance of the `HeliumSdkDelegate` in order to be notified when Chartboost Mediation initialization
    // has completed.
    CBCSDKConfiguration *config = [[CBCSDKConfiguration alloc] initWithChartboostAppID:@"59c2b75ed7d75f0da04c452f"
                                                                               modules:@[]
                                                                      skippedModuleIDs:@[]];
    [ChartboostCore initializeSDKWithConfiguration:config moduleObserver:self];
}

- (void)setGdpr:(GDPR)gdpr {
    _gdpr = gdpr;
    [ChartboostMediationController.chartboostMediation setSubjectToGDPR:gdpr.isSubject];
    if (gdpr.isSubject) {
        [ChartboostMediationController.chartboostMediation setUserHasGivenConsent:gdpr.hasGivenConsent];
    }
}

- (void)setCoppa:(BOOL)coppa {
    _coppa = coppa;
    [ChartboostMediationController.chartboostMediation setSubjectToCoppa:coppa];
}

- (void)setCcpa:(NSNumber *)ccpa {
    _ccpa = ccpa;
    if (ccpa) {
        [ChartboostMediationController.chartboostMediation setCCPAConsent:ccpa.boolValue];
    }
    else {
        [ChartboostMediationController.chartboostMediation setCCPAConsent:YES];
    }
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
    if (result.error != nil) {
        NSLog(@"[Error] Chartboost Core module %@ initialization failed: %@", result.module.moduleID, result.error.localizedDescription);
        self.completionHandler(NO, result.error);
    } else {
        NSLog(@"[Success] Chartboost Core module %@ initialization succeeded", result.module.moduleID);
        self.completionHandler(YES, nil);
    }
    self.completionHandler = nil;
}

@end
