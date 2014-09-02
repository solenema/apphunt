//
//  CircleLineRefreshButton.m
//  apphunt
//
//  Created by Solene Maitre on 01/09/14.
//  Copyright (c) 2014 Enquire. All rights reserved.
//

#import "CircleLineRefreshButton.h"
#import "Colors.h"

@implementation CircleLineRefreshButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawCircleButton
{
    UIColor *color = [Colors apphuntRedColor];
    [self setTitleColor:color forState:UIControlStateNormal];
    self.circleLayer = [CAShapeLayer layer];
    [self.circleLayer setBounds:CGRectMake(0.0f, 0.0f, [self bounds].size.width,
                                           [self bounds].size.height)];
    [self.circleLayer setPosition:CGPointMake(CGRectGetMidX([self bounds]),CGRectGetMidY([self bounds]))];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [self.circleLayer setPath:[path CGPath]];
    [self.circleLayer setStrokeColor:[color CGColor]];
    [self.circleLayer setLineWidth:2.0f];
    [self.circleLayer setFillColor:[[UIColor clearColor] CGColor]];
    [[self layer] addSublayer:self.circleLayer];
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted)
    {
        UIColor *color = [Colors apphuntRedColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        [self.circleLayer setFillColor:color.CGColor];
    }
    else
    {
        UIColor *color = [Colors apphuntRedColor];
        [self.circleLayer setFillColor:[UIColor clearColor].CGColor];
        self.titleLabel.textColor = color;
    }
}


@end
