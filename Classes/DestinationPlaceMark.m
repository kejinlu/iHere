//
//  DestinationPlaceMark.m
//  iHere
//
//  Created by Luke on 7/17/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "DestinationPlaceMark.h"


@implementation DestinationPlaceMark
@synthesize coordinate;

- (NSString *)subtitle{
	return [NSString stringWithFormat:@"纬度:%f,经度:%f",coordinate.latitude,coordinate.longitude];
}
- (NSString *)title{
	return @"位置信息";
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
	return self;
}
@end
