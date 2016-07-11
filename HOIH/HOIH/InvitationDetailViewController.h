//
//  InvitationDetailViewController.h
//  HOIH
//
//  Created by 钟路成 on 16/7/10.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDInvitation.h"
#import "HOIHHTTPClient.h"

@interface InvitationDetailViewController : UITableViewController <HOIHHTTPClientDelegate>
@property CDInvitation *invitation;
@property NSDictionary *userInfoDict;
@end
