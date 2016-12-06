//
//  ScheduleChangeViewController.m
//  EnglishStudy
//
//  Created by admin on 1/22/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "ScheduleChangeViewController.h"
#import "Global.h"
#import "NumberView.h"
#import "StudyViewController.h"
#import "ScheduleViewController.h"

@interface ScheduleChangeViewController ()
{
    int     nWordCount;
}

@end

@implementation ScheduleChangeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
    {
        NSString *strNibname = [NSString stringWithFormat:@"%@_phone", nibNameOrNil];
        self = [super initWithNibName:strNibname bundle:nibBundleOrNil];
    }
    else
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 새로운 급수를 선택하는 경우
    if( [Global sharedGlobal].nLevel != [Global sharedGlobal].nPrepareLevel )
    {
        bNewSchedule = YES;
        nWordCount = 20;
    }
    else
    {
        bNewSchedule = NO;
        nWordCount = [Global sharedGlobal].nDayWords;
        
        if( nWordCount == 0 )
            nWordCount = 20;
    }
    
    [self getTotalWordCountToStudy];
    [self refreshSchedule];
}

- (void)getTotalWordCountToStudy
{
    int     nLevel = [Global sharedGlobal].nPrepareLevel;

#ifndef COMPLETE_PRODUCT_PROJECT
    nLevel = 1;
#endif
    
    NSString     *strQuery = [NSString stringWithFormat:@"select count(*) from word_dic where level = %d", nLevel];
    NSDictionary *dicItem = [[Global sharedGlobal].dbManager queryOneData:strQuery];

    nTotalWords = [[dicItem objectForKey:@"count(*)"] intValue];

    if( bNewSchedule == NO )
        nTotalWords -= [Global sharedGlobal].nStudyWords;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self refreshWordCount];
}

- (void)refreshWordCount
{
    [Global removeAllSubviewFromView:viewWordCount];
    
    NumberView *numView = [NumberView numberViewWithInt:nWordCount frame:viewWordCount.bounds];
    [viewWordCount addSubview:numView];
    [numView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
}

- (void)refreshSchedule
{
    int nDays = (nTotalWords + nWordCount-1)/nWordCount;
    
    lblStudyDays.text = [NSString stringWithFormat:@"%d일", nDays];
    
    NSDateComponents *c = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];

    //c.year = 2015;
    //c.month = 12;
    //c.day = 21;
    //c.day += 100;
    c.day += nDays-1;

    NSDate      *date = [[NSCalendar currentCalendar] dateFromComponents:c];
    NSString    *strDate = [Global getStringOfDate:date ofFormat:@"yyyy년 MM월 dd일"];

    lblFinishDay.text = strDate;
}

- (IBAction)onClickBtnUp:(id)sender
{
    if( nWordCount < 100 )
    {
        nWordCount += 10;
        
        [self refreshWordCount];
        [self refreshSchedule];
    }
}

- (IBAction)onClickBtnDown:(id)sender
{
    if( nWordCount > 10 )
    {
        nWordCount -= 10;
        
        [self refreshWordCount];
        [self refreshSchedule];
    }
}

- (IBAction)onClickBtnOK:(id)sender
{
    [self dismissPopupView];
    
    [Global sharedGlobal].nDayWords = nWordCount;

    // 새로운 급수를 선택하는 경우
    if( bNewSchedule == YES )
    {
        [Global sharedGlobal].nStudyWords = 0;

        [[Global sharedGlobal] selectStudyLevel:[Global sharedGlobal].nPrepareLevel];

        [Global sharedGlobal].nScheduleStartDate = (int)[[NSDate date] timeIntervalSince1970];

        [[StudyViewController sharedViewController] gotoScheduleTab];
    }
    else
    {
        [[ScheduleViewController sharedViewController] refreshSchedule];
    }

    [[Global sharedGlobal] saveUserInfo];
}

- (IBAction)onClickBtnCancel:(id)sender
{
    [self dismissPopupView];
}

@end
