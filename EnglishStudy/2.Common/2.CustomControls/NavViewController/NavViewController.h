//
//  NavViewController.h
//  PhoneBook
//
//  Created by admin on 5/29/15.
//  Copyright (c) 2015 kyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavViewController : UIViewController

- (void)pushToController:(UIViewController*)parentViewController toView:(UIView*)parentView withAnimation:(BOOL)bAnimate;

- (void)pushViewController:(NavViewController *)childViewController withAnimation:(BOOL)bAnimate;

- (void)popViewControllerWithAnimation:(BOOL)bAnimate;

@end
