//
//  InvitationHeadCell.h
//  HOIH
//
//  Created by 钟路成 on 16/7/10.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDFriends.h"
#import "CDInvitation.h"
#import "InvitationDetailViewController.h"

@interface InvitationHeadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *extendButton;

@property (weak) InvitationDetailViewController *delegate;

-(void)setContent:(NSString*)content ShowButton:(Boolean)isShow;
//-(void)setInvitation:(CDInvitation*)invitation Invitor:(CDFriends*)invitor;
-(void)setButton:(Boolean)extended;
@end
