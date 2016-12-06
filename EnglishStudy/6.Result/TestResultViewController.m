
#import "TestResultViewController.h"
#import "Global.h"

@interface TestResultViewController ()

@end

@implementation TestResultViewController

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
    int     pTimes[24] = {82, 42, 38, 67, 70, 55, 52, 62, 42, 36, 78, 62, 88, 90, 82, 100, 80, 75, 52, 65};
    int     nTotalDays = 30;
    int     nCount = 20;
    int     nMaxCount = 100;
    
    CGMutablePathRef  path = CGPathCreateMutable();
    
    CGPathMoveToPoint( path, NULL, 0, size.height );
    
    CGPoint point;

    for( int i = 0; i < nCount; i++ )
    {
        int     nTime = pTimes[i];
        CGRect  rect;
        
        point.x = size.width*i/nTotalDays + size.width/nTotalDays/2;
        point.y = size.height - nTime*size.height/nMaxCount;
        
        rect.size.width = 6;
        rect.size.height = 6;
        rect.origin.x = point.x - 3;
        rect.origin.y = point.y - 3;
        
        CGPathAddLineToPoint( path, NULL, point.x, point.y );

        UIView     *viewPoint = [[UIImageView alloc] initWithFrame:rect];
        viewPoint.layer.cornerRadius = 3;
        viewPoint.clipsToBounds = YES;
        viewPoint.backgroundColor = UIRGBColor(255, 128, 0, 255);

        [viewGraph addSubview:viewPoint];
        viewPoint.layer.zPosition = 1.0f;
    }

    CGPathAddLineToPoint( path, NULL, point.x, size.height );
    
    CGPathCloseSubpath(path);
    
    CAShapeLayer *drawingShapeLayer = [CAShapeLayer layer];
    
    drawingShapeLayer.fillColor = [UIColor colorWithRed:1.0f green:0.0f blue:1.0f alpha:0.3f].CGColor;
    drawingShapeLayer.lineWidth = 1;
    drawingShapeLayer.lineCap = kCALineCapRound;
    drawingShapeLayer.lineJoin = kCALineJoinBevel;
    drawingShapeLayer.position = CGPointMake(0,0);
    
    drawingShapeLayer.strokeColor = [UIColor clearColor].CGColor;
    drawingShapeLayer.path = path;
    
    [viewGraph.layer addSublayer:drawingShapeLayer];
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
