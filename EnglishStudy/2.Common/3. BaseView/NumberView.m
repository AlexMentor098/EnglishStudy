//
//  NumberView.m
//  EnglishStudy
//
//  Created by admin on 1/15/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "NumberView.h"

@implementation NumberView

+ (NumberView *)numberViewWithInt:(int)nNumber frame:(CGRect)rect
{
    NumberView *view = [[NumberView alloc] initWithFrame:rect];
    
    view.backgroundColor = [UIColor clearColor];
    
    [view setNumber:nNumber];

    return view;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setNumber:(int)nNumber
{
    CGFloat fHeight = self.bounds.size.height;
    CGRect  rect = self.bounds;
    
    if( nNumber < 10 )
    {
        NSString *strFileName = [NSString stringWithFormat:@"num%d.png", nNumber];
        
        rect.size.width = 41*fHeight/59;
        rect.origin.x = (self.bounds.size.width - rect.size.width)/2;
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
        imgView.image = [UIImage imageNamed:strFileName];
        
        [self addSubview:imgView];
    }
    else if( nNumber < 100 )
    {
        int     num1 = (nNumber/10)%10;
        int     num2 = nNumber%10;
        
        NSString *strFileName1 = [NSString stringWithFormat:@"num%d.png", num1];
        NSString *strFileName2 = [NSString stringWithFormat:@"num%d.png", num2];
        
        rect.size.width = 41*fHeight/59;
        rect.origin.x = (self.bounds.size.width - rect.size.width*2)/2;
        
        UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:rect];
        imgView1.image = [UIImage imageNamed:strFileName1];
        [self addSubview:imgView1];
        
        rect.origin.x += rect.size.width;
        UIImageView *imgView2 = [[UIImageView alloc] initWithFrame:rect];
        imgView2.image = [UIImage imageNamed:strFileName2];
        [self addSubview:imgView2];
    }
    else
    {
        int     num1 = (nNumber/100)%10;
        int     num2 = (nNumber/10)%10;
        int     num3 = nNumber%10;
        
        NSString *strFileName1 = [NSString stringWithFormat:@"num%d.png", num1];
        NSString *strFileName2 = [NSString stringWithFormat:@"num%d.png", num2];
        NSString *strFileName3 = [NSString stringWithFormat:@"num%d.png", num3];

        rect.size.width = 41*fHeight/59;
        rect.origin.x = (self.bounds.size.width - rect.size.width*3)/2;
        
        UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:rect];
        imgView1.image = [UIImage imageNamed:strFileName1];
        [self addSubview:imgView1];
        
        rect.origin.x += rect.size.width;
        UIImageView *imgView2 = [[UIImageView alloc] initWithFrame:rect];
        imgView2.image = [UIImage imageNamed:strFileName2];
        [self addSubview:imgView2];
        
        rect.origin.x += rect.size.width;
        UIImageView *imgView3 = [[UIImageView alloc] initWithFrame:rect];
        imgView3.image = [UIImage imageNamed:strFileName3];
        [self addSubview:imgView3];
    }
}

@end
