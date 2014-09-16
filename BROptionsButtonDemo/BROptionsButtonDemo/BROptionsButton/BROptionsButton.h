
#import <UIKit/UIKit.h>
#import "BROptionItem.h"

typedef enum {
    BROptionsButtonStateOpened,  // after clicking the button, will be in open state
    BROptionsButtonStateClosed,
    BROptionsButtonStateNormal   // is undefined state usually closed
}BROptionsButtonState;


@protocol BROptionButtonDelegate;
@interface BROptionsButton : UIButton

/*!
 * TabBar currently installed on
 */
@property (nonatomic, readonly, weak) UITabBar *tabBar;
@property (nonatomic, assign) NSInteger locationIndexInTabBar;
@property (nonatomic, weak)   id<BROptionButtonDelegate> delegate;
@property (nonatomic, readonly) BROptionsButtonState currentState;

/*!
 *!parameters: tabBar     - pass the tabBar to be attached to
 *             itemIndex - the item position that will be changed with the button
 *             delgate   - the delegate must be setted
 */
- (instancetype)initWithTabBar:(UITabBar*)tabBar
                 forItemIndex:(NSUInteger)itemIndex
                     delegate:(id<BROptionButtonDelegate>)delegate;
/*! 
 * Set the image for the open state (X in the demo)
 * and for the close state (Apple logo in the demo)
 */
- (void)setImage:(UIImage *)image forBROptionsButtonState:(BROptionsButtonState)state;

@end


//------------------------------------------- Formal Protocol
@protocol BROptionButtonDelegate <NSObject>
- (void)brOptionsButton:(BROptionsButton*)brOptionsButton didSelectItem:(BROptionItem*)item;
- (NSInteger)brOptionsButtonNumberOfItems:(BROptionsButton*)brOptionsButton;

@optional
- (void)brOptionsButton:(BROptionsButton*)optionsButton willDisplayButtonItem:(BROptionItem*)button;
- (NSString*)brOptionsButton:(BROptionsButton*)brOptionsButton titleForItemAtIndex:(NSInteger)index;
- (UIImage*)brOptionsButton:(BROptionsButton*)brOptionsButton imageForItemAtIndex:(NSInteger)index;
@end

