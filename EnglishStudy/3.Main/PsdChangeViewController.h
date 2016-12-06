//
//  PsdChangeViewController.h
//  EnglishStudy
//
//  Created by admin on 1/28/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PsdChangeViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UITextField    *txtEmail;
    IBOutlet UITextField    *txtPass;
    IBOutlet UITextField    *txtConfirmPass;
    
    IBOutlet UIButton       *btnChagePsd;
}

@property (nonatomic) BOOL bForget;

- (IBAction)onClickChange:(id)sender;

- (IBAction)onClickBack:(id)sender;

@end
