
#import <UIKit/UIKit.h>

@interface MainTabBarController : UITabBarController

@end

@protocol CommonDelegate <NSObject>
- (void)changeBROptionsButtonLocaitonTo:(NSInteger)location animated:(BOOL)animated;
@end