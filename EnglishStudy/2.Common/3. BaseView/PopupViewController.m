//
//  PopupViewController.m
//  EnglishStudy
//
//  Created by admin on 1/22/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "PopupViewController.h"

@interface PopupViewController ()

@end

@implementation PopupViewController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popupWithParentViewController:(UIViewController *)parentViewController popupHeight:(float)fHeight ofParentHeight:(float)fParentHeight
{
    [parentViewController addChildViewController:self];
    
    viewMask = [[UIView alloc] initWithFrame:parentViewController.view.bounds];
    viewMask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
    [parentViewController.view addSubview:viewMask];
    
    [self popupToParent:viewMask popupHeight:fHeight ofParentHeight:fParentHeight];
}

- (void)popupToParent:(UIView *)parentView popupHeight:(float)fHeight ofParentHeight:(float)fParentHeight
{
    [parentView addSubview:self.view];
    
    CGSize  size = parentView.bounds.size;
    CGRect  orgRect = self.view.frame;
    
    CGRect  rect;
    
    rect.size.height = size.height*fHeight/fParentHeight;
    rect.size.width = rect.size.height*orgRect.size.width/orgRect.size.height;
    rect.origin.x = (size.width - rect.size.width)/2;
    rect.origin.y = (size.height - rect.size.height)/2;

    self.view.frame = rect;

    self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
    self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.05, 1.05);
    [UIView commitAnimations];
}

- (void)bounce1AnimationStopped
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.95, 0.95);
    [UIView commitAnimations];
}

- (void)bounce2AnimationStopped
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    self.view.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}

- (void)dismissPopupView
{
    self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.15];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(dismissAnimationStopped)];
    self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.01f, 0.01f);
    [UIView commitAnimations];
}

- (void)dismissAnimationStopped
{
    [self.view removeFromSuperview];
    [viewMask removeFromSuperview];

    [self removeFromParentViewController];
}

@end
