//
//  MainTableViewController.m
//  apphunt
//
//  Created by Solene Maitre on 25/08/14.
//  Copyright (c) 2014 Enquire. All rights reserved.
//

#import "MainTableViewController.h"
#import "AFNetworking.h"

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

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.datesSectionTitles objectAtIndex:section];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *dayForSection = [self.datesSectionTitles objectAtIndex:section];
    NSLog(@"%@",dayForSection);
    NSArray *appsForDay = [self.appsDictionary objectForKey:dayForSection];
    return [appsForDay count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"AppTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(AppTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *sectionTitle = [self.datesSectionTitles objectAtIndex:indexPath.section];
    NSArray *apps = [self.appsDictionary objectForKey:sectionTitle];
    NSDictionary *appsDictionary = [apps objectAtIndex:indexPath.row];
    App *app = [self AppObjectFromDictionary:appsDictionary];
    cell.nameLabel.text = app.name;
    cell.baselineLabel.text = app.tagline;
    cell.countVotesLabel.text = [NSString stringWithFormat:@"%d votes", app.votesCount];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    
    for (int i = 1; i <= 10; i++) {
        NSString *dateString;
        NSDate *newDate = [NSDate dateWithTimeInterval:-24*3600*i sinceDate:date];
        dateString = [dateFormatter stringFromDate:newDate];
        [datesArray addObject:dateString];
    }
    
    NSLog(@"%@", datesArray);
    return datesArray;
    
}





@end
