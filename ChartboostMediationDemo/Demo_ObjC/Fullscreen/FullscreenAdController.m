// Copyright 2018-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

#import "FullscreenAdController.h"

@interface FullscreenAdController ()

@property (nonatomic, weak, nullable) id<ActivityDelegate> activityDelegate;
@property (nonatomic, strong, nullable) CBMFullscreenAd * fullscreenAd;

@end

@implementation FullscreenAdController

- (nonnull instancetype)initWithPlacementName:(nonnull NSString *)placementName activityDelegate:(id<ActivityDelegate> _Nullable)activityDelegate {
    self = [super self];
    if (self) {
        _placementName = placementName;
        _activityDelegate = activityDelegate;
    }
    return self;
}

- (void)load {
    [self loadWithKeywords:nil];
}

- (void)loadWithKeywords:(NSDictionary<NSString *, NSString *> * _Nullable)keywords {
    // Attempt to load the ad only if it has not already been created and requested to load.
    if (self.fullscreenAd) {
        NSLog(@"[Warning] fullscreen advertisement has already been loaded");
        return;
    }

    // Notify the demo UI
    [self.activityDelegate activityDidStart];

    CBMFullscreenAdLoadRequest *request = [[CBMFullscreenAdLoadRequest alloc] initWithPlacement:self.placementName keywords:keywords];

    // Load the fullscreen ad, which will make a request to the network. Upon completion, a
    // ChartboostMediationFullscreenAdLoadResult will be passed to the completion block.
    __weak __typeof__(self) weakSelf = self;
    [CBMFullscreenAd loadWith:request completion:^(CBMFullscreenAdLoadResult * _Nonnull result) {
        FullscreenAdController *strongSelf = weakSelf;

        [strongSelf logAction:@"load" placementName:strongSelf.placementName error:result.error];
        CBMFullscreenAd * ad = result.ad;
        if (ad) {
            ad.delegate = strongSelf;
            strongSelf.fullscreenAd = ad;

            // Notify the demo UI
            [strongSelf.activityDelegate activityDidEnd];
        }
        else {
            strongSelf.fullscreenAd = nil;

            // Notify the demo UI
            [strongSelf.activityDelegate activityDidEndWithMessage:@"Failed to load the fullscreen advertisement." error:result.error];
        }
    }];
}

- (void)showWithViewController:(UIViewController *)viewController {
    CBMFullscreenAd * fullscreenAd = self.fullscreenAd;

    // Attempt to show a fullscreen ad only if it has been loaded.
    if (fullscreenAd == nil) {
        NSLog(@"[Error] cannot show a fullscreen advertisement that has not yet been loaded");
        return;
    }

    // Once you've loaded a ChartboostMediationFullscreenAd, it can be shown immediately.

    // Show the ad using the specified view controller.  Upon completion, a ChartboostMediationAdShowResult will be passed to the completion block.
    [fullscreenAd showWith:viewController completion:^(CBMAdShowResult * _Nonnull result) {
        [self logAction:@"show" placementName:self.placementName error:result.error];

        // For simplicity, an ad that has failed to show will be destroyed.
        if (result.error) {
            self.fullscreenAd = nil;
        }
    }];
}

- (void)didRecordImpressionWithAd:(CBMFullscreenAd *)ad {
    [self logAction:@"record impression" placementName:self.placementName error:nil];
}

- (void)didClickWithAd:(CBMFullscreenAd *)ad {
    [self logAction:@"click" placementName:self.placementName error:nil];
}

- (void)didRewardWithAd:(CBMFullscreenAd *)ad {
    [self logAction:@"get reward" placementName:self.placementName error:nil];
}

- (void)didCloseWithAd:(CBMFullscreenAd *)ad error:(CBMError *)error {
    [self logAction:@"close" placementName:self.placementName error:error];
}

- (void)didExpireWithAd:(CBMFullscreenAd *)ad {
    [self logAction:@"expire" placementName:self.placementName error:nil];
}

- (void)logAction:(NSString *)action placementName:(NSString *)placementName error:(CBMError *)error {
    if (error) {
        NSLog(@"[Error] did %@ fullscreen advertisement for placement '%@': '%@' (code: %li)", action, placementName, error.localizedDescription, error.code);
    }
    else {
        NSLog(@"[Success] did %@ fullscreen advertisement for placement '%@'", action, placementName);
    }
}

@end
