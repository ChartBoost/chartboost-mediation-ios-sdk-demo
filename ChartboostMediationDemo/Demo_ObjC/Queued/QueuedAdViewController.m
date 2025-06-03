// Copyright 2018-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

#import "QueuedAdViewController.h"
#import <ChartboostMediationSDK/ChartboostMediationSDK-Swift.h>

@interface QueuedAdViewController () <NSObject, CBMFullscreenAdQueueDelegate>

@property (nonatomic, strong) CBMFullscreenAdQueue *queue;
@property (nonatomic, weak) IBOutlet UIButton *runButton;
@property (nonatomic, weak) IBOutlet UIButton *showButton;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *adSlots;

- (IBAction)runButtonPushed;
- (IBAction)showButtonPushed;
- (void)updateUI;

@end

@implementation QueuedAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.queue = [CBMFullscreenAdQueue queueForPlacement:@"CBInterstitial"];
    // Set self as the delegate so we can react to completed ad loads.
    self.queue.delegate = self;
    [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (IBAction)runButtonPushed {
    if (self.queue.isRunning) {
        [self.queue stop];
    } else {
        [self.queue start];
    }
    [self updateUI];
}

- (IBAction)showButtonPushed {
    id ad = [self.queue getNextAd];
    if (ad) {
        // If ad was nil, there would have been no reason to update the UI because no ad was removed from the queue.
        [self updateUI];
        [ad showWith:self completion:^(CBMAdShowResult * _Nonnull result) {
            [self logAction:@"show" error:result.error];
        }];
    }
}

- (void)updateUI {
    if (self.queue.isRunning) {
        [self.runButton setTitle:@"Stop Queue" forState:UIControlStateNormal];
    } else {
        [self.runButton setTitle:@"Start Queue" forState:UIControlStateNormal];
    }

    for (NSUInteger index = 0; index < [self.adSlots count]; index++) {
        UILabel *label = [self.adSlots objectAtIndex:index];
        if (index < self.queue.numberOfAdsReady) {
            label.text = @"🟩";
        } else {
            label.text = @"🔲";
        }
    }

    self.showButton.enabled = self.queue.hasNextAd;
}

- (void)logAction:(NSString *)action error:(CBMError *)error {
    if (error) {
        NSLog(@"[Error] did %@ fullscreen advertisement: '%@' (code: %li)", action, error.localizedDescription, error.code);
    }
    else {
        NSLog(@"[Success] did %@ fullscreen advertisement", action);
    }
}

#pragma mark - ChartboostMediationFullscreenAdQueueDelegate
// A FullscreenAdQueueDelegate can be used to receive updates about queue events.

- (void)fullscreenAdQueue:(CBMFullscreenAdQueue *)adQueue didFinishLoadingWithResult:(CBMAdLoadResult*)result numberOfAdsReady:(NSInteger)numberOfAdsReady {
    // Update the UI to show that there's one more ad in the queue.
    [self updateUI];
}

- (void)fullscreenAdQueueDidRemoveExpiredAd:(CBMFullscreenAdQueue *)adQueue numberOfAdsReady:(NSInteger)numberOfAdsReady {
    // Update the UI to show that there's one less ad in the queue.
    [self updateUI];
}

@end
