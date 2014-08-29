//
//  ApplicationsURLs.m
//  apphunt
//
//  Created by Solene Maitre on 28/08/14.
//  Copyright (c) 2014 Enquire. All rights reserved.
//

#import "ApplicationsURLs.h"
#import "host.h"
static NSString const *kServiceVersion = @"v1";

@interface ApplicationsURLs()
@property (nonatomic, copy) NSString *apphuntServiceURL;
@end

@implementation ApplicationsURLs

-(id)init{
    if (self = [super init]) {
        self.apphuntServiceURL = [NSString stringWithFormat:@"%@/%@", self.hostname,kServiceVersion];
    }
    return self;
}


- (NSString *)hostname{
    return HOSTNAME;
}


@end
