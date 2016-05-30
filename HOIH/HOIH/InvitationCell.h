//
//  InvitationCell.h
//  HOIH
//
//  Created by 钟路成 on 16/5/30.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvitationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *invitorPhoto;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UIView *invitedContent;
@property (weak, nonatomic) IBOutlet UIView *backgroundRecView;
-(void)addInvitedUsers;
@end
