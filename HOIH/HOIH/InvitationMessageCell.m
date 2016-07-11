//
//  InvitationMessageCell.m
//  HOIH
//
//  Created by 钟路成 on 16/7/10.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "InvitationMessageCell.h"
#import "ImageUtil.h"

@implementation InvitationMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMessageDict:(NSDictionary *)messageDict Photo:(CDFriends*)sender{
    _messageDict = messageDict;
    _sender = sender;
    if(_messageDict){
        NSString *type =_messageDict[@"type"];
        NSString *content = @"";
        if([type isEqualToString:@"change_place"]){
            content = [NSString stringWithFormat:@"修改了地点：%@",_messageDict[@"content"]];
        }else if([type isEqualToString:@"change_time"]){
            content = [NSString stringWithFormat:@"修改了时间：%@",_messageDict[@"content"]];
        }else if([type isEqualToString:@"change_comment"]){
            content = _messageDict[@"content"];
        }
        _contentLabel.text = content;
    }
    if(_sender){
        _photoView.image = [ImageUtil roundedImageNamed:_sender.photo
                                                toWidth:_photoView.frame.size.width height:_photoView.frame.size.height];
        _senderNameLabel.text = _sender.name;
    }
}
@end
