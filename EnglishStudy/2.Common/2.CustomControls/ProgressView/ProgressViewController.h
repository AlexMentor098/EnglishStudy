
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ToastView.h"
#import "QuestionView.h"
#import "Global.h"

@interface ProgressViewController : UIViewController
{
    MBProgressHUD   *HUD;
}

- (void)refreshContentByLangType;

- (void)showBusyDialogWithTitle:(NSString*)strTitle;

- (void)showBusyDialog;

- (void)hideBusyDialog;

@end
