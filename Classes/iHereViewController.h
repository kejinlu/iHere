//
//  iHereViewController.h
//  iHere
//
//  Created by Luke on 7/16/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>
#import "CoreLocationController.h"
#import "DestinationPlaceMark.h"

@interface iHereViewController : UIViewController<UIActionSheetDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,CoreLocationControllerDelegate,MKMapViewDelegate> {
	CoreLocationController *locationController;
	MKMapView *mapView;
	
	CLLocationCoordinate2D destinationCoordinate;
	DestinationPlaceMark *destinationPlaceMark;
}

@property(nonatomic,retain) IBOutlet MKMapView *mapView;
- (IBAction)launchShareMenu;
- (void)displayMessageComposer;
- (void)displayMailComposer;
- (void)launchMailAppOnDevice;
@end

