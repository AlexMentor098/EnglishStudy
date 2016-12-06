

#import <UIKit/UIKit.h>
#import "UniversalViewController.h"

@interface StudyTimeViewController : UniversalViewController
{
    IBOutlet UILabel    *lblPeriod;
    IBOutlet UIButton   *btnLeft;
    IBOutlet UIButton   *btnRight;
    
    IBOutlet UIView     *viewGraph;
    IBOutlet UIView     *viewDesc;
}

- (IBAction)onClickBtnPrev:(id)sender;

- (IBAction)onClickBtnNext:(id)sender;

@end
