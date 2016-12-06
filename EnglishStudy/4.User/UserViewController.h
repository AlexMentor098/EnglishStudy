//
//  UserViewController.h
//  EnglishStudy
//
//  Created by admin on 1/11/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserViewController : UIViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
{
    IBOutlet UIView         *viewPager;
    
    UIPageViewController    *_pageViewCtrl;
}

+ (UserViewController *)sharedViewController;

- (IBAction)onClickReturn:(id)sender;

- (void)presentUserRegisterView;

@end
