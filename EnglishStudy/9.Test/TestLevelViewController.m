
#import "TestLevelViewController.h"
#import "TestStepViewController.h"
#import "StudyViewController.h"
#import "Global.h"

@interface TestLevelViewController ()
{
    
}

@end

@implementation TestLevelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }

    return self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [Global resizeView:viewResult withRatioWidth:617 andHeight:412];
    [Global resizeView:viewLevel withRatioWidth:83 andHeight:111];

    [Global resizeView:btnOK withRatioWidth:205 andHeight:67];
    
    viewGraph.backgroundColor = [UIColor clearColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refreshTestResult];
}

- (void)refreshTestResult
{
    int     nLevel = 1;
    
    int     nScore = 100*self.nCorrectWords/self.nTotalWords;
    
    if( nScore >= 90 )
        nLevel = 5;
    else if( nScore >= 80 )
        nLevel = 4;
    else if( nScore >= 70 )
        nLevel = 3;
    else if( nScore >= 60 )
        nLevel = 2;
    else
        nLevel = 1;
    
    self.nLevel = nLevel;

    lblDesc1.text = [NSString stringWithFormat:@"%d문제중 %d문제가 통과되였습니다. %@님의 학습급수는 %d급입니다.", self.nTotalWords, self.nCorrectWords, [Global sharedGlobal].strUserName, nLevel];
    
    lblDesc2.text = [NSString stringWithFormat:@"%d급에서부터 학습을 시작합니다.", nLevel];
    
    NSString    *strImgName = [NSString stringWithFormat:@"num_oder%d.png", nLevel];
    imgViewLevel.image = [UIImage imageNamed:strImgName];
}

- (IBAction)onClickBtnOK:(id)sender
{
    [[TestStepViewController shareViewController] returnFromTest];

    [Global sharedGlobal].nPrepareLevel = self.nLevel;
    [[StudyViewController sharedViewController] changeSchedule];
}

@end
