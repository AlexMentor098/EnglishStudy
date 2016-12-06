//
//  UserPageViewController.m
//  EnglishStudy
//
//  Created by admin on 1/11/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "UserPageViewController.h"
#import "Global.h"
#import "UserViewController.h"

@interface UserPageViewController ()

@end

@implementation UserPageViewController

+ (id)userPageViewWithNumer:(int)nPageNum
{
    UserPageViewController *viewController = [[UserPageViewController alloc] initWithNibName:@"UserPageViewController" bundle:nil];
    
    viewController.nPageNum = nPageNum;
    
    return viewController;
}

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

    if( self.nPageNum%2 == 0 )
        imgViewBG.image = [UIImage imageNamed:@"page_left_bg.png"];
    else
        imgViewBG.image = [UIImage imageNamed:@"page_right_bg.png"];
    
    [self makeUserItemViews];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [Global resizeView:viewUserItem1 withRatioWidth:340 andHeight:143];
    [Global resizeView:viewUserItem2 withRatioWidth:340 andHeight:143];
    [Global resizeView:viewUserItem3 withRatioWidth:340 andHeight:143];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)makeUserItemViews
{
    int nUsers = [[Global sharedGlobal] getUserCount];
    int nStartIndex = self.nPageNum*3-1;
    
    if( nStartIndex >= nUsers )
        return;

    viewUserItem1 = [UserItemView userItemViewWithUserIndex:nStartIndex];
    [viewUser1 addSubview:viewUserItem1];
    viewUserItem1.frame = viewUser1.bounds;
    viewUserItem1.delegate = self;
    
    int nIndex = nStartIndex + 1;
    if( nIndex >= nUsers )
        return;
    
    viewUserItem2 = [UserItemView userItemViewWithUserIndex:nIndex];
    [viewUser2 addSubview:viewUserItem2];
    viewUserItem2.frame = viewUser2.bounds;
    viewUserItem2.delegate = self;
    
    nIndex = nStartIndex + 2;
    if( nIndex >= nUsers )
        return;

    viewUserItem3 = [UserItemView userItemViewWithUserIndex:nIndex];
    [viewUser3 addSubview:viewUserItem3];
    viewUserItem3.frame = viewUser3.bounds;
    viewUserItem3.delegate = self;
}

// UserItemView Delegate
- (void)userItemViewDidSelected:(UserItemView *)view
{
    
}

- (void)userItemViewDidClickRegister:(UserItemView *)view
{
    [[UserViewController sharedViewController] presentUserRegisterView];
}

- (void)userItemViewDidClickEdit:(UserItemView *)view
{
    [[UserViewController sharedViewController] presentUserRegisterView];
}

- (void)userItemViewDidClickDelete:(UserItemView *)view
{
    
}

@end