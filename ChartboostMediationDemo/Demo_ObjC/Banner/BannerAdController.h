// Copyright 2018-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ChartboostMediationSDK/ChartboostMediationSDK-Swift.h>
#import "ActivityDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/// A basic implementation of a controller for Chartboost Mediation banner ads.  It is capable of loading and showing a banner ad
/// for a single placement. This controller is also its own `CBMBannerAdViewDelegate` so that it is in full control
/// of the ad's lifecycle.
@interface BannerAdController : NSObject <CBMBannerAdViewDelegate>

/// The placement that is controller is for.
@property (nonatomic, readonly) NSString *placementName;

/// An instance of the banner ad that this class controls the lifecycle of.
@property (nonatomic, strong, nullable, readonly) CBMBannerAdView *bannerAd;

/// Initialize the controller with a placement.
/// - Parameter placementName: The name of the placement.
/// - Parameter activityDelegate: A delegate to communicate the start and end of asyncronous activity to.  This is applicable only for this demo.
- (instancetype)initWithPlacementName:(NSString *)placementName activityDelegate:(id<ActivityDelegate> _Nullable)activityDelegate;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

/// Load the banner ad.
/// - Parameter viewController: The view controller that will be the viewer for the banner advertisement.
/// - Parameter width: The max width of ad to load.
/// - Parameter keywords: Optional keywords that can be associated with the advertisement placement.
- (void)loadWithViewController:(UIViewController *)viewController width:(CGFloat)width keywords:(NSDictionary<NSString *, NSString *> * _Nullable)keywords;

@end

NS_ASSUME_NONNULL_END
