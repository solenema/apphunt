//
//  MainViewController.h
//  apphunt
//
//  Created by Solene Maitre on 14/08/14.
//  Copyright (c) 2014 Enquire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppTableViewCell.h"
#import "App.h"
#import "AppsTableViewController.h"
#import <StoreKit/StoreKit.h>



@interface MainViewController : UIViewController <UIScrollViewDelegate,SKStoreProductViewControllerDelegate,SKStoreProductViewControllerDelegate,OpenAppStoreDelegate>

@property (strong, nonatomic) UIScrollView  *horizontalScrollView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *dateArray;
@property (strong, nonatomic) NSMutableArray *tableViewArray;
@property int page;
@property (strong, nonatomic)  UILabel *dateLabel;

@end
