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

#pragma mark - touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.highlighted = YES;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    self.highlighted = NO;
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    CGPoint prevLocation = [touch previousLocationInView:self];
    CGPoint deltaPoint = CGPointMake(location.x - prevLocation.x, location.y - prevLocation.y);
    self.center = CGPointMake(self.center.x + deltaPoint.x, self.center.y + deltaPoint.y);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.center = self.defaultLocation;
    } completion:nil];
    
    if(self.highlighted) {
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (double)CGPointGetDistance:(CGPoint)p1 toPoint:(CGPoint)p2 {
    double dx = (p2.x - p1.x);
    double dy = (p2.y - p1.y);
    double dist = sqrt((dx * dx) + (dy * dy));
    return dist;
}

#pragma  mark - dealloc 

- (void)dealloc {
    
    //NSLog(@"dealloc index: %ld", self.index);
}
@end

