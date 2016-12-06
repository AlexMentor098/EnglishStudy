//
//  TreeTableView.h
//  SmartAXA
//
//  Created by admin on 3/2/15.
//  Copyright (c) 2015 BST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeViewCell.h"

#define     DIC_KEY_TREE_ITEM_TITLE         @"title"
#define     DIC_KEY_TREE_ITEM_CLOSED        @"closed"
#define     DIC_KEY_TREE_ITEM_SUBLIST       @"sublist"

@protocol TreeTableViewDelegate <NSObject>

@optional

- (void)didSelectedTreeTableViewCell:(TreeViewCell *)cell;

@end

@interface TreeTableView : UITableView <UITableViewDataSource, UITableViewDelegate, TreeViewCellDelegate>

@property (nonatomic) NSMutableArray            *arrTreeData;
@property (nonatomic) id<TreeTableViewDelegate> treeTblDelegate;

@end
