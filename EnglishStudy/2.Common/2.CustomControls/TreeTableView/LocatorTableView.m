//
//  LocatorTableView.m
//  SmartAXA
//
//  Created by admin on 4/25/15.
//  Copyright (c) 2015 BST. All rights reserved.
//

#import "LocatorTableView.h"

@implementation LocatorTableView
@synthesize nCntItem, arrTreeData,treeTblDelegate;

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
    
    return nCntItem;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocatorTableViewCell    *cell = nil;
    
    NSString    *strTitle = [arrTreeData objectAtIndex:indexPath.row];
    
    cell = [LocatorTableViewCell createWithTitle:strTitle shouldShow:self.bShow];
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocatorTableViewCell    *cell = (LocatorTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if( cell == nil )
        return;
    cell.nIndex = indexPath.row;
    
    if( [self.treeTblDelegate respondsToSelector:@selector(didSelectedLocatorTableViewCell:)] )
        [self.treeTblDelegate didSelectedLocatorTableViewCell:cell];
}

-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // fix for separators bug in iOS 7
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
///    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}


-(void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // fix for separators bug in iOS 7
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)didTreeViewCellExpanded:(LocatorTableViewCell *)cell
{
}

@end