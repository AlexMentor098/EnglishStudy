
#import "RegisterViewController.h"
#import "Global.h"
#import "UserManager.h"
#import "MsgViewController.h"

@interface RegisterViewController ()
{
#ifdef USE_POPOVER_CAMERA
    UIPopoverController *_popoverImagePicker;
#endif
}

@end

@implementation RegisterViewController

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
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.allowsEditing = YES;

    txtUserName.delegate = self;
    txtEmail.delegate = self;
    txtPass.delegate = self;
    txtConfirmPass.delegate = self;
    
    imgUserPhoto = nil;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    txtUserName.font = [UIFont fontWithName:@"Gulim" size:txtUserName.bounds.size.height*0.8f];
    txtEmail.font = [UIFont fontWithName:@"Gulim" size:txtEmail.bounds.size.height*0.8f];
    txtPass.font = [UIFont fontWithName:@"Gulim" size:txtPass.bounds.size.height*0.8f];
    txtConfirmPass.font = [UIFont fontWithName:@"Gulim" size:txtConfirmPass.bounds.size.height*0.8f];
    
    CGRect  rect;

    [Global resizeView:viewContent withRatioWidth:550 andHeight:228];
    
    [Global resizeView:imgViewCloud withRatioWidth:1533 andHeight:1052];
    rect = imgViewCloud.frame;
    rect.origin.x = self.view.bounds.size.width - rect.size.width;
    imgViewCloud.frame = rect;
}

- (void)setUserPhoto:(UIImage *)image
{
    imgUserPhoto = image;

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
        _popoverImagePicker= [[UIPopoverController alloc] initWithContentViewController:_imagePickerController];
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

- (void)didHideMsgView:(int)nMsgID
{
    if( nMsgID == 2 )
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)onClickRegister:(id)sender
{
    [self.view endEditing:YES];

    if( [txtEmail.text isEqualToString:@""] )
    {
        [MsgViewController popupWithParentViewController:self msg:@"이메일을 입력하세요." msgID:1 delegate:self];
        return;
    }
    
    if( [txtUserName.text isEqualToString:@""] )
    {
        [MsgViewController popupWithParentViewController:self msg:@"유저이름을 입력하세요." msgID:1 delegate:self];
        return;
    }
    
    if( [txtPass.text isEqualToString:@""] )
    {
        [MsgViewController popupWithParentViewController:self msg:@"비밀번호를 입력하세요." msgID:1 delegate:self];
        return;
    }
    
    if( ![txtPass.text isEqualToString:txtConfirmPass.text] )
    {
        [MsgViewController popupWithParentViewController:self msg:@"비밀번호와 비밀번호확인이 일치하지\n않습니다." msgID:1 delegate:self];
        return;
    }

    if( [UserManager findUserEmail:txtEmail.text] == YES )
    {
        [MsgViewController popupWithParentViewController:self msg:@"이미 등록된 이메일입니다." msgID:1 delegate:self];
        return;
    }
    
    if( [UserManager registerUser:txtUserName.text email:txtEmail.text password:txtPass.text photo:imgUserPhoto] == NO )
    {
        [MsgViewController popupWithParentViewController:self msg:@"회원가입실패!" msgID:1 delegate:self];
        return;
    }
    else
    {
        [MsgViewController popupWithParentViewController:self msg:@"회원등록성공!" msgID:2 delegate:self];
    }
}

- (IBAction)onClickBack:(id)sender
{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
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
}


@end
