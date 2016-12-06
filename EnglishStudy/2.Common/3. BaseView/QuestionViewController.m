
#import "QuestionViewController.h"
#import "Global.h"

@interface QuestionViewController ()

@end

@implementation QuestionViewController

+ (void)popupWithParentViewController:(UIViewController *)parentViewController msg:(NSString *)strMsg msgID:(int)nMsgID delegate:(id<QuestionViewDelegate>)delegate
{
    QuestionViewController *viewController = [[QuestionViewController alloc] initWithNibName:@"QuestionViewController" bundle:nil];
    
    viewController.delegate = delegate;
    viewController.nMsgID = nMsgID;
    viewController.strMessage = strMsg;

    if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
        [viewController popupWithParentViewController:parentViewController popupHeight:450 ofParentHeight:640];
    else
        [viewController popupWithParentViewController:parentViewController popupHeight:321 ofParentHeight:768];
}

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

    if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
    {
        CGSize  size = [UIScreen mainScreen].bounds.size;
        float   fFontSize = MIN(size.width, size.height)/20;
        lblMessage.font = [UIFont fontWithName:@"Gulim" size:fFontSize];
    }
    else
        lblMessage.font = [UIFont fontWithName:@"Gulim" size:22];
        
    lblMessage.text = self.strMessage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)onClickOK:(id)sender
{
    [self dismissPopupView];
    
    if( [self.delegate respondsToSelector:@selector(didHideQuestionView:withButton:)] )
        [self.delegate didHideQuestionView:self.nMsgID withButton:0];
}

- (IBAction)onClickCancel:(id)sender
{
    [self dismissPopupView];
    
    if( [self.delegate respondsToSelector:@selector(didHideQuestionView:withButton:)] )
        [self.delegate didHideQuestionView:self.nMsgID withButton:1];
}

@end
