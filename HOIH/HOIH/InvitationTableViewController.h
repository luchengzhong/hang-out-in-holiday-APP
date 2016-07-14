//
//  InvitationTableViewController.h
//  HOIH
//
//  Created by 钟路成 on 16/5/30.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDInvitationManager.h"

@interface InvitationTableViewController : UITableViewController <CDInvitationManagerDelegate, CDFriendsManagerDelegate>
-(void)refresh;
@end
