#import "BROptionsButton.h"


@interface BROptionsButton ()
@property (nonatomic, weak)   UIImageView *openedStateImage;
@property (nonatomic, weak)   UIImageView *closedStateImage;
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
        _currentState = BROptionsButtonStateNormal;
        _items = [NSMutableArray new];
        
        [self installTheButton];
        
    }
    return self;
}

- (void)installTheButton {
    
    NSString *reason = [NSString stringWithFormat:@"The selected index %d is out of bounds for tabBar.items = %d",
                        (int)self.locationIndexInTabBar, (int)self.tabBar.items.count];
    
    NSAssert((self.tabBar.items.count -1 >= self.locationIndexInTabBar), reason);
    
    if(self.tabBar.items.count > self.locationIndexInTabBar) {
        
        //1- disable the button underneath BROptionsButton
        [[self.tabBar.items objectAtIndex:self.locationIndexInTabBar] setEnabled:NO];
        
        CGPoint buttonLocation = [self buttonLocaitonForIndex:self.locationIndexInTabBar];
        CGRect myRect = CGRectMake(0.0, 0.0, 60, 60);
        self.frame = myRect;
        self.center = buttonLocation;
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = 6;
        self.clipsToBounds = YES;
        self.layer.zPosition = MAXFLOAT;
        [self.tabBar addSubview:self];
        
        [self addTarget:self
                 action:@selector(buttonPressed)
        forControlEvents:UIControlEventTouchUpInside];
        
        [self addObservers];
        [self setupSubviews];
        
        self.translatesAutoresizingMaskIntoConstraints = YES;
    }
}

- (void)setupSubviews {
    
    const CGFloat leftRightMargin = 10;
    const CGRect imagesRect = CGRectInset(self.bounds, leftRightMargin, leftRightMargin);
   
    UIImageView *closedImageView = [[UIImageView alloc] initWithFrame:imagesRect];
    closedImageView.contentMode = UIViewContentModeScaleAspectFit;
    closedImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:closedImageView];
    self.closedStateImage = closedImageView;
    
    UIImageView *openedImageView = [[UIImageView alloc] initWithFrame:imagesRect];
    openedImageView.contentMode = closedImageView.contentMode;
    openedImageView.backgroundColor = closedImageView.backgroundColor;
    openedImageView.center = CGPointMake(openedImageView.center.x,
    openedImageView.center.y + (closedImageView.frame.size.height));
    [self addSubview:openedImageView];
    self.openedStateImage = openedImageView;
    
    openedImageView.autoresizingMask = closedImageView.autoresizingMask = [self allAutoresizingMasksFlags];
    openedImageView.translatesAutoresizingMaskIntoConstraints = closedImageView.translatesAutoresizingMaskIntoConstraints = YES;
}

- (void)addObservers {
    [self.tabBar addObserver:self
                  forKeyPath:@"selectedItem"
                     options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                     context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
}

- (CGPoint)buttonLocaitonForIndex:(NSUInteger)index {
    
    UITabBarItem *item = [self.tabBar.items objectAtIndex:index];
    UIView *view = [item valueForKey:@"view"];
    return view.center;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.center = [self buttonLocaitonForIndex:self.locationIndexInTabBar];
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
    
    if(state == BROptionsButtonStateClosed ||
       state == BROptionsButtonStateNormal) {
        
        self.closedStateImage.image = image;
    } else {
        self.openedStateImage.image = image;
    }
}

- (void)setLocationIndexInTabBar:(NSUInteger)newIndex animated:(BOOL)animated {
    
    [[self.tabBar.items objectAtIndex:self.locationIndexInTabBar] setEnabled:YES];
    [[self.tabBar.items objectAtIndex:newIndex] setEnabled:NO];
    _locationIndexInTabBar = newIndex;
    
    CGPoint location = [self buttonLocaitonForIndex:newIndex];
    if(self.currentState == BROptionsButtonStateOpened) {
        [self buttonPressed];
    }
    
    if(animated) {
        [self.superview layoutIfNeeded];
        [UIView animateWithDuration:0.1 animations:^{
            
            self.center = location;
            [self.superview layoutIfNeeded];
            
        } completion:nil];
        
    } else {
        self.center = location;
    }
}

- (void)setCurrentState:(BROptionsButtonState)state animated:(BOOL)animated {
    _currentState = state;
    
    CGPoint openedCenter = self.openedStateImage.center;
    CGPoint closedCenter = self.closedStateImage.center;
    CGFloat animationDelay = 0.0;
    
    if(self.currentState == BROptionsButtonStateNormal ||
       self.currentState == BROptionsButtonStateClosed) {
        
        closedCenter.y = CGRectGetMidY(self.bounds);
        openedCenter.y = closedCenter.y + (self.closedStateImage.frame.size.height * 2);
        animationDelay = 0.05;
        [self hideButtons];
        [self removeBlackView];
        
    } else {
        openedCenter.y = CGRectGetMidY(self.bounds);
        closedCenter.y = openedCenter.y - (self.openedStateImage.frame.size.height * 2);
        [self addBlackView];
        [self showOptions];
    }
    
    if (animated) {
        self.enabled = NO;
        [UIView animateWithDuration:0.4 delay:animationDelay usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.closedStateImage.center = closedCenter;
            self.openedStateImage.center = openedCenter;
            
        } completion:^(BOOL finished) {
            NSLog(@"finished");
            self.enabled = YES;
        }];

    } else {
        self.closedStateImage.center = closedCenter;
        self.openedStateImage.center = openedCenter;
    }
    
}

#pragma mark - Action

- (void)buttonPressed {
    
    if(self.currentState == BROptionsButtonStateNormal ||
       self.currentState == BROptionsButtonStateClosed) {
        
        _currentState = BROptionsButtonStateOpened;

    } else {
        _currentState = BROptionsButtonStateClosed;
    }
    
    [self setCurrentState:self.currentState animated:YES];
}

#pragma  mark - Black overlay view 

- (void)addBlackView {
    
    self.enabled = NO;
    
    [self.tabBar.superview insertSubview:self.blackView belowSubview:self.tabBar];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.blackView.alpha = 0.7;
    } completion:^(BOOL finished) {
        self.enabled = YES;
    }];
}

- (UIView *)blackView {
    
    if(_blackView == nil) {
        _blackView = [[UIView alloc] initWithFrame:self.tabBar.superview.bounds];
        _blackView.autoresizingMask = [self allAutoresizingMasksFlags];
        [_blackView setTranslatesAutoresizingMaskIntoConstraints:YES];
        
        _blackView.backgroundColor = [UIColor blackColor];
        _blackView.alpha = 0.0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blackViewPressed)];
        [_blackView addGestureRecognizer:tap];
    }
    _blackView.frame = self.tabBar.superview.bounds;
    return _blackView;
}

- (void)removeBlackView {
    self.enabled = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.blackView.alpha = 0.0;
    } completion:^(BOOL finished) {
        
        [self.blackView removeFromSuperview];
        self.enabled = YES;
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
        (mypoint.y -  buttonY) - self.tabBar.frame.size.height);
        
        brOptionItem.layer.anchorPoint = self.layer.anchorPoint;
        brOptionItem.center = mypoint;
        brOptionItem.defaultLocation = buttonPoint;
    
        [self.tabBar.superview insertSubview:brOptionItem aboveSubview:self.blackView];
        [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            brOptionItem.center = buttonPoint;
            
        } completion:nil];
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
        
        UIImage *image = [self.delegate brOptionsButton:self
                                    imageForItemAtIndex:index];
        if(image) {
            [brOptionItem setImage:image forState:UIControlStateNormal];
        }
    }
    
    if([self.delegate respondsToSelector:@selector(brOptionsButton:titleForItemAtIndex:)]) {
        
        NSString *buttonTitle = [self.delegate brOptionsButton:self
                                           titleForItemAtIndex:index];
        if(buttonTitle != nil) {
            [brOptionItem setTitle:buttonTitle forState:UIControlStateNormal];
        }
    }
    return brOptionItem;
}

- (void)hideButtons {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            
            for(int i = 0; i < self.items.count; i++) {
                
                UIView *item = [self.items objectAtIndex:i];
                item.center = [self.tabBar.superview convertPoint:self.center fromView:self.superview];
            }
        } completion:^(BOOL finished) {
            
            [self removeItems];
            //NSLog(@"finished");
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
    [self buttonPressed];
    
    [self.delegate brOptionsButton:self didSelectItem:button];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
        button.transform = CGAffineTransformMakeScale(5, 5);
        button.alpha  = 0.0;
        button.center = CGPointMake(button.center.x,
                                    button.superview.frame.size.height / 2);
    } completion:^(BOOL finished) {
        [button removeFromSuperview];
    }];
}

- (UIViewAutoresizing)allAutoresizingMasksFlags {
    UIViewAutoresizing mask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    return mask;
}
@end
