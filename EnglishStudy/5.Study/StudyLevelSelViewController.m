//
//  StudyLevelSelViewController.m
//  EnglishStudy
//
//  Created by admin on 1/14/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "StudyLevelSelViewController.h"
#import "StudyViewController.h"
#import "Global.h"

@interface StudyLevelSelViewController ()

@end

@implementation StudyLevelSelViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [Global resizeView:viewLevels withRatioWidth:400 andHeight:350];
    [Global resizeView:btnStartTest withRatioWidth:138 andHeight:132];
    [Global resizeView:imgViewComment withRatioWidth:272 andHeight:128];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickStartTest:(id)sender
{
    [[StudyViewController sharedViewController] startLevelTest];
}

/*
시험에서...
시험을 중지하겠습니까?
예, 아니.
*/

- (void)showScheduleTab
{
    [Global sharedGlobal].nPrepareLevel = nSelectLevel;

    [[StudyViewController sharedViewController] changeSchedule];
}

- (void)didHideQuestionView:(int)nQuestionID withButton:(int)nButtonID
{
    if( nButtonID != 0 )
        return;

    if( nQuestionID == 1 )
    {
        if( [Global sharedGlobal].nLevel == nSelectLevel )
            return;

        // 일정이 없은 경우(새로 선택하는 경우)
        if( [Global sharedGlobal].nLevel == 0 )
        {
            [self showScheduleTab];
        }
        else
        {
            NSString *strMsg = @"새로운 급수를 선택하는 경우\n이미 보관된 급수자료들이\n모두 지워집니다.\n그래도 계속하겠습니까?";
        
            [QuestionViewController popupWithParentViewController:[StudyViewController sharedViewController] msg:strMsg msgID:2 delegate:self];
        }
    }
    else if( nQuestionID == 2 )
    {
        [self showScheduleTab];
    }
}

- (void)didHideMsgView:(int)nMsgID
{
    
}

- (void)selectLevel:(int)nLevel
{
    nSelectLevel = nLevel;
    
    NSString *strMsg = [NSString stringWithFormat:@"%d급학습을 시작합니다.", nSelectLevel];
    
    [QuestionViewController popupWithParentViewController:[StudyViewController sharedViewController] msg:strMsg msgID:1 delegate:self];
    //[MsgViewController popupWithParentViewController:[StudyViewController sharedViewController] msg:strMsg msgID:1 delegate:self];
}

- (IBAction)onClickBtnLevel:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    [self selectLevel:(int)button.tag];
}

@end
