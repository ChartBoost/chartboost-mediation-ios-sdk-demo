// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

#import "ChartboostMediationController.h"

@interface ChartboostMediationController ()

@property (nonatomic, copy) ChartboostMediationControllerCompletionBlock completionHandler;

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

+ (Helium *)chartboostMediation {
    return Helium.sharedHelium;
}

- (void)startChartboostMediationWithCompletion:(ChartboostMediationControllerCompletionBlock)completionHandler {
    self.completionHandler = completionHandler;

    // * Required *
    // Communicate user privacy settings to the Chartboost Mediation SDK
    [self setGdpr:self.gdpr];
    [self setCoppa:self.coppa];
    [self setCcpa:self.ccpa];

    // * Optional *
    // Enable test mode to make test ads available.
    // Do not enable test mode in production builds.
    Helium.isTestModeEnabled = TRUE;

    // * Optional *
    // Register for impression level revenue data notifications. The Chartboost Mediation SDK publishes this data on the `default`
    // instances of the NotificationCenter. In this demo, the method `didReceiveImpressionLevelTrackingData` receives
    // this data, parses it, and logs it to the console.
    NSNotificationCenter *notificationCenter = NSNotificationCenter.defaultCenter;
    [notificationCenter addObserver:self selector:@selector(didReceiveImpressionLevelTrackingData:) name:NSNotification.heliumDidReceiveILRD object:nil];

    // * Required *
    // Start the Chartboost Mediation SDK using the application identifier, application signature, and
    // an instance of the `HeliumSdkDelegate` in order to be notified when Chartboost Mediation initialization
    // has completed.
    [ChartboostMediationController.chartboostMediation startWithAppId:@"59c2b75ed7d75f0da04c452f" options:nil delegate:self];
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
    HeliumImpressionData *ilrd = (HeliumImpressionData *)notification.object;
    if (ilrd) {
        NSLog(@"[ILRD] received impression level tracking data");
        NSLog(@"[ILRD] %@", ilrd.jsonData);
    }
}

- (void)heliumDidStartWithError:(ChartboostMediationError *)error {
    if (error) {
        NSLog(@"[Error] failed to start Chartboost Mediation: '%@'", [error localizedDescription]);
        self.completionHandler(NO, error);
    }
    else {
        NSLog(@"[Success] Chartboost Mediation has successfully started");
        self.completionHandler(YES, nil);
    }
    self.completionHandler = nil;
}

@end
