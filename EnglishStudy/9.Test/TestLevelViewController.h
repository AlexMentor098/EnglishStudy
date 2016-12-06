
#import <UIKit/UIKit.h>
#import "UniversalViewController.h"

@interface TestLevelViewController : UniversalViewController
{
    IBOutlet UIView         *viewResult;
    IBOutlet UIView         *viewGraph;
    
    IBOutlet UIView         *viewLevel;
    IBOutlet UIImageView    *imgViewLevel;
    
    IBOutlet UILabel        *lblDesc1;
    IBOutlet UILabel        *lblDesc2;
    
    IBOutlet UIButton       *btnOK;
}

@property (nonatomic) int   nTotalWords;
@property (nonatomic) int   nCorrectWords;

@property (nonatomic) int   nLevel;

- (IBAction)onClickBtnOK:(id)sender;

@end
