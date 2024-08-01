// Copyright 2018-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BusyViewController : UIViewController

+ (UIViewController *)presentOverParent:(UIViewController *)parent;

@end

NS_ASSUME_NONNULL_END
