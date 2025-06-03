// Copyright 2018-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

#import <Foundation/Foundation.h>
#import <ChartboostMediationSDK/ChartboostMediationSDK-Swift.h>

NS_ASSUME_NONNULL_BEGIN

/// This class is used by this demo to initialize the Chartboost Mediation SDK, manages the user's various privacy settings, and shows how impression
/// level revenue data (ILRD) can be received within an application.  See `ChartboostMediationInititializationViewController` to see where
/// the `startHelium(completion:)` method is used.

typedef void (^ChartboostMediationControllerCompletionBlock)(BOOL success, NSError  * _Nullable error);

@interface ChartboostMediationController : NSObject

/// A static instance of this class so that it can be easily accessible throughout the application.
@property (nonatomic, class, readonly) ChartboostMediationController *sharedInstance;

/// Before any advertisements can be loaded and shown, the Chartboost Mediation SDK must be initialized. This method should only be called once.
/// - Parameter completionHandler: A completion handler that is called once the SDK has completed initialization.
- (void)startChartboostMediationWithCompletion:(ChartboostMediationControllerCompletionBlock)completionHandler;

@end

NS_ASSUME_NONNULL_END
