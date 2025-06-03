// Copyright 2018-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

#import <ChartboostMediationSDK/ChartboostMediationSDK-Swift.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AdType.h"

NS_ASSUME_NONNULL_BEGIN

@interface QueuedAdViewController : UIViewController

@property (nonatomic) AdType adType;

@end

NS_ASSUME_NONNULL_END
