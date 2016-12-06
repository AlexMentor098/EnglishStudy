
#import <UIKit/UIKit.h>
#import "UniversalViewController.h"
#import "QuestionViewController.h"
#import "TestViewController.h"

@interface TestStepViewController : UniversalViewController <QuestionViewDelegate>
{
    IBOutlet UILabel    *lblTestTab;
    IBOutlet UILabel    *lblBackTab;

    IBOutlet UIView     *viewContent;

    UIViewController<TestViewDelegate> *pageViewController;
}

+ (TestStepViewController *)shareViewController;

- (IBAction)onClickStart:(id)sender;

- (IBAction)onClickBack:(id)sender;

- (IBAction)onTouchDragIn:(id)sender;

- (IBAction)onTouchDragOut:(id)sender;

- (void)moveTo4StepWithTotalWords:(int)nTotalWords andCorrectWords:(int)nCorrectWords;

- (void)showTestResult:(int)nTotalWords correctWords:(int)nCorrectWords;

- (void)returnFromTest;

@end
