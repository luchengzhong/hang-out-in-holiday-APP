//
//  AddPlaceMapViewController.h
//  HOIH
//
//  Created by 钟路成 on 16/7/12.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface AddPlaceMapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate Name:(NSString*)name;
@end
