//
//  MainTableViewController.m
//  apphunt
//
//  Created by Solene Maitre on 25/08/14.
//  Copyright (c) 2014 Enquire. All rights reserved.
//

#import "MainTableViewController.h"



static int nbOfLoadedDays = 1;
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
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [Colors apphuntRedColor];
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"App Hunt", @"");
    self.navigationController.navigationBar.translucent = NO;
    [label sizeToFit];
    
    //Remove the gray line below the Nav Bar
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"bottom-line"]];
    [[UINavigationBar appearance] setTintColor:[Colors apphuntRedColor]];
    
    
    //Add Loader (Spinner View)
    self.spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectZero];
    self.spinnerView.bounds = CGRectMake(0, 0, 40, 40);
    self.spinnerView.tintColor = [Colors apphuntRedColor];
    self.spinnerView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds) - 64);
    
    // Init Table List
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    //load more data when scroll to the bottom
    __weak typeof(self) weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf makeAppsRequests];
    }];
    
    //Add Pull to refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf makeRefreshRequest];
        
        
    }];
    
    [self.view addSubview:self.spinnerView];
    [self makeFirstAppsRequest];
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.spinnerView startAnimating];
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Open the App" properties:nil];
}

-(void)displayViewsAndData{
    [self.spinnerView stopAnimating];
    [self.spinnerView removeFromSuperview];
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    
    //Don't know if it is the best moment to do it and also if I don't start the animation, the spinner is not animated.
    LLARingSpinnerView *infiniteSpinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    infiniteSpinnerView.tintColor = [Colors apphuntRedColor];
    [infiniteSpinnerView startAnimating];
    [self.tableView.pullToRefreshView setCustomView:infiniteSpinnerView forState:SVInfiniteScrollingStateAll];
    
    //Add Pop Up if first time
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasSeenTutorial"]) {
        [self displayTutorial];
    }
    
}

-(void)displayTutorial{
    [[AMPopTip appearance] setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:14]];
    [[AMPopTip appearance] setTextColor:[Colors apphuntWhiteColor]];
    self.welcomePop = [[AMPopTip alloc] initWithFrame:CGRectZero];
    self.welcomePop.popoverColor = [Colors apphuntRedColor];
    NSString *welcomeText = [NSString stringWithFormat:@"Hey App Hunters!\nWe gather iOS apps posted on Product Hunt.\n Install and test the latest apps in 2 taps!"];
    [self.welcomePop showText:welcomeText direction:AMPopTipDirectionDown maxWidth:180 inView:self.view fromFrame:CGRectMake(self.view.frame.size.width/2,15,0,0)];
    [self.view addSubview:self.welcomePop];
    UITapGestureRecognizer *tapToClose = [[UITapGestureRecognizer alloc] initWithTarget:self.welcomePop action:@selector(hide)];
    [tapToClose setNumberOfTapsRequired:1];
    [self.welcomePop addGestureRecognizer:tapToClose];
    
    //Save in User Defaults
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasSeenTutorial"];
    [[NSUserDefaults standardUserDefaults]synchronize];
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
    headerLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:14.0f];
    headerLabel.frame = CGRectMake(20,1,200,24);
    headerLabel.text =  [self convertDateToSectionFormat:[self.datesSectionTitles objectAtIndex:section]];
    if (section == 0) {
        NSString *today = @"TODAY ";
        headerLabel.text = [today stringByAppendingString:[self convertDateToSectionFormat:[self.datesSectionTitles objectAtIndex:0]]];
    }
    else if (section ==1) {
        NSString *yesterday = @"YESTERDAY ";
        headerLabel.text = [yesterday stringByAppendingString:[self convertDateToSectionFormat:[self.datesSectionTitles objectAtIndex:1]]];
    }
    else {
        headerLabel.text =  [self convertDateToSectionFormat:[self.datesSectionTitles objectAtIndex:section]];
        
    }
    
    headerLabel.textColor = [Colors apphuntWhiteColor];
    [customView addSubview:headerLabel];
    return customView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 24;
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
    
    // change background color of selected cell
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[Colors apphuntLightGrayColor]];
    [cell setSelectedBackgroundView:bgColorView];
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(AppTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *sectionTitle = [self.datesSectionTitles objectAtIndex:indexPath.section];
    NSArray *apps = [self.appsDictionary objectForKey:sectionTitle];
    NSDictionary *appsDictionary = [apps objectAtIndex:indexPath.row];
    App *app = [self AppObjectFromDictionary:appsDictionary];
    cell.nameLabel.text = app.name;
    // Store the Appstore identifier in the Tag for Action on cells (a bit hacky)
    cell.tag = [app.appstoreIdentifier integerValue];
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
    cell.separatorInset =  UIEdgeInsetsMake(0, 15, 0, 15);
    
    //Add icon of the App and add a gesture (optional now as the cell can be taped for the same action)
    __weak UIImageView *iconButton = cell.iconButton;
    iconButton.tag = [app.appstoreIdentifier integerValue];
    if(![app.iconPath isKindOfClass:[NSNull class]]) {
        [iconButton setUserInteractionEnabled:YES];
        [iconButton setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:app.iconPath]]placeholderImage:[UIImage imageNamed:@"Logo.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            iconButton.image = image;
            CALayer *layer = iconButton.layer;
            layer.masksToBounds = YES;
            layer.borderColor = [Colors apphuntLightGrayColor].CGColor;
            layer.borderWidth = 0.3f;
            layer.cornerRadius = 10.0f;
        } failure:NULL];
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openAppStoreFromButton:)];
        [singleTap setNumberOfTapsRequired:1];
        [iconButton addGestureRecognizer:singleTap];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    [self openAppStoreFromCell:cell.tag];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)ScrollView{
    if ([self.welcomePop isVisible]){
        [self.welcomePop hide];
    }
}

#pragma mark - OpenAppStore

- (void)openAppStoreFromButton:(UIGestureRecognizer *)sender{
    NSString *identifier = [NSString stringWithFormat:@"%ld", (long)sender.view.tag] ;
    SKStoreProductViewController *storeProductViewController = [[SKStoreProductViewController alloc]init];
    [storeProductViewController setDelegate:self];
    [self presentViewController:storeProductViewController animated:YES completion:nil];
    //THIS IS NOT WORKING.
        //Activity loader does not work on top of storeProductVC
//        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
//        indicator.center = self.view.center;
//        [storeProductViewController.view.window addSubview:indicator];
//        [indicator bringSubviewToFront:self.view];
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
//        [indicator startAnimating];


    [storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:identifier} completionBlock:^(BOOL result, NSError *error) {
        if(error){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                            message:@"We were unable to access the App Store, come back in a bit!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else {
            return;
        }
    }];
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Open App Store From Icon" properties:nil];
}


- (void)openAppStoreFromCell:(NSInteger)appIdentifier{
    NSString *identifier = [NSString stringWithFormat:@"%ld", (long)appIdentifier] ;
    [[UINavigationBar appearance] setTintColor:[Colors apphuntRedColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                            message:@"We were unable to access the App Store, come back in a bit!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else {
            return;
        }
    }];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Open App Store From Cell" properties:nil];
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
    //NSLog(@"%@", stringUrl);
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
        [self displayViewsAndData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.tableView.showsInfiniteScrolling = NO;
        [self.spinnerView stopAnimating];
        [self.spinnerView removeFromSuperview];
        self.failedRequestView = [[FailedRequestViewController alloc] initWithNibName:@"FailedRequestViewController" bundle:nil];
        self.failedRequestView.delegate = self;
        [self.view addSubview:self.failedRequestView.view];
        //[self presentViewController:failedRequestVC animated:NO completion:nil];
    }];
    [operation start];
}



//THIS IS A FAKE REQUEST
-(void)makeRefreshRequest{
    [NSTimer scheduledTimerWithTimeInterval:1 target:self.tableView.pullToRefreshView selector:@selector(stopAnimating) userInfo:nil repeats:YES];
}



-(void)makeAppsRequests{
    ApplicationsURLs *applicationURL = [[ApplicationsURLs alloc] init];
    NSString *stringUrl = [NSString stringWithFormat:@"%@/apps/?from_day=%@&to_day=%@", applicationURL.apphuntServiceURL, [self formattedDate:self.currentFromDate], [self formattedDate:self.currentToDate]];
    //    NSLog(@"%@", stringUrl);
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
    }];
    [operation start];
}

-(void)retryRequest{
    [self.failedRequestView.view removeFromSuperview];
    self.tableView.showsInfiniteScrolling = YES;
    [self.view addSubview:self.spinnerView];
    [self.spinnerView startAnimating];
    [self makeFirstAppsRequest];
}




- (void)reloadTableView:(int)startingSection;
{
    NSIndexSet *insertIndexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(startingSection, nbOfLoadedDays + 1)];
    [self.tableView insertSections:insertIndexSet withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark Private Methods

- (App *)AppObjectFromDictionary:(NSDictionary *)dictionary {
    App   *appObject = [[App alloc] initWithData:dictionary];
    return appObject;
}


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
    [dateInitialFormat setDateStyle:NSDateFormatterMediumStyle];
    NSString *sectionTitle = [dateInitialFormat stringFromDate:date];
    return sectionTitle;
}


@end
