
#import <UIKit/UIKit.h>
#import "UniversalViewController.h"
#import "TestViewController.h"

@interface TestStep1ViewController : UniversalViewController<TestViewDelegate>
{    
    IBOutlet UIImageView    *imgViewStepMark;
    
    IBOutlet UIView         *viewQuestion;
    IBOutlet UIImageView    *imgViewSound;
    IBOutlet UILabel        *lblQuestionMark;
    IBOutlet UILabel        *lblQuestion;
    IBOutlet UIView         *viewProgBar;
    IBOutlet UIView         *viewProgValue;
    
    IBOutlet UIView         *viewAnswer;

    IBOutlet UIButton       *btnAnswer1;
    IBOutlet UIButton       *btnAnswer2;
    IBOutlet UIButton       *btnAnswer3;
    IBOutlet UIButton       *btnAnswer4;
    
    IBOutlet UILabel        *lblAnswer1;
    IBOutlet UILabel        *lblAnswer2;
    IBOutlet UILabel        *lblAnswer3;
    IBOutlet UILabel        *lblAnswer4;
    
    IBOutlet UIImageView    *imgViewFalse1;
    IBOutlet UIImageView    *imgViewFalse2;
    IBOutlet UIImageView    *imgViewFalse3;
    IBOutlet UIImageView    *imgViewFalse4;
    
    IBOutlet UIImageView    *imgViewOK1;
    IBOutlet UIImageView    *imgViewOK2;
    IBOutlet UIImageView    *imgViewOK3;
    IBOutlet UIImageView    *imgViewOK4;

    IBOutlet UILabel    *lblNumber1;
    IBOutlet UILabel    *lblNumber2;
    IBOutlet UILabel    *lblNumber3;
    IBOutlet UILabel    *lblNumber4;
    
    IBOutlet UIView     *viewResults;
    
    IBOutlet UILabel    *lblCountOK;
    IBOutlet UILabel    *lblCountFalse;
    IBOutlet UILabel    *lblCountTotal;
    
    NSArray *arrAnswerButton;
    NSArray *arrAnswerLabels;
    NSArray *arrImgViewFalse;
    NSArray *arrImgViewOK;
    NSArray *arrNumberLabels;
    
    BOOL    bStop;
    BOOL    bPause;
}

- (IBAction)onClickBtnAnswer:(id)sender;

@end
