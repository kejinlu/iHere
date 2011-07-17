//
//  CoreLocationController.m
//  iHere
//
//  Created by Luke on 7/16/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "CoreLocationController.h"


@implementation CoreLocationController
@synthesize locationManager;
@synthesize delegate;

- (id)init{
	if (self = [super init]) {
		self.locationManager = [[[CLLocationManager alloc] init] autorelease];
		self.locationManager.delegate = self;
	}
	return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	if([self.delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)]) { 
		[self.delegate locationUpdate:newLocation];
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	if([self.delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)]) {  
		[self.delegate locationError:error];
	}
}

- (void)dealloc {
	[self.locationManager release];
	[super dealloc];
}
@end
