//
//  LoginViewController.m
//  EnglishStudy
//
//  Created by admin on 1/20/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "LoginViewController.h"
#import "PsdChangeViewController.h"
#import "MsgViewController.h"
#import "Global.h"
#import "UserManager.h"

@implementation UINavigationControllerEx

//- (UIInterfaceOrientationMask)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

@end

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[Global sharedGlobal] initGlobal];
    [[Global sharedGlobal] loadAutoLoginUserParam];

    txtEmail.delegate = self;
    txtPass.delegate = self;
    
    txtEmail.text = [Global sharedGlobal].strSavedEmail;
    txtPass.text = [Global sharedGlobal].strSavedPassword;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    txtEmail.font = [UIFont fontWithName:@"Gulim" size:txtEmail.bounds.size.height*0.8f];
    txtPass.font = [UIFont fontWithName:@"Gulim" size:txtPass.bounds.size.height*0.8f];

    CGRect  rect;
    
    [lblForget sizeToFit];
    
    rect = lblForget.frame;

    rect = viewForgetUnderline.frame;
    rect.origin.x = lblForget.frame.origin.x;
    rect.size.width = lblForget.frame.size.width;
    viewForgetUnderline.frame = rect;

    rect = btnForget.frame;
    rect.origin.x = lblForget.frame.origin.x;
    rect.size.width = lblForget.frame.size.width;
    btnForget.frame = rect;
    
    [lblRegister sizeToFit];
    rect = viewRegisterUnderline.frame;
    rect.origin.x = lblRegister.frame.origin.x;
    rect.size.width = lblRegister.frame.size.width;
    viewRegisterUnderline.frame = rect;

    rect = btnRegister.frame;
    rect.origin.x = lblRegister.frame.origin.x;
    rect.size.width = lblRegister.frame.size.width;
    btnRegister.frame = rect;
    
    [Global resizeView:viewContent withRatioWidth:620 andHeight:277];
    [Global resizeView:imgViewAthena withRatioWidth:432 andHeight:346];
    [Global resizeView:imgViewCloud withRatioWidth:1533 andHeight:1052];
    rect = imgViewCloud.frame;
    rect.origin.x = self.view.bounds.size.width - rect.size.width;
    imgViewCloud.frame = rect;

    [Global resizeView:btnFaceBook withRatioWidth:41 andHeight:41];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void)didHideMsgView:(int)nMsgID
{
    if( nMsgID == 2 )
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)onClickLogin:(id)sender
{
    if( [txtEmail.text isEqualToString:@""] )
    {
        [MsgViewController popupWithParentViewController:self msg:@"이메일을 입력하세요." msgID:1 delegate:self];
        return;
    }
    
    if( [txtPass.text isEqualToString:@""] )
    {
        [MsgViewController popupWithParentViewController:self msg:@"비밀번호를 입력하세요." msgID:1 delegate:self];
        return;
    }

    int nUserID = [UserManager loginUserEmail:txtEmail.text password:txtPass.text];
    if( nUserID == -1 )
    {
        [MsgViewController popupWithParentViewController:self msg:@"존재하지 않는 이메일입니다." msgID:1 delegate:self];
        return;
    }
    else if( nUserID == -2 )
    {
        [MsgViewController popupWithParentViewController:self msg:@"비밀번호가 정확하지 않습니다." msgID:1 delegate:self];
        return;
    }
    
    [Global sharedGlobal].strSavedEmail = txtEmail.text;
    [Global sharedGlobal].strSavedPassword = txtPass.text;
    [[Global sharedGlobal] saveAutoLoginUserParam];

    [[Global sharedGlobal] setLoginUser:nUserID];

    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainviewcontroller"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)onClickRegister:(id)sender
{
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"registerviewcontroller"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)onClickForget:(id)sender
{
    PsdChangeViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"psdchangeviewcontroller"];
    
    viewController.bForget = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{

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
    CGRect      txtFrame2 = [self.view convertRect:txtPass.bounds fromView:txtPass];
    
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
