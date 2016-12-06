//
//  PopupViewController.h
//  EnglishStudy
//
//  Created by admin on 1/22/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupViewController : UIViewController
{
    UIView      *viewMask;
}

- (void)popupWithParentViewController:(UIViewController *)parentViewController popupHeight:(float)fHeight ofParentHeight:(float)fParentHeigt;

- (void)dismissPopupView;

@end
