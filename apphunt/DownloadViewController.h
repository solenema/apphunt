//
//  DownloadViewController.h
//  apphunt
//
//  Created by Solene Maitre on 16/08/14.
//  Copyright (c) 2014 Enquire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface DownloadViewController : UIViewController <SKStoreProductViewControllerDelegate>

@property(strong, nonatomic)NSURL *appStoreURL;
@property (strong, nonatomic) IBOutlet UIView *view;


@end
