//
//  App.m
//  apphunt
//
//  Created by Solene Maitre on 16/08/14.
//  Copyright (c) 2014 Enquire. All rights reserved.
//

#import "App.h"

@implementation App


- (id)initWithData: (NSDictionary *)data {
    self = [super init];
    if (self) {
        self.name = data[APP_NAME];
        self.tagline = data[APP_TAGLINE];
        self.appstorePath = nil;
        self.appstoreIdentifier = data[APP_APPSTOREIDENTIFIER];
        self.iconPath = data[APP_ICONURL];
        self.votesCount = 0;
        self.day = data[APP_DAY];
    }
    return self;
}

- (id)init {
    self = [self initWithData:nil];
    return self;
}


-(NSURL *) appstoreURL {
    return [NSURL URLWithString:self.appstorePath];
}

@end
