//
//  DownloadViewController.m
//  apphunt
//
//  Created by Solene Maitre on 16/08/14.
//  Copyright (c) 2014 Enquire. All rights reserved.
//

#import "DownloadViewController.h"

@interface DownloadViewController ()

@end

@implementation DownloadViewController

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
    [self openAppStore];
//    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 100, 320, 300)];
//    NSURLRequest *URLRequest = [NSURLRequest requestWithURL:self.appStoreURL];
//    [webView loadRequest:URLRequest];
//    NSLog(@"%@", URLRequest);
//    [self.view addSubview:webView];
    }

- (void) openAppStore
{
    if( NSStringFromClass([SKStoreProductViewController class]) != nil )
    {
        SKStoreProductViewController *viewCont = [[SKStoreProductViewController alloc] init];
        viewCont.delegate = self;
        [viewCont loadProductWithParameters:[NSDictionary dictionaryWithObject:@"284882215" forKey:SKStoreProductParameterITunesItemIdentifier] completionBlock:nil];
        [self.navigationController presentViewController:viewCont animated:YES completion:nil];
    }
    else
    {
        // open safari
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/facebook/id284882215?mt=8"]];
    }
}


#pragma-mark SKStoreProductViewControllerDelegate

-(void)productViewControllerDidFinish:(SKStoreProductViewController *)productViewController
{
    [productViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
