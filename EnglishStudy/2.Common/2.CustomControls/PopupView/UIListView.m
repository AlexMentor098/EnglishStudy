
#import "UIListView.h"
#import "Global.h"

@implementation UIListView

#define PHONE_LIST_VIEW_WIDTH        240
#define PHONE_LIST_VIEW_HEIGHT       304

+(void)popupWithParentView:(UIView*)parentView array:(NSArray*)arrayListData delegate:(id<UIListViewDelegate>)delegate viewtype:(int)nType
{
    UIListView*  view = [UIListView alloc];
    view.nViewType = nType;
    
    [view setDelegate:delegate];
    [view setDataListArray:arrayListData];
    
    view = [view initWithFrame:parentView.bounds];

    [view popupToParent:parentView];
}

+(void)popupWithParentView:(UIView*)parentView array:(NSArray*)arrayListData delegate:(id<UIListViewDelegate>)delegate viewtype:(int)nType msgTag:(int)nMsgTag
{
    UIListView*  view = [UIListView alloc];
    view.nViewType = nType;
    view.nMsgTag = nMsgTag;
    
    [view setDelegate:delegate];
    [view setDataListArray:arrayListData];
    
    view = [view initWithFrame:parentView.bounds];
    
    [view popupToParent:parentView];
}

- (void)setDelegate:(id<UIListViewDelegate>)delegate
{
    _delegator = delegate;
}

- (void)setDataListArray:(NSArray*)arrayListData
{
    _arrayListData = arrayListData;
}

- (void)createContentView
{
    CGSize      size = self.bounds.size;
    CGRect      rect, tblRect;

    rect.size.width  = PHONE_LIST_VIEW_WIDTH;
    rect.size.height = 44 * [_arrayListData count];

    if( rect.size.height > PHONE_LIST_VIEW_HEIGHT )
        rect.size.height = PHONE_LIST_VIEW_HEIGHT;
        
    if(self.nViewType == 0) // Add photo
    {
        rect.origin.x   = (size.width - rect.size.width)/2;
        rect.origin.y   = (size.height - rect.size.height)/2;
    }
    else // select create address mode
    {
        rect.origin.x   = (size.width - rect.size.width)/2;
//        rect.origin.y   = size.height - rect.size.height;
        rect.origin.y   = 20;
        
    }
    
    tblRect.origin.x = 0;
    tblRect.origin.y = 0;
    tblRect.size.width = rect.size.width;
    tblRect.size.height = rect.size.height;

    _contentView = [[UIView alloc] initWithFrame:rect];
    _contentView.frame = rect;
    
    if(self.nViewType == 1)
    {
        _contentView.layer.borderWidth = 2;
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:1.0f].CGColor;
    }

    [self addSubview:_contentView];
    [_contentView setBackgroundColor:[UIColor whiteColor]];

    
    UITableView*    tableView = [[UITableView alloc] initWithFrame:tblRect];
    [_contentView addSubview:tableView];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    tableView.dataSource = self;
    tableView.delegate = self;
    //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.bounces = NO;
    if(self.nViewType == 1)
        tableView.layer.cornerRadius = 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrayListData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListItem"];
    
    if( cell == nil )
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ListItem"];
    
    cell.textLabel.text = [_arrayListData objectAtIndex:indexPath.row];

    if(self.nViewType == 0) // select photo
        cell.textLabel.font = [UIFont systemFontOfSize:24];
    else                    // select address
        cell.textLabel.font = [UIFont systemFontOfSize:20];
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
//  cell.textLabel.textColor = [UIColor colorWithRed:0.6 green:0.3 blue:0.25 alpha:1.0f];
    cell.backgroundColor = [UIColor clearColor];
//  cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.nMsgTag == 2)
        [_delegator UIListViewDidSelectItem:(int)indexPath.row msgtag:self.nMsgTag];
    else if(self.nMsgTag == 100) // in profile ,when clicked on "add photo".
        [_delegator UIListViewDidSelectItem:(int)indexPath.row msgtag:self.nMsgTag];
    else
        [_delegator UIListViewDidSelectItem:(int)indexPath.row];
    
    [self dismissPopupView];
}

@end