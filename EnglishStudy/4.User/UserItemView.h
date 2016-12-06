//
//  UserItemView.h
//  EnglishStudy
//
//  Created by admin on 1/11/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserItemView;
@protocol UserItemViewDelegate <NSObject>

- (void)userItemViewDidSelected:(UserItemView *)view;

- (void)userItemViewDidClickRegister:(UserItemView *)view;

- (void)userItemViewDidClickEdit:(UserItemView *)view;

- (void)userItemViewDidClickDelete:(UserItemView *)view;

@end

@interface UserItemView : UIView
{
    IBOutlet UIImageView    *imgViewPhoto;
    IBOutlet UILabel        *lblName;
    IBOutlet UILabel        *lblJob;
    
    IBOutlet UIButton       *btnRegister;
    IBOutlet UIButton       *btnEdit;
    IBOutlet UIButton       *btnDelete;
}

@property (nonatomic) int nUserIndex;
@property (nonatomic) id<UserItemViewDelegate> delegate;

+ (UserItemView *)userItemViewWithUserIndex:(int)nUserIdx;

- (IBAction)onClickRegister:(id)sender;

- (IBAction)onClickEdit:(id)sender;

- (IBAction)onClickDelete:(id)sender;

@end
