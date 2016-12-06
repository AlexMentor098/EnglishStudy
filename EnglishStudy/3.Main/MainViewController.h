//
//  ViewController.h
//  EnglishStudy
//
//  Created by admin on 1/10/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImagePickerController (extensions)

@end

@interface MainViewController : UIViewController
{
    IBOutlet UIButton   *btnUserPhoto;
    IBOutlet UIButton   *btnStudy;
    IBOutlet UIButton   *btnResult;
    IBOutlet UIButton   *btnHelp;
    IBOutlet UIButton   *btnSetting;
    
    IBOutlet UILabel    *lblUserName;
    IBOutlet UILabel    *lblStarRate;

    IBOutlet UILabel    *lblMonth;
    IBOutlet UIView     *lblDay;

    IBOutlet UIView     *viewProfile;
    IBOutlet UIView     *viewWord;
    IBOutlet UIView     *viewCalendar;
}

+ (MainViewController *)sharedViewController;

- (void)refreshUserProfile;

- (IBAction)onClickProfile:(id)sender;

- (IBAction)onClickUser:(id)sender;

- (IBAction)onClickStudy:(id)sender;

- (IBAction)onClickResult:(id)sender;

- (IBAction)onClickWords:(id)sender;

- (IBAction)onClickHelp:(id)sender;

- (IBAction)onClickSetting:(id)sender;

- (void)gotoChangePassword;

- (void)gotoLogout;

@end
