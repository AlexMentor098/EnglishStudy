//
//  UniversalViewController.m
//  EnglishStudy
//
//  Created by admin on 1/17/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "UniversalViewController.h"

@interface UniversalViewController ()

@end

@implementation UniversalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
    {
        NSString *strNibname = [NSString stringWithFormat:@"%@_phone", nibNameOrNil];
        self = [super initWithNibName:strNibname bundle:nibBundleOrNil];
    }
    else
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
