//
//  MainViewController.m
//  apphunt
//
//  Created by Solene Maitre on 14/08/14.
//  Copyright (c) 2014 Enquire. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIFont *dateLabelFont = [UIFont fontWithName:@"BrownStd-Bold" size:26.0f];
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor blackColor],
                                                            NSFontAttributeName: dateLabelFont,
                                                            }];
     self.navigationController.navigationBar.topItem.title = @"Day 1";
    
    [self setupScrollView];
}


- (void)setupScrollView {
    
    CGRect fullScreenRect=[[UIScreen mainScreen] applicationFrame];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.horizontalScrollView=[[UIScrollView alloc] initWithFrame:fullScreenRect];
    self.horizontalScrollView.delegate = self;
    [self.horizontalScrollView setBackgroundColor:[UIColor whiteColor]];
    [self.horizontalScrollView setCanCancelContentTouches:NO];
    self.horizontalScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.horizontalScrollView.clipsToBounds = YES;
    self.horizontalScrollView.scrollEnabled = YES;
    self.horizontalScrollView.pagingEnabled = YES;
    self.horizontalScrollView.showsHorizontalScrollIndicator = NO;
    self.tableViewArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 5; i++) {
        CGRect frame;
        frame.origin.x = self.horizontalScrollView.frame.size.width * i;
        //IS THIS A HACK?
        frame.origin.y = 64;
        frame.size = self.horizontalScrollView.frame.size;
        AppsTableViewController *tableViewController = [[AppsTableViewController alloc] init];
        tableViewController.day = @"2014-08-23";
        tableViewController.contentFrame = frame;
        //tableViewController.appsArray =[self.dataArray objectAtIndex:i];
        tableViewController.delegate = self;
        //TO BE VALIDATED VS AS PROPERTIES TO KEEP IT ALIVE => IE OBJECTS WILL NEVER BE DEALLOCATED???
        [self.horizontalScrollView addSubview:tableViewController.view];
        [self.tableViewArray addObject:tableViewController];
    }
    
    self.horizontalScrollView.contentSize = CGSizeMake(self.horizontalScrollView.frame.size.width * 5 , self.horizontalScrollView.frame.size.height);
    self.horizontalScrollView.bounces = NO;
    self.view = self.horizontalScrollView;
    [self listSubviewsOfView:self.view];
}





#pragma mark - Scroll View Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if([scrollView isKindOfClass:[UITableView class]]) {
        return;
    }
    CGFloat pageWidth = self.horizontalScrollView.frame.size.width;
    self.page = floor((self.horizontalScrollView.contentOffset.x - pageWidth / 2)) / pageWidth + 2;
    NSString *title = [NSString stringWithFormat:@"Day %d", self.page];
    self.navigationController.navigationBar.topItem.title = title;
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if([scrollView isKindOfClass:[UITableView class]]) {
        return;
    }
    

    
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if([scrollView isKindOfClass:[UITableView class]]) {
        return;
    }
}



#pragma mark - SKStoreProductViewController Delegate
//we need to conform the MTViewController class to the SKStoreProductViewControllerDelegate protocol by implementing the productViewControllerDidFinish: method.

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark - OpenAppStoreDelegate
- (void)openAppStoreWithIdentifier:(NSString*)identifier{
    SKStoreProductViewController *storeProductViewController = [[SKStoreProductViewController alloc]init];
    [storeProductViewController setDelegate:self];
    [self presentViewController:storeProductViewController animated:YES completion:nil];
//    Activity loader does not work on top of storeProductVC
//    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
//    indicator.center = self.view.center;
//    [storeProductViewController.view.window addSubview:indicator];
//    [indicator bringSubviewToFront:self.view];
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
//    [indicator startAnimating];
    [storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:@"818540868"} completionBlock:^(BOOL result, NSError *error) {
        if(error){
            NSLog(@"Error %@ with User info %@", error, [error userInfo]);
        }
        else {
            return;
        }
    }];
}

#pragma mark - debug

- (void)listSubviewsOfView:(UIView *)view {
    
    // Get the subviews of the view
    NSArray *subviews = [view subviews];
    
    // Return if there are no subviews
    if ([subviews count] == 0) return; // COUNT CHECK LINE
    
    for (UIView *subview in subviews) {
        
        // Do what you want to do with the subview
        NSLog(@"%@ and class %@", subview, subview.class);
        
        
        // List the subviews of subview
        [self listSubviewsOfView:subview];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
