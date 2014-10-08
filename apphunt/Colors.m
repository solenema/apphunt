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


+ (UIColor *)enquireWhiteColor{
    return [UIColor colorWithHexString:@"ffffff"];
}

+ (UIColor *)enquireBlueColor{
    return [UIColor colorWithHexString:@"30aadd"];
}


+ (UIColor *)apphuntLightGrayColor{
    return [UIColor colorWithHexString:@"cccece"];
}

+ (UIColor *)apphuntDarkGrayColor{
    return [UIColor colorWithHexString:@"333333"];
}




@end
