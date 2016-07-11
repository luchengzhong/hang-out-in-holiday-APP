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

@interface InvitationHeadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *inviterPhotoView;
@property (weak, nonatomic) IBOutlet UILabel *invitorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;

-(void)setInvitation:(CDInvitation*)invitation Invitor:(CDFriends*)invitor;
@end
