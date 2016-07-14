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
@property (weak, nonatomic) IBOutlet UIImageView *invitorPhotoView;
@property (weak, nonatomic) IBOutlet UILabel *invitorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *inviteTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;




@property CDInvitation *invitation;
@property NSDictionary *userInfoDict;

-(void)updateMessage;
-(void)updateMessageByClient:(HOIHHTTPClient*)client;
@end
