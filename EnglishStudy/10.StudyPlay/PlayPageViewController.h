//
//  PlayPageViewController.h
//  EnglishStudy
//
//  Created by admin on 1/16/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniversalViewController.h"

@interface PlayPageViewController : UniversalViewController
{
    IBOutlet UILabel    *lblLevel;
    IBOutlet UILabel    *lblTotalCount;
    IBOutlet UILabel    *lblPageStatus;
    
    IBOutlet UILabel    *lblLeftWord;
    IBOutlet UIView     *viewLeftFrame;
    IBOutlet UIView     *viewLeftProgress;

    IBOutlet UILabel    *lblRightWord;
    IBOutlet UIView     *viewRightFrame;
    IBOutlet UIView     *viewRightProgress;
    
    IBOutlet UIImageView    *imgViewPicture;
}

@property (nonatomic) int   nWordIndex;
@property (nonatomic) BOOL  bPlay;

+ (PlayPageViewController *)playPageWithWordIndex:(int)nIndex;

- (void)startPlay;
- (void)stopPlay;

- (void)pausePlay;
- (void)resumePlay;

@end
