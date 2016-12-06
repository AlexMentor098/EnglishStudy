
#import <UIKit/UIKit.h>

#import "StudyTimeViewController.h"
#import "StudyWordViewController.h"
#import "TestResultViewController.h"
#import "UniversalViewController.h"

@interface ResultViewController : UniversalViewController
{
    IBOutlet UIView     *viewTabBar;
    
    IBOutlet UIButton   *btnTab1;
    IBOutlet UIButton   *btnTab2;
    IBOutlet UIButton   *btnTab3;
    IBOutlet UIButton   *btnTab4;
    
    IBOutlet UILabel    *lblTab1;
    IBOutlet UILabel    *lblTab2;
    IBOutlet UILabel    *lblTab3;
    IBOutlet UILabel    *lblTab4;
    
    IBOutlet UIView     *viewTabContent;
    
    StudyTimeViewController     *tabViewCtrl1;
    StudyWordViewController     *tabViewCtrl2;
    TestResultViewController    *tabViewCtrl3;

    NSArray     *arrTabButtons;
    NSArray     *arrTabLabels;
    int         nSelTab;
}

- (IBAction)onToucnDownTabButton:(id)sender;

- (IBAction)onToucnUpInsideTabButton:(id)sender;

- (IBAction)onToucnUpOutsideTabButton:(id)sender;

@end
