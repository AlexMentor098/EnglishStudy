//
//  TreeTableView.m
//  SmartAXA
//
//  Created by admin on 3/2/15.
//  Copyright (c) 2015 BST. All rights reserved.
//

#import "TreeTableView.h"
#import "TreeViewCell.h"
#import "Global.h"
#import "UtilImage.h"

@implementation TreeTableView

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if( self.arrTreeData == nil )
        return 0;
    
    NSUInteger nCount = [self.arrTreeData count];
    
    for( NSUInteger i = 0; i < [self.arrTreeData count]; i++ )
    {
        NSDictionary    *dicItem    = [self.arrTreeData objectAtIndex:i];
        BOOL            bClosed     = [[dicItem objectForKey:DIC_KEY_TREE_ITEM_CLOSED] boolValue];
        if( bClosed == YES )
            continue;
        
        NSArray         *arrSubItems = [dicItem objectForKey:DIC_KEY_TREE_ITEM_SUBLIST];
        
        nCount += [arrSubItems count];
    }

    return nCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TreeViewCell    *cell = nil;

    int             nBigIndex = 0;
    int             nSubIndex = -1;
    int             nSerial = 1;
    
    NSDictionary    *dicTreeItem = nil;
    
    for( int i = 0; i < [self.arrTreeData count]; i++ )
    {
        NSDictionary    *dicCatItem = [self.arrTreeData objectAtIndex:i];
        
        if( nSerial == indexPath.row+1 )
        {
            dicTreeItem = dicCatItem;
            nBigIndex = i;
            nSubIndex = -1;
            break;
        }
        
        nSerial++;
        
        BOOL        bClosed = [[dicCatItem objectForKey:DIC_KEY_TREE_ITEM_CLOSED] boolValue];
        if( bClosed == YES )
            continue;

        NSArray     *arrSubItems = [dicCatItem objectForKey:DIC_KEY_TREE_ITEM_SUBLIST];
        NSUInteger  nSubItems = [arrSubItems count];
        
        if( indexPath.row < nSerial+nSubItems-1 )
        {
            nBigIndex = i;
            nSubIndex = (int)(indexPath.row - nSerial + 1);
            dicTreeItem = [arrSubItems objectAtIndex:nSubIndex];
            break;
        }

        nSerial += nSubItems;
    }
    
    NSString    *strTitle = [dicTreeItem objectForKey:DIC_KEY_TREE_ITEM_TITLE];

    cell = [TreeViewCell createWithTitle:strTitle bigIndex:nBigIndex subIndex:nSubIndex];
    cell.delegate = self;
    cell.dicCellInfo = dicTreeItem;
    
    NSString        *strThumb = [dicTreeItem objectForKey:@"thumb"];
    NSString *strPath;
    //NSRange rng = [strThumb rangeOfString:@"http:"];
    //if ( rng.location == NSNotFound ) {
    //    strPath = [NSString stringWithFormat:@"%@%@", SERVER_PHOTO_UPLOAD_URL,strThumb];
    //}
    //else
        strPath = [NSString stringWithFormat:@"%@", strThumb];
    
    NSString    *imgPath = [UtilImage loadImagePathFromURL:strPath];
    UIImage *img = [UIImage imageWithContentsOfFile:imgPath];
    if ( img != nil )
        cell.imgThumb.image = img;
    
    if( nSubIndex == -1 )
    {
        BOOL        bClosed = [[dicTreeItem objectForKey:DIC_KEY_TREE_ITEM_CLOSED] boolValue];
        [cell setClosed:bClosed];
        
        NSArray     *arrSubItems = [dicTreeItem objectForKey:DIC_KEY_TREE_ITEM_SUBLIST];
        NSUInteger  nSubItems = [arrSubItems count];
        if( nSubItems == 0 )
            [cell hideExpandButton];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TreeViewCell    *cell = (TreeViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if( cell == nil )
        return;

    if( [self.treeTblDelegate respondsToSelector:@selector(didSelectedTreeTableViewCell:)] )
        [self.treeTblDelegate didSelectedTreeTableViewCell:cell];
}

-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // fix for separators bug in iOS 7
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}


-(void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // fix for separators bug in iOS 7
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)didTreeViewCellExpanded:(TreeViewCell *)cell
{
    NSIndexPath         *indexPath = [self indexPathForCell:cell];
    
    NSMutableDictionary *dicTreeItem = [self.arrTreeData objectAtIndex:cell.nBigIndex];
    NSArray             *arrSubItems = [dicTreeItem objectForKey:DIC_KEY_TREE_ITEM_SUBLIST];
    int                 nSubItems = (int)[arrSubItems count];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for( int i = 0; i < nSubItems; i++ )
        [arr addObject:[NSIndexPath indexPathForItem:indexPath.row+i+1 inSection:0]];

    if( cell.bClosed == YES )
    {
        [cell setClosed:NO];
        [dicTreeItem setObject:[NSNumber numberWithBool:NO] forKey:DIC_KEY_TREE_ITEM_CLOSED];
        [self insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        [cell setClosed:YES];
        [dicTreeItem setObject:[NSNumber numberWithBool:YES] forKey:DIC_KEY_TREE_ITEM_CLOSED];
        [self deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
