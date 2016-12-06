
#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface RegisterViewController : UIViewController<UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    IBOutlet UIImageView    *imgViewCloud;
    IBOutlet UIView         *viewContent;
    
    IBOutlet UIButton       *btnUserPhoto;

    IBOutlet UITextField    *txtUserName;
    IBOutlet UITextField    *txtEmail;
    IBOutlet UITextField    *txtPass;
    IBOutlet UITextField    *txtConfirmPass;
    
    UIImagePickerController *_imagePickerController;

    UIImage     *imgUserPhoto;
}

- (IBAction)onClickUserPhoto:(id)sender;

- (IBAction)onClickRegister:(id)sender;

- (IBAction)onClickBack:(id)sender;

@end
