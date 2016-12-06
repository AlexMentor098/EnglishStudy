
#import <UIKit/UIKit.h>
#import "ScheduleItemView.h"
#import "UniversalViewController.h"

@interface ScheduleViewController : UniversalViewController<ScheduleItemViewDelegate>
{
    IBOutlet UIButton       *btnChange;
    IBOutlet UIButton       *btnPrev;
    IBOutlet UIButton       *btnNext;
    
    IBOutlet UILabel        *lblScheduleDate;

    IBOutlet UIImageView    *imgViewLevel;
    IBOutlet UILabel        *lblStartDate;
    IBOutlet UILabel        *lblEndDate;
    IBOutlet UILabel        *lblStudyCount;

    IBOutlet UIView         *viewProgressBar;
    IBOutlet UIView         *viewProgressValue;
    IBOutlet UILabel        *lblProgressValue;
    
    IBOutlet UIView         *viewItem1;
    IBOutlet UIView         *viewItem2;
    IBOutlet UIView         *viewItem3;
    IBOutlet UIView         *viewItem4;
    IBOutlet UIView         *viewItem5;
    IBOutlet UIView         *viewItem6;
    IBOutlet UIView         *viewItem7;
    IBOutlet UIView         *viewItem8;
    
    NSArray                 *arrViewItemFrames;
    NSMutableArray          *arrViewItems;
}

@property (nonatomic) int   nLeftDays;

@property (nonatomic) NSArray *arrScheduleDays;;

+ (ScheduleViewController *)sharedViewController;

- (void)refreshSchedule;

- (IBAction)onClickScheduleChange:(id)sender;

- (IBAction)onClickBtnPrev:(id)sender;

- (IBAction)onClickBtnNext:(id)sender;

@end
