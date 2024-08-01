// Copyright 2018-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

#import "FullscreenAdViewController.h"
#import "FullscreenAdController.h"
#import "ActivityDelegate.h"
#import "UIViewController+ActivityDelegate.h"

@interface FullscreenAdViewController () <NSObject, ActivityDelegate>

@property (nonatomic, strong) FullscreenAdController *controller;

@end

@implementation FullscreenAdViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    switch (self.adType) {
        case AdTypeBanner:
            self.title = @"Fullscreen Ad"; // Well, this shouldn't really occur...
            break;
        case AdTypeQueued:
            self.title = @"Queued [ERROR]"; // This DEFINITELY shouldn't occur.
        case AdTypeInterstitial:
            self.title = @"Interstitial";
            break;
        case AdTypeRewarded:
            self.title = @"Rewarded";
            break;
    }
}

- (void)setAdType:(AdType)adType {
    _adType = adType;
    NSString *placementName = adType == AdTypeInterstitial ? @"CBInterstitial" : @"CBRewarded";
    self.controller = [[FullscreenAdController alloc] initWithPlacementName: placementName activityDelegate:self];
}

- (IBAction)loadButtonPushed:(id)sender {
    [self.controller load];
}

- (IBAction)showButtonPushed:(id)sender {
    [self.controller showWithViewController:self];
}

@end
