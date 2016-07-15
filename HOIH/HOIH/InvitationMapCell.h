//
//  InvitationMapCell.h
//  HOIH
//
//  Created by 钟路成 on 16/7/15.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface InvitationMapCell : UITableViewCell
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

-(void)setCoordinatesStr:(NSString*)coordinateStr;
@end
