//
//  ScheduleChangeViewController.h
//  EnglishStudy
//
//  Created by admin on 1/22/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupViewController.h"

@interface ScheduleChangeViewController : PopupViewController
{
    IBOutlet UIView      *viewWordCount;
    
    IBOutlet UILabel     *lblStudyDays;
    IBOutlet UILabel     *lblFinishDay;
    
    BOOL    bNewSchedule;
    int     nTotalWords;
}

- (IBAction)onClickBtnUp:(id)sender;

- (IBAction)onClickBtnDown:(id)sender;

- (IBAction)onClickBtnOK:(id)sender;

- (IBAction)onClickBtnCancel:(id)sender;

@end
