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
    UIFont *nameFont = [UIFont fontWithName:@"ProximaNovaA-Bold" size:14.0f];
    UIFont *baselineFont = [UIFont fontWithName:@"ProximaNova-Regular" size:14.0f];
    self.nameLabel.textColor = [UIColor blackColor];
    self.taglineLabel.textColor = [UIColor blackColor];
    [self.nameLabel setFont:nameFont];
    [self.taglineLabel setFont:baselineFont];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.taglineLabel.numberOfLines = 2;
    self.iconButton = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 50, 50)];
    [self addSubview:self.iconButton];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
