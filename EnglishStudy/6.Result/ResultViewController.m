
#import "ResultViewController.h"
#import "Global.h"

@interface ResultViewController ()

@end

@implementation ResultViewController

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

    nSelTab = 0;
    viewTabContent.backgroundColor = [UIColor clearColor];

    [self initTabButtons];
    [self initTabContents];
    [self refreshTabContents];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [Global resizeViewToLeft:viewTabBar withRatioWidth:449 andHeight:35];
    
    [self refreshButtonStatus];
}

- (void)initTabButtons
{
    arrTabButtons = [NSArray arrayWithObjects:btnTab1, btnTab2, btnTab3, btnTab4, nil];
    arrTabLabels = [NSArray arrayWithObjects:lblTab1, lblTab2, lblTab3, lblTab4, nil];
    
    for( int i = 0; i < 4; i++ )
    {
        UIButton *button  = [arrTabButtons objectAtIndex:i];
        button.tag = i;
        
        CGRect rect = button.frame;
        button.layer.anchorPoint = CGPointMake(0.5, 1.0f);
        button.frame = rect;
    }
}

- (void)initTabContents
{
    tabViewCtrl1 = [[StudyTimeViewController alloc] initWithNibName:@"StudyTimeViewController" bundle:nil];
    [self addChildViewController:tabViewCtrl1];
    
    tabViewCtrl2 = [[StudyWordViewController alloc] initWithNibName:@"StudyWordViewController" bundle:nil];
    [self addChildViewController:tabViewCtrl2];
    
    tabViewCtrl3 = [[TestResultViewController alloc] initWithNibName:@"TestResultViewController" bundle:nil];
    [self addChildViewController:tabViewCtrl2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)refreshButtonStatus
{
    for( int i = 0; i < 4; i++ )
    {
        UIButton    *button  = [arrTabButtons objectAtIndex:i];
        UILabel     *label = [arrTabLabels objectAtIndex:i];
        CGRect      rect = label.frame;
        
        if( i == nSelTab )
        {
            button.layer.zPosition = 5;
            button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.05f, 1.2f);
            button.userInteractionEnabled = NO;
            button.selected = YES;
            
            label.textColor = UIRGBColor(255, 255, 255, 255);
            rect.origin.y = rect.size.height/3;
            label.frame = rect;
        }
        else
        {
            button.layer.zPosition = 4-i;
            //1.1, 1.25
            button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
            button.userInteractionEnabled = YES;
            button.selected = NO;
            
            label.textColor = UIRGBColor(74, 90, 1, 255);
            rect.origin.y = rect.size.height/2;
            label.frame = rect;
        }

        label.layer.zPosition = 6;
    }
}

- (void)refreshTabContents
{
    if( nSelTab == 0 )
    {
        [tabViewCtrl2.view removeFromSuperview];
        [tabViewCtrl3.view removeFromSuperview];
        
        [viewTabContent addSubview:tabViewCtrl1.view];
        tabViewCtrl1.view.frame = viewTabContent.bounds;
    }
    else if( nSelTab == 1 )
    {
        [tabViewCtrl1.view removeFromSuperview];
        [tabViewCtrl3.view removeFromSuperview];
        
        [viewTabContent addSubview:tabViewCtrl2.view];
        tabViewCtrl2.view.frame = viewTabContent.bounds;
    }
    else if( nSelTab == 2 )
    {
        [tabViewCtrl1.view removeFromSuperview];
        [tabViewCtrl2.view removeFromSuperview];
        
        [viewTabContent addSubview:tabViewCtrl3.view];
        tabViewCtrl3.view.frame = viewTabContent.bounds;
    }
}

- (IBAction)onToucnDownTabButton:(id)sender
{
    //[self refreshButtonZOrder];
    
    //UIButton *curButton = (UIButton *)sender;
    //curButton.layer.zPosition = 5;
    
    UIButton    *curButton = (UIButton *)sender;
    UILabel     *label = [arrTabLabels objectAtIndex:curButton.tag];
    label.textColor = UIRGBColor(255, 255, 255, 255);
}

- (IBAction)onToucnUpInsideTabButton:(id)sender
{
    UIButton *curButton = (UIButton *)sender;
    
    if( nSelTab == curButton.tag )
        return;
    
    if( curButton.tag == 3 )
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    nSelTab = (int)curButton.tag;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.15];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(onTabSelected)];
    [self refreshButtonStatus];
    [UIView commitAnimations];
}

- (void)onTabSelected
{
    if( nSelTab == 0 )
    {
        [self refreshTabContents];
    }
    else if( nSelTab == 1 )
    {
        [self refreshTabContents];
    }
    else if( nSelTab == 2 )
    {
        [self refreshTabContents];
    }
    else if( nSelTab == 3 )
        [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onToucnUpOutsideTabButton:(id)sender
{
    [self refreshButtonStatus];
}

@end
