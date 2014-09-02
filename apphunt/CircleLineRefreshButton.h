//
//  CircleLineRefreshButton.h
//  apphunt
//
//  Created by Solene Maitre on 01/09/14.
//  Copyright (c) 2014 Enquire. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleLineRefreshButton : UIButton

@property (nonatomic, strong) CAShapeLayer *circleLayer;
- (void)drawCircleButton;


@end
