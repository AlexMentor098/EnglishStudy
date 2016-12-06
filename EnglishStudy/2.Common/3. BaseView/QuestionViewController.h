
#import <UIKit/UIKit.h>

#import "PopupViewController.h"

@protocol QuestionViewDelegate <NSObject>

- (void)didHideQuestionView:(int)nQuestionID withButton:(int)nButtonID;

@end

@interface QuestionViewController : PopupViewController
{
    IBOutlet UILabel *lblMessage;
}

@property (nonatomic) id<QuestionViewDelegate> delegate;
@property (nonatomic) int nMsgID;
@property (nonatomic) NSString *strMessage;


+ (void)popupWithParentViewController:(UIViewController *)parentViewController msg:(NSString *)strMsg msgID:(int)nMsgID delegate:(id<QuestionViewDelegate>)delegate;

- (IBAction)onClickOK:(id)sender;

- (IBAction)onClickCancel:(id)sender;

@end
