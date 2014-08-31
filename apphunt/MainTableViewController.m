//
//  MainTableViewController.m
//  apphunt
//
//  Created by Solene Maitre on 25/08/14.
//  Copyright (c) 2014 Enquire. All rights reserved.
//

#import "MainTableViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"
#import "Colors.h"
#import "ApplicationsURLs.h"
#import "UIScrollView+SVInfiniteScrolling.h"


static int nbOfLoadedDays = 2;
//Must be a multiple of nbOfLoadingDays
static int nbTotalOfDaysAllowed = 2*100;

@interface MainTableViewController ()

@end

@implementation MainTableViewController

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
    
    // Initialize
    self.currentToDate = [NSDate date];
    self.currentFromDate = [self fromDateWith:self.currentToDate];
    self.datesSectionTitles = [self datesArray];
    self.appsDictionary = [[NSMutableDictionary alloc]init];
    
    //NavBar
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"ProximaNovaA-Bold" size:16.0f];
    //label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [Colors apphuntRedColor]; // change this color
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"App Hunt", @"");
    self.navigationController.navigationBar.translucent = NO;
    [label sizeToFit];
    
    //Remove the gray line below the Nav Bar
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    //Add Loader
	self.spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectZero];
    self.spinnerView.bounds = CGRectMake(0, 0, 40, 40);
    self.spinnerView.tintColor = [Colors apphuntRedColor];
    self.spinnerView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds) - 64);
    
    // Init Table List
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.contentInset = UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height, 0,0,0);
    //[self.view addSubview:self.tableView];
    
    __weak typeof(self) weakSelf = self;
    
    //load more data when scroll to the bottom
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf makeAppsRequests];
    }];
    
    [self.view addSubview:self.spinnerView];
    [self makeFirstAppsRequest];
   
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.spinnerView startAnimating];
}

#pragma mark - Table View Data Source

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return self.appsDictionary.count;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    // create the parent view that will hold header Label
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0,0,300,60)];
    customView.backgroundColor = [Colors apphuntLightGrayColor];
    // create the label objects
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero] ;
    headerLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:12.0f];
    headerLabel.frame = CGRectMake(20,0,200,20);
    headerLabel.text =  [self convertDateToSectionFormat:[self.datesSectionTitles objectAtIndex:section]];
    headerLabel.textColor = [Colors apphuntWhiteColor];
    [customView addSubview:headerLabel];
    return customView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *dayForSection = [self.datesSectionTitles objectAtIndex:section];
    NSArray *appsForDay = [self.appsDictionary objectForKey:dayForSection];
    return [appsForDay count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"AppTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(AppTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset =  UIEdgeInsetsMake(0, 15, 0, 15);
    NSString *sectionTitle = [self.datesSectionTitles objectAtIndex:indexPath.section];
    NSArray *apps = [self.appsDictionary objectForKey:sectionTitle];
    NSDictionary *appsDictionary = [apps objectAtIndex:indexPath.row];
    App *app = [self AppObjectFromDictionary:appsDictionary];
    cell.nameLabel.text = app.name;
    NSMutableAttributedString *attrStringTagline = [[NSMutableAttributedString alloc] initWithString:app.tagline];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    [style setLineSpacing:0];
    if(![app.tagline isKindOfClass:[NSNull class]]) {
    [attrStringTagline addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [app.tagline length])];
    }
    else {
    [attrStringTagline addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, 0)];
    }
    cell.taglineLabel.attributedText = attrStringTagline;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //I change from a button to an imageView with a gesture because I wanted to add custom the radius corner. Also, I pass the identifier as the tag of the clicked view. I'm sure there is a proper way to do all of this - such as subclass & identifier as a property but withotu UIbutton I don't know how to make it. Maybe also apply a mask and not a UICorner to the image so I can keep the image and the button.
    
    __weak UIImageView *iconButton = cell.iconButton;

    iconButton.tag = [app.appstoreIdentifier integerValue];
    
    if(![app.iconPath isKindOfClass:[NSNull class]]) {
    [iconButton setUserInteractionEnabled:YES];
    [iconButton setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:app.iconPath]]placeholderImage:[UIImage imageNamed:@"Logo.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            iconButton.image = image;
            CALayer *layer = iconButton.layer;
            layer.masksToBounds = YES;
            layer.cornerRadius = 10.0f;
        } failure:NULL];
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openAppStore:)];
    [singleTap setNumberOfTapsRequired:1];
    [iconButton addGestureRecognizer:singleTap];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - OpenAppStoreDelegate
- (void)openAppStore:(UIGestureRecognizer *)sender{
    NSString *identifier = [NSString stringWithFormat:@"%ld", (long)sender.view.tag] ;
    NSLog(@"click on %@",identifier);
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
    [storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:identifier} completionBlock:^(BOOL result, NSError *error) {
        if(error){
            NSLog(@"Error %@ with User info %@", error, [error userInfo]);
        }
        else {
            return;
        }
    }];
}



#pragma mark - SKStoreProductViewController Delegate
//we need to conform the MTViewController class to the SKStoreProductViewControllerDelegate protocol by implementing the productViewControllerDidFinish: method.

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark Networking Service



-(void)makeFirstAppsRequest{
    ApplicationsURLs *applicationURL = [[ApplicationsURLs alloc] init];
    NSString *stringUrl = [NSString stringWithFormat:@"%@/apps/?from_day=%@&to_day=%@", applicationURL.apphuntServiceURL, [self formattedDate:self.currentFromDate], [self formattedDate:self.currentToDate]];
    NSLog(@"%@", stringUrl);
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //AFNetworking asynchronous url request
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //Update the request days
        self.currentToDate = [self newToDateWith:self.currentToDate];
        self.currentFromDate = [self fromDateWith:self.currentToDate];
        
        //Save the dictionary of apps into the existing appsDictionary
        [self.appsDictionary addEntriesFromDictionary:responseObject];
        [self.spinnerView stopAnimating];
        [self.spinnerView removeFromSuperview];
        
        
        //Clear the infinite scroll
        [self.tableView.infiniteScrollingView stopAnimating];
        
        [self.view addSubview:self.tableView];
        [self.tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.tableView.showsInfiniteScrolling = NO;
        NSLog(@"Request Failed: %@,%@", error, error.userInfo);
    }];
    [operation start];
}


-(void)makeAppsRequests{
    ApplicationsURLs *applicationURL = [[ApplicationsURLs alloc] init];
    NSString *stringUrl = [NSString stringWithFormat:@"%@/apps/?from_day=%@&to_day=%@", applicationURL.apphuntServiceURL, [self formattedDate:self.currentFromDate], [self formattedDate:self.currentToDate]];
    NSLog(@"%@", stringUrl);
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //AFNetworking asynchronous url request
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        int currentSection = [self.appsDictionary count];
        //Update the request days
        self.currentToDate = [self newToDateWith:self.currentToDate];
        self.currentFromDate = [self fromDateWith:self.currentToDate];
        
        //Save the dictionary of apps into the existing appsDictionary
        [self.appsDictionary addEntriesFromDictionary:responseObject];
        [self reloadTableView:currentSection];
        //Clear the infinite scroll
        [self.tableView.infiniteScrollingView stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.tableView.showsInfiniteScrolling = NO;
        NSLog(@"Request Failed: %@,%@", error, error.userInfo);
    }];
    [operation start];
}


- (void)reloadTableView:(int)startingSection;
{
    NSIndexSet *insertIndexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(startingSection, nbOfLoadedDays + 1)];
    [self.tableView insertSections:insertIndexSet withRowAnimation:UITableViewRowAnimationFade];
}


- (App *)AppObjectFromDictionary:(NSDictionary *)dictionary {
    App   *appObject = [[App alloc] initWithData:dictionary];
    return appObject;
}

#pragma mark Methods related to Dates

-(NSMutableArray *)datesArray {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *now = [dateFormatter stringFromDate:date];
    NSMutableArray *datesArray = [[NSMutableArray alloc] initWithObjects: now, nil];
    
    for (int i = 1; i <= nbTotalOfDaysAllowed; i++) {
        NSString *dateString;
        NSDate *newDate = [NSDate dateWithTimeInterval:-24*3600*i sinceDate:date];
        dateString = [dateFormatter stringFromDate:newDate];
        [datesArray addObject:dateString];
    }
    return datesArray;
    
}

-(NSDate *)fromDateWith:(NSDate *)toDate{
    return [NSDate dateWithTimeInterval:-24*3600*nbOfLoadedDays sinceDate:toDate];
}

-(NSDate *)newToDateWith:(NSDate *)toDate{
    return [NSDate dateWithTimeInterval:-24*3600*(nbOfLoadedDays+1) sinceDate:toDate];
}

-(NSString *)formattedDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}


-(NSString *)convertDateToSectionFormat:(NSString *)strDate {
    NSDateFormatter *dateInitialFormat = [[NSDateFormatter alloc] init];
    [dateInitialFormat setDateFormat: @"YYYY-MM-dd"];
    NSDate *date = [dateInitialFormat dateFromString:strDate];
    [dateInitialFormat setDateFormat:@"EEE, MMMM d"];
    NSString *sectionTitle = [dateInitialFormat stringFromDate:date];
    NSLog(@"title = %@",sectionTitle);
    return sectionTitle;
}


@end
