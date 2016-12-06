//
//  StudyLevelSelViewController.h
//  EnglishStudy
//
//  Created by admin on 1/14/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgViewController.h"
#import "QuestionViewController.h"
#import "UniversalViewController.h"

@interface StudyLevelSelViewController : UniversalViewController <MsgViewDelegate, QuestionViewDelegate>
{
    IBOutlet UIView     *viewLevels;
    IBOutlet UIButton   *btnStartTest;
    
    IBOutlet UIImageView    *imgViewComment;
    
    int     nSelectLevel;
}

- (IBAction)onClickStartTest:(id)sender;

- (IBAction)onClickBtnLevel:(id)sender;

@end
