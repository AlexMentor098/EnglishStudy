//
//  MsgViewController.m
//  EnglishStudy
//
//  Created by admin on 1/23/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "MsgViewController.h"
#import "Global.h"

@interface MsgViewController ()

@end

@implementation MsgViewController

+ (void)popupWithParentViewController:(UIViewController *)parentViewController msg:(NSString *)strMsg msgID:(int)nMsgID delegate:(id<MsgViewDelegate>)delegate
{
    MsgViewController *viewController = [[MsgViewController alloc] initWithNibName:@"MsgViewController" bundle:nil];
    
    viewController.delegate = delegate;
    viewController.nMsgID = nMsgID;
    viewController.strMessage = strMsg;

    if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
        [viewController popupWithParentViewController:parentViewController popupHeight:320 ofParentHeight:640];
    else
        [viewController popupWithParentViewController:parentViewController popupHeight:282 ofParentHeight:768];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
    {
        NSString *strNibname = [NSString stringWithFormat:@"%@_phone", nibNameOrNil];
        self = [super initWithNibName:strNibname bundle:nibBundleOrNil];
    }
    else
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
    {
        CGSize  size = [UIScreen mainScreen].bounds.size;
        float   fFontSize = MIN(size.width, size.height)/20;
        lblMessage.font = [UIFont fontWithName:@"Gulim" size:fFontSize];
    }
    else
        lblMessage.font = [UIFont fontWithName:@"Gulim" size:22];
    lblMessage.text = self.strMessage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)onClickContinue:(id)sender
{
    [self dismissPopupView];

    if( [self.delegate respondsToSelector:@selector(didHideMsgView:)] )
        [self.delegate didHideMsgView:self.nMsgID];
}

@end
