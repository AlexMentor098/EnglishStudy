
#import <UIKit/UIKit.h>

#import "StudyTimeViewController.h"
#import "StudyWordViewController.h"
#import "TestResultViewController.h"
#import "UniversalViewController.h"

@interface WordsViewController : UniversalViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UIButton   *btnTab1;
    IBOutlet UIButton   *btnTab2;
    IBOutlet UIButton   *btnTab3;
    IBOutlet UIButton   *btnTab4;
    
    IBOutlet UIView     *viewTabContent;
    
    IBOutlet UITableView    *tblViewContent;
    
    IBOutlet UIButton       *btnSortName;
    IBOutlet UIButton       *btnSortRegister;
    IBOutlet UIImageView    *imgViewWordAll;
    
    IBOutlet UILabel        *lblPage;

    NSArray     *arrTabButtons;
    int         nSelTab;
    
    BOOL        bSortBySpell;
}

- (IBAction)onToucnDownTabButton:(id)sender;

- (IBAction)onToucnUpInsideTabButton:(id)sender;

- (IBAction)onToucnUpOutsideTabButton:(id)sender;

- (IBAction)onClickSortName:(id)sender;

- (IBAction)onClickSortRegister:(id)sender;

- (IBAction)onClickFilterEng:(id)sender;

- (IBAction)onClickFilterAll:(id)sender;

- (IBAction)onClickFilterKor:(id)sender;

- (IBAction)onClickNext:(id)sender;

- (IBAction)onClickPrev:(id)sender;

@end
