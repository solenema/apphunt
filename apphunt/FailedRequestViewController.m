//
//  FailedRequestViewController.m
//  apphunt
//
//  Created by Solene Maitre on 01/09/14.
//  Copyright (c) 2014 Enquire. All rights reserved.
//

#import "FailedRequestViewController.h"



@interface FailedRequestViewController ()

@end

@implementation FailedRequestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.errorMessage.text = NSLocalizedString(@"failedrequest.retry",nil);
    self.refreshButton = [[CircleLineRefreshButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.refreshButton.center = CGPointMake(self.view.center.x, self.view.center.y - 64);
    [self.refreshButton drawCircleButton];
    [self.view addSubview:self.refreshButton];
    UIFont *errorFont = [UIFont fontWithName:@"ProximaNova-Regular" size:15.0f];
    [self.errorMessage setFont:errorFont];
    [self.refreshButton addTarget:self action:@selector(reloadMainTableViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Failed to Load Apps" properties:nil];
}


-(void)reloadMainTableViewController:(CircleLineRefreshButton *)sender{
    //[self.view removeFromSuperview];
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate retryRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
