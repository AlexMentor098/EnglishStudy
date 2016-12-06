
#import <UIKit/UIKit.h>
#import "UniversalViewController.h"

@interface SettingViewController : UniversalViewController
{
    IBOutlet UIView     *viewContent;
    
    IBOutlet UILabel    *lblRepeat1;
    IBOutlet UILabel    *lblRepeat2;
    IBOutlet UILabel    *lblWordColor;
    IBOutlet UILabel    *lblMeanColor;
    IBOutlet UILabel    *lblTestTime;
    IBOutlet UILabel    *lblTestMethod;
    IBOutlet UILabel    *lblStudySpeed;
}

+ (SettingViewController *)sharedViewController;

- (void)refreshSettingValues;

- (IBAction)onClickBack:(id)sender;

- (IBAction)onClickBtnStudyRepeat1:(id)sender;

- (IBAction)onClickBtnStudyRepeat2:(id)sender;

- (IBAction)onClickBtnWordColor:(id)sender;

- (IBAction)onClickBtnMeanColor:(id)sender;

- (IBAction)onClickBtnTestTime:(id)sender;

- (IBAction)onClickBtnTestMethod:(id)sender;

- (IBAction)onClickBtnStudySpeed:(id)sender;

@end
