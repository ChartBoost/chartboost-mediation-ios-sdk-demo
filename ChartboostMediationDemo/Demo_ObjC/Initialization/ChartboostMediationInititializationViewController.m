// Copyright 2018-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

#import "ChartboostMediationInititializationViewController.h"
#import "ChartboostMediationController.h"
#import "AdTypeSelectionViewController.h"

@implementation ChartboostMediationInititializationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.progressLabel.text = @"Initializing the Chartboost Mediation SDK ...";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // In this demo, Chartboost Mediation initialization and general control is performed
    // within the class `ChartboostMediationController`.
    ChartboostMediationController *chartboostMediationController = ChartboostMediationController.sharedInstance;

    // Start up the Chartboost Mediation SDK using the `startChartboostMediation` method in the
    // example `ChartboostMediationController` class. Initialization completion is
    // communicated back using a completion handler.
    [chartboostMediationController startChartboostMediationWithCompletion:^(BOOL success, NSError * _Nullable error) {
        [self didCompleteInitializationSuccessfully:success error:error];
    }];
}

- (void)didCompleteInitializationSuccessfully:(BOOL)success error:(NSError * _Nullable)error {
    [self.activityIndicatorView stopAnimating];
    if (error) {
        self.progressLabel.text = [NSString stringWithFormat:@"Failed to initialize Chartboost Mediation SDK:\n\n%@", error.localizedDescription];
    }
    else if (success) {
        self.progressLabel.text = @"Chartboost Mediation SDK initialization complete!";
        [UIView animateWithDuration:0.5 animations:^{
            self.contentView.alpha = 0;
        } completion:^(BOOL finished) {
            [self showAdTypeSelectionViewController];
        }];
    }
    else {
        self.progressLabel.text = @"Chartboost Mediation SDK failed initialization but no reason was given.";
    }
}

- (void)showAdTypeSelectionViewController {
    UIViewController *vc = [AdTypeSelectionViewController make];
    [self.navigationController pushViewController:vc animated:false];
}

@end
