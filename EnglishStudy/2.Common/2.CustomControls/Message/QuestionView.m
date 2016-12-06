//
//  QuestionView.m
//  PhoneBook
//
//  Created by admin on 6/10/15.
//
//

#import "QuestionView.h"

@implementation QuestionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (void)showWithParent:(UIView*)parent
                  quiz:(NSString*)strQuiz
                  cont:(NSString*)strCont
                   tag:(int)nTag
             delegator:(id<QuestionViewDelegate>)delegat;
{
    //[ToastView showWithParent:parent text:text afterDelay:0.0f];

    QuestionView *alert = [[QuestionView alloc] init];
    alert.tag = nTag;
    alert.nType = 0; // normal question
    
    [alert showWithParent:parent quiz:strQuiz cont:strCont delegate:delegat];
    
    [alert show];
}

+ (void)show3SelectionViewWithParent:(UIView*)parent
                  quiz:(NSString*)strQuiz
                  cont:(NSString*)strCont
                   tag:(int)nTag
             delegator:(id<QuestionViewDelegate>)delegat
{
    QuestionView *alert = [[QuestionView alloc] init];
    alert.tag = nTag;
    alert.nType = 1; // 3 question
    
    [alert show3SelectionViewWithParent:parent quiz:strQuiz cont:strCont delegate:delegat];
    
    [alert show];
}

- (void)show3SelectionViewWithParent:(UIView*)parent quiz:(NSString*)strQuiz cont:(NSString*)strCont delegate:(id<QuestionViewDelegate>)delegat
{
    self.delegator = delegat;
    
    [super initWithTitle:strQuiz
                 message:strCont
                delegate:self
       cancelButtonTitle:@"AudioCall"
       otherButtonTitles:@"VideoCall", @"Cancel", nil];
}

- (void)showWithParent:(UIView*)parent quiz:(NSString*)strQuiz cont:(NSString*)strCont delegate:(id<QuestionViewDelegate>)delegat
{
    self.delegator = delegat;
    
    [super  initWithTitle:strCont
                  message:strQuiz
                 delegate:self
        cancelButtonTitle:@"YES"
        otherButtonTitles:@"NO"
                        ,nil];    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(self.nType == 0) // normal selection
    {
        if(buttonIndex == 0)
            [self.delegator QuestionViewYesBtnClicked:self];
    }
    else if(self.nType == 1 )// three selection
    {
        if(buttonIndex == 0)
            [self.delegator QuestionViewAudioBtnClicked:self];
        
        if(buttonIndex == 1)
            [self.delegator QuestionViewVideoBtnClicked:self];
    }
}

@end
