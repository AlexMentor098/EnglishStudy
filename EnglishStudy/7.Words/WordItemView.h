//
//  WordItemView.h
//  EnglishStudy
//
//  Created by admin on 2/1/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordItemView : UITableViewCell
{
    IBOutlet UILabel *lblWord;
    IBOutlet UILabel *lblMean;
}

@property (nonatomic) NSDictionary  *dicWordItem;

+ (id)wordItemWithWord:(NSDictionary *)dicWord;

- (IBAction)onClickDelete:(id)sender;

@end
