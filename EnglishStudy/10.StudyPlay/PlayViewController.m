
#import "PlayViewController.h"
#import "TestViewController.h"
#import "MainViewController.h"
#import "StudyViewController.h"
#import "Global.h"
#import "UserManager.h"
#import "SoundManager.h"

@interface PlayViewController ()

@end

@implementation PlayViewController

PlayViewController *_sharedPlayViewController = nil;

+ (PlayViewController *)sharedViewController
{
    return _sharedPlayViewController;
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

    self.bStepChanging = FALSE;

    _sharedPlayViewController = self;
    self.nCurStep = 1;
    self.nRepeat = 0;

    [self prepareStudyWords];
    [self createPageView:0];
    
    [self switchToPauseButton];
}

- (void)switchToPauseButton
{
    bPaused = NO;

    [btnPause setImage:[UIImage imageNamed:@"btn_play_pause_n.png"] forState:UIControlStateNormal];
    [btnPause setImage:[UIImage imageNamed:@"btn_play_pause_d.png"] forState:UIControlStateHighlighted];
}

- (void)prepareStudyWords
{
    int     nLevel = [Global sharedGlobal].nLevel;
    
#ifndef COMPLETE_PRODUCT_PROJECT
    nLevel = 1;
#endif

    // 새로운 학습
    if( [Global sharedGlobal].nScheduledID == 0 )
    {
        NSString    *strQuery = [NSString stringWithFormat:@"select * from word_dic where level = %d", nLevel];
        NSArray     *arrTotalWords = [[Global sharedGlobal].dbManager queryArrayData:strQuery];
        
        NSMutableArray  *arrStudyWords = [NSMutableArray arrayWithCapacity:0];
        
        int     nStudyWords = [Global sharedGlobal].nStudyWords;
        
        self.nWordCount = MIN( [Global sharedGlobal].nDayWords, [arrTotalWords count] - nStudyWords);
        
        for( int i = 0; i < self.nWordCount; i++ )
        {
            NSDictionary *dicWordItem = [arrTotalWords objectAtIndex:nStudyWords+i];
            [arrStudyWords addObject:dicWordItem];
        }

        self.arrDicWords = arrStudyWords;
    }
    // 재학습인 경우
    else
    {
        NSDictionary    *dicDayItem = [UserManager getScheduleDayInfo:[Global sharedGlobal].nScheduledID];
        
        int     nStartID = [[dicDayItem objectForKey:@"swid"] intValue];
        self.nWordCount = [[dicDayItem objectForKey:@"count"] intValue];

        NSString    *strQuery = [NSString stringWithFormat:@"select * from word_dic where level = %d and id >= %d", nLevel, nStartID];
        self.arrDicWords = [[Global sharedGlobal].dbManager queryArrayData:strQuery];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [Global resizeView:btnSave withRatioWidth:308 andHeight:93];
    [Global resizeView:btnBack withRatioWidth:308 andHeight:93];

    [Global resizeView:btnPrev withRatioWidth:40 andHeight:40];
    [Global resizeView:btnPause withRatioWidth:40 andHeight:40];
    [Global resizeView:btnNext withRatioWidth:40 andHeight:40];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)didHideMsgView:(int)nMsgID
{
    if( nMsgID == 1 )
    {
        self.bPagingEnable = TRUE;
        self.bStepChanging = FALSE;
        
        PlayPageViewController *curViewController = [_pageViewCtrl.viewControllers objectAtIndex:0];
        [curViewController startPlay];
        
        bPaused = NO;
        [self switchToPauseButton];
    }
}

- (void)showStartStepMsg
{
    NSString *strMsg = [NSString stringWithFormat:@"%d단계학습을 시작합니다.", self.nCurStep];
    
    [MsgViewController popupWithParentViewController:self msg:strMsg msgID:1 delegate:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self showStartStepMsg];
}

- (void)createPageView:(int)pageNum
{
    self.nCurPage = pageNum;

    self.bPagingEnable = FALSE;

    _pageViewCtrl = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                  options:nil];
    _pageViewCtrl.delegate = self;
    _pageViewCtrl.dataSource = self;

    PlayPageViewController *viewController = [PlayPageViewController playPageWithWordIndex:pageNum];

    NSArray *viewControllers = @[viewController];
    
    [_pageViewCtrl setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:NULL];
    
    [self addChildViewController:_pageViewCtrl];
    [viewPager addSubview:_pageViewCtrl.view];
    _pageViewCtrl.view.backgroundColor = [UIColor clearColor];
    
    CGRect pageViewRect = viewPager.bounds;
    _pageViewCtrl.view.frame = pageViewRect;
    
    [_pageViewCtrl didMoveToParentViewController:self];
}

- (void)presentPage:(UIViewController*)pageView direction:(UIPageViewControllerNavigationDirection)direction
{
    NSArray *viewControllers = @[pageView];
    
    //__block UIPageViewController *blockPageView = _pageViewCtrl;

    self.bPagingEnable = FALSE;
    [_pageViewCtrl setViewControllers:viewControllers direction:direction animated:YES completion: ^(BOOL finished) {
        /*
         if(finished)
         {
         dispatch_async(dispatch_get_main_queue(), ^{
         [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];// bug fix for uipageview controller
         });
         }*/
        
        PlayPageViewController *playView = (PlayPageViewController *)pageView;

        if( [PlayViewController sharedViewController].bStepChanging == FALSE )
        {
            [PlayViewController sharedViewController].bPagingEnable = TRUE;
            [playView startPlay];
            
            bPaused = NO;
            [self switchToPauseButton];
        }
    }];
    
    [SoundManager playPageEffectSound];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if( finished == YES )
        self.bPagingEnable = TRUE;

    if( completed == YES )
    {
        PlayPageViewController *prevViewController = [previousViewControllers objectAtIndex:0];
        [prevViewController stopPlay];
        
        PlayPageViewController *curViewController = [_pageViewCtrl.viewControllers objectAtIndex:0];
        [curViewController startPlay];
        
        self.nCurPage = curViewController.nWordIndex;
        [SoundManager playPageEffectSound];
        
        bPaused = NO;
        [self switchToPauseButton];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    PlayPageViewController *curViewController = (PlayPageViewController *)viewController;
    
    int     nCurIndex = curViewController.nWordIndex;

    if( self.bPagingEnable == FALSE )
        return nil;

    if( nCurIndex+1 >= self.nWordCount )
    {
        [self playNextStepStuding];
        return nil;
    }

    PlayPageViewController *newViewController = [PlayPageViewController playPageWithWordIndex:nCurIndex+1];

    self.bPagingEnable = FALSE;
    
    return newViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    PlayPageViewController *curViewController = (PlayPageViewController *)viewController;
    
    if( curViewController.nWordIndex == 0 || self.bPagingEnable == FALSE )
        return nil;

    PlayPageViewController *newViewController = [PlayPageViewController playPageWithWordIndex:curViewController.nWordIndex-1];

    self.bPagingEnable = FALSE;
    return newViewController;
}

-(IBAction)onClickBack:(id)sender
{
    PlayPageViewController *curViewController = [_pageViewCtrl.viewControllers objectAtIndex:0];
    [curViewController stopPlay];

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickSave:(id)sender
{
    
}

- (IBAction)onClickPrev:(id)sender
{
    if( self.bPagingEnable == FALSE )
        return;
    
    if( self.nCurPage <= 0 || self.bPagingEnable == FALSE )
        return;

    PlayPageViewController *curViewController = [_pageViewCtrl.viewControllers objectAtIndex:0];
    [curViewController stopPlay];

    self.nCurPage = self.nCurPage-1;
    PlayPageViewController *newViewController = [PlayPageViewController playPageWithWordIndex:self.nCurPage];
    
    [self presentPage:newViewController direction:UIPageViewControllerNavigationDirectionReverse];
}

- (IBAction)onClickNext:(id)sender
{
    [self playNextWordOfIndex:self.nCurPage];
}

- (IBAction)onClickPause:(id)sender
{
    PlayPageViewController *curViewController = [_pageViewCtrl.viewControllers objectAtIndex:0];
    
    if( bPaused == YES )
    {
        bPaused = NO;

        [self switchToPauseButton];
        [curViewController resumePlay];
    }
    else
    {
        bPaused = YES;
        
        [btnPause setImage:[UIImage imageNamed:@"btn_play_right_n.png"] forState:UIControlStateNormal];
        [btnPause setImage:[UIImage imageNamed:@"btn_play_right_d.png"] forState:UIControlStateHighlighted];
        
        [curViewController pausePlay];
    }
}

- (void)playNextPage:(PlayPageViewController *)curPlayPage
{
    PlayPageViewController *curViewController = [_pageViewCtrl.viewControllers objectAtIndex:0];
    
    if( curPlayPage != curViewController )
        return;

    [self playNextWordOfIndex:curPlayPage.nWordIndex];
}

- (void)playNextWordOfIndex:(int)nIndex
{
    if( self.bPagingEnable == FALSE )
        return;

    if( self.nCurPage >= nIndex+1 || self.bPagingEnable == FALSE )
        return;
    
    PlayPageViewController *curViewController = [_pageViewCtrl.viewControllers objectAtIndex:0];
    [curViewController stopPlay];

    if( nIndex+1 >= self.nWordCount )
    {
        [self playNextStepStuding];
        return;
    }

    self.nCurPage = nIndex+1;
    PlayPageViewController *newViewController = [PlayPageViewController playPageWithWordIndex:self.nCurPage];
    
    [self presentPage:newViewController direction:UIPageViewControllerNavigationDirectionForward];
}

- (void)playNextStepStuding
{
    BOOL bStepChange = NO;

    self.nRepeat++;

    if( self.nCurStep == 2 && self.nRepeat > [Global sharedGlobal].setting.nRepeatStep2 )
    {
        // goto test view
        [self gotoTestView];
        return;
    }

    if( self.nCurStep == 1 && self.nRepeat > [Global sharedGlobal].setting.nRepeatStep1 )
    {
        self.nCurStep = 2;
        self.nRepeat = 0;
        
        bStepChange = YES;
        self.bStepChanging = TRUE;
    }

    self.nCurPage = 0;
    PlayPageViewController *newViewController = [PlayPageViewController playPageWithWordIndex:self.nCurPage];
    [self presentPage:newViewController direction:UIPageViewControllerNavigationDirectionForward];

    if( bStepChange == YES )
        [self performSelector:@selector(showStartStepMsg) withObject:nil afterDelay:0.5f];
}

- (void)gotoTestView
{
    [Global sharedGlobal].bLevelTest = NO;

    TestViewController *viewController = [[TestViewController alloc] initWithNibName:@"TestViewController" bundle:nil];
    
    NSArray *viewControllerList = [NSArray arrayWithObjects:[MainViewController sharedViewController], [StudyViewController sharedViewController], viewController, nil];

    [self.navigationController setViewControllers:viewControllerList animated:YES];
}

@end
