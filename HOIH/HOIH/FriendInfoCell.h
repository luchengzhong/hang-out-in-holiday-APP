//
//  FriendInfoCell.h
//  HOIH
//
//  Created by 钟路成 on 16/7/11.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDFriends.h"

@interface FriendInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

-(void)setCDFriend:(CDFriends*)cdFriend;
@end
