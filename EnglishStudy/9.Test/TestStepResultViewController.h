
#import <UIKit/UIKit.h>
#import "UniversalViewController.h"

@interface TestStepResultViewController : UniversalViewController
{
    IBOutlet UIView         *viewStudyWords;
    IBOutlet UIView         *viewScore;
    IBOutlet UIView         *viewIncorrectWords;

    IBOutlet UILabel        *lblStudyWords;
    IBOutlet UILabel        *lblScore;
    IBOutlet UILabel        *lblIncorrectWords;
    
    IBOutlet UIImageView    *imgViewStar1;
    IBOutlet UIImageView    *imgViewStar2;
    IBOutlet UIImageView    *imgViewStar3;
    IBOutlet UIImageView    *imgViewStar4;
    IBOutlet UIImageView    *imgViewStar5;
    
    IBOutlet UIImageView    *imgViewMedal;
    IBOutlet UIView         *viewResult;
    
    IBOutlet UIButton       *btnOK;
}

@property (nonatomic) int   nWordCount;
@property (nonatomic) int   nTotalWords;
@property (nonatomic) int   nCorrectWords;

- (IBAction)onClickBtnOK:(id)sender;

@end
