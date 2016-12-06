
#import "ScheduleItemView.h"
#import "ScheduleViewController.h"
#import "Global.h"
#import "UserManager.h"

@implementation ScheduleItemView

+ (ScheduleItemView *)scheduleItemViewWithDayIndex:(int)nDayIdx
{
    NSArray             *nibs = [[NSBundle mainBundle] loadNibNamed:@"ScheduleItemView" owner:self options:nil];
    ScheduleItemView    *view = (ScheduleItemView *)nibs[0];

    [view initWithDayIndex:nDayIdx];

    return view;
}

- (void)initWithDayIndex:(int)nDayIdx
{
    btnStart.hidden = NO;

    [self initStarViews];

    NSArray     *arrScheduleInfo = [ScheduleViewController sharedViewController].arrScheduleDays;
    int         nLeftDays = [ScheduleViewController sharedViewController].nLeftDays;
    
    self.nDayIndex = nDayIdx;
    
    if( nDayIdx < [arrScheduleInfo count] )
    {
        NSDictionary    *dicDayInfo = [arrScheduleInfo objectAtIndex:nDayIdx];
        
        int nScore = [[dicDayInfo objectForKey:@"score"] intValue];
        int nDate = [[dicDayInfo objectForKey:@"date"] intValue];
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:nDate];
        
        lblDay.text = [Global getStringOfDate:date ofFormat:@"dd"];
        
        [self refreshSubItemsByScore:nScore];
    }
    else if( nDayIdx == [arrScheduleInfo count] )
    {
        lblDay.text = [Global getStringOfDate:[NSDate date] ofFormat:@"dd"];
        
        [self refreshSubItemsByScore:-1];
    }
    else if( nDayIdx < [arrScheduleInfo count]+nLeftDays )
    {
        NSDateComponents *c = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];

        c.day += nDayIdx - [arrScheduleInfo count];

        NSDate  *date = [[NSCalendar currentCalendar] dateFromComponents:c];

        lblDay.text = [Global getStringOfDate:date ofFormat:@"dd"];
        
        [self refreshSubItemsByScore:-2];

        btnStart.hidden = YES;
    }
    else
    {
        lblDay.text = @"";

        [self refreshSubItemsByScore:-3];
        
        btnStart.hidden = YES;
    }
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
        
        imgViewMedal.hidden = NO;
        imgViewLock.hidden = YES;
        imgViewPlay.hidden = YES;
    }
    else if( nScore >= 90 )
    {
        [self refreshStarCount:4];
        
        imgViewMedal.image = [UIImage imageNamed:@"medal2.png"];
        imgViewMedal.hidden = NO;
        imgViewLock.hidden = YES;
        imgViewPlay.hidden = YES;
    }
    else if( nScore >= 80  )
    {
        [self refreshStarCount:3];
        
        imgViewMedal.image = [UIImage imageNamed:@"medal3.png"];
        imgViewMedal.hidden = NO;
        imgViewLock.hidden = YES;
        imgViewPlay.hidden = YES;
    }
    else if( nScore >= 0  )
    {
        if( nScore >= 70 )
            [self refreshStarCount:2];
        else if( nScore >= 50 )
            [self refreshStarCount:1];
        else
            [self refreshStarCount:0];
        
        imgViewMedal.image = [UIImage imageNamed:@"medal4.png"];
        imgViewMedal.hidden = NO;
        imgViewLock.hidden = YES;
        imgViewPlay.hidden = YES;
    }
    else if( nScore == -1 )
    {
        [self refreshStarCount:0];
        imgViewMedal.hidden = YES;
        imgViewLock.hidden = YES;
        imgViewPlay.hidden = NO;
    }
    else
    {
        [self refreshStarCount:0];
        imgViewMedal.hidden = YES;
        imgViewLock.hidden = NO;
        imgViewPlay.hidden = YES;
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

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self addObserver:self forKeyPath:@"frame" options:0 context:nil];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"frame"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if( object == self && [keyPath isEqualToString:@"frame"] )
    {
        [self resizeSubViews];
    }
}

- (void)resizeSubViews
{
    [Global resizeView:imgViewLock withRatioWidth:68 andHeight:94];
    [Global resizeView:imgViewMedal withRatioWidth:185 andHeight:174];
    [Global resizeView:imgViewPlay withRatioWidth:128 andHeight:128];
    
    [Global resizeView:viewDayFrame withRatioWidth:100 andHeight:100];

    viewDayFrame.layer.cornerRadius = viewDayFrame.bounds.size.width/2;
    viewDayFrame.clipsToBounds = YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }

    return self;
}

- (IBAction)onClickPlay:(id)sender
{
    [self.delegate playButtonPressedOnScheduleItemView:self];
}

- (IBAction)onClickEdit:(id)sender
{
    
}

- (IBAction)onClickDelete:(id)sender
{
    
}

@end
