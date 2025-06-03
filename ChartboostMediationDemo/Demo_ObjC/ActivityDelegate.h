// Copyright 2018-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

#ifndef ActivityDelegate_h
#define ActivityDelegate_h

NS_ASSUME_NONNULL_BEGIN

/// A protocol that is relevent for this demo only. It is not applicable to anything specific to the Chartboost Mediation SDK.
@protocol ActivityDelegate <NSObject>

- (void)activityDidStart;
- (void)activityDidEnd;
- (void)activityDidEndWithMessage:(NSString *)message error:(NSError * _Nullable)error;

@end

#endif /* ActivityDelegate_h */

NS_ASSUME_NONNULL_END
