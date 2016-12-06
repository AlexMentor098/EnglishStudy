//
//  UserItemView.h
//  EnglishStudy
//
//  Created by admin on 1/11/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScheduleItemView;
@protocol ScheduleItemViewDelegate <NSObject>

- (void)playButtonPressedOnScheduleItemView:(ScheduleItemView *)viewScheduleItem;

@end

@interface ScheduleItemView : UIView
{
    IBOutlet UIImageView    *imgViewMedal;
    IBOutlet UIImageView    *imgViewLock;
    IBOutlet UIImageView    *imgViewPlay;
    
    IBOutlet UIButton       *btnStart;

    IBOutlet UIImageView    *imgViewStar1;
    IBOutlet UIImageView    *imgViewStar2;
    IBOutlet UIImageView    *imgViewStar3;
    IBOutlet UIImageView    *imgViewStar4;
    IBOutlet UIImageView    *imgViewStar5;

    IBOutlet UIView         *viewDayFrame;
    IBOutlet UILabel        *lblDay;
    
    NSArray     *arrImgViewStars;
}

@property (nonatomic) int nDayIndex;
@property (nonatomic) id<ScheduleItemViewDelegate> delegate;

+ (ScheduleItemView *)scheduleItemViewWithDayIndex:(int)nDayIdx;

- (IBAction)onClickPlay:(id)sender;

@end
