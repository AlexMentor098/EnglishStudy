
#import <UIKit/UIKit.h>

#define k_PULL_STATE_NORMAL         0
#define k_PULL_STATE_DOWN           1    
#define k_PULL_STATE_LOAD           2    
#define k_PULL_STATE_UP             3    
#define k_PULL_STATE_END            4    

#define k_RETURN_DO_NOTHING         0    
#define k_RETURN_REFRESH            1    
#define k_RETURN_LOADMORE           2    

#define k_STATE_VIEW_HEIGHT                 40
#define k_STATE_VIEW_INDICATE_WIDTH         60

typedef enum {
    kStateViewTypeHeaderRefresh,
    kStateViewTypeHeaderLoadMore,
    kStateViewTypeFooterLoadMore,
} kStateViewType;

#define k_VIEW_TYPE_HEADER_REFRESH          0
#define k_VIEW_TYPE_HEADER_LOAD_MORE        1
#define k_VIEW_TYPE_FOOTER                  2


@interface StateView : UIView
{
@private
    UIActivityIndicatorView * indicatorView;
    UIImageView             * arrowView;
    UILabel                 * stateLabel;     
    UILabel                 * timeLabel;
    int                       currentState;
}

@property (nonatomic, retain) UIActivityIndicatorView * indicatorView;
@property (nonatomic, retain) UIImageView             * arrowView;
@property (nonatomic, retain) UILabel                 * stateLabel;
@property (nonatomic, retain) UILabel                 * timeLabel;
@property (nonatomic)         kStateViewType            viewType;
@property (nonatomic)         int                       currentState; 

- (id)initWithFrame:(CGRect)frame viewType:(kStateViewType)type;

- (void)changeState:(int)state;

- (void)updateTimeLabel;

@end

@interface PullToRefreshTableView : UITableView
{
    //StateView   *headerView;
    StateView   *footerView;
}

- (void)initHeaderView;
- (void)initFooterView;

- (void)tableViewDidDragging;

- (int)tableViewDidEndDragging;

- (void)reloadData:(BOOL)dataIsAllLoaded;

@end

@interface PullToRefreshScrollView : UIScrollView
{
    StateView   *headerView;
    StateView   *footerView;
}

- (void)initHeaderView;
- (void)initFooterView;

- (void)scrollViewDidDragging;

- (int)scrollViewDidEndDragging;

- (void)endBusyState:(BOOL)dataIsAllLoaded;

@end