//
//  QuestionView.h
//  PhoneBook
//
//  Created by admin on 6/10/15.
//
//

#import <UIKit/UIKit.h>

@class QuestionView;

@protocol QuestionViewDelegate <NSObject>

- (void)QuestionViewYesBtnClicked:(QuestionView*)view;
- (void)QuestionViewAudioBtnClicked:(QuestionView*)view;
- (void)QuestionViewVideoBtnClicked:(QuestionView*)view;

@end

@interface QuestionView : UIAlertView<UIAlertViewDelegate>

@property(nonatomic, retain) id<QuestionViewDelegate> delegator;
@property(nonatomic, readwrite) int nType;

+ (void)showWithParent:(UIView*)parent
                  quiz:(NSString*)strQuiz
                  cont:(NSString*)strCont
                   tag:(int)nTag
             delegator:(id<QuestionViewDelegate>)delegat;

+ (void)show3SelectionViewWithParent:(UIView*)parent
                  quiz:(NSString*)strQuiz
                  cont:(NSString*)strCont
                   tag:(int)nTag
             delegator:(id<QuestionViewDelegate>)delegat;

@end