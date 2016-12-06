//
//  ProfileViewController.m
//  EnglishStudy
//
//  Created by admin on 1/28/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "ProfileViewController.h"
#import "Global.h"
#import "UserManager.h"

@interface ProfileViewController ()
{
#ifdef USE_POPOVER_CAMERA
    UIPopoverController *_popoverImagePicker;
#endif
}

@end

@implementation ProfileViewController

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
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.allowsEditing = YES;
    
    self.view.layer.cornerRadius = 10;
    self.view.layer.borderWidth = 2;
    self.view.clipsToBounds = YES;
    self.view.layer.borderColor = UIRGBColor(227, 97, 10, 255).CGColor;

    txtUsername.delegate = self;
    txtUsername.text = [Global sharedGlobal].strUserName;
    lblEmail.text = [Global sharedGlobal].strEmail;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    txtUsername.font = [UIFont fontWithName:@"Gulim" size:txtUsername.bounds.size.height*0.8f];
    
    txtUsername.text = @"";
    txtUsername.text = [Global sharedGlobal].strUserName;
    
    if( [Global sharedGlobal].imgUserPhoto != nil )
    {
        [self setUserPhoto:[Global sharedGlobal].imgUserPhoto];
    }
}

- (IBAction)onClickClose:(id)sender
{
    [self dismissPopupView];
    
    [[MainViewController sharedViewController] refreshUserProfile];
}

- (IBAction)onClickChangePassword:(id)sender
{
    [self dismissPopupView];
    [[MainViewController sharedViewController] gotoChangePassword];
}

- (IBAction)onClickLogout:(id)sender
{
    [self dismissPopupView];
    [[MainViewController sharedViewController] gotoLogout];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 0 )
    {
        if( [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] == FALSE )
            return;
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self performSelector:@selector(showImagePickerView) withObject:nil afterDelay:0];
        
    }
    else if( buttonIndex == 1 )
    {
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self performSelector:@selector(showImagePickerView) withObject:nil afterDelay:0];
    }
}

// function for perform selector
- (void)showImagePickerView
{
#ifdef USE_POPOVER_CAMERA
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        _popoverImagePicker = [[UIPopoverController alloc] initWithContentViewController:_imagePickerController];
        CGRect              rect = [self.view convertRect:btnUserPhoto.bounds fromView:btnUserPhoto];
        [_popoverImagePicker presentPopoverFromRect:rect inView: self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else
#endif
    {
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    }
}

- (IBAction)onClickUserPhoto:(id)sender
{
#ifdef __IPHONE_8_0
    if( SYSTEM_VERSION_LESS_THAN(@"8.0") || [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
    {
#endif
        UIActionSheet   *popup = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:@"취소"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"사진기", @"갤러리", nil];
        
        [popup showInView:self.view];
#ifdef __IPHONE_8_0
    }
    else
    {
        UIAlertController   *popup = [UIAlertController alertControllerWithTitle:@""
                                                                         message:@""
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction       *action1 = [UIAlertAction actionWithTitle:@"사진기"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  if( [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] == FALSE )
                                                                      return;
                                                                  
                                                                  _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                                  
                                                                  //[self presentViewController:_imagePickerController animated:YES completion:nil];
                                                                  [self performSelector:@selector(showImagePickerView) withObject:nil afterDelay:0];
                                                              }];
        
        UIAlertAction       *action2 = [UIAlertAction actionWithTitle:@"갤러리"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                                  _imagePickerController.allowsEditing = YES;
                                                                  //_imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
                                                                  [self performSelector:@selector(showImagePickerView) withObject:nil afterDelay:0];
                                                                  //[self presentViewController:_imagePickerController animated:YES completion:nil];
                                                              }];
        
        [popup addAction:action1];
        [popup addAction:action2];
        
        UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:popup];
        
        CGRect rect = [btnUserPhoto convertRect:btnUserPhoto.bounds toView:self.view];
        
        UIPopoverArrowDirection dir = UIPopoverArrowDirectionUp;
        
        [popoverController presentPopoverFromRect:rect
                                           inView:self.view
                         permittedArrowDirections:dir
                                         animated:YES];
    }
#endif
}

- (void)setUserPhoto:(UIImage *)image
{
    [btnUserPhoto setBackgroundImage:image forState:UIControlStateNormal];
    [btnUserPhoto setBackgroundImage:nil forState:UIControlStateHighlighted];
    
    btnUserPhoto.layer.cornerRadius = btnUserPhoto.bounds.size.height/2;
    btnUserPhoto.layer.borderWidth = 0;
    btnUserPhoto.layer.borderColor = [UIColor whiteColor].CGColor;
    btnUserPhoto.clipsToBounds = YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
#ifdef USE_POPOVER_CAMERA
    [picker dismissViewControllerAnimated:YES completion:nil];
    [_popoverImagePicker dismissPopoverAnimated:YES];
#else
    [picker dismissViewControllerAnimated:YES completion:nil];
#endif
    
    [Global sharedGlobal].imgUserPhoto = image;
    [UserManager updateUserPhoto:image];
    
    [self setUserPhoto:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
#ifdef USE_POPOVER_CAMERA
    [picker dismissViewControllerAnimated:YES completion:nil];
    [_popoverImagePicker dismissPopoverAnimated:YES];
#else
    [picker dismissViewControllerAnimated:YES completion:nil];
#endif
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
    [Global sharedGlobal].strUserName = txtUsername.text;
    
    [[Global sharedGlobal] saveUserInfo];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    return YES;
}

- (IBAction)onClickRegister:(id)sender
{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBack:(id)sender
{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -
#pragma mark Notifications
/*
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect      keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float       fShowHeight = self.view.frame.size.height - MIN(keyboardFrame.size.width, keyboardFrame.size.height);
    
    NSNumber    *curve = [[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSNumber    *duration = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    CGRect      rect = self.view.frame;
    
    CGRect      txtFrame1 = [self.view convertRect:txtUserName.bounds fromView:txtUserName];
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
}*/

@end
