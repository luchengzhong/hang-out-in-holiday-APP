//
//  InvSendMessageCell.h
//  HOIH
//
//  Created by 钟路成 on 16/7/13.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvitationDetailViewController.h"
#import "HOIHHTTPClient.h"

@interface InvSendMessageCell : UITableViewCell <HOIHHTTPClientDelegate>
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendBt;

@property (weak) InvitationDetailViewController *delegate;
@end
