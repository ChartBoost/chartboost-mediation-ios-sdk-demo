// Copyright 2018-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

#import "BannerAdViewController.h"
#import "BannerAdController.h"
#import "ActivityDelegate.h"
#import "UIViewController+ActivityDelegate.h"

@interface BannerAdViewController () <NSObject, ActivityDelegate>

@property (nonatomic, strong) BannerAdController *controller;

@end

@implementation BannerAdViewController

- (instancetype)init {
    if (self = [super init]) {
        self.controller = [[BannerAdController alloc] initWithPlacementName:@"CBAdaptiveBanner" activityDelegate:self];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        self.controller = [[BannerAdController alloc] initWithPlacementName:@"CBAdaptiveBanner" activityDelegate:self];
    }
    return self;
}

- (IBAction)loadButtonPushed:(id)sender {
    [self.controller loadWithViewController:self width:self.view.frame.size.width keywords:nil];
}

- (IBAction)showButtonPushed:(id)sender {
    CBMBannerAdView *bannerAd = self.controller.bannerAd;

    // Attempt to show an ad only if it has been loaded.
    if (bannerAd == nil) {
        NSLog(@"[Error] cannot show an banner advertisement that has not yet been loaded");
        return;
    }

    // Remove the banner ad from its super view if it was previously added to one.
    [bannerAd removeFromSuperview];

    // Place the banner ad view within the provided view container.
    bannerAd.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:bannerAd];

    // If using auto-layout, the banner view will automatically resize when new ads are loaded.
    // The banner view can also be manually sized.
    [NSLayoutConstraint activateConstraints:@[
        [bannerAd.centerXAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerXAnchor],
        [bannerAd.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];
}

@end
