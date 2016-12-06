//
//  LocatorTableView.h
//  SmartAXA
//
//  Created by admin on 4/25/15.
//  Copyright (c) 2015 BST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocatorTableViewCell.h"

@protocol LocatorTableViewDelegate <NSObject>

@optional

- (void)didSelectedLocatorTableViewCell:(LocatorTableViewCell *)cell;

@end

@interface LocatorTableView : UITableView <UITableViewDataSource,
UITableViewDelegate, LocatorTableCellDelegate>

@property (nonatomic) id<LocatorTableViewDelegate> treeTblDelegate;
@property (nonatomic) NSMutableArray            *arrTreeData;
@property (nonatomic,readwrite) int             nCntItem;
@property (nonatomic,readwrite) BOOL            bShow;

@end