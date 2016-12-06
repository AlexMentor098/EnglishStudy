//
//  TreeViewCell.h
//  HealthManagement
//
//  Created by BST on 13-10-24.
//  Copyright (c) 2013年 BST. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TreeViewCell;
@protocol TreeViewCellDelegate <NSObject>

@required

- (void)didTreeViewCellExpanded:(TreeViewCell *)cell;

@end

@interface TreeViewCell : UITableViewCell
{
    IBOutlet    UILabel         *_lblText;
    IBOutlet    UIButton        *_btnExpand;
}

@property (nonatomic, retain) IBOutlet    UIImageView     *imgThumb;

@property (nonatomic) id<TreeViewCellDelegate> delegate;

@property (nonatomic) NSDictionary  *dicCellInfo;

@property (nonatomic, assign) int nBigIndex;
@property (nonatomic, assign) int nSubIndex;
@property (nonatomic, assign) BOOL bClosed;

+ (id)createWithTitle:(NSString*)title bigIndex:(int)nBigIndex subIndex:(int)nSubIndex;

- (void)setClosed:(BOOL)bClosed;

- (void)hideExpandButton;

- (IBAction)onClickBtnExpand:(id)sender;

@end
