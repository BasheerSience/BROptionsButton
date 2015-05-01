//
//  BROptionItem.h
//  BROptionsButtonDemo
//
//  Created by Basheer Malaa on 3/10/14.
//  Copyright (c) 2014 Basheer Malaa. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const CGFloat kBROptionsItemDefaultItemHeight;


@interface BROptionItem : UIButton

@property (nonatomic, readonly) NSInteger index;
@property (nonatomic, assign) CGPoint defaultLocation;
- (instancetype)initWithIndex:(NSInteger)index;

@end
