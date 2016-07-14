//
//  InvSendMessageCell.m
//  HOIH
//
//  Created by 钟路成 on 16/7/13.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "InvSendMessageCell.h"
#import "DateUtil.h"

@implementation InvSendMessageCell{
    HOIHHTTPClient *hClient;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    hClient = [[HOIHHTTPClient alloc] initWithStaticURL];
    hClient.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)sendMessage:(id)sender {
    if(!_delegate)
        return;
    NSInteger textLength = [_contentTextField.text length];
    if(textLength == 0 || textLength > 20){
#warning todo.. alarm
        return;
    }
    [_contentTextField setEnabled:false];
    [_sendBt setEnabled:false];
    [_sendBt setTitle:@"发送中" forState:UIControlStateNormal];
    
    [hClient addMessageForInv:_delegate.invitation.iid Time:[DateUtil getCurrentNormalDateString] Content:_contentTextField.text];
}
-(void)HOIHHTTPClient:(HOIHHTTPClient *)client didSendMessage:(id)response{
    if(response[@"MID"]){
        [_delegate updateMessageByClient:hClient];
    }
}
-(void)HOIHHTTPClient:(HOIHHTTPClient *)client didUpdateMessages:(id)messages Invitation:(id)invitation{
    [_contentTextField setEnabled:true];
    _contentTextField.text = @"";
    [_sendBt setEnabled:true];
    [_sendBt setTitle:@"发送" forState:UIControlStateNormal];
    [_delegate HOIHHTTPClient:client didUpdateMessages:messages Invitation:invitation];
}
@end
