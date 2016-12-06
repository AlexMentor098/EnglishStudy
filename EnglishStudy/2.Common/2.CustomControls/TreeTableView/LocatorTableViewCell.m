//
//  LocatorTableViewCell.m
//  SmartAXA
//
//  Created by admin on 4/25/15.
//  Copyright (c) 2015 BST. All rights reserved.
//

#import "LocatorTableViewCell.h"


@implementation LocatorTableViewCell

+ (id)createWithTitle:(NSString*)title shouldShow:(BOOL)bShow
{
    NSArray       *nibs = [[NSBundle mainBundle] loadNibNamed:@"LocatorTableViewCell" owner:self options:nil];
    LocatorTableViewCell  *cell = (LocatorTableViewCell *)nibs[0];
    
    cell = [cell initWithTitle:title shouldShow:bShow];
    
    return cell;
}

- (id)initWithTitle:(NSString*)title shouldShow:(BOOL)bShow
{
    _lblText.text   = title;
    _viewBack.layer.cornerRadius = 7;
    _imgArrow.hidden = (bShow == YES ? NO:YES);
    
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if( self )
    {
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //if( _nClassIndex != -1 )
    //    return;
    //[super setSelected:selected animated:animated];
}

@end