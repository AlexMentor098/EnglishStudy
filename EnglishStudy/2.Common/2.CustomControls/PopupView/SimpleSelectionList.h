//
//  SimpleSelectionList.h
//  PropertyKing5
//
//  Created by admin on 1/27/15.
//  Copyright (c) 2015 ___exchange___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIMaskView.h"

#define SELECTION_LIST_SHOW_TYPE_POPUP      1
#define SELECTION_LIST_SHOW_TYPE_DROPDOWN   2

@class SimpleSelectionList;
@protocol SimpleSelectionListDelegate <NSObject>

@required

- (void)simpleSelectionList:(SimpleSelectionList*)simpleSelectionList didSelectRowAtIndex:(int)nRow;

@end

@interface SimpleSelectionList : UITableView <UITableViewDelegate, UITableViewDataSource, UIMaskViewDelegate>
@property (nonatomic, assign) id<SimpleSelectionListDelegate> listDelegate;

@property (nonatomic, retain) NSDictionary  *dicListInfo;
@property (nonatomic, retain) NSArray       *arrListInfo;

@property (nonatomic, assign) UIMaskView*   viewMask;
@property (nonatomic, assign) BOOL bShouldSelect;

@property (nonatomic, retain) NSString *strShowItemKey;

+ (void)popupToParent:(UIView*)parent
             delegate:(id<SimpleSelectionListDelegate>)delegate
             listInfo:(id)listInfo
                  tag:(NSInteger)nTag;

+ (void)popupToParent:(UIView*)parent
             delegate:(id<SimpleSelectionListDelegate>)delegate
                frame:(CGRect)frame
             anchorPt:(CGPoint)anchorPoint
             listInfo:(id)listInfo
      shouldSelectOne:(BOOL)bShouldSelect
                  tag:(NSInteger)nTag
             showType:(int)nShowType;

+ (void)popupToParent:(UIView*)parent
             delegate:(id<SimpleSelectionListDelegate>)delegate
                frame:(CGRect)frame
             anchorPt:(CGPoint)anchorPoint
             listInfo:(id)listInfo
      shouldSelectOne:(BOOL)bShouldSelect
                  tag:(NSInteger)nTag
             showType:(int)nShowType
          showItemKey:(NSString*)strShowItemKey;

- (void)deselectAll;

@end