//
//  SimpleSelectionList.m
//  PropertyKing5
//
//  Created by admin on 1/27/15.
//  Copyright (c) 2015 ___exchange___. All rights reserved.
//

#import "SimpleSelectionList.h"
#import "NSString+Base64.h"
#import "Global.h"

@implementation SimpleSelectionList

+ (void)popupToParent:(UIView*)parent
             delegate:(id<SimpleSelectionListDelegate>)delegate
             listInfo:(id)listInfo
                  tag:(NSInteger)nTag
{
    CGRect  rect;
    int     nCnt = (int)[listInfo count];
    
    if(nCnt > 5)
        nCnt = nCnt / 5 + 5;
    
    rect.size.width  = 200;
    rect.size.height = 30 * nCnt;
    
    rect.origin.x   = (parent.frame.size.width - rect.size.width)/2;
    rect.origin.y   = 20;

    [self popupToParent:parent
               delegate:delegate
                  frame:rect
               anchorPt:CGPointMake(0.5f, 0.5f)
               listInfo:listInfo
        shouldSelectOne:YES
                    tag:nTag
               showType:SELECTION_LIST_SHOW_TYPE_POPUP];
}

+ (void)popupToParent:(UIView*)parent
             delegate:(id<SimpleSelectionListDelegate>)delegate
                frame:(CGRect)frame
             anchorPt:(CGPoint)anchorPoint
             listInfo:(id)listInfo
      shouldSelectOne:(BOOL)bShouldSelect
                  tag:(NSInteger)nTag
             showType:(int)nShowType
{
    [self popupToParent:parent
               delegate:delegate
                  frame:frame
               anchorPt:anchorPoint
               listInfo:listInfo
        shouldSelectOne:bShouldSelect
                    tag:nTag
               showType:nShowType
            showItemKey:@"title"];
}

+ (void)popupToParent:(UIView*)parent
             delegate:(id<SimpleSelectionListDelegate>)delegate
                frame:(CGRect)frame
             anchorPt:(CGPoint)anchorPoint
             listInfo:(id)listInfo
      shouldSelectOne:(BOOL)bShouldSelect
                  tag:(NSInteger)nTag
             showType:(int)nShowType
          showItemKey:(NSString*)strShowItemKey
{
    SimpleSelectionList* simpleSelectionList = [[SimpleSelectionList alloc] initWithFrame:frame listInfo:listInfo shouldSelectOne:bShouldSelect];

    simpleSelectionList.layer.anchorPoint = anchorPoint;
    simpleSelectionList.frame = frame;
    simpleSelectionList.listDelegate = delegate;
    simpleSelectionList.tag = nTag;
    simpleSelectionList.bShouldSelect = bShouldSelect;
    simpleSelectionList.strShowItemKey = strShowItemKey;
    
    UIMaskView *viewMask = [[UIMaskView alloc] initWithFrame:parent.bounds];
    viewMask.delegate = simpleSelectionList;
    [parent addSubview:viewMask];
    [parent addSubview:simpleSelectionList];

    simpleSelectionList.viewMask = viewMask;

    //[simpleSelectionList deselectAll];

    if( nShowType == SELECTION_LIST_SHOW_TYPE_POPUP )
    {
        simpleSelectionList.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    
        [UIView animateWithDuration:0.2f animations:^(void){
            simpleSelectionList.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.05, 1.05);
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.1f animations:^(void){
                simpleSelectionList.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
            }];
        }];
    }
    else
    {
        simpleSelectionList.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 0.001);
    
        [UIView animateWithDuration:0.2f animations:^(void){
            simpleSelectionList.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
            } completion:^(BOOL finished){
        }];
    }
}

- (id)initWithFrame:(CGRect)frame listInfo:(id)listInfo shouldSelectOne:(BOOL)bShouldSelect
{
    self = [super initWithFrame:frame];
    
    if( [listInfo isKindOfClass:[NSDictionary class]] )
    {
        self.dicListInfo = listInfo;
        self.arrListInfo = nil;
    }
    else if( [listInfo isKindOfClass:[NSArray class]] )
    {
        self.arrListInfo = listInfo;
        self.dicListInfo = nil;
    }

    self.bShouldSelect = bShouldSelect;

    self.rowHeight = 30.0f;
    self.separatorInset = UIEdgeInsetsZero;
    self.delegate = self;
    self.dataSource = self;

    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.cornerRadius = 5;
    self.backgroundColor = UIRGBColor(230, 230, 245, 255);

    [self reloadData];

    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }

    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int     nCount = 0;
    
    if( self.dicListInfo != nil )
        nCount = (int)[self.dicListInfo count];
    else if( self.arrListInfo != nil )
        nCount = (int)[self.arrListInfo count];
    
    if( self.bShouldSelect == NO )
        return nCount + 1;
    else
        return nCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if( cell == nil )
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];

    if( self.bShouldSelect == NO && indexPath.row == 0 )
    {
        cell.textLabel.text = @"No Select";
    }
    else if( self.dicListInfo != nil )
    {
        NSString        *key = nil;
        
        if( self.bShouldSelect == NO )
            key = [NSString stringWithFormat:@"%d", (int)indexPath.row];
        else
            key = [NSString stringWithFormat:@"%d", (int)(indexPath.row+1)];

        NSDictionary    *item = [self.dicListInfo objectForKey:key];
        NSString        *title = [item objectForKey:self.strShowItemKey];
    
        if( self.tag == 2 )
            title = [title base64DecodedString];
        cell.textLabel.text = title;
    }
    else
    {
        NSDictionary    *item = nil;
        NSString        *title = nil;
        
        if( self.bShouldSelect == NO )
            item = [self.arrListInfo objectAtIndex:indexPath.row+1];
        else
            item = [self.arrListInfo objectAtIndex:indexPath.row];

        // array type
        if( [item isKindOfClass:[NSString class]] )
            title = (NSString *)item;
        else
            title = [item objectForKey:self.strShowItemKey];

        cell.textLabel.text = title;
    }

    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor clearColor];

    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 44;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( [self.listDelegate respondsToSelector:@selector(simpleSelectionList:didSelectRowAtIndex:)] )
        [self.listDelegate simpleSelectionList:self didSelectRowAtIndex:(int)indexPath.row];

    [UIView animateWithDuration:0.1f animations:^(void){
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    } completion:^(BOOL finished){
        [self.viewMask removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)deselectAll
{
    [self deselectRowAtIndexPath:[self indexPathForSelectedRow] animated:NO];
}

- (void)touchBeganOnMaskView:(UIMaskView *)viewMask
{
    //[viewMask removeFromSuperview];
    
    [UIView animateWithDuration:0.1f animations:^(void){
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    } completion:^(BOOL finished){
        [self removeFromSuperview];
        [viewMask removeFromSuperview];
    }];
}

@end