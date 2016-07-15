//
//  InvitationMapCell.m
//  HOIH
//
//  Created by 钟路成 on 16/7/15.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "InvitationMapCell.h"

@implementation InvitationMapCell{
    MKPointAnnotation *annot;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCoordinatesStr:(NSString*)coordinateStr{
    NSArray *coors = [coordinateStr componentsSeparatedByString:@";"];
    if([coors count]>1){
        
        [_mapView setShowsUserLocation:true];
        
        CLLocationCoordinate2D cor = CLLocationCoordinate2DMake([coors[0] doubleValue], [coors[1] doubleValue]);
        
        MKCoordinateRegion mapRegion;
        mapRegion.center = cor;
        mapRegion.span.latitudeDelta = 0.01;
        mapRegion.span.longitudeDelta = 0.01;
        [_mapView setRegion:mapRegion animated: NO];
        
        if(!annot){
            annot = [[MKPointAnnotation alloc] init];
            if(self.mapView)
                [self.mapView addAnnotation:annot];
        }
        
        
        annot.coordinate = cor;
    }
}
@end
