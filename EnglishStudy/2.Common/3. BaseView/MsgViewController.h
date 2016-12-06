
#import <UIKit/UIKit.h>

#import "PopupViewController.h"

@protocol MsgViewDelegate <NSObject>

- (void)didHideMsgView:(int)nMsgID;

@end

@interface MsgViewController : PopupViewController
{
    IBOutlet UILabel *lblMessage;
}

@property (nonatomic) id<MsgViewDelegate> delegate;
@property (nonatomic) int nMsgID;
@property (nonatomic) NSString *strMessage;

+ (void)popupWithParentViewController:(UIViewController *)parentViewController msg:(NSString *)strMsg msgID:(int)nMsgID delegate:(id<MsgViewDelegate>)delegate;

- (IBAction)onClickContinue:(id)sender;

@end
