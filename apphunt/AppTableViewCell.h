//
//  AppTableViewCell.h
//  apphunt
//
//  Created by Solene Maitre on 16/08/14.
//  Copyright (c) 2014 Enquire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadViewController.h"

@interface AppTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *baselineLabel;
@property (strong, nonatomic) IBOutlet UILabel *countVotesLabel;

@end