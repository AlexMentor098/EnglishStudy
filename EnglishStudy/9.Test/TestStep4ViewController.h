
#import <UIKit/UIKit.h>
#import "UniversalViewController.h"
#import "TestViewController.h"

@interface TestStep4ViewController : UniversalViewController<TestViewDelegate>
{    
    IBOutlet UIImageView    *imgViewStepMark;
    
    IBOutlet UIView         *viewQuestion;
    IBOutlet UIImageView    *imgViewSound;
    IBOutlet UILabel        *lblQuestionMark;
    IBOutlet UILabel        *lblQuestion;
    
    IBOutlet UIView         *viewProgBar;
    IBOutlet UIView         *viewProgValue;
    
    IBOutlet UIImageView    *imgViewOK;
    IBOutlet UIImageView    *imgViewFALSE;

    IBOutlet UIView         *viewEngWord;
    
    IBOutlet UIView         *viewAnswer;
    IBOutlet UIView         *viewCorrectAnswer;
    IBOutlet UILabel        *lblCorrectAnswer;

    IBOutlet UIView         *viewResults;
    IBOutlet UILabel        *lblCountOK;
    IBOutlet UILabel        *lblCountFalse;
    IBOutlet UILabel        *lblCountTotal;
    
    IBOutlet UIButton       *btnShift;
    
    BOOL        bStop;
}

- (void)startTestWithTotalWords:(int)nTotal nCorrectWords:(int)nCorrect;

- (IBAction)onClickEnglishButton:(id)sender;

- (IBAction)onClickShift:(id)sender;

- (IBAction)onClickDelete:(id)sender;

- (IBAction)onClickBtnCheck:(id)sender;

@end
