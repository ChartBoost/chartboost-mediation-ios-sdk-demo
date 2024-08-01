// Copyright 2018-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ActivityDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ActivityDelegateExtension) <ActivityDelegate>

@property (nonatomic, nullable) UIViewController *busy;

@end

NS_ASSUME_NONNULL_END
