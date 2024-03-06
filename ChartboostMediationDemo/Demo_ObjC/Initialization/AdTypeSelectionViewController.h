// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// This demo uses this view controller as the entry point for selecting the different advertisement types that the
/// Chartboost Mediation SDK provides.  These include:
/// - Banners
/// - Full screen interstitials
/// - Full screen rewarded videos
///
/// To see how to utilize banner advertisements, look at the following classes:
/// - `BannerAdController`
/// - `BannerAdViewController`
///
/// To see how to utilize interstitial and rewarded advertisements, look at the following classes:
/// - `FullscreenAdController`
/// - `FullscreenAdViewController`
///
@interface AdTypeSelectionViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITableView *tableView;

/// Make an instace of this view controller.
+ (UIViewController *)make;

@end

NS_ASSUME_NONNULL_END
