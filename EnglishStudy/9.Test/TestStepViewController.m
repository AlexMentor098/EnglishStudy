
#import "TestStepViewController.h"
#import "TestStep1ViewController.h"
#import "TestStep4ViewController.h"

#import "TestStepResultViewController.h"
#import "TestLevelViewController.h"

#import "MainViewController.h"
#import "StudyViewController.h"
#import "Global.h"

@interface TestStepViewController ()
{
    BOOL    bInitPage;
}

@end

@implementation TestStepViewController

TestStepViewController *_sharedTestStepViewController = nil;

+ (TestStepViewController *)shareViewController
{
    return _sharedTestStepViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _sharedTestStepViewController = self;

    if( [Global sharedGlobal].bLevelTest == YES )
        lblTestTab.text = @"급수시험";
    else
        lblTestTab.text = @"시험";
    
    bInitPage = NO;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    [self initPage];
    pageViewController.view.frame = viewContent.bounds;
}

- (void)initPage
{
    if( bInitPage == YES )
        return;

    bInitPage = YES;

    if( ([Global sharedGlobal].setting.nTestMethod & TEST_METHOD_OPTION_STEP_CHOOSE) != 0 )
    {
        TestStep1ViewController *viewController = [[TestStep1ViewController alloc] initWithNibName:@"TestStep1ViewController" bundle:nil];
    
        pageViewController = viewController;
    
        [self addChildViewController:pageViewController];
        [viewContent addSubview:pageViewController.view];
        pageViewController.view.frame = viewContent.bounds;
    }
    else
    {
        [self showTestStep4ViewController:0 andCorrectWords:0];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)onClickStart:(id)sender
{
    
}

- (void)returnFromTest
{
    if( [pageViewController respondsToSelector:@selector(stopTest)] )
        [pageViewController stopTest];

    //[self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToViewController:[StudyViewController sharedViewController] animated:YES];
}

- (void)didHideQuestionView:(int)nQuestionID withButton:(int)nButtonID
{
    if( nButtonID == 0 )
        [self returnFromTest];
    else
    {
        if( [pageViewController respondsToSelector:@selector(resume)] )
            [pageViewController resume];
    }
}

- (IBAction)onClickBack:(id)sender
{
    if( [pageViewController respondsToSelector:@selector(pause)] )
    {
        [pageViewController pause];
    
        NSString *strMsg = @"시험을 중지하겠습니까?";
        [QuestionViewController popupWithParentViewController:self msg:strMsg msgID:2 delegate:self];
    }
    else
        [self returnFromTest];
}

- (IBAction)onTouchDragIn:(id)sender
{
    lblBackTab.textColor = UIRGBColor(255, 255, 255, 255);
}

- (IBAction)onTouchDragOut:(id)sender
{
    lblBackTab.textColor = UIRGBColor(74, 90, 1, 255);
}

- (void)removeCurrentView
{
    [pageViewController.view removeFromSuperview];
    [pageViewController removeFromParentViewController];
}

- (void)showTestStep4ViewController:(int)nTotalWords andCorrectWords:(int)nCorrectWords
{
    TestStep4ViewController *viewController = [[TestStep4ViewController alloc] initWithNibName:@"TestStep4ViewController" bundle:nil];
    
    pageViewController = viewController;
    
    [self addChildViewController:pageViewController];
    [viewContent addSubview:pageViewController.view];
    pageViewController.view.frame = viewContent.bounds;
    
    [viewController startTestWithTotalWords:nTotalWords nCorrectWords:nCorrectWords];
}

- (void)moveTo4StepWithTotalWords:(int)nTotalWords andCorrectWords:(int)nCorrectWords
{
    if( ([Global sharedGlobal].setting.nTestMethod & TEST_METHOD_OPTION_STEP4) == 0 )
    {
        [self showTestResult:nTotalWords correctWords:nCorrectWords];
        return;
    }

    TestStep1ViewController *step1Controller = (TestStep1ViewController *)pageViewController;
    [step1Controller stopTest];
    [self removeCurrentView];

    [self showTestStep4ViewController:nTotalWords andCorrectWords:nCorrectWords];
}

- (void)showTestResult:(int)nTotalWords correctWords:(int)nCorrectWords
{
    [self removeCurrentView];

    UIViewController *viewController = nil;

    if( [Global sharedGlobal].bLevelTest == NO )
    {
        TestStepResultViewController *testResultViewController = [[TestStepResultViewController alloc] initWithNibName:@"TestStepResultViewController" bundle:nil];

        testResultViewController.nTotalWords = nTotalWords;
        testResultViewController.nCorrectWords = nCorrectWords;

        viewController = testResultViewController;
    }
    else
    {
        TestLevelViewController *testLevelViewController = [[TestLevelViewController alloc] initWithNibName:@"TestLevelViewController" bundle:nil];
        
        testLevelViewController.nTotalWords = nTotalWords;
        testLevelViewController.nCorrectWords = nCorrectWords;

        viewController = testLevelViewController;
    }
    
    pageViewController = (UIViewController<TestViewDelegate>*)viewController;

    [self addChildViewController:pageViewController];
    [viewContent addSubview:pageViewController.view];
    pageViewController.view.frame = viewContent.bounds;
}

@end
