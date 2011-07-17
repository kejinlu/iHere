//
//  iHereViewController.m
//  iHere
//
//  Created by Luke on 7/16/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import "iHereViewController.h"

#define SHARE_ACTION_SHEET 123
@implementation iHereViewController
@synthesize mapView; 

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	mapView.delegate = self;
	locationController = [[CoreLocationController alloc] init];
	locationController.delegate = self;
	[locationController.locationManager startUpdatingLocation];	
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.mapView = nil;
}

#pragma mark -
#pragma mark LocationController delegate
- (void)locationUpdate:(CLLocation *)location {
	//locLabel.text = [location description];
	MKCoordinateRegion region;
	region.center = location.coordinate;
	destinationCoordinate = location.coordinate;
	//Set Zoom level using Span
	MKCoordinateSpan span;
	span.latitudeDelta=.005;
	span.longitudeDelta=.005;
	region.span=span;
	
	[mapView setRegion:region animated:TRUE];
	
	if (destinationPlaceMark) {
		[mapView removeAnnotation:destinationPlaceMark];
		[destinationPlaceMark release];
	}
	destinationPlaceMark = [[DestinationPlaceMark alloc] initWithCoordinate:destinationCoordinate];
	[mapView addAnnotation:destinationPlaceMark];
	[mapView selectAnnotation:destinationPlaceMark animated:YES];
}

- (void)locationError:(NSError *)error {
	
	if (error) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出错了" 
														message:[error localizedDescription]
													   delegate:self 
											  cancelButtonTitle:@"知道了" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
}



#pragma mark -
#pragma mark Custom Annotation
/*
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
	NSLog(@"View for Annotation is called");
	MKPinAnnotationView *test=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"parkingloc"];
	test.userInteractionEnabled=TRUE;
	[test setPinColor:MKPinAnnotationColorGreen];
	test.selected = YES;
	test.draggable = YES;
	return test;
}
 */

#pragma mark -
#pragma mark share sheet
//http://maps.google.com/maps?ll=39.905841,116.391596&spn=0.004710,0.007832&t=k&hl=en
- (IBAction)launchShareMenu{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
															 delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil
													otherButtonTitles: @"邮件发送",@"短信发送",nil];
	[actionSheet setActionSheetStyle:UIActionSheetStyleAutomatic];
	[actionSheet setTag:SHARE_ACTION_SHEET];
	[actionSheet showInView:self.view];
	[actionSheet release];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (actionSheet.tag == SHARE_ACTION_SHEET) {
		if (buttonIndex == 0) {
			//邮件发送
			if ([MFMailComposeViewController canSendMail]) {
				[self displayMailComposer];
			}else {
				[self launchMailAppOnDevice];
			}

		}else if (buttonIndex == 1) {
			//短信发送
			if ([MFMessageComposeViewController canSendText]) {
				[self displayMessageComposer];
			}else {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出错了" 
																message:@"无法发送短信"
															   delegate:self 
													  cancelButtonTitle:@"知道了" otherButtonTitles:nil];
				[alert show];
				[alert release];
			}


		}
	}
	return;
}

#pragma mark -
#pragma mark Mail
- (void)displayMailComposer {
	MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = self;
	[controller setSubject:@"我在这儿"];
	NSString *imageURLString = [NSString stringWithFormat:@"http://ditu.google.cn/maps/api/staticmap?size=300x300&zoom=14&maptype=roadmap&mobile=true&sensor=false&markers=color:red|%f,%f", 
								destinationCoordinate.latitude,
								destinationCoordinate.longitude];
	NSString *linkURLString = [NSString stringWithFormat:@"<a href=\"http://ditu.google.cn/?ll=%f,%f&spn=0.005,0.005&z=17&mobile=true&iwloc=near&q=%f,%f\">%f,%f</a>",
							   destinationCoordinate.latitude,
							   destinationCoordinate.longitude,
							   destinationCoordinate.latitude,
							   destinationCoordinate.longitude,
							   destinationCoordinate.latitude,
							   destinationCoordinate.longitude];
	
	[controller setMessageBody:[NSString stringWithFormat:@"我在这儿 %@ <br/> <img src=\"%@\">",linkURLString,imageURLString] isHTML:YES];
	[self presentModalViewController:controller animated:YES];
	[controller release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)launchMailAppOnDevice{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:xxx@xxx.com"]];
}

#pragma mark -
#pragma mark Text Message
- (void)displayMessageComposer {
	MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
	controller.messageComposeDelegate = self;
	[controller setBody:[NSString  stringWithFormat:@"我在这儿: http://ditu.google.cn/?ll=%f,%f&spn=0.005,0.005&z=17&mobile=true&iwloc=near&q=%f,%f",
						 destinationCoordinate.latitude,
						 destinationCoordinate.longitude,
						 destinationCoordinate.latitude,
						 destinationCoordinate.longitude]];
	[self presentModalViewController:controller animated:YES];
	[controller release];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark show info
/*
- (IBAction)showInfo {    
	
	InfoViewController *controller = [[InfoViewController alloc] init];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}
*/

#pragma mark -
#pragma mark dealloc
- (void)dealloc {
	[locationController release];
	[mapView release];
	mapView = nil;
    [super dealloc];
}

@end
