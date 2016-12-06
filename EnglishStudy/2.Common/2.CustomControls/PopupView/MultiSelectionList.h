//
//  MultiSelectionList.h
//  PropertyKing5
//
//  Created by admin on 2/1/15.
//  Copyright (c) 2015 ___exchange___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIMaskView.h"

@class MultiSelectionList;
@protocol MultiSelectionListDelegate <NSObject>

@required

- (void)multiSelectionList:(MultiSelectionList *)multiSelectionList didSelectedIndexPaths:(NSArray *)arrIndexPaths;

@end

@interface MultiSelectionList : UIScrollView <UITableViewDataSource, UITableViewDelegate, UIMaskViewDelegate>
{
    UITableView *viewTblContent;
}

@property (nonatomic, assign) id<MultiSelectionListDelegate> listDelegate;
@property (nonatomic, assign) NSDictionary  *dicListInfo;
@property (nonatomic, assign) NSArray       *arrSelIndexPaths;
@property (nonatomic, assign) UIMaskView    *viewMask;

+ (void)popupToParent:(UIView *)parent
             delegate:(id<MultiSelectionListDelegate>)delegate
                frame:(CGRect)frame
             anchorPt:(CGPoint)anchorPoint
             listInfo:(NSDictionary *)dicListInfo
            selIndexs:(NSArray *)arrSelIndexs
                  tag:(NSInteger)nTag;

@end
