//
//  AddInvitationController.h
//  HOIH
//
//  Created by 钟路成 on 16/7/11.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypePickerView.h"
#import "HOIHHTTPClient.h"
#import <MapKit/MapKit.h>

@interface AddInvitationController : UITableViewController <HOIHHTTPClientDelegate>
@property (weak, nonatomic) IBOutlet UIDatePicker *inviteTimePicker;
@property (weak, nonatomic) IBOutlet UITextField *placeLabel;
@property (weak, nonatomic) IBOutlet UIView *membersView;
@property (weak, nonatomic) IBOutlet TypePickerView *typePicker;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel *addMemberNotiLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *payMethodSeg;

-(void)updateMembers:(NSArray*)member;
-(void)setPlace:(NSString*)name Coordinate:(CLLocationCoordinate2D)coordinate;
@end
