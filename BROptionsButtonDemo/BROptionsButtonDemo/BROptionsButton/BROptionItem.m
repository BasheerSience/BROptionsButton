//
//  BROptionItem.m
//  BROptionsButtonDemo
//
//  Created by Basheer Malaa on 3/10/14.
//  Copyright (c) 2014 Basheer Malaa. All rights reserved.
//

#import "BROptionItem.h"

const CGFloat kBROptionsItemDefaultItemHeight = 40;

@interface BROptionItem ()

@property (nonatomic, strong) UIAttachmentBehavior *dragAttachement;
@property (nonatomic, strong) UIDynamicAnimator *dynamicsAnimator;
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;

@end


@implementation BROptionItem

#pragma mark - Inits/setups

- (instancetype)initWithIndex:(NSInteger)index {
    self = [self init];
    if(self) {
        _index = index;
    }
    return self;
}

- (id)init {
    self = [super initWithFrame:CGRectMake(0.0,
                                           0.0,
                                           kBROptionsItemDefaultItemHeight,
                                           kBROptionsItemDefaultItemHeight)];
    if(self) {
        [self LayoutTheButton];
    }
    return self;
}

- (void)LayoutTheButton {
    self.layer.cornerRadius = self.frame.size.height/2;
    self.backgroundColor = [UIColor blueColor];
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0, 1);
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.5;
}


// overriding super class methods
- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    [super setImage:image forState:state];
    self.backgroundColor = [UIColor clearColor];
}

//TODO: override setCenter or setFrame


#pragma mark - touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.superview];
    location.x += (self.frame.size.width/2);
    location.y += (self.frame.size.height/2);
    self.dragAttachement  = [[UIAttachmentBehavior alloc] initWithItem:self attachedToAnchor:location];
    self.highlighted = YES;
    
    UIDynamicAnimator *animator = self.attachment.dynamicAnimator;
    // add attachment to move
    [animator addBehavior:self.dragAttachement];
    // remove the old behavior
    [animator removeBehavior:self.attachment];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // move the attachment
    UITouch *touch = [touches anyObject];
    CGPoint nextPoint = [touch locationInView:self];
    nextPoint.x += (self.frame.size.width/2);
    nextPoint.y += (self.frame.size.height/2);
    
    nextPoint = [self.superview convertPoint:nextPoint fromView:self];
    self.dragAttachement.anchorPoint = nextPoint;
    
    self.highlighted = NO;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // remove the attachment
    UIDynamicAnimator *animator = self.dragAttachement.dynamicAnimator;
    
    [animator removeBehavior:self.dragAttachement];
    [animator addBehavior:self.attachment];
    // add the old attahment
    
    if(self.highlighted) {
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    self.highlighted = NO;
}

#pragma  mark - dealloc 

- (void)dealloc {
    _attachment = nil;
}
@end

