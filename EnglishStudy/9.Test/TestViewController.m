
#import "TestViewController.h"
#import "StudyViewController.h"
#import "TestStepViewController.h"

#import "MainViewController.h"
#import "StudyViewController.h"

#import "Global.h"

@interface TestViewController ()

@end

@implementation TestViewController

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

    if( [Global sharedGlobal].bLevelTest == YES )
    {
        lblTestTab.text = @"급수시험";
        lblComment.text = @"급수시험은 4단계로 나누어 진행합니다.";
    }
    else
    {
        lblTestTab.text = @"시험";
        lblComment.text = @"시험은 4단계로 나누어 진행합니다.";
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [Global resizeView:imgViewDesc withRatioWidth:538 andHeight:435];
    [Global resizeView:btnStartTest withRatioWidth:107 andHeight:140];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTouchDragIn:(id)sender
{
    lblBackTab.textColor = UIRGBColor(255, 255, 255, 255);
}

- (IBAction)onTouchDragOut:(id)sender
{
    lblBackTab.textColor = UIRGBColor(74, 90, 1, 255);
}

- (IBAction)onClickStart:(id)sender
{
    TestStepViewController *viewController = [[TestStepViewController alloc] initWithNibName:@"TestStepViewController" bundle:nil];
    
    NSArray *viewControllerList = [NSArray arrayWithObjects:[MainViewController sharedViewController], [StudyViewController sharedViewController], viewController, nil];
    
    [self.navigationController setViewControllers:viewControllerList animated:NO];
}

- (IBAction)onClickBack:(id)sender
{
    [self.navigationController popToViewController:[StudyViewController sharedViewController] animated:YES];
}

@end
