//
//  MainTableViewController.h
//  apphunt
//
//  Created by Solene Maitre on 25/08/14.
//  Copyright (c) 2014 Enquire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App.h"
#import "AppTableViewCell.h"

@protocol OpenAppStoreDelegate <NSObject>
- (void)openAppStoreWithIdentifier:(NSString*)identifier;
@end

@interface MainTableViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak,nonatomic) id <OpenAppStoreDelegate> delegate;
@property (strong, nonatomic) NSString *day;
@property (strong, nonatomic) NSMutableArray *datesSectionTitles;
@property (strong, nonatomic) NSDictionary *appsDictionary;
@property (strong, nonatomic) UITableView *tableView;

@end
