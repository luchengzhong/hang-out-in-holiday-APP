//
//  InvitationMessageCell.h
//  HOIH
//
//  Created by 钟路成 on 16/7/10.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDFriends.h"

@interface InvitationMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *senderNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property NSDictionary* messageDict;
@property CDFriends *sender;
-(void)setMessageDict:(NSDictionary *)messageDict Photo:(CDFriends*)sender;
@end
