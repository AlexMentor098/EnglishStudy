//
//  UserItemView.m
//  EnglishStudy
//
//  Created by admin on 1/11/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "UserItemView.h"

@implementation UserItemView

+ (UserItemView *)userItemViewWithUserIndex:(int)nUserIdx
{
    NSArray       *nibs = [[NSBundle mainBundle] loadNibNamed:@"UserItemView" owner:self options:nil];
    UserItemView  *view = (UserItemView *)nibs[0];

    [view initWithUserIndex:nUserIdx];

    return view;
}

- (void)initWithUserIndex:(int)nUserIdx
{
    self.nUserIndex = nUserIdx;
    
    if( self.nUserIndex == -1 )
    {
        btnRegister.hidden = NO;
        btnEdit.hidden = YES;
        btnDelete.hidden = YES;
        lblName.hidden = YES;
        lblJob.hidden = YES;
    }
    else
    {
        btnRegister.hidden = YES;
        btnEdit.hidden = NO;
        btnDelete.hidden = NO;
        lblName.hidden = NO;
        lblJob.hidden = NO;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }

    return self;
}

- (IBAction)onClickRegister:(id)sender
{
    [self.delegate userItemViewDidClickRegister:self];
}

- (IBAction)onClickEdit:(id)sender
{
    
}

- (IBAction)onClickDelete:(id)sender
{
    
}

@end
