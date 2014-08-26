//
//  App.h
//  apphunt
//
//  Created by Solene Maitre on 16/08/14.
//  Copyright (c) 2014 Enquire. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface App : NSObject

@property (strong,nonatomic) NSString *date;
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *tagline;
@property(strong, nonatomic) NSString *appstorePath;
@property(strong, nonatomic) NSString *appstoreIdentifier;
@property(strong,nonatomic)  NSString *day;
@property int votesCount;
@property(strong, nonatomic) NSString *iconPath;
- (id)initWithData: (NSDictionary *)data;
-(NSURL *) appstoreURL;

@end
