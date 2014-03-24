//
//  MainTabBarController.m
//  BROptionsButtonDemo
//
//  Created by Basheer Malaa on 3/10/14.
//  Copyright (c) 2014 Basheer Malaa. All rights reserved.
//

#import "MainTabBarController.h"
#import "BROptionsButton.h"

@interface MainTabBarController ()<BROptionButtonDelegate>

@end

@implementation MainTabBarController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    BROptionsButton *brOption = [[BROptionsButton alloc] initForTabBar:self.tabBar forItemIndex:1 delegate:self];
    
    [brOption setImage:[UIImage imageNamed:@"Apple"] forBROptionsButtonState:BROptionsButtonStateNormal];
    [brOption setImage:[UIImage imageNamed:@"close"] forBROptionsButtonState:BROptionsButtonStateOpened];
}

#pragma mark - BROptionsButtonState

- (NSInteger)brOptionsButtonNumberOfItems:(BROptionsButton *)brOptionsButton
{
    return 7;
}

- (UIImage*)brOptionsButton:(BROptionsButton *)brOptionsButton imageForItemAtIndex:(NSInteger)index
{
    UIImage *image = [UIImage imageNamed:@"Apple"];
    return image;
}


- (void)brOptionsButton:(BROptionsButton *)brOptionsButton didSelectItem:(BROptionItem *)item
{
    [self setSelectedIndex:brOptionsButton.locationIndexInTabBar];
}

@end
