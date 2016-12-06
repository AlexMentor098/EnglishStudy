
#import "Global.h"
#import "ProgressViewController.h"

@interface ProgressViewController ()

@end

@implementation ProgressViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshContentByLangType];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)refreshContentByLangType
{
    
}

- (void)showBusyDialogWithTitle:(NSString*)strTitle
{
    if( HUD != nil )
    {
        [self hideBusyDialog];
    }
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = strTitle;
    [self.view bringSubviewToFront:HUD];
    HUD.removeFromSuperViewOnHide = true;
    [HUD show:YES];
}

- (void)showBusyDialog
{
    [self showBusyDialogWithTitle:@"Please wait..."];
}

- (void)hideBusyDialog
{
    [HUD hide:YES];
    [HUD removeFromSuperview];
    HUD = nil;
}

@end
