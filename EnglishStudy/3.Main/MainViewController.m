//
//  ViewController.m
//  EnglishStudy
//
//  Created by admin on 1/10/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "MainViewController.h"
#import "StudyViewController.h"
#import "ResultViewController.h"
#import "WordsViewController.h"
#import "SettingViewController.h"
#import "NumberView.h"

#import "Global.h"
#import "MsgViewController.h"
#import "ProfileViewController.h"
#import "PsdChangeViewController.h"


@implementation UIImagePickerController (extensions)

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
    //return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[UIApplication sharedApplication] statusBarOrientation];
}

@end

@interface MainViewController ()

@end

@implementation MainViewController

MainViewController *_sharedMainViewController = nil;
+ (MainViewController *)sharedViewController
{
    return _sharedMainViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _sharedMainViewController = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshUserProfile];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
        [Global resizeView:viewProfile withRatioWidth:120 andHeight:54];
    else
        [Global resizeView:viewProfile withRatioWidth:228 andHeight:104];
    
    [Global resizeView:viewWord withRatioWidth:187 andHeight:195];
    [Global resizeView:viewCalendar withRatioWidth:187 andHeight:195];
    
    //[Global resizeView:btnUserPhoto withRatioWidth:100 andHeight:100];
    [Global resizeView:btnStudy withRatioWidth:645 andHeight:465];
    [Global resizeView:btnResult withRatioWidth:575 andHeight:460];
    [Global resizeViewToRight:btnHelp withRatioWidth:132 andHeight:45];
    [Global resizeView:btnSetting withRatioWidth:132 andHeight:45];
    
    [self initCalendar];
}

- (void)initCalendar
{
    [Global removeAllSubviewFromView:lblDay];
    
    NumberView *numView = [NumberView numberViewWithInt:[Global getCurDay] frame:lblDay.bounds];
    [lblDay addSubview:numView];

    lblMonth.text = [NSString stringWithFormat:@"%d월", [Global getCurMonth]];
}

- (void)setUserPhoto:(UIImage *)image
{
    [btnUserPhoto setBackgroundImage:image forState:UIControlStateNormal];
    [btnUserPhoto setBackgroundImage:nil forState:UIControlStateHighlighted];
    
    CGSize size = viewProfile.bounds.size;
    CGRect rect = btnUserPhoto.frame;
    
    rect.size.height = size.height - rect.origin.y*2 - 1;
    rect.size.width = rect.size.height;
    rect.origin.x = size.width - rect.size.width - rect.origin.y - 1;
    btnUserPhoto.frame = rect;
    
    btnUserPhoto.layer.cornerRadius = btnUserPhoto.bounds.size.height/2;
    btnUserPhoto.layer.borderWidth = 3;
    btnUserPhoto.layer.borderColor = [UIColor whiteColor].CGColor;
    btnUserPhoto.clipsToBounds = YES;
}

- (IBAction)onClickUser:(id)sender
{
    ProfileViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"profileviewcontroller"];
    
    [viewController popupWithParentViewController:self popupHeight:560 ofParentHeight:640];
}

- (IBAction)onClickProfile:(id)sender
{
    ProfileViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"profileviewcontroller"];
    
    [viewController popupWithParentViewController:self popupHeight:560 ofParentHeight:640];
}

- (IBAction)onClickStudy:(id)sender
{
    StudyViewController *viewController = [[StudyViewController alloc] initWithNibName:@"StudyViewController" bundle:nil];

    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)onClickResult:(id)sender
{
    if( [Global sharedGlobal].nLevel == 0 )
    {
        [MsgViewController popupWithParentViewController:self msg:@"학습일정을 선택하십시요." msgID:1 delegate:self];
        return;
    }

    ResultViewController *viewController = [[ResultViewController alloc] initWithNibName:@"ResultViewController" bundle:nil];

    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)onClickWords:(id)sender
{
    WordsViewController *viewController = [[WordsViewController alloc] initWithNibName:@"WordsViewController" bundle:nil];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)onClickHelp:(id)sender
{

}

- (IBAction)onClickSetting:(id)sender
{
    SettingViewController *viewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)gotoChangePassword
{
    PsdChangeViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"psdchangeviewcontroller"];
    
    viewController.bForget = NO;

    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)gotoLogout
{
    //[self.navigationController popViewControllerAnimated:YES];
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginviewcontroller"];

    [self.navigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:NO];
}

- (void)refreshUserProfile
{
    lblUserName.text = [Global sharedGlobal].strUserName;
    
    [Global resetFontSizeOfAnswerLabel:lblUserName];
    
    if( [Global sharedGlobal].imgUserPhoto != nil )
    {
        [self setUserPhoto:[Global sharedGlobal].imgUserPhoto];
    }
    
    lblStarRate.text = [NSString stringWithFormat:@"%d", [Global sharedGlobal].nStarRate];
}

@end
