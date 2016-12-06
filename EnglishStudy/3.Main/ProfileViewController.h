//
//  ProfileViewController.h
//  EnglishStudy
//
//  Created by admin on 1/28/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupViewController.h"
#import "MainViewController.h"

@interface ProfileViewController : PopupViewController<UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    IBOutlet UIButton       *btnUserPhoto;
    
    IBOutlet UIImageView    *imgViewStart1;
    IBOutlet UIImageView    *imgViewStart2;
    IBOutlet UIImageView    *imgViewStart3;
    IBOutlet UIImageView    *imgViewStart4;
    IBOutlet UIImageView    *imgViewStart5;

    IBOutlet UITextField    *txtUsername;
    IBOutlet UILabel        *lblEmail;

    UIImagePickerController *_imagePickerController;
}

- (IBAction)onClickUserPhoto:(id)sender;

- (IBAction)onClickClose:(id)sender;

- (IBAction)onClickChangePassword:(id)sender;

- (IBAction)onClickLogout:(id)sender;

@end
