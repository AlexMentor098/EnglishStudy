//
//  SettingOptionViewController.h
//  EnglishStudy
//
//  Created by admin on 1/22/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupViewController.h"

@interface SettingCheckViewController : PopupViewController
{
    IBOutlet UILabel        *lblTitle;
    
    IBOutlet UILabel        *lblItem1;
    IBOutlet UILabel        *lblItem2;
    IBOutlet UILabel        *lblItem3;
    IBOutlet UILabel        *lblItem4;

    IBOutlet UIButton       *btnItem1;
    IBOutlet UIButton       *btnItem2;
    IBOutlet UIButton       *btnItem3;
    IBOutlet UIButton       *btnItem4;
    
    NSArray *arrOptionButtons;
    NSArray *arrOptionLabels;
    
    int     nCurSelectedMode;
}

- (IBAction)onClickBtnOK:(id)sender;

- (IBAction)onClickBtnCancel:(id)sender;

- (IBAction)onClickOption:(id)sender;

@end
