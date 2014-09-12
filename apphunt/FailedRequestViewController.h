//
//  FailedRequestViewController.h
//  apphunt
//
//  Created by Solene Maitre on 01/09/14.
//  Copyright (c) 2014 Enquire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleLineRefreshButton.h"
#import "Colors.h"
#import <Mixpanel/Mixpanel.h>

@protocol FailedRequestViewControllerDelegate <NSObject>

-(void)retryRequest;

@end

@interface FailedRequestViewController : UIViewController

@property (weak, nonatomic) id <FailedRequestViewControllerDelegate> delegate;
@property (strong, nonatomic) CircleLineRefreshButton *refreshButton;
@property (strong, nonatomic) IBOutlet UILabel *errorMessage;

@end
