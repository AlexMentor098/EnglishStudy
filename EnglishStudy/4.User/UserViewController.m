//
//  UserViewController.m
//  EnglishStudy
//
//  Created by admin on 1/11/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "UserViewController.h"
#import "UserPageViewController.h"
#import "UserRegViewController.h"
#import "Global.h"

@interface UserViewController ()

@end

@implementation UserViewController

UserViewController *_sharedUserViewController = nil;

+ (UserViewController *)sharedViewController
{
    return _sharedUserViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)onClickReturn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self createPageView:0];
    
    _sharedUserViewController = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createPageView:(NSUInteger)pageNum
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:UIPageViewControllerSpineLocationMid], UIPageViewControllerOptionSpineLocationKey, [NSNumber numberWithInt:30], UIPageViewControllerOptionInterPageSpacingKey, nil];

    _pageViewCtrl = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:options];
    _pageViewCtrl.delegate = self;
    
    UserPageViewController *viewControllerL = [UserPageViewController userPageViewWithNumer:0];
    UserPageViewController *viewControllerR = [UserPageViewController userPageViewWithNumer:1];
    
    //_pageViewCtrlRight.doubleSided = NO;
    _pageViewCtrl.dataSource = self;

    NSArray *viewControllers = @[viewControllerL, viewControllerR];
    
    [_pageViewCtrl setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:NULL];

    [self addChildViewController:_pageViewCtrl];
    [viewPager addSubview:_pageViewCtrl.view];
    _pageViewCtrl.view.backgroundColor = [UIColor clearColor];

    CGRect pageViewRect = viewPager.bounds;
    _pageViewCtrl.view.frame = pageViewRect;
    
    [_pageViewCtrl didMoveToParentViewController:self];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    UserPageViewController *curViewController = (UserPageViewController *)viewController;
    
    int     nUsers = [[Global sharedGlobal] getUserCount];
    int     nCurPageLastIndex = curViewController.nPageNum*3-1;
    
    if( nCurPageLastIndex >= nUsers )
        return nil;

    UserPageViewController *pageViewCtrl = [UserPageViewController userPageViewWithNumer:curViewController.nPageNum+1];
    
    return pageViewCtrl;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    UserPageViewController *curViewController = (UserPageViewController *)viewController;
    
    if( curViewController.nPageNum == 0 )
        return nil;

    UserPageViewController *pageViewCtrl = [UserPageViewController userPageViewWithNumer:curViewController.nPageNum-1];
    
    return pageViewCtrl;
}

- (void)presentUserRegisterView
{
    UserRegViewController *viewController = [[UserRegViewController alloc] initWithNibName:@"UserRegViewController" bundle:nil];

    [self.navigationController pushViewController:viewController animated:YES];
}

@end
