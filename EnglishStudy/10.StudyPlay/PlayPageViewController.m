//
//  PlayPageViewController.m
//  EnglishStudy
//
//  Created by admin on 1/16/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "PlayPageViewController.h"
#import "PlayViewController.h"
#import "Global.h"
#import "SoundManager.h"

#define SHOW_STEP_FIRST_WORD        0
#define SHOW_STEP_WORD_PICTURE      1
#define SHOW_STEP_SECOND_WORD       2

#define SHOW_TIMER_INTERVAL         0.02f

@interface PlayPageViewController ()
{
    NSTimer             *timeCounter;
    NSTimeInterval      fTimeElapsed;
    
    NSTimeInterval      fShowingTime;
    NSTimeInterval      fShowingTimeGap;

    int                 nShowingStep;
    BOOL                bPlaySound;
}

@end

@implementation PlayPageViewController

+ (PlayPageViewController *)playPageWithWordIndex:(int)nIndex
{
    PlayPageViewController *viewController = [[PlayPageViewController alloc] initWithNibName:@"PlayPageViewController" bundle:nil];
    
    viewController.nWordIndex = nIndex;

    return viewController;
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
    
    Global  *global = [Global sharedGlobal];
    int     nCurStep = [PlayViewController sharedViewController].nCurStep;

    lblLevel.text = [NSString stringWithFormat:@"%d급", global.nLevel];
    lblTotalCount.text = [NSString stringWithFormat:@"%d", global.nDayWords];
    lblPageStatus.text = [NSString stringWithFormat:@"%d단계 : %d/%d", nCurStep, self.nWordIndex+1, global.nDayWords];
    
    viewLeftFrame.backgroundColor = [UIColor clearColor];
    viewLeftFrame.clipsToBounds = YES;
    
    viewRightFrame.backgroundColor = [UIColor clearColor];
    viewRightFrame.clipsToBounds = YES;
    
    self.bPlay = FALSE;
    
    bPlaySound = NO;

    [self initTimeVariable];
    [self prepareWord];
}

- (void)initTimeVariable
{
    // according to setting
    switch ( [Global sharedGlobal].setting.nStudySpeedMode )
    {
        case 0:// very slow
            fShowingTime = 5.0f;
            break;
        case 1:
            fShowingTime = 4.0f;
            break;
        case 2:
            fShowingTime = 3.0f;
            break;
        case 3:
            fShowingTime = 2.0f;
            break;
        case 4:
            fShowingTime = 1.0f;
            break;
        default:
            break;
    }
    fShowingTimeGap = 0.2f;
}

- (void)prepareWord
{
    NSArray         *arrDicWords = [PlayViewController sharedViewController].arrDicWords;
    NSDictionary    *dicWord = [arrDicWords objectAtIndex:self.nWordIndex];
    int             nWordID = [[dicWord objectForKey:@"id"] intValue];
    
    lblLeftWord.text = [dicWord objectForKey:@"mean_en"];
    lblRightWord.text = [dicWord objectForKey:@"mean_kr"];

    NSString    *strPicFile = [NSString stringWithFormat:@"1-%d.png", nWordID];
    imgViewPicture.image = [UIImage imageNamed:strPicFile];
    
    [self hideAll];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [Global resetFontSizeOfAnswerLabel:lblLeftWord];
    [Global resetFontSizeOfAnswerLabel:lblRightWord];
}

- (void)hideAll
{
    viewLeftFrame.hidden = YES;
    viewRightFrame.hidden = YES;
    imgViewPicture.hidden = YES;
}

- (void)startPlay
{
    self.bPlay = TRUE;
    
    nShowingStep = SHOW_STEP_FIRST_WORD;
    fTimeElapsed = 0;

    [self performSelector:@selector(startTimeCounter) withObject:nil afterDelay:0.2f];
}

- (void)stopPlay
{
    self.bPlay = FALSE;
    
    [timeCounter invalidate];
}

- (void)pausePlay
{
    [timeCounter invalidate];
}

- (void)resumePlay
{
    [self startTimeCounter];
}

- (void)startTimeCounter
{
    timeCounter = [NSTimer scheduledTimerWithTimeInterval:SHOW_TIMER_INTERVAL target:self selector:@selector(onTimeElapsed) userInfo:nil repeats:YES];
}

- (void)expandingLeftOrRightWord:(BOOL)bLeftWord
{
    float fTimeValue = MIN( fTimeElapsed, fShowingTime );

    // first step (left->right)
    if( bLeftWord )
    {
        viewLeftFrame.hidden = NO;
        
        CGRect  rect = viewLeftFrame.bounds;
        rect.size.width = fTimeValue*rect.size.width/fShowingTime;
        viewLeftProgress.frame = rect;
    }
    else
    {
        viewRightFrame.hidden = NO;
        
        CGRect  rect = viewRightFrame.bounds;
        rect.size.width = fTimeValue*rect.size.width/fShowingTime;
        viewRightProgress.frame = rect;
    }
}

- (void)playWordSound
{
    if( bPlaySound == YES )
        return;
    
    bPlaySound = YES;
    NSArray         *arrDicWords = [PlayViewController sharedViewController].arrDicWords;
    NSDictionary    *dicWord = [arrDicWords objectAtIndex:self.nWordIndex];
    int             nWordID = [[dicWord objectForKey:@"id"] intValue];

    NSString    *strSoundFile = [NSString stringWithFormat:@"1-%d", nWordID];
    
    [SoundManager playSoundMP3File:strSoundFile];
}

- (void)onTimeElapsed
{
    if( self.bPlay == NO )
    {
        [timeCounter invalidate];
        return;
    }

    fTimeElapsed += SHOW_TIMER_INTERVAL;

    if( nShowingStep == SHOW_STEP_FIRST_WORD )
    {
        if( [PlayViewController sharedViewController].nCurStep == 1 && fTimeElapsed > 0.2f )
            [self playWordSound];
        
        // first step (left->right)
        if( [PlayViewController sharedViewController].nCurStep == 1 )
            [self expandingLeftOrRightWord:YES];
        else
            [self expandingLeftOrRightWord:NO];

        if( fTimeElapsed >= fShowingTime+fShowingTimeGap )
        {
            fTimeElapsed = 0;
            nShowingStep = SHOW_STEP_WORD_PICTURE;
        }
    }
    else if( nShowingStep == SHOW_STEP_WORD_PICTURE )
    {
        imgViewPicture.hidden = NO;
        
        if( fTimeElapsed >= fShowingTime/2 )//+fShowingTimeGap )
        {
            fTimeElapsed = 0;
            nShowingStep = SHOW_STEP_SECOND_WORD;
        }
    }
    else if( nShowingStep == SHOW_STEP_SECOND_WORD )
    {
        if( [PlayViewController sharedViewController].nCurStep == 2 && fTimeElapsed > 0.2f )
            [self playWordSound];

        // second step (right->left)
        if( [PlayViewController sharedViewController].nCurStep == 2 )
            [self expandingLeftOrRightWord:YES];
        else
            [self expandingLeftOrRightWord:NO];
        
        if( fTimeElapsed >= fShowingTime+fShowingTimeGap )
        {
            fTimeElapsed = 0;
            [timeCounter invalidate];
            
            [self playNextWord];
        }
    }
}

- (void)playNextWord
{
    if( self.bPlay == FALSE )
        return;

    [[PlayViewController sharedViewController] playNextPage:self];
}

@end
