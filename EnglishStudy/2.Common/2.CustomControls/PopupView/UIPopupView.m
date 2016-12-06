
#import "UIPopupView.h"

@implementation UIPopupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _contentView = nil;
        
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5f];
        [self createContentView];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnTableView:)];
        tapRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer:tapRecognizer];
    }

    return self;
}

- (void)createContentView
{
    
}

- (void)popupToParent:(UIView*)parentView
{
    [parentView addSubview:self];
    
    if( _contentView == nil )
        return;
    
    _contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
    _contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.05, 1.05);
    [UIView commitAnimations];
}

- (void)bounce1AnimationStopped
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    _contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.95, 0.95);
    [UIView commitAnimations];
}

- (void)bounce2AnimationStopped
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    _contentView.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}

- (void)dismissPopupView
{
    _contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.15];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(dismissAnimationStopped)];
    _contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.01f, 0.01f);
    [UIView commitAnimations];
}

- (void)dismissAnimationStopped
{
    [self removeFromSuperview];
}

- (void)tapOnTableView:(UITapGestureRecognizer *)gesture
{
    //[self dismissPopupView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch*    touch = [touches anyObject];
    CGPoint     point = [touch locationInView:self];
    
    if( !CGRectContainsPoint(_contentView.frame, point) )
        [self dismissPopupView];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}

@end
