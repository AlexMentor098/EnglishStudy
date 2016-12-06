//
//  UILabelResizable.m
//  EnglishStudy
//
//  Created by admin on 1/11/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "UISystemLabel.h"

@implementation UISystemLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self refreshFont];

    [self addObserver:self forKeyPath:@"frame" options:0 context:nil];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"frame"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{	
    if( object == self && [keyPath isEqualToString:@"frame"] )
    {
        [self refreshFont];
    }
}

- (void)refreshFont
{
    CGSize size = self.bounds.size;

    self.font = [UIFont systemFontOfSize:size.height];
}

@end
