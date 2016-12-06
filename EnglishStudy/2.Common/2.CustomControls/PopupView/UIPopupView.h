
#import <UIKit/UIKit.h>

@interface UIPopupView : UIView
{
    UIView*     _contentView;
    CGRect      _contentFrame;
}

- (void)createContentView;

- (void)popupToParent:(UIView*)parentView;

- (void)dismissPopupView;

@end
