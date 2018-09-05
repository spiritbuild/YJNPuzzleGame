#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
@class MBBackgroundView;
@protocol MBProgressHUDDelegate;
extern CGFloat const MBProgressMaxOffset;
typedef NS_ENUM(NSInteger, MBProgressHUDMode) {
    MBProgressHUDModeIndeterminate,
    MBProgressHUDModeDeterminate,
    MBProgressHUDModeDeterminateHorizontalBar,
    MBProgressHUDModeAnnularDeterminate,
    MBProgressHUDModeCustomView,
    MBProgressHUDModeText
};
typedef NS_ENUM(NSInteger, MBProgressHUDAnimation) {
    MBProgressHUDAnimationFade,
    MBProgressHUDAnimationZoom,
    MBProgressHUDAnimationZoomOut,
    MBProgressHUDAnimationZoomIn
};
typedef NS_ENUM(NSInteger, MBProgressHUDBackgroundStyle) {
    MBProgressHUDBackgroundStyleSolidColor,
    MBProgressHUDBackgroundStyleBlur
};
NS_ASSUME_NONNULL_BEGIN
@interface MBProgressHUD : UIView
+ (instancetype)showHUDInView:(UIView *)view;
+ (instancetype)showHUDInView:(UIView *)view withText:(NSString *)hudText;
+ (instancetype)showHUDInView:(UIView *)view withText:(NSString *)hudText isSquare:(BOOL)isSquare;
+ (instancetype)showMessageInView:(UIView *)view withText:(NSString *)hudText;
+ (instancetype)showHUDInView:(UIView *)view withCustomView:(UIView *)customView;
+ (instancetype)showHUDInView:(UIView *)view withCustomView:(UIView *)customView andText:(NSString *)hudText;
+ (instancetype)showBlockedHUDInView:(UIView *)view;
+ (instancetype)showBlockedHUDInView:(UIView *)view withText:(NSString *)hudText;
+ (BOOL)hideHUDForView:(UIView *)view;
+ (instancetype)showHUDAddedTo:(UIView *)view animated:(BOOL)animated;
+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated;
+ (nullable MBProgressHUD *)HUDForView:(UIView *)view;
- (instancetype)initWithView:(UIView *)view;
- (void)showAnimated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay;
@property (weak, nonatomic) id<MBProgressHUDDelegate> delegate;
@property (assign, nonatomic) NSTimeInterval graceTime;
@property (assign, nonatomic) NSTimeInterval minShowTime;
@property (assign, nonatomic) BOOL removeFromSuperViewOnHide;
@property (nonatomic, strong) UIView *indicator;
@property (assign, nonatomic) MBProgressHUDMode mode;
@property (strong, nonatomic, nullable) UIColor *contentColor UI_APPEARANCE_SELECTOR;
@property (assign, nonatomic) MBProgressHUDAnimation animationType UI_APPEARANCE_SELECTOR;
@property (assign, nonatomic) CGPoint offset UI_APPEARANCE_SELECTOR;
@property (assign, nonatomic) CGFloat margin UI_APPEARANCE_SELECTOR;
@property (assign, nonatomic) CGSize minSize UI_APPEARANCE_SELECTOR;
@property (assign, nonatomic, getter = isSquare) BOOL square UI_APPEARANCE_SELECTOR;
@property (assign, nonatomic, getter=areDefaultMotionEffectsEnabled) BOOL defaultMotionEffectsEnabled UI_APPEARANCE_SELECTOR;
@property (assign, nonatomic) float progress;
@property (strong, nonatomic, readonly) MBBackgroundView *bezelView;
@property (strong, nonatomic, readonly) MBBackgroundView *backgroundView;
@property (strong, nonatomic, nullable) UIView *customView;
@property (strong, nonatomic, readonly) UILabel *label;
@property (strong, nonatomic, readonly) UILabel *detailsLbl;
@property (strong, nonatomic, readonly) UIButton *button;
@end
@protocol MBProgressHUDDelegate <NSObject>
@optional
- (void)hudWasHidden:(MBProgressHUD *)hud;
@end
@interface MBRoundProgressView : UIView 
@property (nonatomic, assign) float progress;
@property (nonatomic, strong) UIColor *progressTintColor;
@property (nonatomic, strong) UIColor *backgroundTintColor;
@property (nonatomic, assign, getter = isAnnular) BOOL annular;
@end
@interface MBBarProgressView : UIView
@property (nonatomic, assign) float progress;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) UIColor *progressRemainingColor;
@property (nonatomic, strong) UIColor *progressColor;
@end
@interface MBBackgroundView : UIView
@property (nonatomic) MBProgressHUDBackgroundStyle style;
@property (nonatomic, strong) UIColor *color;
@end
@interface MBProgressHUD (Deprecated)
+ (NSArray *)allHUDsForView:(UIView *)view __attribute__((deprecated("Store references when using more than one HUD per view.")));
+ (NSUInteger)hideAllHUDsForView:(UIView *)view animated:(BOOL)animated __attribute__((deprecated("Store references when using more than one HUD per view.")));
- (id)initWithWindow:(UIWindow *)window __attribute__((deprecated("Use initWithView: instead.")));
- (void)show:(BOOL)animated __attribute__((deprecated("Use showAnimated: instead.")));
- (void)hide:(BOOL)animated __attribute__((deprecated("Use hideAnimated: instead.")));
- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay __attribute__((deprecated("Use hideAnimated:afterDelay: instead.")));
typedef void (^MBProgressHUDCompletionBlock)(void);
- (void)showWhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated __attribute__((deprecated("Use GCD directly.")));
- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block __attribute__((deprecated("Use GCD directly.")));
- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block completionBlock:(nullable MBProgressHUDCompletionBlock)completion __attribute__((deprecated("Use GCD directly.")));
- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue __attribute__((deprecated("Use GCD directly.")));
- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue
     completionBlock:(nullable MBProgressHUDCompletionBlock)completion __attribute__((deprecated("Use GCD directly.")));
@property (copy, nullable) MBProgressHUDCompletionBlock completionBlock __attribute__((deprecated("Use GCD directly.")));
@property (assign) BOOL taskInProgress __attribute__((deprecated("No longer needed.")));
@property (nonatomic, copy) NSString *labelText __attribute__((deprecated("Use label.text instead.")));
@property (nonatomic, strong) UIFont *labelFont __attribute__((deprecated("Use label.font instead.")));
@property (nonatomic, strong) UIColor *labelColor __attribute__((deprecated("Use label.textColor instead.")));
@property (nonatomic, copy) NSString *detailsLblText __attribute__((deprecated("Use detailsLbl.text instead.")));
@property (nonatomic, strong) UIFont *detailsLblFont __attribute__((deprecated("Use detailsLbl.font instead.")));
@property (nonatomic, strong) UIColor *detailsLblColor __attribute__((deprecated("Use detailsLbl.textColor instead.")));
@property (assign, nonatomic) CGFloat opacity __attribute__((deprecated("Customize bezelView properties instead.")));
@property (strong, nonatomic) UIColor *color __attribute__((deprecated("Customize the bezelView color instead.")));
@property (assign, nonatomic) CGFloat xOffset __attribute__((deprecated("Set offset.x instead.")));
@property (assign, nonatomic) CGFloat yOffset __attribute__((deprecated("Set offset.y instead.")));
@property (assign, nonatomic) CGFloat cornerRadius __attribute__((deprecated("Set bezelView.layer.cornerRadius instead.")));
@property (assign, nonatomic) BOOL dimBackground __attribute__((deprecated("Customize HUD background properties instead.")));
@property (strong, nonatomic) UIColor *activityIndicatorColor __attribute__((deprecated("Use UIAppearance to customize UIActivityIndicatorView.")));
@property (atomic, assign, readonly) CGSize size __attribute__((deprecated("Get the bezelView.frame.size instead.")));

NS_ASSUME_NONNULL_END
@end
