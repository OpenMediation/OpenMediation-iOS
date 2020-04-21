// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMUnityBannerClass_h
#define OMUnityBannerClass_h

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, UADSBannerErrorCode) {
    UADSBannerErrorCodeUnknown = 0,
    UADSBannerErrorCodeNativeError = 1,
    UADSBannerErrorCodeWebViewError = 2,
    UADSBannerErrorCodeNoFillError = 3
};

typedef NS_ENUM(NSInteger, UnityAdsBannerPosition) {
    kUnityAdsBannerPositionTopLeft,
    kUnityAdsBannerPositionTopCenter,
    kUnityAdsBannerPositionTopRight,
    kUnityAdsBannerPositionBottomLeft,
    kUnityAdsBannerPositionBottomCenter,
    kUnityAdsBannerPositionBottomRight,
    kUnityAdsBannerPositionCenter,
    kUnityAdsBannerPositionNone
};

@interface UADSBannerError : NSError

- (instancetype)initWithCode:(UADSBannerErrorCode)code userInfo:(nullable NSDictionary<NSErrorUserInfoKey, id> *)dict;

@end



@class UADSBannerView;

/**
 * UnityAdsBannerDelegate is a delegate class for callbacks from Unity Ads Banner operations.
 */
@protocol UADSBannerViewDelegate <NSObject>

@optional
/**
 Called when the banner is loaded and ready to be placed in the view hierarchy.

 @param bannerView View that was loaded
*/
- (void)bannerViewDidLoad:(UADSBannerView *)bannerView;

/**
 * Called when the user clicks the banner.
 *
 * @param bannerView View that the click occurred on.
 */
- (void)bannerViewDidClick:(UADSBannerView *)bannerView;

/**
 * Called when a banner causes
 * @param bannerView View that triggered leaving application
 */
- (void)bannerViewDidLeaveApplication:(UADSBannerView *)bannerView;

/**
 *  Called when `UnityAdsBanner` encounters an error. All errors will be logged but this method can be used as an additional debugging aid. This callback can also be used for collecting statistics from different error scenarios.
 *
 *  @param bannerView View that encountered an error.
 *  @param error UADSBannerError that occurred
 */
- (void)bannerViewDidError:(UADSBannerView *)bannerView error:(UADSBannerError *)error;

@end

@interface UADSBannerView : UIView

@property(nonatomic, readonly) CGSize size;
@property(nonatomic, readwrite, nullable, weak) NSObject <UADSBannerViewDelegate> *delegate;
@property(nonatomic, readonly) NSString *placementId;

-(instancetype)initWithPlacementId:(NSString *)placementId size:(CGSize)size;

-(void)load;

@end

NS_ASSUME_NONNULL_END

#endif /* OMUnityBannerClass_h */
