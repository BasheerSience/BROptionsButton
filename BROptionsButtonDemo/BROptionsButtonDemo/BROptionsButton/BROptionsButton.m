#import "BROptionsButton.h"


@interface BROptionsButton ()

@property (nonatomic, strong) UIDynamicAnimator *dynamicsAnimator2;
@property (nonatomic, strong) UIDynamicAnimator *dynamicsAnimator;
@property (nonatomic, strong) UIAttachmentBehavior *attachmentBehavior;
@property (nonatomic, strong) UIGravityBehavior *gravityBehavior;
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior *dynamicItem;
@property (nonatomic, strong) UIImageView *openedStateImage;
@property (nonatomic, strong) UIImageView *closedStateImage;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) UIView *blackView;

@end

@implementation BROptionsButton

- (instancetype)initWithTabBar:(UITabBar *)tabBar
                  forItemIndex:(NSUInteger)itemIndex
                      delegate:(id)delegate {
    
    if(self = [super init]) {
        _delegate = delegate;
        _tabBar = tabBar;
        _locationIndexInTabBar = itemIndex;
        _damping = 0.5;
        _frequecny = 4;
        _currentState = BROptionsButtonStateClosed;
        _items = [NSMutableArray new];
        
        [self installTheButton];
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.translatesAutoresizingMaskIntoConstraints = YES;
    }
    return self;
}

- (void)installTheButton {
    
    NSString *reason = [NSString stringWithFormat:@"The selected index %lu is out of bounds for tabBar.items = %lu",
                        (long)self.locationIndexInTabBar, (unsigned long)self.tabBar.items.count];
    
    NSAssert((self.tabBar.items.count -1 >= self.locationIndexInTabBar), reason);
    
    if(self.tabBar.items.count > self.locationIndexInTabBar) {
        
        UITabBarItem *item = [self.tabBar.items objectAtIndex:self.locationIndexInTabBar];
        item.enabled = NO;
        UIView *view = [item valueForKey:@"view"];
       // NSLog(@"%@", NSStringFromCGRect(view.frame));
    
        CGRect myRect = CGRectMake(0.0,
                                   0.0,
                                   60, 60);
        self.frame = myRect;
        self.center = view.center;
        
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = 6;
        self.clipsToBounds = YES;
        
        [view.superview addSubview:self];
        //NSLog(@"%@", NSStringFromCGRect(self.frame));
        [self addTarget:self
                 action:@selector(buttonPressed)
       forControlEvents:UIControlEventTouchUpInside];
        
        // Dynamic stuff
        //self.gravityBehavior = [[UIGravityBehavior alloc] init];
        //self.gravityBehavior.gravityDirection = CGVectorMake(0.0, -20);
        self.dynamicsAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.tabBar.superview];
        self.dynamicItem = [[UIDynamicItemBehavior alloc] init];
        self.dynamicItem.allowsRotation = NO;
        
        //self.collisionBehavior = [[UICollisionBehavior alloc] init];
        //self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
        //[self.dynamicsAnimator addBehavior:self.collisionBehavior];
        //[self.dynamicsAnimator addBehavior:self.gravityBehavior];
        [self.tabBar addObserver:self
                      forKeyPath:@"selectedItem"
                         options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                         context:nil];
        [self.tabBar addObserver:self forKeyPath:@"frame"
                         options:0
                                            context:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(orientationChanged)
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
    }
}

- (CGPoint)buttonLocaitonForIndex:(NSUInteger)index {
    UITabBarItem *item = [self.tabBar.items objectAtIndex:index];
    UIView *view = [item valueForKey:@"view"];
    CGPoint pointToSuperview = view.center;//[self.tabBar.superview convertPoint:view.center
                                 //                         fromView:self.tabBar];
    return pointToSuperview;
}

#pragma  mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if([keyPath isEqualToString:@"selectedItem"]) {
        if(self.currentState == BROptionsButtonStateOpened) {
            [self buttonPressed];
        }
    } else if([keyPath isEqualToString:@"frame"]) {
    }
}

#pragma mark - UIInterfaceOrientation notifications

- (void)orientationChanged {
    if(self.currentState == BROptionsButtonStateOpened) {
        [self buttonPressed];
    }
}

#pragma mark - Public 

- (void)setImage:(UIImage *)image forBROptionsButtonState:(BROptionsButtonState)state {
    UIImageView *imgV = Nil;
    imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0,
                                                         self.frame.size.width,
                                                         self.frame.size.height - 20)];
    imgV.image = image;
    imgV.contentMode = UIViewContentModeScaleAspectFit;
    imgV.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    if(state == BROptionsButtonStateClosed ||
       state == BROptionsButtonStateNormal) {
        self.openedStateImage = imgV;
        [self addSubview:self.openedStateImage];
    } else {
        self.closedStateImage = imgV;
        self.closedStateImage.center = CGPointMake(self.closedStateImage.center.x,
                                                   self.frame.size.height + (self.closedStateImage.frame.size.height/2));
        [self addSubview:self.closedStateImage];
    }
    
}

- (void)setLocationIndexInTabBar:(NSUInteger)newIndex animated:(BOOL)animated {
    [[self.tabBar.items objectAtIndex:_locationIndexInTabBar]setEnabled:YES];
    [[self.tabBar.items objectAtIndex:newIndex]setEnabled:NO];
    
    _locationIndexInTabBar = newIndex;
    CGPoint location = [self buttonLocaitonForIndex:newIndex];
    CGRect frame = self.frame;
    frame.origin = location;
    if(self.currentState == BROptionsButtonStateOpened) {
        [self buttonPressed];
    }
    if(animated) {
        [UIView animateWithDuration:0.1 animations:^{
            [self.superview layoutIfNeeded];
            [self.superview setNeedsDisplay];
            self.center = location;
        } completion:^(BOOL finished) {
            [self.tabBar.superview setNeedsDisplay];
        }];
    } else {
        self.center = location;
    }
}

#pragma mark - Action

- (void)buttonPressed {
    
    if(self.currentState == BROptionsButtonStateNormal ||
       self.currentState == BROptionsButtonStateClosed) {
        
        _currentState = BROptionsButtonStateOpened;
        [self changeTheButtonStateAnimatedToOpen:@(YES)];
        [self performSelector:@selector(showOptions)
                   withObject:nil
                   afterDelay:0.05];
    } else {
        _currentState = BROptionsButtonStateClosed;
        [self hideButtons];
        [self performSelector:@selector(changeTheButtonStateAnimatedToOpen:)
                   withObject:@(NO)
                   afterDelay:0.05];
    }
}

- (void)changeTheButtonStateAnimatedToOpen:(NSNumber*)open {
    
    CGPoint openImgCenter = self.openedStateImage.center;
    CGPoint closedImgCenter = self.closedStateImage.center;
    
    if([open boolValue]) {
        openImgCenter.y = ((self.openedStateImage.frame.size.height/2) * -1);
        closedImgCenter.y = (self.frame.size.height /2);
        closedImgCenter.x = self.frame.size.width/2;
        [self addBlackView];
    } else {
        openImgCenter.y = self.frame.size.height /2;
        closedImgCenter.y = self.frame.size.height + self.closedStateImage.frame.size.height/2;
        [self removeBlackView];
    }
    
    self.openedStateImage.center = CGPointMake(self.frame.size.width/2, self.openedStateImage.center.y);
    self.closedStateImage.center = CGPointMake((self.frame.size.width/2) , self.closedStateImage.center.y);
    
    self.dynamicsAnimator2 = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    
    UISnapBehavior *snapBehaviour = [[UISnapBehavior alloc] initWithItem:self.closedStateImage
                                                             snapToPoint:closedImgCenter];
    UISnapBehavior *snapBehaviour2 = [[UISnapBehavior alloc] initWithItem:self.openedStateImage
                                                              snapToPoint:openImgCenter];
    snapBehaviour.damping = 0.78;
    snapBehaviour2.damping = 0.78;
    [self.dynamicsAnimator2 addBehavior:snapBehaviour];
    [self.dynamicsAnimator2 addBehavior:snapBehaviour2];
}

#pragma  mark - Black overlay view 

- (void)addBlackView {
    
    self.enabled = NO;
    self.blackView = [[UIView alloc] initWithFrame:self.tabBar.superview.bounds];
    self.blackView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    [self.blackView setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    self.blackView.backgroundColor = [UIColor blackColor];
    self.blackView.alpha = 0.0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blackViewPressed)];
    [self.blackView addGestureRecognizer:tap];
    
    [self.tabBar.superview insertSubview:self.blackView belowSubview:self.tabBar];
    [UIView animateWithDuration:0.3 animations:^{
        self.blackView.alpha = 0.7;
    } completion:^(BOOL finished) {
        if(finished){
            self.enabled = YES;
        }
    }];
}

- (void)removeBlackView {
    
    self.enabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        
        self.blackView.alpha = 0.0;
    } completion:^(BOOL finished) {
        
        if(finished) {
            [self.blackView removeFromSuperview];
            self.blackView = nil;
            self.enabled = YES;
        }
    }];
}

- (void)blackViewPressed {
    [self buttonPressed];
}

- (void)showOptions {
    
    NSInteger numberOfItems = [self.delegate brOptionsButtonNumberOfItems:self];
    NSAssert(numberOfItems > 0 , @"number of items should be more than 0");
    
    CGFloat angle = 0.0;
    CGFloat radius = 20 * numberOfItems;
    angle = (180.0 / numberOfItems);
    // convert to radians

    angle = angle / 180.0f * M_PI;
    
    for(int i = 0; i<numberOfItems; i++) {
        CGFloat buttonX = radius * cosf((angle * i) + angle/2);
        CGFloat buttonY = radius * sinf((angle * i) + angle/2);

        BROptionItem *brOptionItem = [self createButtonItemAtIndex:i];
        CGPoint mypoint = [self.tabBar.superview convertPoint:self.center fromView:self.superview];
        CGPoint buttonPoint = CGPointMake(mypoint.x + buttonX, 
                                          mypoint.y -  buttonY - self.frame.size.height);
        
        brOptionItem.layer.anchorPoint = self.layer.anchorPoint;
        brOptionItem.center = mypoint;
    
        UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:brOptionItem
                                                                     attachedToAnchor:buttonPoint];
        attachment.damping = self.damping;
        attachment.frequency = self.frequecny;
        attachment.length = 1;
        
        // set the attachment for dragging behavior
        brOptionItem.attachment = attachment;
        [self.dynamicItem addItem:brOptionItem];
        
        if([self.delegate respondsToSelector:@selector(brOptionsButton:willDisplayButtonItem:)]) {
            [self.delegate brOptionsButton:self willDisplayButtonItem:brOptionItem];
        }
        
        [self.tabBar.superview insertSubview:brOptionItem belowSubview:self.tabBar];
        [self.dynamicsAnimator addBehavior:attachment];
        [self.items addObject:brOptionItem];
    }
}

/*! Just make new button, set the index 
 * and customise it
 */
- (BROptionItem*)createButtonItemAtIndex:(NSInteger)index {
    
    BROptionItem *brOptionItem = [[BROptionItem alloc] initWithIndex:index];
    [brOptionItem addTarget:self
                     action:@selector(buttonItemPressed:)
           forControlEvents:UIControlEventTouchUpInside];
    brOptionItem.autoresizingMask = UIViewAutoresizingNone;
    
    if([self.delegate respondsToSelector:@selector(brOptionsButton:imageForItemAtIndex:)]) {
        UIImage *image = [self.delegate brOptionsButton:self imageForItemAtIndex:index];
        if(image) {
            [brOptionItem setImage:image forState:UIControlStateNormal];
        }
    }
    
    if([self.delegate respondsToSelector:@selector(brOptionsButton:titleForItemAtIndex:)]) {
        NSString *buttonTitle = [self.delegate brOptionsButton:self titleForItemAtIndex:index];
        if(buttonTitle.length) {
            [brOptionItem setTitle:buttonTitle forState:UIControlStateNormal];
        }
    }
    return brOptionItem;
}

- (void)hideButtons {
    
    [self.dynamicsAnimator removeAllBehaviors];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        __block int count = 0;
        [UIView animateWithDuration:0.2 animations:^{
            
            for(int i = 0; i<self.items.count; i++) {
                UIView *item = [self.items objectAtIndex:i];
                item.center = [self.tabBar.superview convertPoint:self.center fromView:self.superview];
                count ++;
            }
        } completion:^(BOOL finished) {
            
            if(finished && count >= self.items.count) {
                dispatch_barrier_async(dispatch_get_main_queue(), ^{
                    [self removeItems];
                });
            }
        }];
    });
}

- (void)removeItems {
    for(UIView *view in self.items) {
        [view removeFromSuperview];
    }
    [self.items removeAllObjects];
}

#pragma mark - Buttons Actions

- (void)buttonItemPressed:(BROptionItem*)button {
    
    // removeing the object will not animate it with others
    [self.items removeObject:button];
    [self.dynamicsAnimator removeBehavior:button.attachment];
    [self buttonPressed];
    
    [self.delegate brOptionsButton:self didSelectItem:button];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
        button.transform = CGAffineTransformMakeScale(5, 5);
        button.alpha  = 0.0;
        button.center = CGPointMake(button.superview.frame.size.width/2 + button.frame.size.width/2,
                                    button.superview.frame.size.height/2);
    } completion:^(BOOL finished) {
        if(finished) {
            [button removeFromSuperview];
        }
    }];
}

@end
