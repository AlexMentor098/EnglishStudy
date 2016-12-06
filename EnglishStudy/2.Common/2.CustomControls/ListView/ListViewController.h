
#import <UIKit/UIKit.h>

@class ListViewController;
@protocol ListViewDelegate <NSObject>

@required

- (void)listViewController:(ListViewController *)listViewController didSelectRowAtIndex:(int)nRow;

@end

@interface ListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UILabel        *lblTitle;
    IBOutlet UITableView    *tblView;

    NSString        *_strTitle;
    NSString        *_strFieldName;
    NSArray         *_arrListData;
}

@property (nonatomic, assign) id<ListViewDelegate> listDelegate;

+ (id)listViewWithData:(NSArray *)arrListData ofTitle:(NSString *)strTitle;

+ (id)listViewWithData:(NSArray *)arrListData fieldName:(NSString *)strFieldName ofTitle:(NSString *)strTitle;

- (IBAction)onClickBack:(id)sender;

@end
