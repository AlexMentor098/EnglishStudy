//
//  UIMyInputView.m
//  PhoneBook
//
//  Created by admin on 7/9/15.
//
//

#import "UIMyInputView.h"
#import "ToastView.h"

@implementation UIMyInputView
{
    UILabel* lb;
    UITextField* txtFldInput;
    UIButton* btnAdd;
    UIButton* btnCancel;
}

+ (void)popupToParent:(UIView*)parent
             delegate:(id<UIInputViewDelegate>)delegate
                frame:(CGRect)frame
             anchorPt:(CGPoint)anchorPoint
             showType:(int)nShowType
{
    UIMyInputView* inputView = [[UIMyInputView alloc] initWithFrame:frame];
    
    inputView.layer.anchorPoint = anchorPoint;
    inputView.frame = frame;
    inputView.inputViewDelegate = delegate;
    
    UIMaskView *viewMask = [[UIMaskView alloc] initWithFrame:parent.bounds];
    viewMask.delegate = inputView;
    [parent addSubview:viewMask];
    [parent addSubview:inputView];
    
    inputView.viewMask = viewMask;
    
    //[simpleSelectionList deselectAll];
    
    if( nShowType == SHOW_TYPE_POPUP )
    {
        inputView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
        
        [UIView animateWithDuration:0.2f animations:^(void){
            inputView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.05, 1.05);
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.1f animations:^(void){
                inputView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
            }];
        }];
    }
    else
    {
        inputView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 0.001);
        
        [UIView animateWithDuration:0.2f animations:^(void){
            inputView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
        } completion:^(BOOL finished){
        }];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self)
    {
        // Initialization code
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.cornerRadius = 5;
        self.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:245.0f/255.0f alpha:1.0f];

        UIFont* font = [UIFont fontWithName:@"Helvetica" size:11.0f];
        CGRect rect = CGRectMake(10, 20, 70, 30);
        lb = [[UILabel alloc]initWithFrame:rect];
        lb.text = @"GroupName:";
        lb.font = font;
//        [lb setHidden:NO];
        
        rect = CGRectMake(85, 23, 200, 26);
        txtFldInput  = [[UITextField alloc] initWithFrame:rect];
        [txtFldInput setReturnKeyType:UIReturnKeyDone];
        [txtFldInput setBorderStyle:UITextBorderStyleRoundedRect];
        [txtFldInput setPlaceholder:@"GroupText"];
        txtFldInput.font = font;
        txtFldInput.delegate = self;
//        [inputV setHidden:NO];
        
        rect = CGRectMake(40, 60, 100, 30);
        btnAdd  = [[UIButton alloc] initWithFrame:rect];
        [btnAdd setTitle:@"Add" forState:UIControlStateNormal];
        [btnAdd setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btnAdd.autoresizesSubviews = NO;
		btnAdd.autoresizingMask = UIViewAutoresizingNone;
		btnAdd.backgroundColor = [UIColor lightGrayColor];
        btnAdd.layer.cornerRadius = 3.0f;
		btnAdd.titleLabel.font = font;
        btnAdd.tag = 1;

        [btnAdd addTarget:self action:@selector(onClickAddGroup:) forControlEvents:UIControlEventTouchUpInside];

//        [btnAdd setHidden:NO];

        rect = CGRectMake(160, 60, 100, 30);
        btnCancel  = [[UIButton alloc] initWithFrame:rect];
        [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
        [btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btnCancel.autoresizesSubviews = NO;
		btnCancel.autoresizingMask = UIViewAutoresizingNone;
		btnCancel.backgroundColor = [UIColor lightGrayColor];
        btnCancel.layer.cornerRadius = 3.0f;
		btnCancel.titleLabel.font = font;
        btnCancel.tag = 2;
        [btnCancel addTarget:self action:@selector(onClickCancel:) forControlEvents:UIControlEventTouchUpInside];
//        [btnCancel setHidden:NO];
        
        [self addSubview:lb];
        [self addSubview:txtFldInput];
        [self addSubview:btnAdd];
        [self addSubview:btnCancel];
    }
    
    return self;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(IBAction)onClickAddGroup:(id)sender
{
    NSString* strContent = txtFldInput.text;
    
    if((strContent == nil) || ( [strContent isEqualToString:@""] == YES))
    {
        [ToastView showWithParent:self text:@"Please input correct group name."];
        return;
    }

    [self.inputViewDelegate UIInputViewOkBtnClicked:strContent];
    [self touchBeganOnMaskView:self.viewMask];
}

-(IBAction)onClickCancel:(id)sender
{
    [self touchBeganOnMaskView:self.viewMask];
}

- (void)touchBeganOnMaskView:(UIMaskView *)viewMask
{
    //[viewMask removeFromSuperview];
    
    [UIView animateWithDuration:0.1f animations:^(void){
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    } completion:^(BOOL finished){
        [self removeFromSuperview];
        [viewMask removeFromSuperview];
    }];
}


@end
