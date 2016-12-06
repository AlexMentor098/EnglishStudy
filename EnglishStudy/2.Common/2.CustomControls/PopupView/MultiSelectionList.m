//
//  MultiSelectionList.m
//  PropertyKing5
//
//  Created by admin on 2/1/15.
//  Copyright (c) 2015 ___exchange___. All rights reserved.
//

#import "MultiSelectionList.h"
#import "NSString+Base64.h"

@implementation MultiSelectionList

+ (void)popupToParent:(UIView*)parent
             delegate:(id<MultiSelectionListDelegate>)delegate
                frame:(CGRect)frame
             anchorPt:(CGPoint)anchorPoint
             listInfo:(NSDictionary*)dicListInfo
            selIndexs:(NSArray*)arrSelIndexs
                  tag:(NSInteger)nTag
{
    MultiSelectionList *multiSelectionList = [[MultiSelectionList alloc] initWithFrame:frame listInfo:dicListInfo selIndexs:arrSelIndexs];
    multiSelectionList.layer.anchorPoint = anchorPoint;
    multiSelectionList.frame = frame;
    multiSelectionList.listDelegate = delegate;
    multiSelectionList.tag = nTag;
    
    UIMaskView *viewMask = [[UIMaskView alloc] initWithFrame:parent.bounds];
    viewMask.delegate = multiSelectionList;
    [parent addSubview:viewMask];
    [parent addSubview:multiSelectionList];
    
    multiSelectionList.viewMask = viewMask;
    
    multiSelectionList.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    
    [UIView animateWithDuration:0.2f animations:^(void){
        multiSelectionList.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.05, 1.05);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.1f animations:^(void){
            multiSelectionList.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
        }];
    }];
}

- (id)initWithFrame:(CGRect)frame listInfo:(NSDictionary *)dicListInfo selIndexs:(NSArray *)arrSelIndexs
{
    self = [super initWithFrame:frame];
    
    self.dicListInfo = dicListInfo;
    self.arrSelIndexPaths = arrSelIndexs;
    
    NSArray*    arrKeys = [self.dicListInfo allKeys];
    
    int         nClassKind = (int)[arrKeys count];
    int         nDetailCount = 0;
    
    for( int i = 0; i < nClassKind; i++ )
    {
        NSString*   strKey = [arrKeys objectAtIndex:i];
        NSArray*    arrItems = [self.dicListInfo objectForKey:strKey];
        
        nDetailCount += [arrItems count];
    }

    CGRect  rect;
    CGSize  size = CGSizeMake( frame.size.width, 25*nDetailCount + 21*nClassKind);
    rect.origin = CGPointZero;
    rect.size = size;
    
    viewTblContent = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    viewTblContent.rowHeight = 25.0f;
    viewTblContent.separatorInset = UIEdgeInsetsZero;
    viewTblContent.delegate = self;
    viewTblContent.dataSource = self;
    viewTblContent.allowsMultipleSelection = YES;
    viewTblContent.scrollEnabled = NO;
    viewTblContent.backgroundColor = [UIColor colorWithRed:240/255.0f green:78/255.0f blue:37/255.0f alpha:1.0f];
    [self addSubview:viewTblContent];

    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.cornerRadius = 5;
    self.backgroundColor = [UIColor colorWithRed:240/255.0f green:78/255.0f blue:37/255.0f alpha:1.0f];

    [viewTblContent reloadData];
    
    UIButton*   btnOK = [[UIButton alloc] initWithFrame:CGRectMake( (size.width-60)/2, size.height+5, 60, 25 )];
    [self addSubview:btnOK];
    btnOK.backgroundColor = [UIColor colorWithRed:0.5 green:0.0 blue:1.0f alpha:1.0f];
    btnOK.layer.cornerRadius = 3;
    btnOK.clipsToBounds = YES;
    [btnOK setTitle:@"确定" forState:UIControlStateNormal];
    [btnOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnOK setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    btnOK.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [btnOK addTarget:self action:@selector(onClickBtnOK) forControlEvents:UIControlEventTouchUpInside];
    
    size.height += 35;
    self.contentSize = size;
    
    [self restoreLastSelection];
    
    return self;
}

- (void)restoreLastSelection
{
    if( self.arrSelIndexPaths == nil )
        return;
    
    for( int i = 0; i < [self.arrSelIndexPaths count]; i++ )
    {
        NSIndexPath *indexPath = [self.arrSelIndexPaths objectAtIndex:i];
        
        [viewTblContent selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        
        UITableViewCell *cell = [viewTblContent cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dicListInfo.allKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString*   strKey = [self.dicListInfo.allKeys objectAtIndex:section];
    NSArray*    arrSectionItems = [self.dicListInfo objectForKey:strKey];
    
    return [arrSectionItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView*     viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
    viewFooter.backgroundColor = [UIColor whiteColor];
    
    return viewFooter;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString*   strKey = [self.dicListInfo.allKeys objectAtIndex:section];
    
    UIView*     viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    viewHeader.backgroundColor = [UIColor whiteColor];
    
    UILabel*    lblSectionHeader = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width-10, 20)];
    lblSectionHeader.text = strKey;
    lblSectionHeader.backgroundColor = [UIColor clearColor];
    lblSectionHeader.font = [UIFont systemFontOfSize:9.0f];
    [viewHeader addSubview:lblSectionHeader];
    
    return viewHeader;
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString*   strKey = [self.dicListInfo.allKeys objectAtIndex:section];
    
    return strKey;
}*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if( cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    UIView* viewSelBG = [[UIView alloc] initWithFrame:CGRectMake(0, 1, tableView.frame.size.width, 23)];
    viewSelBG.backgroundColor = [UIColor colorWithRed:0.5 green:0.2 blue:1.0 alpha:1.0f];
    cell.selectedBackgroundView = viewSelBG;
    
    NSString*       strKey = [self.dicListInfo.allKeys objectAtIndex:indexPath.section];
    NSArray*        arrSectionItems = [self.dicListInfo objectForKey:strKey];
    NSDictionary    *item = [arrSectionItems objectAtIndex:indexPath.row];
    NSString        *title = [item objectForKey:@"title"];
    
    cell.textLabel.text = title;
    cell.textLabel.font = [UIFont systemFontOfSize:9.0f];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor colorWithRed:240/255.0f green:78/255.0f blue:37/255.0f alpha:1.0f];
    //cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    /*
    if( [self.listDelegate respondsToSelector:@selector(multiSelectionList:didSelectRowAtIndex:)] )
        [self.listDelegate multiSelectionList:self didSelectRowAtIndex:indexPath.row];
    
    [UIView animateWithDuration:0.1f animations:^(void){
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    } completion:^(BOOL finished){
        [self.viewMask removeFromSuperview];
        [self removeFromSuperview];
    }];*/
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

- (void)dismissView
{
    [UIView animateWithDuration:0.1f animations:^(void){
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    } completion:^(BOOL finished){
        [self removeFromSuperview];
        [self.viewMask removeFromSuperview];
    }];
}

- (void)touchBeganOnMaskView:(UIMaskView *)viewMask
{
    //[viewMask removeFromSuperview];
    [self dismissView];
}

- (void)onClickBtnOK
{
    NSArray*    arrIndexPaths = [viewTblContent indexPathsForSelectedRows];
    
    if( [self.listDelegate respondsToSelector:@selector(multiSelectionList:didSelectedIndexPaths:)] )
        [self.listDelegate multiSelectionList:self didSelectedIndexPaths:arrIndexPaths];

    [self dismissView];
}

@end
