//
//  SettingOptionViewController.h
//  EnglishStudy
//
//  Created by admin on 1/22/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupViewController.h"

#define SETTING_OPTION_MODE_REPEAT1         0
#define SETTING_OPTION_MODE_REPEAT2         1
#define SETTING_OPTION_MODE_SPEED           2
#define SETTING_OPTION_MODE_TIME            3
#define SETTING_OPTION_MODE_WORD_COLOR      4
#define SETTING_OPTION_MODE_MEAN_COLOR      5

@interface SettingOptionViewController : PopupViewController
{
    IBOutlet UILabel        *lblTitle;
    
    IBOutlet UILabel        *lblItem1;
    IBOutlet UILabel        *lblItem2;
    IBOutlet UILabel        *lblItem3;
    IBOutlet UILabel        *lblItem4;
    IBOutlet UILabel        *lblItem5;

    IBOutlet UIButton       *btnItem1;
    IBOutlet UIButton       *btnItem2;
    IBOutlet UIButton       *btnItem3;
    IBOutlet UIButton       *btnItem4;
    IBOutlet UIButton       *btnItem5;
    
    IBOutlet UIView         *viewColor1;
    IBOutlet UIView         *viewColor2;
    IBOutlet UIView         *viewColor3;
    IBOutlet UIView         *viewColor4;
    
    NSArray *arrOptionButtons;
    NSArray *arrOptionLabels;
    NSArray *arrOptionColors;

    int     nCurSel;
}

@property (nonatomic) int nSettingMode;
@property (nonatomic) int nSettingValue;

- (IBAction)onClickBtnOK:(id)sender;

- (IBAction)onClickBtnCancel:(id)sender;

- (IBAction)onClickOption:(id)sender;

@end
