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
#import <StoreKit/StoreKit.h>
#import "LLARingSpinnerView.h"


@interface MainTableViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,SKStoreProductViewControllerDelegate>

@property (strong, nonatomic) NSString *day;
@property (strong, nonatomic) NSMutableArray *datesSectionTitles;
@property (strong, nonatomic) NSMutableDictionary *appsDictionary;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSDate *currentFromDate;
@property (strong, nonatomic) NSDate *currentToDate;
@property (nonatomic, strong) LLARingSpinnerView *spinnerView;


@end
