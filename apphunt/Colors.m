//
//  Colors.m
//  apphunt
//
//  Created by Solene Maitre on 26/08/14.
//  Copyright (c) 2014 Enquire. All rights reserved.
//

#import "Colors.h"
#import "HexColor.h"

@implementation Colors


+ (UIColor *)apphuntWhiteColor{
    return [UIColor colorWithHexString:@"ffffff"];
}

+ (UIColor *)apphuntRedColor{
    return [UIColor colorWithHexString:@"ed4c2a"];
}


+ (UIColor *)apphuntLightGrayColor{
    return [UIColor colorWithRed:0.51f green:0.51f blue:0.51f alpha:0.8f];
}

+ (UIColor *)apphuntDarkGrayColor{
    return [UIColor colorWithHexString:@"333333"];
}




@end
