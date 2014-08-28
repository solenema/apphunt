//
//  AppDelegate.h
//  apphunt
//
//  Created by Solene Maitre on 14/08/14.
//  Copyright (c) 2014 Enquire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTableViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainTableViewController *mainTableViewController;
@property (strong, nonatomic) UINavigationController *navigationController;

@end
