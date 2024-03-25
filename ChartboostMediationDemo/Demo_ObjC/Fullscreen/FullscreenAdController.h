// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ChartboostMediationSDK/ChartboostMediationSDK-Swift.h>
#import "ActivityDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/// A basic implementation of a controller for Chartboost Mediation fullscreen ads.  It is capable of loading and showing a full screen fullscreen ad
/// for a single placement.  This controller is also its own `ChartboostMediationFullscreenAdDelegate` so that it is in full control
/// of the ad's lifecycle.
@interface FullscreenAdController : NSObject <ChartboostMediationFullscreenAdDelegate>

/// The placement that this controller is for.
@property (nonatomic, readonly) NSString *placementName;

/// An instance of the fullscreen ad that this class controls the lifecycle of when using the new API.
@property (nonatomic, strong, nullable, readonly) id<ChartboostMediationFullscreenAd> fullscreenAd;

/// Initialize the controller with a placement.
/// - Parameter placementName: The name of the placementt.
/// - Parameter activityDelegate: A delegate to communicate the start and end of asyncronous activity to.  This is applicable only for this demo.
- (instancetype)initWithPlacementName:(NSString *)placementName activityDelegate:(id<ActivityDelegate> _Nullable)activityDelegate;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

/// Load the fullscreen ad.
- (void)load;

/// Load the fullscreen ad.
/// - Parameter keywords: Optional keywords that can be associated with the advertisement placement.
- (void)loadWithKeywords:(HeliumKeywords * _Nullable)keywords;

/// Show the fullscreen ad if it has been loaded and is ready to show.
/// - Parameter viewController: The view controller to present the fullscreen over.
- (void)showWithViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
