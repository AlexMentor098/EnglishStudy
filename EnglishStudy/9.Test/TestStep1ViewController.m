
#import "TestStep1ViewController.h"
#import "TestStepViewController.h"
#import "StudyViewController.h"
#import "Global.h"
#import "SoundManager.h"

#define     TIME_STATUS_WAIT_FOR_TEST       0
#define     TIME_STATUS_TESTING             1
#define     TIME_STATUS_SHOW_ANSWER         2
#define     TIME_STATUS_HIDE_ANSWER         3
#define     TIME_STATUS_SHOW_ANSWER2        4
#define     TIME_STATUS_SHOW_CORRECT        5
#define     TIME_STATUS_SHOW_FAIL           6

@interface TestStep1ViewController ()
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
    
    int     nCorrectAnswerIndex;
    
    BOOL    bCanAnswer;

    NSTimer         *timeCounter;
    NSArray         *arrDicWords;
    NSMutableArray  *arrStepWords;
}

@end

#define     TIME_COUNTER_STEP       0.06f

NSString    *_arrStrCorrectNums[4] = {@"①", @"②", @"③", @"④"};

NSString    *_arrStrTestStepComment[3] = { @"1. 다음 단어의 뜻으로 알맞는것을 선택하십시오.",
    @"2. 다음 단어의 뜻으로 알맞는것을 선택하십시오.",
    @"3. 다음 발음에 알맞는 뜻을 선택하십시오." };

@implementation TestStep1ViewController

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
    
    [Global resizeView:imgViewStepMark withRatioWidth:129 andHeight:312];
    [Global resizeView:viewQuestion withRatioWidth:587 andHeight:165];
    [Global resizeView:viewAnswer withRatioWidth:645 andHeight:280];
    [Global resizeView:viewResults withRatioWidth:227 andHeight:46];

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
    
    bPause = NO;
    [self initTimeLimit];
    
    [self initControls];
    [self initPage];
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

- (void)initControls
{
    arrAnswerButton = [NSArray arrayWithObjects:btnAnswer1, btnAnswer2, btnAnswer3, btnAnswer4, nil];
    
    for( int i = 0; i < [arrAnswerButton count]; i++ )
    {
        UIButton *button = [arrAnswerButton objectAtIndex:i];
        button.tag = i+1;
    }
    
    arrAnswerLabels = [NSArray arrayWithObjects:lblAnswer1, lblAnswer2, lblAnswer3, lblAnswer4, nil];
    arrImgViewFalse = [NSArray arrayWithObjects:imgViewFalse1, imgViewFalse2, imgViewFalse3, imgViewFalse4, nil];
    arrImgViewOK = [NSArray arrayWithObjects:imgViewOK1, imgViewOK2, imgViewOK3, imgViewOK4, nil];
    arrNumberLabels = [NSArray arrayWithObjects:lblNumber1, lblNumber2, lblNumber3, lblNumber4, nil];
}

- (void)initPage
{
    [self prepareControlsForNewQuestion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)determineTotalCount
{
    nTotalWords = 0;
    
    for( int i = 0; i < 4; i++ )
    {
        if( [Global sharedGlobal].setting.nTestMethod & (1<<i) )
            nTotalWords += STEP_TEST_WORD_COUNT;
    }
}

- (void)determineNextStepFrom:(int)nStep
{
    nTestStep = nStep;
    
    for( ; nTestStep < 3; nTestStep++ )
    {
        if( [Global sharedGlobal].setting.nTestMethod & (1<<nTestStep) )
            break;
    }
}

- (void)prepareAndStartTest
{
    bStop = NO;

    [self determineTotalCount];
    [self determineNextStepFrom:0];

    nTestWords = 0;

    [self refreshWordCounts];
    [self prepareCurrentStepEnvironment];
}

- (void)prepareCurrentStepEnvironment
{
    lblQuestionMark.text = _arrStrTestStepComment[nTestStep];
    
    if( nTestStep == 0 )
        imgViewStepMark.image = [UIImage imageNamed:@"tes01_1.png"];
    else if( nTestStep == 1 )
        imgViewStepMark.image = [UIImage imageNamed:@"tes02_1.png"];
    else
    {
        imgViewStepMark.image = [UIImage imageNamed:@"tes03_1.png"];
        imgViewSound.hidden = NO;
    }
    
    [self prepareStepWords];
    [self prepareForAnswer];
}

- (BOOL)prepareNextStep
{
    nTestStep++;
    [self determineNextStepFrom:nTestStep];

    if( nTestStep >= 3 )
    {
        //test all finished
        [[TestStepViewController shareViewController] moveTo4StepWithTotalWords:nTestWords andCorrectWords:nCorrectWords];
        return NO;
    }
    
    [self prepareCurrentStepEnvironment];
    
    return YES;
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

        NSMutableArray  *arrWordPairs = [[NSMutableArray alloc] initWithCapacity:0];
        
        [arrWordPairs addObject:[NSNumber numberWithInt:nWordIndex]];

        // search incorrect word(test pairs)
        NSMutableArray  *arrPairIndex = [[NSMutableArray alloc] initWithCapacity:0];
        
        for( int k = 0; k < [arrDicWords count]; k++ )
        {
            if( k != nWordIndex )
                [arrPairIndex addObject:[NSNumber numberWithInt:k]];
        }
        
        for( int j = 0; j < 3; j++ )
        {
            nRand = rand()%[arrPairIndex count];
            
            int nPairIndex = [[arrPairIndex objectAtIndex:nRand] intValue];
            
            [arrWordPairs addObject:[NSNumber numberWithInt:nPairIndex]];
            
            // remove added pair word
            [arrPairIndex removeObjectAtIndex:nRand];
        }

        [arrStepWords addObject:arrWordPairs];
    }
}

- (void)setQuestionWordIndex:(int)nIndex
{
    NSDictionary    *dicWord = [arrDicWords objectAtIndex:nIndex];

    // korea -> english
    if( nTestStep == 0 )
    {
        lblQuestion.text = [dicWord objectForKey:@"mean_kr"];
    }
    // english -> korea
    else if( nTestStep == 1 )
    {
        lblQuestion.text = [dicWord objectForKey:@"mean_en"];
    }
    // pronounce -> korea
    else if( nTestStep == 2 )
    {
        //lblQuestion.text = [dicWord objectForKey:@"mean_en"];
        lblQuestion.text = @"";
        
        int         nWordID = [[dicWord objectForKey:@"id"] intValue];
        NSString    *strSoundFile = [NSString stringWithFormat:@"1-%d", nWordID];
        
        [SoundManager playSoundMP3File:strSoundFile];
    }
    else // typing english
    {
        lblQuestion.text = [dicWord objectForKey:@"mean_kr"];
    }
}

- (void)setAnswerWordIndex:(int)nIndex ofAnswerIndex:(int)nAnswerIndex
{
    NSDictionary    *dicWord = [arrDicWords objectAtIndex:nIndex];
    UILabel         *lblAnswer = [arrAnswerLabels objectAtIndex:nAnswerIndex];

    // korea -> english
    if( nTestStep == 0 )
    {
        lblAnswer.text = [dicWord objectForKey:@"mean_en"];
    }
    // english -> korea
    else if( nTestStep == 1 )
    {
        lblAnswer.text = [dicWord objectForKey:@"mean_kr"];
    }
    // pronounce -> korea
    else if( nTestStep == 2 )
    {
        lblAnswer.text = [dicWord objectForKey:@"mean_kr"];
    }
    else // typing english
    {
        //lblAnswer.text = [dicWord objectForKey:@"mean_en"];
    }

    [Global resetFontSizeOfAnswerLabel:lblAnswer];
}

- (void)prepareControlsForNewQuestion
{
    for( int i = 0; i < 4; i++ )
    {
        UILabel *lblNumber = [arrNumberLabels objectAtIndex:i];
        
        lblNumber.text = [NSString stringWithFormat:@"%d", i+1];
        lblNumber.textColor = UIRGBColor(110, 94, 88, 255);
        
        UIImageView *imgViewFalse = [arrImgViewFalse objectAtIndex:i];
        imgViewFalse.hidden = YES;
        
        UIImageView *imgViewOK = [arrImgViewOK objectAtIndex:i];
        imgViewOK.hidden = YES;
        
        UIButton *btnAnswer = [arrAnswerButton objectAtIndex:i];
        [btnAnswer setBackgroundImage:[UIImage imageNamed:@"btn_test_false_bg"] forState:UIControlStateNormal];
    }
    
    CGRect rect = viewProgValue.frame;
    rect.size.width = 0;
    viewProgValue.frame = rect;
}

- (void)prepareForAnswer
{
    [self prepareControlsForNewQuestion];

    NSArray *arrWordPairs = [arrStepWords objectAtIndex:nTestStepWords];

    [self setQuestionWordIndex:[[arrWordPairs objectAtIndex:0] intValue]];

    nCorrectAnswerIndex = rand()%4;

    int nWordIndex = 0;
    int nIndex = 1;
    
    for( int i = 0; i < 4; i++ )
    {
        // correct answer
        if( i == nCorrectAnswerIndex )
            nWordIndex = [[arrWordPairs objectAtIndex:0] intValue];
        else
        {
            nWordIndex = [[arrWordPairs objectAtIndex:nIndex] intValue];
            nIndex++;
        }

        [self setAnswerWordIndex:nWordIndex ofAnswerIndex:i];
    }
    
    [self startTimeCounter:TIME_STATUS_WAIT_FOR_TEST];
}

- (void)refreshWordCounts
{
    lblCountTotal.text = [NSString stringWithFormat:@"%d/%d", nTestWords, nTotalWords];
    lblCountFalse.text = [NSString stringWithFormat:@"%d", nTestWords-nCorrectWords];
    lblCountOK.text = [NSString stringWithFormat:@"%d", nCorrectWords];
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
        [self prepareNextStep];
        return;
    }

    [self prepareForAnswer];
}

- (void)setCorrectAnswer:(int)nNumber
{
    UILabel *lblNumber = [arrNumberLabels objectAtIndex:nNumber];
    lblNumber.text = _arrStrCorrectNums[nNumber];
    lblNumber.textColor = UIRGBColor(57, 200, 156, 255);
    
    UIButton *button = [arrAnswerButton objectAtIndex:nNumber];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_test_ok_bg.png"] forState:UIControlStateNormal];
    
    UIImageView *imgViewOK = [arrImgViewOK objectAtIndex:nNumber];
    imgViewOK.hidden = NO;
}

- (void)setFalseAnswer:(int)nNumber
{
    UIImageView *imgViewFalse = [arrImgViewFalse objectAtIndex:nNumber];
    imgViewFalse.hidden = NO;
}

- (void)startTimeCounter:(int)nTimeStatus
{
    [self resetTimeCounter:nTimeStatus];

    timeCounter = [NSTimer scheduledTimerWithTimeInterval:TIME_COUNTER_STEP target:self selector:@selector(onTimeCount) userInfo:nil repeats:YES];
}

- (void)resetTimeCounter:(int)nTimeStatus
{
    nCurrentTimeStatus = nTimeStatus;
    if( nCurrentTimeStatus == TIME_STATUS_TESTING )
        bCanAnswer = YES;
    else
        bCanAnswer = NO;

    fTimePass = 0;
}

- (void)onTimeCount
{
    fTimePass += TIME_COUNTER_STEP;
    
    if( bStop == YES || bPause == YES )
    {
        [timeCounter invalidate];
        return;
    }

    if( nCurrentTimeStatus == TIME_STATUS_WAIT_FOR_TEST )
    {
        if( fTimePass >= 0.5f )
            [self resetTimeCounter:TIME_STATUS_TESTING];
    }
    else if( nCurrentTimeStatus == TIME_STATUS_TESTING )
    {
        CGRect rect = viewProgValue.frame;
        rect.size.width = viewProgBar.bounds.size.width*fTimePass/fTimeLimit;
        viewProgValue.frame = rect;
        
        if( fTimePass >= fTimeLimit )
        {
            [SoundManager playErrorSound];
            [self setCorrectAnswer:nCorrectAnswerIndex];
            
            [self resetTimeCounter:TIME_STATUS_SHOW_ANSWER];
        }
    }
    else if( nCurrentTimeStatus == TIME_STATUS_SHOW_ANSWER )
    {
        if( fTimePass >= 0.5f )
        {
            UIImageView *imgViewOK = [arrImgViewOK objectAtIndex:nCorrectAnswerIndex];
            imgViewOK.hidden = YES;

            [self resetTimeCounter:TIME_STATUS_HIDE_ANSWER];
        }
    }
    else if( nCurrentTimeStatus == TIME_STATUS_HIDE_ANSWER )
    {
        if( fTimePass >= 0.2f )
        {
            UIImageView *imgViewOK = [arrImgViewOK objectAtIndex:nCorrectAnswerIndex];
            imgViewOK.hidden = NO;
            
            [self resetTimeCounter:TIME_STATUS_SHOW_ANSWER2];
        }
    }
    else if( nCurrentTimeStatus == TIME_STATUS_SHOW_ANSWER2 )
    {
        if( fTimePass >= 1.0f )
        {
            [timeCounter invalidate];
            [self moveToNextWordTest];
        }
    }
    else if( nCurrentTimeStatus == TIME_STATUS_SHOW_CORRECT )
    {
        if( fTimePass >= 0.5f )
        {
            [timeCounter invalidate];
            [self moveToNextWordTest];
        }
    }
    else if( nCurrentTimeStatus == TIME_STATUS_SHOW_FAIL )
    {
        if( fTimePass >= 1.5f )
        {
            [timeCounter invalidate];
            [self moveToNextWordTest];
        }
    }
}

- (IBAction)onClickBtnAnswer:(id)sender
{
    if( bCanAnswer == NO )
        return;

    UIButton    *button = sender;
    int         nAnswerIndex = (int)button.tag - 1;
    
    if( nAnswerIndex == nCorrectAnswerIndex )
    {
        [SoundManager playSuccessSound];
        [self setCorrectAnswer:nCorrectAnswerIndex];
        nCorrectWords++;
        
        [self resetTimeCounter:TIME_STATUS_SHOW_CORRECT];
    }
    else
    {
        [SoundManager playErrorSound];
        [self setCorrectAnswer:nCorrectAnswerIndex];
        [self setFalseAnswer:nAnswerIndex];
        
        [self resetTimeCounter:TIME_STATUS_SHOW_FAIL];
    }
}

- (void)stopTest
{
    bStop = YES;
    [timeCounter invalidate];
}

- (void)pause
{
    bPause = YES;
    [timeCounter invalidate];
}

- (void)resume
{
    bPause = NO;
    timeCounter = [NSTimer scheduledTimerWithTimeInterval:TIME_COUNTER_STEP target:self selector:@selector(onTimeCount) userInfo:nil repeats:YES];
}

@end