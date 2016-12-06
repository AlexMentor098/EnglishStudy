//
//  UIMaskView.m
//  PropertyKing5
//
//  Created by admin on 1/27/15.
//  Copyright (c) 2015 ___exchange___. All rights reserved.
//

#import "UIMaskView.h"

@implementation UIMaskView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.2f;

        self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //UITouch*    touch = [touches anyObject];
    //CGPoint     point = [touch locationInView:self];
    
    if( [self.delegate respondsToSelector:@selector(touchBeganOnMaskView:)] )
        [self.delegate touchBeganOnMaskView:self];
}

@end
