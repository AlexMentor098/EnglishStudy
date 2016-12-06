
#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController
{
    IBOutlet UILabel    *lblTitle;
    IBOutlet UIWebView  *webView;

    NSString    *_webAddress;
    NSString    *_Title;
}

+ (id)webViewWithAddress:(NSString *)webAddress ofTitle:(NSString*)strTitle;

- (id)initWithWebAddress:(NSString *)webAddress ofTitle:(NSString*)strTitle;

- (IBAction)onClickBack:(id)sender;

@end
