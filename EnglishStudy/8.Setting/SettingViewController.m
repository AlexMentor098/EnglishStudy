
#import "SettingViewController.h"
#import "SettingOptionViewController.h"
#import "SettingCheckViewController.h"
#import "Global.h"

@interface SettingViewController()

@end

@implementation SettingViewController

SettingViewController *_sharedSettingViewController = nil;

+ (SettingViewController *)sharedViewController
{
    return _sharedSettingViewController;
}

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
    
    _sharedSettingViewController = self;

    [self refreshSettingValues];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [Global resizeView:viewContent withRatioWidth:776 andHeight:457];
}

- (IBAction)onClickBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

NSString    *_arrStrSettingColors[] = { @"없음", @"노란색", @"풀색", @"빨간색", @"파란색" };
NSString    *_arrStrSettingTestSeconds[] = { @"5초", @"7초", @"10초" };
NSString    *_arrStrSettingStudySpeeds[] = { @"매우느림", @"느림", @"보통", @"빠름", @"매우빠름" };

- (void)refreshSettingValues
{
    Global  *global = [Global sharedGlobal];

    lblRepeat1.text = [NSString stringWithFormat:@"%d회반복", global.setting.nRepeatStep1+1];
    lblRepeat2.text = [NSString stringWithFormat:@"%d회반복", global.setting.nRepeatStep2+1];

    lblWordColor.text = _arrStrSettingColors[global.setting.nWordColorMode];
    lblMeanColor.text = _arrStrSettingColors[global.setting.nMeanColorMode];
    
    lblTestTime.text = _arrStrSettingTestSeconds[global.setting.nTestTimeMode];
    
    lblStudySpeed.text = _arrStrSettingStudySpeeds[global.setting.nStudySpeedMode];
}

- (void)popupOptionSettingView:(int)nSettingMode withValue:(int)nSettingValue
{
    SettingOptionViewController *viewController = [[SettingOptionViewController alloc] initWithNibName:@"SettingOptionViewController" bundle:nil];
    
    viewController.nSettingMode = nSettingMode;
    viewController.nSettingValue = nSettingValue;

    if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
        [viewController popupWithParentViewController:self popupHeight:596 ofParentHeight:640];
    else
        [viewController popupWithParentViewController:self popupHeight:452 ofParentHeight:768];
}

- (IBAction)onClickBtnStudyRepeat1:(id)sender
{
    [self popupOptionSettingView:SETTING_OPTION_MODE_REPEAT1 withValue:[Global sharedGlobal].setting.nRepeatStep1];
}

- (IBAction)onClickBtnStudyRepeat2:(id)sender
{
    [self popupOptionSettingView:SETTING_OPTION_MODE_REPEAT2 withValue:[Global sharedGlobal].setting.nRepeatStep2];
}

- (IBAction)onClickBtnWordColor:(id)sender
{
    [self popupOptionSettingView:SETTING_OPTION_MODE_WORD_COLOR withValue:[Global sharedGlobal].setting.nWordColorMode];
}

- (IBAction)onClickBtnMeanColor:(id)sender
{
    [self popupOptionSettingView:SETTING_OPTION_MODE_MEAN_COLOR withValue:[Global sharedGlobal].setting.nMeanColorMode];
}

- (IBAction)onClickBtnTestTime:(id)sender
{
    [self popupOptionSettingView:SETTING_OPTION_MODE_TIME withValue:[Global sharedGlobal].setting.nTestTimeMode];
}

- (IBAction)onClickBtnStudySpeed:(id)sender
{
    [self popupOptionSettingView:SETTING_OPTION_MODE_SPEED withValue:[Global sharedGlobal].setting.nStudySpeedMode];
}

- (IBAction)onClickBtnTestMethod:(id)sender
{
    SettingCheckViewController *viewController = [[SettingCheckViewController alloc] initWithNibName:@"SettingCheckViewController" bundle:nil];

    if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
        [viewController popupWithParentViewController:self popupHeight:596 ofParentHeight:640];
    else
        [viewController popupWithParentViewController:self popupHeight:452 ofParentHeight:768];
}

@end
