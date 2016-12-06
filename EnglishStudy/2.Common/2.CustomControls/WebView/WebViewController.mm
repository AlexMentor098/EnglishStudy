
#import "WebViewController.h"
#import "AppDelegate.h"

@implementation WebViewController

+ (id)webViewWithAddress:(NSString*)webAddress ofTitle:(NSString*)strTitle
{
    WebViewController* detail = [[WebViewController alloc] initWithWebAddress:webAddress ofTitle:strTitle];
    
    return detail;
}

-(id)initWithWebAddress:(NSString*)webAddress ofTitle:(NSString*)strTitle
{
    self = [self initWithNibName:@"WebViewController" bundle:nil];
    
    _webAddress = [[NSString alloc] initWithString:webAddress];
    _Title = [[NSString alloc] initWithString:strTitle];

    return self;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webAddress]]];

    self.title = _Title;

    lblTitle.text = _Title;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (IBAction)onClickBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

// New Autorotation support.
- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end