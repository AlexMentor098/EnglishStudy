
#import "StudyWordViewController.h"
#import "Global.h"

@interface StudyWordViewController ()

@end

@implementation StudyWordViewController

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

    [Global resizeView:viewDesc withRatioWidth:147 andHeight:131];
    
    [self drawXYAxis];
    [self drawTimeGraph];
}

- (void)drawXYAxis
{
    CGSize  size = viewGraph.bounds.size;
    float   fTimeGap = size.height/10;
    float   fFontSize = size.height/24-2;
    
    for( int i = 0; i <= 10; i++ )
    {
        CGRect  rect;
        
        rect.origin.x = viewGraph.frame.origin.x - 100;
        rect.size.width = 90;
        
        rect.size.height = fFontSize;
        rect.origin.y = viewGraph.frame.origin.y + (10-i)*fTimeGap - fFontSize/2;
        
        UILabel     *label = [[UILabel alloc] initWithFrame:rect];
        
        label.text = [NSString stringWithFormat:@"%d", i*10];
        label.font = [UIFont systemFontOfSize:fFontSize];
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
        rect.size.height = fFontSize;
        rect.size.width = fDayGap;
        
        rect.origin.x = viewGraph.frame.origin.x + (i-1)*fDayGap;

        UILabel     *label = [[UILabel alloc] initWithFrame:rect];

        label.text = [NSString stringWithFormat:@"%d", i];
        label.font = [UIFont systemFontOfSize:fFontSize];
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
    int     pTimes[24] = {82, 12, 30, 7, 70, 55, 12, 6, 42, 36, 78, 62, 88, 90, 82, 100, 20, 30, 40, 50};
    int     nTotalDays = 30;
    int     nCount = 20;
    int     nMaxCount = 100;

    for( int i = 0; i < nCount; i++ )
    {
        int     nTime = pTimes[i];
        CGRect  rect;
        
        rect.size.width = size.width/nTotalDays;
        rect.size.height = nTime*size.height/nMaxCount;
        rect.origin.x = size.width*i/nTotalDays;
        rect.origin.y = size.height - rect.size.height;

        UIImageView     *imgViewBar = [[UIImageView alloc] initWithFrame:rect];
        
        if( nTime < 10 )
            imgViewBar.image = [UIImage imageNamed:@"graph_bar1.png"];
        else if( nTime < 20 )
            imgViewBar.image = [UIImage imageNamed:@"graph_bar2.png"];
        else if( nTime < 30 )
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
