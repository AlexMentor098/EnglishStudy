//
//  StudyViewController.m
//  EnglishStudy
//
//  Created by admin on 1/14/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "StudyViewController.h"
#import "TestViewController.h"
#import "ResultViewController.h"
#import "PlayViewController.h"
#import "ScheduleChangeViewController.h"
#import "Global.h"

@interface StudyViewController ()

@end

@implementation StudyViewController

StudyViewController *_sharedStudyViewController = nil;

+ (StudyViewController *)sharedViewController
{
    return _sharedStudyViewController;
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
    
    _sharedStudyViewController = self;
    
    viewTabContent.backgroundColor = [UIColor clearColor];
    
    if( [Global sharedGlobal].nLevel == 0 )
        nSelTab = 0;
    else
        nSelTab = 1;
    
    [self initTabButtons];
    [self initTabContents];
    [self refreshTabContents];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [Global resizeViewToLeft:viewTabBar withRatioWidth:559 andHeight:52];
    
    [self refreshButtonStatus];
}

- (void)initTabButtons
{
    arrTabButtons = [NSArray arrayWithObjects:btnTab1, btnTab2, btnTab3, btnTab4, nil];
    arrTabLabels = [NSArray arrayWithObjects:lblTab1, lblTab2, lblTab3, lblTab4, nil];

    for( int i = 0; i < 4; i++ )
    {
        UIButton *button  = [arrTabButtons objectAtIndex:i];
        button.tag = i;
        
        CGRect rect = button.frame;
        button.layer.anchorPoint = CGPointMake(0.5, 1.0f);
        button.frame = rect;
    }
    
    //[self refreshButtonStatus];
}

- (void)initTabContents
{
    tabViewCtrl1 = [[StudyLevelSelViewController alloc] initWithNibName:@"StudyLevelSelViewController" bundle:nil];
    [self addChildViewController:tabViewCtrl1];
    
    tabViewCtrl2 = [[ScheduleViewController alloc] initWithNibName:@"ScheduleViewController" bundle:nil];
    [self addChildViewController:tabViewCtrl2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)refreshButtonStatus
{
    for( int i = 0; i < 4; i++ )
    {
        UIButton    *button  = [arrTabButtons objectAtIndex:i];
        UILabel     *label = [arrTabLabels objectAtIndex:i];
        CGRect      rect = label.frame;

        if( i == nSelTab )
        {
            button.layer.zPosition = 5;
            button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.05f, 1.15f);
            button.userInteractionEnabled = NO;
            button.selected = YES;

            label.textColor = UIRGBColor(100, 64, 0, 255);
            rect.origin.y = rect.size.height/3;
            label.frame = rect;
        }
        else
        {
            button.layer.zPosition = 4-i;
            button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
            button.userInteractionEnabled = YES;
            button.selected = NO;
            
            label.textColor = UIRGBColor(105, 27, 0, 255);
            rect.origin.y = rect.size.height/2;
            label.frame = rect;
        }
        
        label.layer.zPosition = 6;
    }
}

- (void)refreshTabContents
{
    if( nSelTab == 0 )
    {
        [tabViewCtrl2.view removeFromSuperview];
        
        [viewTabContent addSubview:tabViewCtrl1.view];
        tabViewCtrl1.view.frame = viewTabContent.bounds;
    }
    else if( nSelTab == 1 )
    {
        [tabViewCtrl1.view removeFromSuperview];
        
        [viewTabContent addSubview:tabViewCtrl2.view];
        tabViewCtrl2.view.frame = viewTabContent.bounds;
    }
}

- (IBAction)onToucnDownTabButton:(id)sender
{
    //[self refreshButtonZOrder];
    
    //UIButton *curButton = (UIButton *)sender;
    //curButton.layer.zPosition = 5;
    
    UIButton    *curButton = (UIButton *)sender;
    UILabel     *label = [arrTabLabels objectAtIndex:curButton.tag];
    label.textColor = UIRGBColor(100, 64, 0, 255);
}

- (IBAction)onToucnUpInsideTabButton:(id)sender
{
    UIButton *curButton = (UIButton *)sender;
    
    if( nSelTab == curButton.tag )
        return;
    
    // 학습일정이 없을 때
    if( [Global sharedGlobal].nLevel == 0 )
    {
        //일정이나 결과타브를 선택하는 경우
        if( curButton.tag == 1 )
        {
            [MsgViewController popupWithParentViewController:self msg:@"보관된 일정자료가 없습니다." msgID:1 delegate:self];
            return;
        }
        else if( curButton.tag == 2 )
        {
            [MsgViewController popupWithParentViewController:self msg:@"학습일정을 선택하십시요." msgID:1 delegate:self];
            return;
        }
    }

    if( curButton.tag == 3 )
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    else if( curButton.tag == 2 )
    {
        ResultViewController *viewController = [[ResultViewController alloc] initWithNibName:@"ResultViewController" bundle:nil];
        
        [self.navigationController pushViewController:viewController animated:YES];
        return;
    }
    
    [self selectTab:(int)curButton.tag];
}

- (void)selectTab:(int)nTab
{
    nSelTab = nTab;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.15];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(onTabSelected)];
    [self refreshButtonStatus];
    [UIView commitAnimations];
}

- (void)onTabSelected
{
    if( nSelTab == 0 )
    {
        [self refreshTabContents];
    }
    else if( nSelTab == 1 )
    {
        [self refreshTabContents];
    }
    else if( nSelTab == 2 )
    {
    }
    else if( nSelTab == 3 )
        [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onToucnUpOutsideTabButton:(id)sender
{
    [self refreshButtonStatus];
}

- (void)startLevelTest
{
    [Global sharedGlobal].bLevelTest = YES;
    TestViewController *viewController = [[TestViewController alloc] initWithNibName:@"TestViewController" bundle:nil];

    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)startStudy
{
    // check exception
    if( [Global sharedGlobal].nDayWords < 10 )
    {
        [Global sharedGlobal].nDayWords = 10;
        [[Global sharedGlobal] saveUserInfo];
    }

    PlayViewController *viewController = [[PlayViewController alloc] initWithNibName:@"PlayViewController" bundle:nil];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)changeSchedule
{
    ScheduleChangeViewController *viewController = [[ScheduleChangeViewController alloc] initWithNibName:@"ScheduleChangeViewController" bundle:nil];
    
    if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
        [viewController popupWithParentViewController:self popupHeight:596 ofParentHeight:640];
    else
        [viewController popupWithParentViewController:self popupHeight:486 ofParentHeight:768];
}

- (void)gotoScheduleTab
{
    [self selectTab:1];

    [[ScheduleViewController sharedViewController] refreshSchedule];
}

- (void)refreshScheduleView
{
    [[ScheduleViewController sharedViewController] refreshSchedule];
}

@end
