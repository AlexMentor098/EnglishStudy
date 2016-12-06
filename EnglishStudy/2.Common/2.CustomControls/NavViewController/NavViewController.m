//
//  NavViewController.m
//  PhoneBook
//
//  Created by admin on 5/29/15.
//  Copyright (c) 2015 kyn. All rights reserved.
//

#import "NavViewController.h"

@interface NavViewController ()

@end

@implementation NavViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)pushToController:(UIViewController*)parentViewController toView:(UIView*)parentView withAnimation:(BOOL)bAnimate
{
    [parentViewController addChildViewController:self];
    
    [parentView addSubview:self.view];

    self.view.frame = parentView.bounds;

    if( bAnimate )
    {
        CGRect frame = self.view.frame;
        frame.origin.x = frame.size.width;
        
        self.view.frame = frame;
    
        [UIView animateWithDuration:0.3f animations:^(void){
            self.view.frame = parentView.bounds;
        } completion:^(BOOL finished){

        }];
    }
}

- (void)pushViewController:(NavViewController *)childViewController withAnimation:(BOOL)bAnimate
{
    [childViewController pushToController:self toView:self.view withAnimation:bAnimate];
}

- (void)popViewControllerWithAnimation:(BOOL)bAnimate
{
    if( bAnimate == NO )
    {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
    else
    {
        [UIView animateWithDuration:0.3f animations:^(void){
            CGRect frame = self.view.frame;
            
            frame.origin.x = frame.size.width;
            
            self.view.frame = frame;
        } completion:^(BOOL finished){
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }];
    }
}

@end
