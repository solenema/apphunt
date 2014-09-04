//
//  OnboardingViewController.m
//  apphunt
//
//  Created by Solene Maitre on 04/09/14.
//  Copyright (c) 2014 Enquire. All rights reserved.
//

#import "OnboardingViewController.h"
#import "Colors.h"


@interface OnboardingViewController ()

@end

@implementation OnboardingViewController

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
    [[AMPopTip appearance] setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:14]];
    self.popWelcome = [[AMPopTip alloc] initWithFrame:CGRectZero];
    self.popWelcome.popoverColor = [Colors apphuntRedColor];
    [self.popWelcome showText:@"Hello" direction:AMPopTipDirectionUp maxWidth:200 inView:self.view fromFrame:self.navigationController.navigationBar.frame];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
