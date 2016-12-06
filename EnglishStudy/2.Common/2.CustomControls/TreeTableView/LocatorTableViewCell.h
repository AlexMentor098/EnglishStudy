//
//  LocatorTableViewCell.h
//  SmartAXA
//
//  Created by admin on 4/25/15.
//  Copyright (c) 2015 BST. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LocatorTableViewCell;

@protocol LocatorTableCellDelegate <NSObject>

@required

- (void)didTreeViewCellExpanded:(LocatorTableViewCell *)cell;

@end

@interface LocatorTableViewCell : UITableViewCell
{
    IBOutlet    UILabel         *_lblText;
    IBOutlet    UIButton        *_btnExpand;
    IBOutlet    UIView          *_viewBack;
    IBOutlet    UIImageView     *_imgArrow;

}

@property (nonatomic) id<LocatorTableCellDelegate> delegate;
@property (nonatomic, assign) NSInteger nIndex;

+ (id)createWithTitle:(NSString*)title shouldShow:(BOOL)bShow;

@end