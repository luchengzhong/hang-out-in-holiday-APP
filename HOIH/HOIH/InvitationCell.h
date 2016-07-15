//
//  InvitationCell.h
//  HOIH
//
//  Created by 钟路成 on 16/5/30.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDInvitation.h"

@interface InvitationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *invitorPhoto;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIView *invitedContent;
@property (weak, nonatomic) IBOutlet UIView *backgroundRecView;
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *payMethodLabel;

@property CDInvitation *invitation;
@property NSDictionary* memberList;
-(void)setInvitation:(CDInvitation *)invitation MemberList:(NSDictionary*) memberList;
-(void)addInvitedUsers;
@end
