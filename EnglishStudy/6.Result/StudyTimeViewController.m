
#import "StudyTimeViewController.h"
#import "Global.h"

@interface StudyTimeViewController ()

@end

@implementation StudyTimeViewController

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
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [Global resizeView:btnLeft withRatioWidth:40 andHeight:40];
    [Global resizeView:btnRight withRatioWidth:40 andHeight:40];

    [Global resizeView:viewDesc withRatioWidth:147 andHeight:138];
    
    [self drawXYAxis];
    [self drawTimeGraph];
}

- (void)drawXYAxis
{
    CGSize  size = viewGraph.bounds.size;
    float    fTimeGap = size.height/24;
    
    for( int i = 0; i <= 24; i++ )
    {
        CGRect  rect;
        
        rect.origin.x = viewGraph.frame.origin.x - 100;
        rect.size.width = 90;
        
        rect.size.height = fTimeGap-2;
        rect.origin.y = viewGraph.frame.origin.y + (24-i)*fTimeGap - (fTimeGap-2)/2;
        
        UILabel     *label = [[UILabel alloc] initWithFrame:rect];
        
        label.text = [NSString stringWithFormat:@"%d", i];
        label.font = [UIFont systemFontOfSize:fTimeGap-2];
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
        
        [self.view addSubview:label];
    }

    int     nDays = 30;
    float   fDayGap = size.width/nDays;
    for( int i = 1; i <= nDays; i++ )
    {
        CGRect  rect;
        
        rect.origin.y = viewGraph.frame.origin.y + size.height + 5;
        rect.size.height = fTimeGap;
        rect.size.width = fDayGap;
        
        rect.origin.x = viewGraph.frame.origin.x + (i-1)*fDayGap;

        UILabel     *label = [[UILabel alloc] initWithFrame:rect];

        label.text = [NSString stringWithFormat:@"%d", i];
        label.font = [UIFont systemFontOfSize:fTimeGap-2];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
        
        [self.view addSubview:label];
    }
}

- (void)drawTimeGraph
{
    viewGraph.backgroundColor = [UIColor clearColor];
    viewGraph.layer.opacity = 1.0f;
    [Global removeAllSubviewFromView:viewGraph];
    
    CGSize  size = viewGraph.bounds.size;
    int     pTimes[24] = {135, 230, 380, 650, 1200, 90, 560, 250, 110, 460, 70, 180, 390, 560, 680, 230, 145, 470, 550, 290, 340};
    int     nTotalDays = 30;
    int     nCount = 20;
    int     nMaxMinutes = 24*60;

    for( int i = 0; i < nCount; i++ )
    {
        int     nTime = pTimes[i];
        CGRect  rect;
        
        rect.size.width = size.width/nTotalDays;
        rect.size.height = nTime*size.height/nMaxMinutes;
        rect.origin.x = size.width*i/nTotalDays;
        rect.origin.y = size.height - rect.size.height;
        
        UIImageView     *imgViewBar = [[UIImageView alloc] initWithFrame:rect];
        
        if( nTime < 120 )
            imgViewBar.image = [UIImage imageNamed:@"graph_bar1.png"];
        else if( nTime < 240 )
            imgViewBar.image = [UIImage imageNamed:@"graph_bar2.png"];
        else if( nTime < 360 )
            imgViewBar.image = [UIImage imageNamed:@"graph_bar3.png"];
        else
            imgViewBar.image = [UIImage imageNamed:@"graph_bar4.png"];

        [viewGraph addSubview:imgViewBar];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)onClickBtnPrev:(id)sender
{
    
}

- (IBAction)onClickBtnNext:(id)sender
{
    
}

@end
