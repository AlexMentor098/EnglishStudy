
#import "TestStep4ViewController.h"
#import "StudyViewController.h"
#import "TestLevelViewController.h"
#import "TestStepViewController.h"
#import "Global.h"
#import "SoundManager.h"

#define     TIME_STATUS_WAIT_FOR_TEST       0
#define     TIME_STATUS_TESTING             1
#define     TIME_STATUS_SHOW_ANSWER         2
#define     TIME_STATUS_HIDE_ANSWER         3
#define     TIME_STATUS_SHOW_ANSWER2        4
#define     TIME_STATUS_SHOW_CORRECT        5
#define     TIME_STATUS_SHOW_FAIL           6

@interface TestStep4ViewController ()
{
    int     nCurrentTimeStatus;

    float   fTimeLimit;
    float   fTimePass;
    
    int     nTestStep;
    
    int     nTotalWords;
    int     nTestWords;
    int     nCorrectWords;
    
    int     nTotalStepWords;
    int     nTestStepWords;
    
    BOOL    bCanAnswer;

    NSArray         *arrDicWords;
    NSMutableArray  *arrStepWords;
    
    NSMutableArray  *arrLblSpells;
    
    NSTimer         *timeCounter;
    NSString        *strTypeAnswer;
}

@end

#define     TIME_COUNTER_STEP       0.06f

@implementation TestStep4ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }

    return self;
}

- (void)startTestWithTotalWords:(int)nTotal nCorrectWords:(int)nCorrect
{
    nTestStep = 3;
    
    nTotalWords = nTotal + STEP_TEST_WORD_COUNT;
    nTestWords = nTotal;
    nCorrectWords = nCorrect;

    [self initTimeLimit];

    [self initControls];
    [self prepareAndStartTest];
}

- (void)initTimeLimit
{
    if( [Global sharedGlobal].setting.nTestTimeMode == 0 )
        fTimeLimit = 5.0f;
    else if( [Global sharedGlobal].setting.nTestTimeMode == 1 )
        fTimeLimit = 7.0f;
    else
        fTimeLimit = 10.0f;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [Global resizeView:imgViewStepMark withRatioWidth:129 andHeight:312];
    [Global resizeView:viewQuestion withRatioWidth:587 andHeight:165];
    [Global resizeView:viewAnswer withRatioWidth:727 andHeight:263];
    [Global resizeView:viewResults withRatioWidth:227 andHeight:46];
    
    viewCorrectAnswer.layer.cornerRadius = viewCorrectAnswer.bounds.size.height/11;
    viewCorrectAnswer.clipsToBounds = YES;

    [self initProgressBar];
}

- (void)initProgressBar
{
    viewProgBar.layer.cornerRadius = viewProgBar.bounds.size.height/2;
    viewProgBar.clipsToBounds = YES;
    viewProgBar.backgroundColor = UIRGBColor(0, 138, 255, 255);
    
    viewProgValue.backgroundColor = UIRGBColor(255, 255, 255, 255);
    
    CGRect rect = viewProgValue.frame;
    rect.size.width = 0;
    
    viewProgValue.frame = rect;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    bCanAnswer = NO;
}

- (void)initControls
{
    arrLblSpells = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareAndStartTest
{
    bStop = NO;

    [self refreshWordCounts];
    [self prepareStepWords];
    [self prepareForAnswer];
}

- (void)prepareStepWords
{
    nTotalStepWords = STEP_TEST_WORD_COUNT;
    nTestStepWords = 0;

    arrDicWords = [[Global sharedGlobal].dbManager queryArrayData:@"select * from word_dic"];
    arrStepWords = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSMutableArray  *arrWordIndex = [[NSMutableArray alloc] initWithCapacity:0];
    
    for( int i = 0; i < [arrDicWords count]; i++ )
        [arrWordIndex addObject:[NSNumber numberWithInt:i]];
    
    NSTimeInterval curTimeInterval = [[NSDate date] timeIntervalSince1970];
    srand(curTimeInterval);

    for( int i = 0; i < nTotalStepWords; i++ )
    {
        // search untested word index
        int nRand = rand()%[arrWordIndex count];
        int nWordIndex = [[arrWordIndex objectAtIndex:nRand] intValue];
        
        // remove added word from test list
        [arrWordIndex removeObjectAtIndex:nRand];

        [arrStepWords addObject:[NSNumber numberWithInt:nWordIndex]];
    }
}

- (void)prepareControlsForNewQuestion:(int)nCount
{
    float   fWid = viewEngWord.frame.size.height;
    
    [Global removeAllSubviewFromView:viewEngWord];
    [arrLblSpells removeAllObjects];

    for( int i = 0; i < nCount; i++ )
    {
        CGRect      rect;
        
        rect.size.width = fWid*1.2f;
        rect.size.height = fWid*0.9f;
        rect.origin.x = fWid*1.2f*i;
        rect.origin.y = 0;

        UILabel     *label = [[UILabel alloc] initWithFrame:rect];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:fWid*0.8f];
        label.textColor = UIRGBColor(0, 240, 255, 255);
        //label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        //label.autoresizingMask = viewEngWord.autoresizingMask;

        [viewEngWord addSubview:label];

        label.text = @"";
        
        [arrLblSpells addObject:label];
        
        rect.origin.y = fWid;
        rect.origin.x += fWid*0.1f;
        rect.size.width = fWid;
        rect.size.height = fWid*0.1f;

        UIView  *viewUnderline = [[UIView alloc] initWithFrame:rect];
        viewUnderline.layer.cornerRadius = rect.size.height/2;
        viewUnderline.clipsToBounds = YES;
        viewUnderline.backgroundColor = UIRGBColor(0, 138, 255, 255);
        [viewEngWord addSubview:viewUnderline];
        
        //viewEngWord.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        //viewUnderline.autoresizingMask = viewEngWord.autoresizingMask;
    }
    
    float   fTotalWid = fWid*1.2f*nCount;
    CGRect  rect = viewEngWord.frame;

    rect.size.width = fTotalWid;
    rect.origin.x = (viewQuestion.bounds.size.width - rect.size.width)/2;
    viewEngWord.frame = rect;
    
    imgViewFALSE.hidden = YES;
    imgViewOK.hidden = YES;
    viewCorrectAnswer.hidden = YES;
}

- (void)prepareForAnswer
{
    int             nWordIndex = [[arrStepWords objectAtIndex:nTestStepWords] intValue];
    NSDictionary    *dicWord = [arrDicWords objectAtIndex:nWordIndex];
    NSString        *strWord = [dicWord objectForKey:@"mean_en"];
    
    lblQuestion.text = [dicWord objectForKey:@"mean_kr"];

    [self prepareControlsForNewQuestion:(int)[strWord length]];

    [self startTimeCounter];
}

- (void)startTimeCounter
{
    bCanAnswer = YES;
    strTypeAnswer = @"";
    fTimePass = 0;
    
    nCurrentTimeStatus = TIME_STATUS_TESTING;

    timeCounter = [NSTimer scheduledTimerWithTimeInterval:TIME_COUNTER_STEP target:self selector:@selector(onTimeCount) userInfo:nil repeats:YES];
}

- (void)onTimeCount
{
    if( bStop == YES )
    {
        [timeCounter invalidate];
        return;
    }

    fTimePass += TIME_COUNTER_STEP;

    if( nCurrentTimeStatus == TIME_STATUS_TESTING )
    {
        CGRect rect = viewProgValue.frame;
        rect.size.width = viewProgBar.bounds.size.width*fTimePass/fTimeLimit;
        viewProgValue.frame = rect;
        
        if( fTimePass >= fTimeLimit )
        {
            bCanAnswer = NO;
            [self onTimeElpased];
        }
    }
    else
    {
        if( fTimePass >= 1.0f )
        {
            [timeCounter invalidate];
            [self moveToNextWordTest];
        }
    }
}

- (void)onTimeElpased
{
    bCanAnswer = NO;
    
    if( [self checkCorrectnessOfTypeWord] == YES )
    {
        nCorrectWords++;
        imgViewOK.hidden = NO;
        [SoundManager playSuccessSound];
    }
    else
    {
        imgViewFALSE.hidden = NO;
        [self showCorrectAnswer];
        [SoundManager playErrorSound];
    }

    fTimePass = 0;
    nCurrentTimeStatus = TIME_STATUS_SHOW_CORRECT;
}

- (void)refreshWordCounts
{
    lblCountTotal.text = [NSString stringWithFormat:@"%d/%d", nTestWords, nTotalWords];
    lblCountFalse.text = [NSString stringWithFormat:@"%d", nTestWords-nCorrectWords];
    lblCountOK.text = [NSString stringWithFormat:@"%d", nCorrectWords];
}

- (void)moveToTestResultView
{
    [[TestStepViewController shareViewController] showTestResult:nTestWords correctWords:nCorrectWords];
}

- (void)moveToNextWordTest
{
    if( bStop == YES )
        return;

    nTestStepWords++;
    nTestWords++;

    [self refreshWordCounts];

    // step finished
    if( nTestStepWords >= nTotalStepWords )
    {
        [self moveToTestResultView];
        return;
    }

    [self prepareForAnswer];
}

- (BOOL)checkCorrectnessOfTypeWord
{
    int             nWordIndex = [[arrStepWords objectAtIndex:nTestStepWords] intValue];
    NSDictionary    *dicWord = [arrDicWords objectAtIndex:nWordIndex];
    NSString        *strWord = [dicWord objectForKey:@"mean_en"];
    
    if( [strTypeAnswer isEqualToString:strWord] )
        return YES;
    else
        return NO;
}

- (void)showCorrectAnswer
{
    int             nWordIndex = [[arrStepWords objectAtIndex:nTestStepWords] intValue];
    NSDictionary    *dicWord = [arrDicWords objectAtIndex:nWordIndex];
    NSString        *strWord = [dicWord objectForKey:@"mean_en"];
    
    lblCorrectAnswer.text = strWord;
    viewCorrectAnswer.hidden = NO;
}

- (IBAction)onClickEnglishButton:(id)sender
{
    if( bCanAnswer == NO )
        return;
    
    UIButton    *button = sender;
    NSString    *strTypeChar = button.titleLabel.text;
    int         nIndex = (int)[strTypeAnswer length];
    int         nCount = (int)[arrLblSpells count];
    
    if( nIndex >= nCount )
        return;
    
    strTypeAnswer = [strTypeAnswer stringByAppendingString:strTypeChar];
    
    UILabel     *label = [arrLblSpells objectAtIndex:nIndex];
    label.text = strTypeChar;

    if( btnShift.highlighted == YES )
    {
        btnShift.highlighted = NO;
        [self toLowerCaseButtonLabels];
    }
}


- (void)toLowerCaseButtonLabels
{
    for( UIView *subview in viewAnswer.subviews )
    {
        if( ![subview isKindOfClass:[UIButton class]] || subview.tag != 101 )
            continue;
        
        UIButton    *button = (UIButton *)subview;
        
        NSString *strLabel = [button.titleLabel.text lowercaseString];

        [button setTitle:strLabel forState:UIControlStateNormal];
    }
}

- (void)toUpperCaseButtonLabels
{
    for( UIView *subview in viewAnswer.subviews )
    {
        if( ![subview isKindOfClass:[UIButton class]] || subview.tag != 101 )
            continue;
        
        UIButton    *button = (UIButton *)subview;
        
        NSString *strLabel = [button.titleLabel.text uppercaseString];
        
        [button setTitle:strLabel forState:UIControlStateNormal];
    }
}

- (IBAction)onClickShift:(id)sender
{
    if( btnShift.isHighlighted == YES )
    {
        btnShift.highlighted = NO;
        [self toLowerCaseButtonLabels];
    }
    else
    {
        btnShift.highlighted = YES;
        [self toUpperCaseButtonLabels];
    }
}

- (IBAction)onClickDelete:(id)sender
{
    if( bCanAnswer == NO )
        return;
    
    int         nIndex = (int)[strTypeAnswer length];

    if( nIndex <= 0 )
        return;
    
    strTypeAnswer = [strTypeAnswer substringToIndex:nIndex-1];

    UILabel     *label = [arrLblSpells objectAtIndex:nIndex-1];
    label.text = @"";
}

- (IBAction)onClickBtnCheck:(id)sender
{
    if( bCanAnswer == NO )
        return;
    
    [self onTimeElpased];
}

- (void)stopTest
{
    bStop = YES;
    [timeCounter invalidate];
}

- (void)pause
{
    [timeCounter invalidate];
}

- (void)resume
{
    timeCounter = [NSTimer scheduledTimerWithTimeInterval:TIME_COUNTER_STEP target:self selector:@selector(onTimeCount) userInfo:nil repeats:YES];
}

@end