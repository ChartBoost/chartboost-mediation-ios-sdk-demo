// Copyright 2018-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

#import "BusyViewController.h"

@implementation BusyViewController

+ (UIViewController *)presentOverParent:(UIViewController *)parent {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Busy" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Busy"];
    [parent presentViewController:vc animated:YES completion:^{
        // :D
    }];
    return vc;
}

@end
