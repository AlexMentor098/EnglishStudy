//
//  UserRegViewController.m
//  EnglishStudy
//
//  Created by admin on 1/12/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "UserRegViewController.h"

@interface UserRegViewController ()

@end

@implementation UserRegViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)onClickOK:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];    
}

@end
