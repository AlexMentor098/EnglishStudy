//
//  UIMaskView.h
//  PropertyKing5
//
//  Created by admin on 1/27/15.
//  Copyright (c) 2015 ___exchange___. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIMaskView;
@protocol UIMaskViewDelegate <NSObject>

@optional

- (void)touchBeganOnMaskView:(UIMaskView*)viewMask;

@end

@interface UIMaskView : UIView

@property (nonatomic, assign) id<UIMaskViewDelegate> delegate;

@end
