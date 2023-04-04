// Copyright 2022-2023 Chartboost, Inc.
// 
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

//
//  CHBHMultipleLoadRequester.h
//  HeliumSdkTests
//
//  Created by Virendra Shakya on 1/19/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHBHMultipleLoadRequester : NSObject
- (void)shootNInterstitialLoads:(NSInteger)N;
@end

NS_ASSUME_NONNULL_END
