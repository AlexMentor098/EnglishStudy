//
//  UserPageViewController.h
//  EnglishStudy
//
//  Created by admin on 1/11/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserItemView.h"

@interface UserPageViewController : UIViewController <UserItemViewDelegate>
{
    IBOutlet UIImageView    *imgViewBG;
    
    IBOutlet UIView         *viewUser1;
    IBOutlet UIView         *viewUser2;
    IBOutlet UIView         *viewUser3;
    
    UserItemView    *viewUserItem1;
    UserItemView    *viewUserItem2;
    UserItemView    *viewUserItem3;
}

@property (nonatomic) int nPageNum;

+ (id)userPageViewWithNumer:(int)nPageNum;

@end
