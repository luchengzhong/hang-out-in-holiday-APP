//
//  AddPlaceMapViewController.m
//  HOIH
//
//  Created by 钟路成 on 16/7/12.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "AddPlaceMapViewController.h"
#import "AddInvitationController.h"

@interface AddPlaceMapViewController ()

@end

@implementation AddPlaceMapViewController{
    CLLocationManager *locationManager;
    MKPointAnnotation *annot;
    UILabel *nameLabel;
    CLGeocoder *geocoder;
    CLLocationCoordinate2D coordinate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //location update
    locationManager = [[CLLocationManager alloc] init];
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    locationManager.delegate=self;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    locationManager.distanceFilter = 10;
    
    [locationManager startUpdatingLocation];
    
    //navigate to user's location
    [_mapView setShowsUserLocation:YES];
    MKCoordinateRegion mapRegion;
    mapRegion.center = _mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.04;
    mapRegion.span.longitudeDelta = 0.02;
    
    [_mapView setRegion:mapRegion animated: NO];
    _mapView.delegate=self;
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.5; //user needs to press for 2 seconds
    [_mapView addGestureRecognizer:lpgr];
    
    //Add pin
    if(annot)
        [self.mapView addAnnotation:annot];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Map
- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    [self setPin:touchMapCoordinate];
    
    if (!geocoder)
        geocoder = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude
                                                      longitude:touchMapCoordinate.longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:
     ^(NSArray* placemarks, NSError* error){
         if ([placemarks count] > 0)
         {
             CLPlacemark *pm = placemarks[0];
             [self setLabel:pm.addressDictionary[@"Name"]];
             /*
             annot.title = pm.addressDictionary[@"Name"];*/
             /*
             annot.placemark = [placemarks objectAtIndex:0];
             
             // Add a More Info button to the annotation's view.
             MKPinAnnotationView* view = (MKPinAnnotationView*)[map viewForAnnotation:annotation];
             if (view && (view.rightCalloutAccessoryView == nil))
             {
                 view.canShowCallout = YES;
                 view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
             }*/
         }
     }];
}

-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate Name:(NSString*)name{
    [self setPin:newCoordinate];
    [self setLabel:name];
    
    

}
-(void)setPin:(CLLocationCoordinate2D)cor{
    if(!annot){
        annot = [[MKPointAnnotation alloc] init];
        annot.coordinate = cor;
        if(self.mapView)
            [self.mapView addAnnotation:annot];
    }else{
        annot.coordinate = cor;
    }
}
-(void)setLabel:(NSString*)str{
    if(!nameLabel){
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 550 , 50)];
        [nameLabel setTextColor:[UIColor whiteColor]];
        [nameLabel setBackgroundColor:[UIColor lightGrayColor]];
        [self.view addSubview:nameLabel];
        [self.view bringSubviewToFront:nameLabel];
    }
    nameLabel.text = str;
}

- (IBAction)TapDone:(id)sender {
    if(annot){
        AddInvitationController *controller = self.navigationController.viewControllers[[self.navigationController.viewControllers count] -2];
        if([controller respondsToSelector:@selector(setPlace:Coordinate:)]){
            [controller setPlace:nameLabel.text Coordinate:annot.coordinate];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - location
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *currentLocation = [manager location];
    [_mapView setCenterCoordinate:currentLocation.coordinate animated:NO];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
