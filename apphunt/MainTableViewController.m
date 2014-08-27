//
//  MainTableViewController.m
//  apphunt
//
//  Created by Solene Maitre on 25/08/14.
//  Copyright (c) 2014 Enquire. All rights reserved.
//

#import "MainTableViewController.h"
#import "AFNetworking.h"
#import "Colors.h"

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
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.datesSectionTitles = [self datesArray];
    [self.tableView reloadData];
    [self.view addSubview:self.tableView];
    [self makeAppsRequests];
}


#pragma mark - Table View Data Source

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datesSectionTitles.count;
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
    [attrStringTagline addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [app.tagline length])];
    cell.taglineLabel.attributedText = attrStringTagline;
    cell.countVotesLabel.text = [NSString stringWithFormat:@"%d votes", app.votesCount];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //I change from a button to an imageView with a gesture because I wanted to add custom the radius corner. Also, I pass the identifier as the tag of the clicked view. I'm sure there is a proper way to do all of this - such as subclass & identifier as a property but withotu UIbutton I don't know how to make it. Maybe also apply a mask and not a UICorner to the image so I can keep the image and the button.
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 50, 50)];
    imgView.layer.cornerRadius = 10.0f;
    imgView.clipsToBounds = YES;
    imgView.tag = [app.appstoreIdentifier integerValue];
    NSData * iconData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: app.iconPath]];
    imgView.image = [UIImage imageWithData:iconData];
    
    [imgView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openAppStore:)];
    [singleTap setNumberOfTapsRequired:1];
    [imgView addGestureRecognizer:singleTap];
    [cell addSubview:imgView];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Open App Store


#pragma mark - OpenAppStoreDelegate
- (void)openAppStore:(UIGestureRecognizer *)sender{
    NSString *identifier = [NSString stringWithFormat:@"%d", sender.view.tag] ;
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

-(void)makeAppsRequests{
    
    NSString *stringUrl = [NSString stringWithFormat:@"http://localhost:3000/v1/apps?from_day=%@&to_day=%@",self.datesSectionTitles.lastObject,self.datesSectionTitles.firstObject];
    NSLog(@"%@", stringUrl);
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //AFNetworking asynchronous url request
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"The Array: %@", responseObject);
        self.appsDictionary = responseObject;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request Failed: %@,%@", error, error.userInfo);
    }];
    
    [operation start];
    
}

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
    
    for (int i = 1; i <= 5; i++) {
        NSString *dateString;
        NSDate *newDate = [NSDate dateWithTimeInterval:-24*3600*i sinceDate:date];
        dateString = [dateFormatter stringFromDate:newDate];
        [datesArray addObject:dateString];
    }
    return datesArray;
    
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
