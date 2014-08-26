//
//  AppTableViewCell.m
//  apphunt
//
//  Created by Solene Maitre on 16/08/14.
//  Copyright (c) 2014 Enquire. All rights reserved.
//

#import "AppTableViewCell.h"

@implementation AppTableViewCell

- (void)awakeFromNib
{
    UIFont *nameFont = [UIFont fontWithName:@"BrownStd-regular" size:20.0f];
    UIFont *baselineFont = [UIFont fontWithName:@"BrownStd-light" size:16.0f];
    UIFont *countvotesFont = [UIFont fontWithName:@"BrownStd-light" size:12.0f];
    self.nameLabel.textColor = [UIColor blackColor];
    self.baselineLabel.textColor = [UIColor blackColor];
    self.countVotesLabel.textColor = [UIColor grayColor];
    [self.nameLabel setFont:nameFont];
    [self.baselineLabel setFont:baselineFont];
    [self.countVotesLabel setFont:countvotesFont];
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
