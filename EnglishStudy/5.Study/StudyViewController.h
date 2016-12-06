//
//  StudyViewController.h
//  EnglishStudy
//
//  Created by admin on 1/14/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StudyLevelSelViewController.h"
#import "ScheduleViewController.h"
#import "UniversalViewController.h"

@interface StudyViewController : UniversalViewController
{
    IBOutlet UIView     *viewTabBar;

    IBOutlet UIButton   *btnTab1;
    IBOutlet UIButton   *btnTab2;
    IBOutlet UIButton   *btnTab3;
    IBOutlet UIButton   *btnTab4;
    
    IBOutlet UILabel    *lblTab1;
    IBOutlet UILabel    *lblTab2;
    IBOutlet UILabel    *lblTab3;
    IBOutlet UILabel    *lblTab4;

    IBOutlet UIView     *viewTabContent;
    
    StudyLevelSelViewController *tabViewCtrl1;
    ScheduleViewController      *tabViewCtrl2;

    NSArray     *arrTabLabels;
    NSArray     *arrTabButtons;
    int         nSelTab;
}

+ (StudyViewController *)sharedViewController;

- (IBAction)onToucnDownTabButton:(id)sender;

- (IBAction)onToucnUpInsideTabButton:(id)sender;

- (IBAction)onToucnUpOutsideTabButton:(id)sender;

- (void)startLevelTest;

- (void)startStudy;

- (void)changeSchedule;

- (void)gotoScheduleTab;

- (void)refreshScheduleView;

@end
