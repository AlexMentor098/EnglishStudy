
#import "UIPopupView.h"
#import "UIListView.h"

@protocol UIListViewDelegate <NSObject>

@required

- (void)UIListViewDidSelectItem:(int)nSelItem;
- (void)UIListViewDidSelectItem:(int)nSelItem msgtag:(int)nMsgTag;

@end

@interface UIListView : UIPopupView <UITableViewDataSource, UITableViewDelegate>
{
    id<UIListViewDelegate>  _delegator;
    NSArray*                _arrayListData;
}

@property(nonatomic, readwrite)int nViewType;
@property(nonatomic, readwrite)int nMsgTag;

+(void)popupWithParentView:(UIView*)parentView array:(NSArray*)arrayListData delegate:(id<UIListViewDelegate>)delegate viewtype:(int)nViewType;
+(void)popupWithParentView:(UIView*)parentView array:(NSArray*)arrayListData delegate:(id<UIListViewDelegate>)delegate viewtype:(int)nViewType msgTag:(int)nMsgTag;

@end
