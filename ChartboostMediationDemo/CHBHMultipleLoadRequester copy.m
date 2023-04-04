// Copyright 2022-2023 Chartboost, Inc.
// 
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

//
//  CHBHMultipleLoadRequester.m
//  HeliumSdkTests
//
//  Created by Virendra Shakya on 1/19/19.
//

#import "CHBHMultipleLoadRequester.h"
#import "HeliumSdk.h"
#import "HeliumDelegates.h"
#import "HeliumError.h"
#import "CHBHMultipleLoadRequester.h"

static NSString *const kTapjoyPlacementId     = @"Main Screen";
static NSString *const kChartboostPlacementId = @"Startup";

#define TRACE NSLog(@"%@", [NSString stringWithUTF8String:__PRETTY_FUNCTION__]);

static const char *g_tj_int_placements[] = {
  "Startup",
  "SimplePlacementTest",
  "CHvsTJ",
  "Startup-Rewarded",
  "TapJoyInterstitial"
};
static const char *g_tj_rv_placements[] = {
  "Startup",
  "SimplePlacementTest",
  "CHvsTJ",
  "Startup-Rewarded",
  "TapJoyInterstitial"
};
static const char *g_cb_int_placements[] = {
  "Startup",
  "SimplePlacementTest",
  "CHvsTJ",
  "Startup-Rewarded",
  "TapJoyInterstitial"
};
static const char *g_cb_rv_placements[] = {
  "Startup",
  "SimplePlacementTest",
  "CHvsTJ",
  "Startup-Rewarded",
  "TapJoyInterstitial"
};

@interface CHBHMultipleLoadRequester () <CHBHeliumInterstitialAdDelegate,CHBHeliumRewardedVideoAdAdDelegate>

@end
@implementation CHBHMultipleLoadRequester {
  NSMutableArray<id<HeliumInterstialAd>>* ints;
  NSMutableArray<id<HeliumRewardedAd>>* rvs;
  id<HeliumInterstialAd> interstitialAd;
}
- (void)shootNInterstitialLoads:(NSInteger)N {TRACE
  ints = [NSMutableArray array];
  rvs = [NSMutableArray array];
  
  typedef enum chbh_load {
   only_cb_int,
   only_cb_rv,
   only_tj_int,
   only_tj_rv,
   mix_cb_int_cb_rv,
   mix_cb_int_tj_rv,
   mix_cb_rv_tj_int,
   mix_cb_rv_tj_rv,
  } chbh_load_e;
  
  chbh_load_e load = only_cb_int;
  
  long tj_int=0;
  long tj_rv=0;
  long cb_int=0;
  long cb_rv=0;
  
  for(long i=0;i<N;i++) {
    switch(load) {
      case only_cb_int: {
        size_t arrlen = sizeof(g_cb_int_placements)/sizeof(g_cb_int_placements[0]);
        if (cb_int >= 0 && cb_int < arrlen) {
          const char *p = g_cb_int_placements[cb_int++];
          [self oneReentrantInt:p];
        }
        
      } break;
    }
  }
}
- (void)oneReentrantInt:(const char *)p {TRACE
  NSString *pid = [NSString stringWithUTF8String:p];
  if (pid) {
    interstitialAd = [[HeliumSdk sharedHelium] interstitialAdProviderWithDelegate:self andPlacementId:pid];
    [ints addObject:interstitialAd];
    [interstitialAd loadAd];
  }
}
- (void)oneRv {TRACE
  //rewardedAd = [[HeliumSdk sharedHelium] rewardedVideoAdProviderWithDelegate:self andPlacementId:kTapjoyPlacementId];
}
//INT
- (void)heliumInterstitialAdWithPlacementId:(NSString*)placementId
                           didLoadWithError:(HeliumError *)error {TRACE
  
}
- (void)heliumInterstitialAdWithPlacementId:(NSString*)placementId
                           didShowWithError:(HeliumError *)error {TRACE
  
}
- (void)heliumInterstitialAdWithPlacementId:(NSString*)placementId
                          didClickWithError:(HeliumError *)error {TRACE
  
}
- (void)heliumInterstitialAdWithPlacementId:(NSString*)placementId
                          didCloseWithError:(HeliumError *)error {TRACE
  
}
//RV
- (void)heliumRewardedVideoAdWithPlacementId:(NSString*)placementId
                            didLoadWithError:(HeliumError *)error {TRACE
  
}
- (void)heliumRewardedVideoAdWithPlacementId:(NSString*)placementId
                            didShowWithError:(HeliumError *)error {TRACE
  
}
- (void)heliumRewardedVideoAdWithPlacementId:(NSString*)placementId
                           didClickWithError:(HeliumError *)error {TRACE
  
}
- (void)heliumRewardedVideoAdWithPlacementId:(NSString*)placementId
                           didCloseWithError:(HeliumError *)error {TRACE
  
}
- (void)heliumRewardedVideoAdWithPlacementId:(NSString*)placementId
                                didGetReward:(NSInteger)reward {TRACE
  
}
@end
