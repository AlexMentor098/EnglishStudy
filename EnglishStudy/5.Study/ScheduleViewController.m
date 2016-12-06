
#import "ScheduleViewController.h"
#import "StudyViewController.h"
#import "Global.h"
#import "UserManager.h"

@interface ScheduleViewController ()
{
    int         nCurPage;
    int         nTotalPage;
    int         nTotalScheduleItem;

    int         nTotalWords;
}

@end

@implementation ScheduleViewController

ScheduleViewController *_sharedScheduleViewController = nil;

+ (ScheduleViewController *)sharedViewController
{
    return _sharedScheduleViewController;
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
    
    _sharedScheduleViewController = self;
    
    nCurPage = 0;
 
    [self initSubItemViews];
    [self refreshSchedule];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [Global resizeView:btnChange withRatioWidth:130 andHeight:38];
    [Global resizeView:btnPrev withRatioWidth:40 andHeight:40];
    [Global resizeView:btnNext withRatioWidth:40 andHeight:40];
    
    CGFloat fHeight = viewProgressBar.frame.size.height;
    viewProgressBar.layer.cornerRadius = fHeight/2;
    viewProgressBar.layer.borderColor = viewProgressBar.backgroundColor.CGColor;
    viewProgressBar.layer.borderWidth = viewProgressValue.frame.origin.x;
    viewProgressBar.clipsToBounds = YES;
}

- (void)initSubItemViews
{
    arrViewItemFrames = [NSArray arrayWithObjects:viewItem1, viewItem2, viewItem3, viewItem4, viewItem5, viewItem6, viewItem7, viewItem8, nil];
    
    arrViewItems = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)getTotalWordCountToStudy
{
    int     nLevel = [Global sharedGlobal].nLevel;

#ifndef COMPLETE_PRODUCT_PROJECT
    nLevel = 1;
#endif
    
    NSString     *strQuery = [NSString stringWithFormat:@"select count(*) from word_dic where level = %d", nLevel];
    NSDictionary *dicItem = [[Global sharedGlobal].dbManager queryOneData:strQuery];

    nTotalWords = [[dicItem objectForKey:@"count(*)"] intValue];
}

- (void)refreshScheduleLabels
{
    int nDayWords = [Global sharedGlobal].nDayWords;
    int nWordCount = nTotalWords - [Global sharedGlobal].nStudyWords;
    int nDays = (nWordCount + nDayWords-1)/nDayWords;
    
    self.nLeftDays = nDays;

    NSDate      *startDate = [NSDate dateWithTimeIntervalSince1970:[Global sharedGlobal].nScheduleStartDate];
    NSString    *strStartDate = [Global getStringOfDate:startDate ofFormat:@"yy.MM.dd"];
    
    lblStartDate.text = strStartDate;
    
    NSDateComponents *c = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:startDate];
    
    c.day += nDays-1;
    
    NSDate      *endDate = [[NSCalendar currentCalendar] dateFromComponents:c];
    NSString    *strEndDate = [Global getStringOfDate:endDate ofFormat:@"yy.MM.dd"];
    
    lblEndDate.text = strEndDate;
    
    strStartDate = [Global getStringOfDate:startDate ofFormat:@"yyyy/MM/dd"];
    strEndDate = [Global getStringOfDate:endDate ofFormat:@"yyyy/MM/dd"];
    
    lblScheduleDate.text = [NSString stringWithFormat:@"%@ - %@", strStartDate, strEndDate];
    
    lblStudyCount.text = [NSString stringWithFormat:@"%d개", [Global sharedGlobal].nStudyWords];
    
    CGRect  rect = viewProgressValue.frame;
    CGFloat fWidth = viewProgressBar.bounds.size.width - rect.origin.x*2;
    
    rect.size.width = fWidth*[Global sharedGlobal].nStudyWords/nTotalWords;
    viewProgressValue.frame = rect;
    
    int nProgValue = [Global sharedGlobal].nStudyWords*100/nTotalWords;
    lblProgressValue.text = [NSString stringWithFormat:@"%d%%", nProgValue];
}

- (void)getScheduleDaysInfo
{
    self.arrScheduleDays = [UserManager getScheduleInfo];

    nTotalScheduleItem = (int)[self.arrScheduleDays count] + 1;
    nTotalPage = (nTotalScheduleItem+7)/8;
}

- (void)refreshScheduleDayItems
{
    for( int i = 0; i < [arrViewItems count]; i++ )
    {
        UIView  *viewItem = [arrViewItems objectAtIndex:i];
        [viewItem removeFromSuperview];
    }
    [arrViewItems removeAllObjects];
    
    int     nStartIdx = 8*nCurPage;
    
    for( int i = 0; i < 8; i++ )
    {
        int     nDayIndex = nStartIdx+i;

        UIView              *viewFrame = (UIView *)[arrViewItemFrames objectAtIndex:i];
        ScheduleItemView    *viewItem = [ScheduleItemView scheduleItemViewWithDayIndex:nDayIndex];

        viewItem.delegate = self;
        viewFrame.backgroundColor = [UIColor clearColor];
        [viewFrame addSubview:viewItem];
        
        
        viewItem.frame = viewFrame.bounds;
        [arrViewItems addObject:viewItem];
    }
}

- (void)refreshSchedule
{
    NSString    *strImgName = [NSString stringWithFormat:@"num_oder%d.png", [Global sharedGlobal].nLevel];
    imgViewLevel.image = [UIImage imageNamed:strImgName];

    [self getTotalWordCountToStudy];
    [self refreshScheduleLabels];

    [self getScheduleDaysInfo];
    [self refreshScheduleDayItems];
}

- (IBAction)onClickScheduleChange:(id)sender
{
    [Global sharedGlobal].nPrepareLevel = [Global sharedGlobal].nLevel;

    [[StudyViewController sharedViewController] changeSchedule];
}

- (IBAction)onClickBtnPrev:(id)sender
{
    if( nCurPage > 0 )
    {
        nCurPage--;
        [self refreshScheduleDayItems];
    }
}

- (IBAction)onClickBtnNext:(id)sender
{
    if( nCurPage < nTotalPage-1 )
    {
        nCurPage++;
        [self refreshScheduleDayItems];
    }
}

- (void)playButtonPressedOnScheduleItemView:(ScheduleItemView *)viewScheduleItem
{
    int     nDayIdx = viewScheduleItem.nDayIndex;
    
    if( nDayIdx < [self.arrScheduleDays count] )
    {
        NSDictionary    *dicDayItem = [self.arrScheduleDays objectAtIndex:nDayIdx];
        [Global sharedGlobal].nScheduledID = [[dicDayItem objectForKey:@"id"] intValue];
    }
    else
        [Global sharedGlobal].nScheduledID = 0;

    [[StudyViewController sharedViewController] startStudy];
}

@end
