//
//  TestViewController.h
//  EnglishStudy
//
//  Created by admin on 1/15/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniversalViewController.h"

@protocol TestViewDelegate <NSObject>

@optional
- (void)stopTest;

- (void)pause;

- (void)resume;

@end

@interface TestViewController : UniversalViewController
{
    IBOutlet UILabel    *lblTestTab;
    IBOutlet UILabel    *lblBackTab;
    
    IBOutlet UIImageView    *imgViewDesc;
    IBOutlet UIButton       *btnStartTest;
    IBOutlet UILabel        *lblComment;
}

- (IBAction)onClickStart:(id)sender;

- (IBAction)onClickBack:(id)sender;

- (IBAction)onTouchDragIn:(id)sender;

- (IBAction)onTouchDragOut:(id)sender;

@end