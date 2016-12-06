
#import "PullToRefreshTableView.h"
#import <QuartzCore/QuartzCore.h>

@implementation StateView

@synthesize indicatorView;
@synthesize arrowView;
@synthesize stateLabel;
@synthesize timeLabel;
@synthesize viewType;
@synthesize currentState;

- (id)initWithFrame:(CGRect)frame viewType:(kStateViewType)type
{
    CGFloat width = frame.size.width;
    
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, width, k_STATE_VIEW_HEIGHT)];
    
    if (self)
    {
        self.viewType = type;
        self.backgroundColor = [UIColor clearColor];
        
        indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((k_STATE_VIEW_INDICATE_WIDTH - 20) / 2, (k_STATE_VIEW_HEIGHT - 20) / 2, 20, 20)];
        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        indicatorView.hidesWhenStopped = YES;
        [self addSubview:indicatorView];
        
        arrowView = [[UIImageView alloc] initWithFrame:CGRectMake((k_STATE_VIEW_INDICATE_WIDTH - 32) / 2, (k_STATE_VIEW_HEIGHT - 32) / 2, 32, 32)];

        NSString * imageNamed = nil;
        
        if( self.viewType == kStateViewTypeHeaderRefresh )
            imageNamed = @"arrow_down.png";
        else if( self.viewType == kStateViewTypeHeaderLoadMore )
            imageNamed = @"arrow_down.png";
        else
            imageNamed = @"arrow_up.png";

        arrowView.image = [UIImage imageNamed:imageNamed];
        [self addSubview:arrowView];

        stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, width, 20)];
        stateLabel.font = [UIFont systemFontOfSize:12.0f];
        stateLabel.backgroundColor = [UIColor clearColor];
        stateLabel.textAlignment = NSTextAlignmentCenter;
        
        if( self.viewType == kStateViewTypeHeaderRefresh )
            stateLabel.text = @"pull down to refresh";
        else if( self.viewType == kStateViewTypeHeaderLoadMore )
            stateLabel.text = @"pull down to load more";
        else
            stateLabel.text = @"pull down to load more";
        
        [self addSubview:stateLabel];
        
        /*
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, width, k_STATE_VIEW_HEIGHT - 20)];
        timeLabel.font = [UIFont systemFontOfSize:12.0f];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textAlignment = UITextAlignmentCenter;
        timeLabel.text = @"-";
        [self addSubview:timeLabel];
         */
    }
    
    return self;
}

- (void)changeState:(int)state
{
    [indicatorView stopAnimating];
    arrowView.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    
    switch (state) {
        case k_PULL_STATE_NORMAL:
            currentState = k_PULL_STATE_NORMAL;
            
            if( self.viewType == kStateViewTypeHeaderRefresh )
                stateLabel.text = @"pull down to refresh";
            else if( self.viewType == kStateViewTypeHeaderLoadMore )
                stateLabel.text = @"pull down to load more";
            else
                stateLabel.text = @"pull to load more";

            arrowView.layer.transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            break;
        case k_PULL_STATE_DOWN:
            currentState = k_PULL_STATE_DOWN;
            
            if( self.viewType == kStateViewTypeHeaderRefresh )
                stateLabel.text = @"release to refresh";
            else if( self.viewType == kStateViewTypeHeaderLoadMore )
                stateLabel.text = @"release to load more";
            else
                stateLabel.text = @"release to load more";
            
            arrowView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            break;

        case k_PULL_STATE_UP:
            currentState = k_PULL_STATE_UP;
            stateLabel.text = @"release to load more";
            arrowView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            break;
            
        case k_PULL_STATE_LOAD:
            currentState = k_PULL_STATE_LOAD;
            if( self.viewType == kStateViewTypeHeaderRefresh )
                stateLabel.text = @"refreshing...";
            else if( self.viewType == kStateViewTypeHeaderLoadMore )
                stateLabel.text = @"loading...";
            else
                stateLabel.text = @"loading...";
            [indicatorView startAnimating];
            arrowView.hidden = YES;
            break;
            
        case k_PULL_STATE_END:
            currentState = k_PULL_STATE_END;

            if( self.viewType == kStateViewTypeHeaderLoadMore )
                //stateLabel.text = @"data all loaded";
                stateLabel.text = @"";
            else if( self.viewType == kStateViewTypeFooterLoadMore )
                //stateLabel.text = @"data all loaded";
                stateLabel.text = @"";
            
            arrowView.hidden = YES;
            break;
            
        default:
            currentState = k_PULL_STATE_NORMAL;
            
            if( self.viewType == kStateViewTypeHeaderRefresh )
                stateLabel.text = @"pull down to refresh";
            else if( self.viewType == kStateViewTypeHeaderLoadMore )
                stateLabel.text = @"pull down to load more";
            else
                stateLabel.text = @"pull up to load more";

            arrowView.layer.transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            break;
    }
    [UIView commitAnimations];
}

- (void)updateTimeLabel
{
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    //[formatter setDateStyle:kCFDateFormatterFullStyle];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    timeLabel.text = [NSString stringWithFormat:@"Updating %@", [formatter stringFromDate:date]];
}

@end

@implementation PullToRefreshTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //headerView = [[StateView alloc] initWithFrame:CGRectMake(0, -k_STATE_VIEW_HEIGHT, frame.size.width, frame.size.height) viewType:kStateViewTypeHeaderRefresh];
        footerView = [[StateView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) viewType:kStateViewTypeFooterLoadMore];
        //[self addSubview:headerView];
        [self setTableFooterView:footerView];
        
        self.contentInset = UIEdgeInsetsMake(0, 0, -k_STATE_VIEW_HEIGHT, 0);
    }
    return self;
}

- (void)initHeaderView
{
    //CGRect  frame = self.frame;
    
    //headerView = [[StateView alloc] initWithFrame:CGRectMake(0, -k_STATE_VIEW_HEIGHT, frame.size.width, frame.size.height) viewType:kStateViewTypeHeaderRefresh];

    //[self addSubview:headerView];
}

- (void)initFooterView
{
    CGRect  frame = self.frame;

    footerView = [[StateView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) viewType:kStateViewTypeFooterLoadMore];
    [self setTableFooterView:footerView];
    footerView.hidden = YES;
    
    self.contentInset = UIEdgeInsetsMake(0, 0, -k_STATE_VIEW_HEIGHT, 0);
}

- (void)tableViewDidDragging
{
    CGFloat offsetY = self.contentOffset.y;
    
    if( //headerView.currentState == k_PULL_STATE_LOAD ||
        footerView.currentState == k_PULL_STATE_LOAD )
    {
        return;
    }
    
    /*
    if( offsetY < -k_STATE_VIEW_HEIGHT - 10 )
    {
        [headerView changeState:k_PULL_STATE_DOWN];
    }
    else
    {
        [headerView changeState:k_PULL_STATE_NORMAL];
    }*/
    
    if( footerView.currentState == k_PULL_STATE_END )
    {
        return;
    }
    
    CGFloat differenceY = self.contentSize.height > self.frame.size.height ? (self.contentSize.height - self.frame.size.height) : 0;

    if( offsetY > differenceY + k_STATE_VIEW_HEIGHT/2 )
    {
        [footerView changeState:k_PULL_STATE_UP];
    }
    else
    {
        [footerView changeState:k_PULL_STATE_NORMAL];
    }
}

- (int)tableViewDidEndDragging
{
    CGFloat offsetY = self.contentOffset.y;

    if( //headerView.currentState == k_PULL_STATE_LOAD ||
        footerView.currentState == k_PULL_STATE_LOAD )
    {
        return k_RETURN_DO_NOTHING;
    }
    
    /*
    if( offsetY < -k_STATE_VIEW_HEIGHT - 10 )
    {
        [headerView changeState:k_PULL_STATE_LOAD];
        self.contentInset = UIEdgeInsetsMake(k_STATE_VIEW_HEIGHT, 0, 0, 0);
        return k_RETURN_REFRESH;
    }*/

    CGFloat differenceY = self.contentSize.height > self.frame.size.height ? (self.contentSize.height - self.frame.size.height) : 0;
    if( footerView.currentState != k_PULL_STATE_END && offsetY > differenceY + k_STATE_VIEW_HEIGHT / 3 * 2 )
    {
        [footerView changeState:k_PULL_STATE_LOAD];
        self.contentInset = UIEdgeInsetsZero;
        return k_RETURN_LOADMORE;
    }

    return k_RETURN_DO_NOTHING;
}

- (void)reloadData:(BOOL)dataIsAllLoaded
{
    [self reloadData];
    
    self.contentInset = UIEdgeInsetsMake(0, 0, -k_STATE_VIEW_HEIGHT, 0);
    //self.contentInset = UIEdgeInsetsZero;
    
    //[headerView changeState:k_PULL_STATE_NORMAL];

    if( dataIsAllLoaded )
    {
        [footerView changeState:k_PULL_STATE_END];
    }
    else
    {
        [footerView changeState:k_PULL_STATE_NORMAL];
    }

    //[headerView updateTimeLabel];
    //[footerView updateTimeLabel];
}

@end

@implementation PullToRefreshScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    
    return self;
}

- (void)initHeaderView
{
    CGRect  frame = self.frame;
    
    headerView = [[StateView alloc] initWithFrame:CGRectMake(0, -k_STATE_VIEW_HEIGHT, frame.size.width, frame.size.height) viewType:kStateViewTypeHeaderLoadMore];

    [self addSubview:headerView];
}

- (void)initFooterView
{
    //CGRect  frame = self.frame;
    //headerView = [[StateView alloc] initWithFrame:CGRectMake(0, -k_STATE_VIEW_HEIGHT, frame.size.width, frame.size.height) viewType:k_VIEW_TYPE_HEADER];
    //footerView = [[StateView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) viewType:k_VIEW_TYPE_FOOTER];
    //[self addSubview:headerView];
    
    //self.contentInset = UIEdgeInsetsMake(0, 0, -k_STATE_VIEW_HEIGHT, 0);
}

- (void)scrollViewDidDragging
{
    CGFloat offsetY = self.contentOffset.y;
    
    if( headerView.currentState == k_PULL_STATE_LOAD ||
       footerView.currentState == k_PULL_STATE_LOAD )
    {
        return;
    }
    
    if( offsetY < -k_STATE_VIEW_HEIGHT - 10 )
    {
        [headerView changeState:k_PULL_STATE_DOWN];
    }
    else
    {
        [headerView changeState:k_PULL_STATE_NORMAL];
    }
    
    if( footerView.currentState == k_PULL_STATE_END )
    {
        return;
    }
    
    CGFloat differenceY = self.contentSize.height > self.frame.size.height ? (self.contentSize.height - self.frame.size.height) : 0;
    
    if( offsetY > differenceY + k_STATE_VIEW_HEIGHT/2 )
    {
        [footerView changeState:k_PULL_STATE_UP];
    }
    else
    {
        [footerView changeState:k_PULL_STATE_NORMAL];
    }
}

- (int)scrollViewDidEndDragging
{
    CGFloat offsetY = self.contentOffset.y;
    
    if( headerView.currentState == k_PULL_STATE_LOAD ||
       footerView.currentState == k_PULL_STATE_LOAD )
    {
        return k_RETURN_DO_NOTHING;
    }
    
    if( offsetY < -k_STATE_VIEW_HEIGHT - 10 )
    {
        [headerView changeState:k_PULL_STATE_LOAD];
        self.contentInset = UIEdgeInsetsMake(k_STATE_VIEW_HEIGHT, 0, 0, 0);
        //return k_RETURN_REFRESH;
        return k_RETURN_LOADMORE;
    }
    
    /*
    CGFloat differenceY = self.contentSize.height > self.frame.size.height ? (self.contentSize.height - self.frame.size.height) : 0;
    if( footerView.currentState != k_PULL_STATE_END && offsetY > differenceY + k_STATE_VIEW_HEIGHT / 3 * 2 )
    {
        [footerView changeState:k_PULL_STATE_LOAD];
        self.contentInset = UIEdgeInsetsZero;
        return k_RETURN_LOADMORE;
    }*/
    
    return k_RETURN_DO_NOTHING;
}

- (void)endBusyState:(BOOL)dataIsAllLoaded
{
    self.contentInset = UIEdgeInsetsZero;
    
    [headerView changeState:k_PULL_STATE_NORMAL];
    
    if( dataIsAllLoaded )
    {
        [footerView changeState:k_PULL_STATE_END];
    }
    else
    {
        [footerView changeState:k_PULL_STATE_NORMAL];
    }
    
    //[headerView updateTimeLabel];
    //[footerView updateTimeLabel];
}

@end