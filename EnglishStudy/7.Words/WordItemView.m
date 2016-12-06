//
//  WordItemView.m
//  EnglishStudy
//
//  Created by admin on 2/1/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "WordItemView.h"
#import "Global.h"

@implementation WordItemView

+ (id)wordItemWithWord:(NSDictionary *)dicWord
{
    NSArray       *nibs = [[NSBundle mainBundle] loadNibNamed:@"WordItemView" owner:self options:nil];
    WordItemView  *cell = (WordItemView *)nibs[0];
    
    [cell initWithWord:dicWord];

    return cell;
}

- (void)initWithWord:(NSDictionary *)dicWord
{
    self.dicWordItem = dicWord;
    
    lblWord.text = [dicWord objectForKey:@"mean_en"];
    lblMean.text = [dicWord objectForKey:@"mean_kr"];

    [lblWord addObserver:self forKeyPath:@"frame" options:0 context:nil];
    
    [self refreshFont];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if( [keyPath isEqualToString:@"frame"] )
    {
        [self refreshFont];
    }
}

- (void)dealloc
{
    [lblWord removeObserver:self forKeyPath:@"frame"];
}

- (void)refreshFont
{
    [Global resetFontSizeOfAnswerLabel:lblWord];
    [Global resetFontSizeOfAnswerLabel:lblMean];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onClickDelete:(id)sender
{
    
}

@end
