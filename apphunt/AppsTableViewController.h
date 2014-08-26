//
//  AppsTableViewController.h
//  apphunt
//
//  Created by Solene Maitre on 18/08/14.
//  Copyright (c) 2014 Enquire. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "App.h"
#import "AppTableViewCell.h"
#import "DownloadViewController.h"

@protocol OpenAppStoreDelegate <NSObject>
- (void)openAppStoreWithIdentifier:(NSString*)identifier;
@end

@interface AppsTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) id <OpenAppStoreDelegate> delegate;
@property (strong, nonatomic) NSString *day;
@property (strong, nonatomic) NSArray *appsArray;
@property (strong, nonatomic)  UITableView *tableView;
@property CGRect contentFrame;
@end
