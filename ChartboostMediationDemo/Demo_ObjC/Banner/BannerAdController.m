// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

#import "BannerAdController.h"
#import <ChartboostMediationSDK/ChartboostMediationSDK.h>

@interface BannerAdController ()

@property (nonatomic, weak, nullable) id<ActivityDelegate> activityDelegate;
@property (nonatomic, strong, nullable) ChartboostMediationBannerView *bannerAd;

@end

@implementation BannerAdController

- (nonnull instancetype)initWithPlacementName:(nonnull NSString *)placementName activityDelegate:(id<ActivityDelegate> _Nullable)activityDelegate {
    self = [super self];
    if (self) {
        _placementName = placementName;
        _activityDelegate = activityDelegate;
    }
    return self;
}

- (void)loadWithViewController:(UIViewController *)viewController width:(CGFloat)width keywords:(NSDictionary<NSString *, NSString *> * _Nullable)keywords {
    // Attempt to load the ad only if it has not already been created and requested to load.
    if (self.bannerAd) {
        NSLog(@"[Warning] banner advertisement has already been loaded");
        return;
    }

    self.bannerAd = [ChartboostMediationBannerView new];
    self.bannerAd.delegate = self;

    // In this demo, we will load a 6x1 banner with the max width of the screen.
    // If you are instead loading a fixed size banner placement, you can do that with:
    // ChartboostMediationBannerSizeStandard, ChartboostMediationBannerSizeMedium, or
    // ChartboostMediationBannerSizeLeaderboard.
    ChartboostMediationBannerSize *size = [ChartboostMediationBannerSize adaptive6x1WithWidth:width];
    ChartboostMediationBannerLoadRequest *request = [[ChartboostMediationBannerLoadRequest alloc] initWithPlacement:self.placementName size:size];

    // Notify the demo UI
    [self.activityDelegate activityDidStart];

    // Associate any provided keywords with the advertisement before it is loaded.
    self.bannerAd.keywords = keywords;

    // Load the banner ad, which will make a request to the network. Upon completion, the
    // completion block will be called.
    __weak __typeof__(self) weakSelf = self;
    [self.bannerAd loadWith:request viewController:viewController completion:^(ChartboostMediationBannerLoadResult * _Nonnull result) {
        BannerAdController *strongSelf = weakSelf;
        ChartboostMediationError *error = result.error;

        [weakSelf logAction:@"load" placementName:strongSelf.placementName error:error];

        // If a banner fails to load, you can simply call `load` on it again to retry.
        // However for this demo, we will destroy the banner.
        if (error) {
            weakSelf.bannerAd = nil;

            // Notify the demo UI
            [strongSelf.activityDelegate activityDidEndWithMessage:@"Failed to load the banner advertisement." error:result.error];
        }
        else {
            // Notify the demo UI
            [strongSelf.activityDelegate activityDidEnd];
        }
    }];
}

- (void)willAppearWithBannerView:(ChartboostMediationBannerView *)bannerView {
    // Called when a new ad is about to appear inside of `bannerView`. This method can be used
    // to manually size `bannerView` if desired.
    // This method can also be used to check other updated properties of `bannerView`.
}

- (void)logAction:(NSString *)action placementName:(NSString *)placementName error:(ChartboostMediationError *)error {
    if (error) {
        NSLog(@"[Error] did %@ banner advertisement for placement '%@': '%@' (code: %li)", action, placementName, error.localizedDescription, error.code);
    }
    else {
        NSLog(@"[Success] did %@ banner advertisement for placement '%@'", action, placementName);
    }
}

@end
