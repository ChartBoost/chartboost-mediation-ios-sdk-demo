// Copyright 2018-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

#import "UIViewController+ActivityDelegate.h"
#import <objc/runtime.h>
#import "BusyViewController.h"
#import <ChartboostMediationSDK/ChartboostMediationSDK-Swift.h>

static char kAssociatedObjectKey;

@implementation UIViewController (ActivityDelegateExtension)

- (UIViewController *)busy {
    return objc_getAssociatedObject(self, &kAssociatedObjectKey);
}

- (void)setBusy:(UIViewController *)busy {
    objc_setAssociatedObject(self, &kAssociatedObjectKey, busy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)activityDidStart {
    self.busy = [BusyViewController presentOverParent:self];
}

- (void)activityDidEnd {
    [self.busy dismissViewControllerAnimated:YES completion:^{
        self.busy = nil;
    }];
}

- (void)activityDidEndWithMessage:(NSString *)message error:(NSError * _Nullable)error {
    if (self.busy) {
        [self.busy dismissViewControllerAnimated:YES completion:^{
            self.busy = nil;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self presentAlertWithMessage:message error:error];
            });
        }];
    }
    else {
        [self presentAlertWithMessage:message error:error];
    }
}

- (void)presentAlertWithMessage:(NSString *)message error:(NSError * _Nullable)error {
    CBMError *chartboostError = (CBMError *)error;
    NSString *alertMessage;
    if (chartboostError) {
        alertMessage = [NSString stringWithFormat:@"%@\n\n%@", message, chartboostError.localizedFailureReason];
    }
    else {
        alertMessage = [NSString stringWithFormat:@"%@\n\n%@", message, error.localizedDescription];
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}]];
    [self presentViewController:alert animated:YES completion:^{}];
}

@end
