
#import "TestStepResultViewController.h"
#import "StudyViewController.h"
#import "TestStepViewController.h"
#import "Global.h"
#import "UserManager.h"

@interface TestStepResultViewController ()
{
    NSArray     *arrImgViewStars;
}

@end

@implementation TestStepResultViewController

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
    
    [Global resizeView:viewStudyWords withRatioWidth:177 andHeight:175];
    [Global resizeView:viewScore withRatioWidth:177 andHeight:175];
    [Global resizeView:viewIncorrectWords withRatioWidth:177 andHeight:175];
    
    [Global resizeView:viewResult withRatioWidth:182 andHeight:175];

    [Global resizeView:btnOK withRatioWidth:205 andHeight:67];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initStarViews];
    [self refreshTestResult];
}

- (void)initStarViews
{
    arrImgViewStars = [NSArray arrayWithObjects:imgViewStar1, imgViewStar2, imgViewStar3, imgViewStar4, imgViewStar5, nil];
    
    for( int i = 0; i < 5; i++ )
    {
        UIImageView     *imgViewStar = (UIImageView *)[arrImgViewStars objectAtIndex:i];
        [Global resizeView:imgViewStar withRatioWidth:41 andHeight:39];
    }
}

- (void)refreshSubItemsByScore:(int)nScore
{
    if( nScore >= 95 )
    {
        [self refreshStarCount:5];
        
        imgViewMedal.image = [UIImage imageNamed:@"medal1.png"];
    }
    else if( nScore >= 90 )
    {
        [self refreshStarCount:4];
        
        imgViewMedal.image = [UIImage imageNamed:@"medal2.png"];
    }
    else if( nScore >= 80  )
    {
        [self refreshStarCount:3];
        
        imgViewMedal.image = [UIImage imageNamed:@"medal3.png"];
    }
    else
    {
        if( nScore >= 70 )
            [self refreshStarCount:2];
        else if( nScore >= 50 )
            [self refreshStarCount:1];
        else
            [self refreshStarCount:0];

        imgViewMedal.image = [UIImage imageNamed:@"medal4.png"];
    }
}

- (void)refreshStarCount:(int)nYellowCount
{
    for( int i = 0; i < nYellowCount; i++ )
    {
        UIImageView     *imgViewStar = (UIImageView *)[arrImgViewStars objectAtIndex:i];
        
        imgViewStar.image = [UIImage imageNamed:@"icon_small_star_yellow.png"];
    }
    
    for( int i = nYellowCount; i < 5; i++ )
    {
        UIImageView     *imgViewStar = (UIImageView *)[arrImgViewStars objectAtIndex:i];
        
        imgViewStar.image = [UIImage imageNamed:@"icon_small_star_white.png"];
    }
}

- (void)refreshTestResult
{
    int     nLevel = [Global sharedGlobal].nLevel;
    
#ifndef COMPLETE_PRODUCT_PROJECT
    nLevel = 1;
#endif

    int     nScore = 100*self.nCorrectWords/self.nTotalWords;
    
    // 새로운 학습
    if( [Global sharedGlobal].nScheduledID == 0 )
    {
        NSString    *strQuery = [NSString stringWithFormat:@"select * from word_dic where level = %d", nLevel];
        
        NSArray     *arrTotalWords = [[Global sharedGlobal].dbManager queryArrayData:strQuery];

        int     nStudyWords = [Global sharedGlobal].nStudyWords;

        self.nWordCount = MIN( [Global sharedGlobal].nDayWords, [arrTotalWords count] - nStudyWords);

        NSDictionary *dicWordItem = [arrTotalWords objectAtIndex:nStudyWords];

        int nStartWordID = [[dicWordItem objectForKey:@"id"] intValue];

        // 80점이상인 경우에만 진도를 나간다
        if( nScore >= 80 )
        {
            [UserManager addScheduleWordIdx:nStartWordID count:self.nWordCount score:nScore];

            [Global sharedGlobal].nStudyWords += self.nWordCount;
            [[Global sharedGlobal]  saveUserInfo];
        }
    }
    // 재학습인 경우
    else
    {
        NSDictionary    *dicDayItem = [UserManager getScheduleDayInfo:[Global sharedGlobal].nScheduledID];
        
        self.nWordCount = [[dicDayItem objectForKey:@"count"] intValue];
        
        [UserManager updateScheduleDate:[Global sharedGlobal].nScheduledID score:nScore];
    }

    lblStudyWords.text = [NSString stringWithFormat:@"%d", self.nWordCount];
    lblIncorrectWords.text = [NSString stringWithFormat:@"%d", self.nTotalWords - self.nCorrectWords];

    lblScore.text = [NSString stringWithFormat:@"%d", nScore];

    [self refreshSubItemsByScore:nScore];
}

- (IBAction)onClickBtnOK:(id)sender
{
    [[TestStepViewController shareViewController] returnFromTest];

    [[StudyViewController sharedViewController] refreshScheduleView];
}

@end
