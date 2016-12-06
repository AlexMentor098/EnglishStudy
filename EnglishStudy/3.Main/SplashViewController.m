//
//  SplashViewController.m
//  EnglishStudy
//
//  Created by admin on 1/27/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "SplashViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

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

    [viewLoading startAnimating];
    
    [self performSelector:@selector(gotoLogin) withObject:nil afterDelay:3.0f];
}

- (void)gotoLogin
{
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginviewcontroller"];
    //[self.navigationController pushViewController:viewController animated:NO];
    [self.navigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
