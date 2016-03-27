//
//  ViewController.m
//  Love Places
//
//  Created by Meng Han on 3/2/16.
//  Copyright © 2016 menghan2. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
// Instantiate a pair of UILabels in Interface Builder
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@end

@implementation ViewController
{
    GMSPlacesClient *_placesClient;
    GMSPlacePicker *_placePicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _placesClient = [[GMSPlacesClient alloc] init];
    
    
    //36.546564,116.8337803
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:36.546564 longitude:116.8337803 zoom:9];
    
    
    //self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    [self.mapView setCamera:camera];
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.settings.compassButton = YES;
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(36.546564, 116.8337803);
    marker.title = @"Susie";
    marker.snippet = @"Baby";
    marker.map = self.mapView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pickPlace:(UIButton *)sender {
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(51.5108396, -0.0922251);
    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001);
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001);
    GMSCoordinateBounds *viewport = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast
                                                                         coordinate:southWest];
    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:viewport];
    _placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
    
    [_placePicker pickPlaceWithCallback:^(GMSPlace *place, NSError *error) {
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        
        if (place != nil) {
            NSLog(@"Place name %@", place.name);
            NSLog(@"Place address %@", place.formattedAddress);
            NSLog(@"Place attributions %@", place.attributions.string);
            GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:place.coordinate zoom:20];
            [self.mapView setCamera:camera];
            
            
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = place.coordinate;
            marker.title = place.name;
            marker.snippet = place.formattedAddress;
            marker.map = self.mapView;
            
            
        } else {
            NSLog(@"No place selected");
        }
    }];
}


@end
