//
//  SettingOptionViewController.m
//  EnglishStudy
//
//  Created by admin on 1/22/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "SettingOptionViewController.h"
#import "Global.h"
#import "SettingViewController.h"

@interface SettingOptionViewController ()

@end

@implementation SettingOptionViewController

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
    
    [self initControls];
    [self refreshTitle];

    nCurSel = self.nSettingValue;
    [self refreshOptionStatus];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)initControls
{
    arrOptionButtons = [NSArray arrayWithObjects:btnItem1, btnItem2, btnItem3, btnItem4, btnItem5, nil];
    arrOptionLabels = [NSArray arrayWithObjects:lblItem1, lblItem2, lblItem3, lblItem4, lblItem5, nil];
    arrOptionColors = [NSArray arrayWithObjects:viewColor1, viewColor2, viewColor3, viewColor4, nil];

    for( int i = 0; i < 5; i++ )
    {
        UIButton    *btnOption = [arrOptionButtons objectAtIndex:i];

        btnOption.tag = i+1;
        btnOption.selected = NO;
    }
    
    if( self.nSettingMode != SETTING_OPTION_MODE_WORD_COLOR && self.nSettingMode != SETTING_OPTION_MODE_MEAN_COLOR )
    {
        for( int i = 0; i < 4; i++ )
        {
            UIView    *viewColor = [arrOptionColors objectAtIndex:i];
            viewColor.hidden = YES;
        }
    }

    if( self.nSettingMode == SETTING_OPTION_MODE_TIME )
    {
        for( int i = 3; i < 5; i++ )
        {
            UIButton    *btnOption = [arrOptionButtons objectAtIndex:i];
            btnOption.hidden = YES;
            
            UILabel     *lblOption = [arrOptionLabels objectAtIndex:i];
            lblOption.hidden = YES;
        }
    }
}

- (void)refreshTitle
{
    if( self.nSettingMode == SETTING_OPTION_MODE_REPEAT1 )
        lblTitle.text = @"학습반복 1단계";
    else if( self.nSettingMode == SETTING_OPTION_MODE_REPEAT2 )
        lblTitle.text = @"학습반복 2단계";
    else if( self.nSettingMode == SETTING_OPTION_MODE_SPEED )
    {
        lblTitle.text = @"빠르기";
        
        lblItem1.text = @"매우느림";
        lblItem2.text = @"느림";
        lblItem3.text = @"보통";
        lblItem4.text = @"빠름";
        lblItem5.text = @"매우빠름";
    }
    else if( self.nSettingMode == SETTING_OPTION_MODE_TIME )
    {
        lblTitle.text = @"테스트 시간";
        
        lblItem1.text = @"5초";
        lblItem2.text = @"7초";
        lblItem3.text = @"10초";
    }
    else
    {
        if( self.nSettingMode == SETTING_OPTION_MODE_WORD_COLOR )
            lblTitle.text = @"단어 형광펜 색";
        else
            lblTitle.text = @"뜻 형광펜 색";

        lblItem1.text = @"없음";
        lblItem2.text = @"노란색";
        lblItem3.text = @"풀색";
        lblItem4.text = @"빨간색";
        lblItem5.text = @"파란색";
    }
}

- (void)refreshOptionStatus
{
    for( int i = 0; i < 5; i++ )
    {
        UIButton    *btnOption = [arrOptionButtons objectAtIndex:i];
        
        if( i == nCurSel )
        {
            btnOption.selected = YES;
            btnOption.userInteractionEnabled = NO;
        }
        else
        {
            btnOption.selected = NO;
            btnOption.userInteractionEnabled = YES;
        }
    }
}

- (IBAction)onClickBtnOK:(id)sender
{
    if( self.nSettingMode == SETTING_OPTION_MODE_REPEAT1 )
        [Global sharedGlobal].setting.nRepeatStep1 = nCurSel;
    else if( self.nSettingMode == SETTING_OPTION_MODE_REPEAT2 )
        [Global sharedGlobal].setting.nRepeatStep2 = nCurSel;
    else if( self.nSettingMode == SETTING_OPTION_MODE_SPEED )
        [Global sharedGlobal].setting.nStudySpeedMode = nCurSel;
    else if( self.nSettingMode == SETTING_OPTION_MODE_TIME )
        [Global sharedGlobal].setting.nTestTimeMode = nCurSel;
    else if( self.nSettingMode == SETTING_OPTION_MODE_WORD_COLOR )
        [Global sharedGlobal].setting.nWordColorMode = nCurSel;
    else
        [Global sharedGlobal].setting.nMeanColorMode = nCurSel;

    [[Global sharedGlobal] saveUserInfo];

    [self dismissPopupView];
    
    [[SettingViewController sharedViewController] refreshSettingValues];
}

- (IBAction)onClickBtnCancel:(id)sender
{
    [self dismissPopupView];
}

- (IBAction)onClickOption:(id)sender
{
    UIButton    *btnOption = sender;

    nCurSel = (int)(btnOption.tag-1);
    
    [self refreshOptionStatus];
}

@end
