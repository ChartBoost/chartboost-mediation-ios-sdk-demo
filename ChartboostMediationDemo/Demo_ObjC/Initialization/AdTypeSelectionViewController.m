// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

#import "AdTypeSelectionViewController.h"
#import "AdType.h"
#import "FullscreenAdViewController.h"

@interface AdTypeSelectionViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation AdTypeSelectionViewController

+ (UIViewController *)make {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"AdTypeSelection"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"AdTypeSelectionCell"];
    self.tableView.separatorColor = [[UIColor alloc] initWithRed:123/255 green:190/255 blue:56/255 alpha:1];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (UIViewController *)adViewForAdType:(AdType)adType {
    NSString *title = nil;
    switch (adType) {
        case AdTypeBanner:
            title = @"Banner";
            break;
        case AdTypeInterstitial:
            title = @"Interstitial";
            break;
        case AdTypeRewarded:
            title = @"Rewarded";
            break;
        case AdTypeQueued:
            title = @"Queued";
            break;
    }

    // Since we're using the fullscreen API, we need to set the ad type for Rewarded & Interstitial
    switch (adType) {
        case AdTypeBanner:
        case AdTypeQueued:
            return [[UIStoryboard storyboardWithName:title bundle:nil] instantiateViewControllerWithIdentifier:title];
        case AdTypeRewarded:
        case AdTypeInterstitial: {
            // A cast to FullscreenAdViewController is necessary so we can set .adType
            FullscreenAdViewController *fullScreenAdViewController = [[UIStoryboard storyboardWithName:@"Fullscreen" bundle:nil] instantiateViewControllerWithIdentifier:@"Fullscreen"];
            fullScreenAdViewController.adType = adType;
            return fullScreenAdViewController;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AdType adType;
    switch (indexPath.row) {
        case 0:
            adType = AdTypeBanner;
            break;
        case 1:
            adType = AdTypeInterstitial;
            break;
        case 2:
            adType = AdTypeRewarded;
            break;
        case 3:
            adType = AdTypeQueued;
            break;
        default:
            adType = AdTypeBanner;
            break;
    }
    UIViewController *vc = [self adViewForAdType:adType];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AdType adType = AdTypeBanner;
    NSString *cellTitle = @"Banner";
    UIImage *cellImage = [UIImage imageNamed:@"Banner"];
    if (indexPath.row == 1) {
        adType = AdTypeInterstitial;
        cellTitle = @"Interstitial";
        cellImage = [UIImage imageNamed:@"Interstitial"];
    }
    else if (indexPath.row == 2) {
        adType = AdTypeRewarded;
        cellTitle = @"Rewarded";
        cellImage = [UIImage imageNamed:@"Rewarded"];
    }
    else if (indexPath.row == 3) {
        adType = AdTypeQueued;
        cellTitle = @"Queued";
        cellImage = [UIImage imageNamed:@"Queued"];
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdTypeSelectionCell" forIndexPath:indexPath];
    cell.imageView.image = cellImage;
    cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
    cell.textLabel.text = cellTitle;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

@end
