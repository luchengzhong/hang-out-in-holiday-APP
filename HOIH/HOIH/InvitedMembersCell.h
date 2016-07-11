//
//  InvitedMembersCell.h
//  HOIH
//
//  Created by 钟路成 on 16/7/10.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvitedMembersCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;

-(void)setMembers:(NSArray*)members UsersInfoDict:(NSDictionary*)userInfoDict;
@end
