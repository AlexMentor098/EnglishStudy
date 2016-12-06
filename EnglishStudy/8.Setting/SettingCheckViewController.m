//
//  SettingOptionViewController.m
//  EnglishStudy
//
//  Created by admin on 1/22/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "SettingCheckViewController.h"
#import "Global.h"

@interface SettingCheckViewController ()

@end

@implementation SettingCheckViewController

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
    
    nCurSelectedMode = [Global sharedGlobal].setting.nTestMethod;
    
    [self initControls];
    [self refreshOptionStatus];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)initControls
{
    arrOptionButtons = [NSArray arrayWithObjects:btnItem1, btnItem2, btnItem3, btnItem4, nil];
    arrOptionLabels = [NSArray arrayWithObjects:lblItem1, lblItem2, lblItem3, lblItem4, nil];

    for( int i = 0; i < 4; i++ )
    {
        UIButton    *btnOption = [arrOptionButtons objectAtIndex:i];

        btnOption.tag = i+1;
        btnOption.selected = NO;
    }
}

- (void)refreshOptionStatus
{
    for( int i = 0; i < 4; i++ )
    {
        UIButton    *btnOption = [arrOptionButtons objectAtIndex:i];
        
        if( nCurSelectedMode & (1<<i) )
        {
            btnOption.selected = YES;
        }
        else
        {
            btnOption.selected = NO;
        }
    }
}

- (IBAction)onClickBtnOK:(id)sender
{
    if( nCurSelectedMode == 0 )
        nCurSelectedMode = TEST_METHOD_OPTION_STEP1;

    [Global sharedGlobal].setting.nTestMethod = nCurSelectedMode;
    [[Global sharedGlobal] saveUserInfo];

    [self dismissPopupView];
}

- (IBAction)onClickBtnCancel:(id)sender
{
    [self dismissPopupView];
}

- (IBAction)onClickOption:(id)sender
{
    UIButton    *btnOption = sender;

    if( btnOption.selected == NO )
    {
        nCurSelectedMode |= (1<<(btnOption.tag-1));
        btnOption.selected = YES;
    }
    else
    {
        nCurSelectedMode &= ~(1<<(btnOption.tag-1));
        btnOption.selected = NO;
    }
}

@end
