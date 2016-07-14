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

-(void)setMessage:(CDMessage *)message SenderName:(NSString*)name SenderPhoto:(NSString*)photo{
    _cdMessage = message;
    if(_cdMessage){
        NSString *type =_cdMessage.type;
        NSString *content = @"";
        if([type isEqualToString:@"change_place"]){
            content = [NSString stringWithFormat:@"修改了地点：%@",_cdMessage.content];
        }else if([type isEqualToString:@"change_time"]){
            content = [NSString stringWithFormat:@"修改了时间：%@",_cdMessage.content];
        }else if([type isEqualToString:@"user_comment"]){
            content = _cdMessage.content;
        }else if([type isEqualToString:@"change_comment"]){
            content = [NSString stringWithFormat:@"修改了备注：%@",_cdMessage.content];
        }else if([type isEqualToString:@"change_status"]){
            content = _cdMessage.content;
            if([content isEqualToString:@"1"]){
                content = @"接受了邀请";
            }else{
                content = @"拒绝了邀请";
            }
        }
        _contentLabel.text = content;
    }
    if(name){
        _senderNameLabel.text = name;
        
    }
    if(photo){
        _photoView.image = [ImageUtil roundedImageNamed:photo
                                                toWidth:_photoView.frame.size.width height:_photoView.frame.size.height];
    }
}
@end
