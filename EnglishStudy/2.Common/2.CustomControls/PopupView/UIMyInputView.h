//
//  UIMyInputView.h
//  PhoneBook
//
//  Created by admin on 7/9/15.
//
//

#import <Foundation/Foundation.h>
#import "UIPopupView.h"
#import "UIMaskView.h"

#define SHOW_TYPE_POPUP      1

@protocol UIInputViewDelegate <NSObject>

- (void)UIInputViewOkBtnClicked:(NSString*)strContent;

@end

@interface UIMyInputView : UIView<UITextFieldDelegate, UIMaskViewDelegate>

@property (nonatomic, assign) id<UIInputViewDelegate> inputViewDelegate;
@property (nonatomic, assign) UIMaskView*   viewMask;

+ (void)popupToParent:(UIView*)parent
             delegate:(id<UIInputViewDelegate>)delegate
                frame:(CGRect)frame
             anchorPt:(CGPoint)anchorPoint
             showType:(int)nShowType;
@end