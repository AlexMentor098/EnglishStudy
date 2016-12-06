//
//  PsdChangeViewController.m
//  EnglishStudy
//
//  Created by admin on 1/28/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "PsdChangeViewController.h"

@interface PsdChangeViewController ()

@end

@implementation PsdChangeViewController

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
    
    txtEmail.delegate = self;
    txtPass.delegate = self;
    txtConfirmPass.delegate = self;
    
    if( self.bForget == YES )
    {
        [btnChagePsd setBackgroundImage:[UIImage imageNamed:@"btn_reset_psd.png"] forState:UIControlStateNormal];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    txtEmail.font = [UIFont fontWithName:@"Gulim" size:txtEmail.bounds.size.height*0.8f];
    txtPass.font = [UIFont fontWithName:@"Gulim" size:txtPass.bounds.size.height*0.8f];
    txtConfirmPass.font = [UIFont fontWithName:@"Gulim" size:txtConfirmPass.bounds.size.height*0.8f];
}

- (IBAction)onClickChange:(id)sender
{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBack:(id)sender
{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //CGRect rect = self.view.frame;
    
    //if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
    //    rect.origin.y = -120;
    //else
    //    rect.origin.y = -216;
    
    //self.view.frame = rect;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];

	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -
#pragma mark Notifications

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect      keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float       fShowHeight = self.view.frame.size.height - MIN(keyboardFrame.size.width, keyboardFrame.size.height);

    NSNumber    *curve = [[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSNumber    *duration = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    CGRect      rect = self.view.frame;
    
    CGRect      txtFrame1 = [self.view convertRect:txtEmail.bounds fromView:txtEmail];
    CGRect      txtFrame2 = [self.view convertRect:txtConfirmPass.bounds fromView:txtConfirmPass];
    
    rect.origin.y = -txtFrame1.origin.y + 20;
    rect.origin.y = MAX( rect.origin.y, fShowHeight-txtFrame2.origin.y-txtFrame2.size.height-20 );
    //rect.origin.y = -MIN(keyboardFrame.size.width, keyboardFrame.size.height);

    [UIView animateWithDuration:[duration floatValue]
                          delay:0
                        options:[curve integerValue] << 16
                     animations:^{
                         self.view.frame = rect;
                     }
                     completion:^(BOOL finished){
                         // do nothing for the time being...
                     }
     ];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSNumber    *curve = [[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSNumber    *duration = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];

    [UIView animateWithDuration:[duration floatValue]
                          delay:0
                        options:[curve integerValue] << 16
                     animations:^{
                         self.view.frame = self.view.bounds;
                     }
                     completion:^(BOOL finished){
                         // do nothing for the time being...
                     }
     ];
}

@end
