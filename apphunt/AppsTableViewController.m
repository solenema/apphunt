//
//  AppsTableViewController.m
//  apphunt
//
//  Created by Solene Maitre on 18/08/14.
//  Copyright (c) 2014 Enquire. All rights reserved.
//

#import "AppsTableViewController.h"
#import "AFNetworking.h"

@interface AppsTableViewController ()

@end

@implementation AppsTableViewController


- (void)loadView {
    UIView *contentView = [[UIView alloc] initWithFrame:self.contentFrame];
    contentView.autoresizesSubviews = YES;
    //   contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    contentView.backgroundColor = [UIColor blackColor];
    [self setView:contentView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.tableView setAutoresizesSubviews:YES];
    //    [self.tableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 50, 0, 100);
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    [[self view] addSubview:self.tableView];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self makeAppsRequests];
    [self datesArray];
}



#pragma mark - Table View Data Source


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.appsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        [tableView registerNib:[UINib  nibWithNibName:@"AppTableViewCell" bundle:nil]  forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    }
    UIButton *downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    downloadButton.tag = indexPath.row;
    [downloadButton addTarget:self
                       action:@selector(openAppStore:)
             forControlEvents:UIControlEventTouchDown];
    [downloadButton  setImage:[UIImage imageNamed:@"appstore-icon"] forState:UIControlStateNormal];
    downloadButton.frame = CGRectMake(15.0f, 15.0f, 50.0f, 50.0f);
    [cell addSubview:downloadButton];
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(AppTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *appDictionary = [self.appsArray objectAtIndex:indexPath.row];
    App *app = [self AppObjectFromDictionary:appDictionary];
    cell.nameLabel.text = app.name;
    cell.taglineLabel.text = app.tagline;
    cell.countVotesLabel.text = [NSString stringWithFormat:@"%D votes", app.votesCount];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

}


#pragma - mark App Store

-(void)openAppStore:(id)sender {
    UIButton *downloadButtonClicked = (UIButton *)sender;
    
    NSDictionary *appDictionary = [self.appsArray objectAtIndex:downloadButtonClicked.tag];
    App *app = [self AppObjectFromDictionary:appDictionary];
    NSLog(@"%li, %@", (long)downloadButtonClicked.tag, app.name);
    NSString *identifier = @"818540868";
    [self.delegate openAppStoreWithIdentifier:identifier];
}


-(void)makeAppsRequests{
    
    NSString *stringUrl = [NSString stringWithFormat:@"http://localhost:3000/v1/apps?day=%@", self.day];
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //AFNetworking asynchronous url request
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"The Array: %@", responseObject);
        self.appsArray = [responseObject objectForKey:@"apps"];
        //NSLog(@"The Array: %@",self.appsArray);
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request Failes: %@,%@", error, error.userInfo);
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
    
    for (int i = 1; i <= 35; i++) {
        NSString *dateString;
        NSDate *newDate = [NSDate dateWithTimeInterval:-24*3600*i sinceDate:date];
        dateString = [dateFormatter stringFromDate:newDate];
        [datesArray addObject:dateString];
    }
    
    NSLog(@"%@", datesArray);
    return datesArray;
    
}


@end
