// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

#import <Foundation/Foundation.h>
#import <ChartboostMediationSDK/ChartboostMediationSDK-Swift.h>
#import "GDPR.h"

NS_ASSUME_NONNULL_BEGIN

/// This class is used by this demo to initialize the Chartboost Mediation SDK, manages the user's various privacy settings, and shows how impression
/// level revenue data (ILRD) can be received within an application.  See `ChartboostMediationInititializationViewController` to see where
/// the `startHelium(completion:)` method is used.

typedef void (^ChartboostMediationControllerCompletionBlock)(BOOL success, NSError  * _Nullable error);

@interface ChartboostMediationController : NSObject <HeliumSdkDelegate>

/// A static instance of this class so that it can be easily accessible throughout the application.
@property (nonatomic, class, readonly) ChartboostMediationController *sharedInstance;

/// The shared instances of the Chartboost Mediation SDK.
@property (nonatomic, class, readonly) ChartboostMediation *chartboostMediation;

/// A property that can be used to define and update the user's GDPR settings.
/// For more information about GDPR, see: https://answers.chartboost.com/en-us/articles/115001489613
@property (nonatomic) GDPR gdpr;

/// A property that can be used to define and update if the user is subject to COPPA.
/// For more information about COPPA, see: https://answers.chartboost.com/en-us/articles/115001488494
@property (nonatomic) BOOL coppa;

/// A property that can be used to define and update if the CCPA-applicable user has granted consent to the collection of Personally Identifiable Information.
/// For more information about CCPA, see: https://answers.chartboost.com/en-us/articles/115001490031
@property (nonatomic, strong, nullable) NSNumber *ccpa;

/// Before any advertisements can be loaded and shown, the Chartboost Mediation SDK must be initialized. This method should only be called once.
/// - Parameter completionHandler: A completion handler that is called once the SDK has completed initialization.
- (void)startChartboostMediationWithCompletion:(ChartboostMediationControllerCompletionBlock)completionHandler;

@end

NS_ASSUME_NONNULL_END
