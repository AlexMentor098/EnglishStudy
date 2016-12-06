

#import <UIKit/UIKit.h>
#import "UniversalViewController.h"

@interface TestResultViewController : UniversalViewController
{
    IBOutlet UILabel    *lblPeriod;
    IBOutlet UIButton   *btnLeft;
    IBOutlet UIButton   *btnRight;
    
    IBOutlet UIView     *viewGraph;
}

- (IBAction)onClickBtnPrev:(id)sender;

- (IBAction)onClickBtnNext:(id)sender;

@end
