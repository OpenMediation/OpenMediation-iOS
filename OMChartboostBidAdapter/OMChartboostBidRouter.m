// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMChartboostBidRouter.h"

static OMChartboostBidRouter * _instance = nil;

@implementation OMChartboostBidRouter
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _placementDelegateMap = [NSMutableDictionary dictionary];
        _placementAdMap = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registerPidDelegate:(NSString*)pid delegate:(id)delegate {
    [_placementDelegateMap setObject:delegate forKey:pid];
}


- (void)loadInterstitialWithPlacmentID:(NSString *)pid {
    
    id <HeliumInterstitialAd> heliumInterstitial = [_placementAdMap objectForKey:pid];
    if (!heliumInterstitial) {
        Class heliumClass = NSClassFromString(@"HeliumSdk");
        if (heliumClass && [heliumClass instancesRespondToSelector:@selector(interstitialAdProviderWithDelegate:andPlacementName:)]) {
            heliumInterstitial = [[heliumClass sharedHelium] interstitialAdProviderWithDelegate:self andPlacementName:pid];
            [_placementAdMap setObject:heliumInterstitial forKey:pid];
        }
    }
    
    [heliumInterstitial loadAd];
    
}
- (void)loadRewardedVideoWithPlacmentID:(NSString *)pid {
    
    id <HeliumRewardedAd> heliumRewarded = [_placementAdMap objectForKey:pid];

    if (!heliumRewarded) {
        Class heliumClass = NSClassFromString(@"HeliumSdk");
        if (heliumClass && [heliumClass instancesRespondToSelector:@selector(interstitialAdProviderWithDelegate:andPlacementName:)]) {
            heliumRewarded = [[heliumClass sharedHelium] rewardedAdProviderWithDelegate:self andPlacementName:pid];
            [_placementAdMap setObject:heliumRewarded forKey:pid];
        }
    }
    
    [heliumRewarded loadAd];
}


- (BOOL)isReady:(NSString *)pid {
    BOOL isReady = NO;
    id <HeliumInterstitialAd> heliumInterstitial = [_placementAdMap objectForKey:pid];
    if (heliumInterstitial && [heliumInterstitial respondsToSelector:@selector(readyToShow)]) {
        isReady = [heliumInterstitial readyToShow];
    }
    return isReady;
}

- (void)showAd:(NSString *)pid withVC:(UIViewController*)vc {
    if ([self isReady:pid]) {
        id <HeliumInterstitialAd> heliumInterstitial = [_placementAdMap objectForKey:pid];
        if(heliumInterstitial && [heliumInterstitial respondsToSelector:@selector(showAdWithViewController:)]) {
            [heliumInterstitial showAdWithViewController:vc];
        }
    }
}

#pragma -- CHBHeliumInterstitialAdDelegate


- (void)heliumInterstitialAdWithPlacementName:(NSString*)placementName
                             didLoadWithError:(HeliumError *)error {
    id <OMChartboostBidAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementName];
    if (delegate) {
        [delegate omChartboostBiDdidLoadWithError:error];
    }
}

- (void)heliumInterstitialAdWithPlacementName:(NSString*)placementName
                             didShowWithError:(HeliumError *)error {
    id <OMChartboostBidAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementName];
    if (delegate) {
        [delegate omChartboostBidDidShowWithError:error];
    }
}

- (void)heliumInterstitialAdWithPlacementName:(NSString*)placementName
                            didClickWithError:(HeliumError *)error {
    id <OMChartboostBidAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementName];
    if (delegate) {
        [delegate omChartboostBidDidClickWithError:error];
    }
}

- (void)heliumInterstitialAdWithPlacementName:(NSString*)placementName
                            didCloseWithError:(HeliumError *)error {
    id <OMChartboostBidAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementName];
    if (delegate) {
        [delegate omChartboostBidDidCloseWithError:error];
    }
}


- (void)heliumInterstitialAdWithPlacementName:(NSString*)placementName
                    didLoadWinningBidWithInfo:(NSDictionary*)bidInfo {
    id <OMChartboostBidAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementName];
    if (delegate) {
        [delegate omChartboostBidDidLoadWinningBidWithInfo:bidInfo];
    }
}

#pragma -- CHBHeliumRewardedAdDelegate

- (void)heliumRewardedAdWithPlacementName:(NSString*)placementName
                         didLoadWithError:(HeliumError *)error {
    id <OMChartboostBidAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementName];
    if (delegate) {
        [delegate omChartboostBiDdidLoadWithError:error];
    }
}

- (void)heliumRewardedAdWithPlacementName:(NSString*)placementName
                         didShowWithError:(HeliumError *)error {
    id <OMChartboostBidAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementName];
    if (delegate) {
        [delegate omChartboostBidDidShowWithError:error];
    }
}

- (void)heliumRewardedAdWithPlacementName:(NSString*)placementName
                        didClickWithError:(HeliumError *)error {
    
    id <OMChartboostBidAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementName];
    if (delegate) {
        [delegate omChartboostBidDidClickWithError:error];
    }
}

- (void)heliumRewardedAdWithPlacementName:(NSString*)placementName
                        didCloseWithError:(HeliumError *)error {
    id <OMChartboostBidAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementName];
    if (delegate) {
        [delegate omChartboostBidDidCloseWithError:error];
    }
}

- (void)heliumRewardedAdWithPlacementName:(NSString*)placementName
                             didGetReward:(NSInteger)reward {
    id <OMChartboostBidAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementName];
    if (delegate) {
        [delegate omChartboostBidDidGetReward:reward];
    }
}


- (void)heliumRewardedAdWithPlacementName:(NSString*)placementName
                didLoadWinningBidWithInfo:(NSDictionary*)bidInfo {
    id <OMChartboostBidAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementName];
    if (delegate) {
        [delegate omChartboostBidDidLoadWinningBidWithInfo:bidInfo];
    }
}



@end
