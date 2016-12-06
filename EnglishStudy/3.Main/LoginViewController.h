//
//  LoginViewController.h
//  EnglishStudy
//
//  Created by admin on 1/20/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationControllerEx :  UINavigationController

@end

@interface LoginViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UIImageView    *imgViewAthena;
    IBOutlet UIImageView    *imgViewCloud;
    
    IBOutlet UIButton       *btnFaceBook;
    
    IBOutlet UILabel        *lblForget;
    IBOutlet UIButton       *btnForget;
    IBOutlet UIView         *viewForgetUnderline;
    
    IBOutlet UILabel        *lblRegister;
    IBOutlet UIButton       *btnRegister;
    IBOutlet UIView         *viewRegisterUnderline;
    
    IBOutlet UIView         *viewContent;

    IBOutlet UITextField    *txtEmail;
    IBOutlet UITextField    *txtPass;
}

- (IBAction)onClickLogin:(id)sender;

- (IBAction)onClickRegister:(id)sender;

- (IBAction)onClickForget:(id)sender;

@end
