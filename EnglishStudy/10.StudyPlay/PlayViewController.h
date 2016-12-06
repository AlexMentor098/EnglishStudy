

#import <UIKit/UIKit.h>
#import "PlayPageViewController.h"
#import "MsgViewController.h"
#import "UniversalViewController.h"

@interface PlayViewController : UniversalViewController <MsgViewDelegate, UIPageViewControllerDelegate, UIPageViewControllerDataSource>
{
    IBOutlet UIView         *viewPager;
    
    IBOutlet UIButton       *btnSave;
    IBOutlet UIButton       *btnBack;
    
    IBOutlet UIButton       *btnPrev;
    IBOutlet UIButton       *btnPause;
    IBOutlet UIButton       *btnNext;

    UIPageViewController    *_pageViewCtrl;
    
    BOOL    bPaused;
}

@property (nonatomic) NSArray   *arrDicWords;
@property (nonatomic) int       nWordCount;

@property (nonatomic) BOOL  bStepChanging;
@property (nonatomic) BOOL  bPagingEnable;

@property (nonatomic) int   nCurStep;
@property (nonatomic) int   nRepeat;
@property (nonatomic) int   nCurPage;

+ (PlayViewController *)sharedViewController;

- (IBAction)onClickBack:(id)sender;

- (IBAction)onClickSave:(id)sender;

- (IBAction)onClickPrev:(id)sender;

- (IBAction)onClickNext:(id)sender;

- (IBAction)onClickPause:(id)sender;

- (void)playNextPage:(PlayPageViewController *)curPlayPage;

@end
