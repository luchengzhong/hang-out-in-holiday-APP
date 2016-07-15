//
//  InvitationMessageCell.m
//  HOIH
//
//  Created by 钟路成 on 16/7/10.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "InvitationMessageCell.h"
#import "ImageUtil.h"
#import "DateUtil.h"

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
        NSString *date = [DateUtil formatDateFromDate:_cdMessage.create_time Type:@"Normal"];
        _timeLabel.text = date;
        
        NSString *type =_cdMessage.type;
        NSString *content = _cdMessage.content;
        NSString *typeStr = @"";
        if([type isEqualToString:@"change_place"]){
            typeStr = @"修改了地点";
            content = [NSString stringWithFormat:@"新地点：%@",_cdMessage.content];
        }else if([type isEqualToString:@"change_time"]){
            typeStr = @"修改了时间";
            content = [NSString stringWithFormat:@"新时间：%@",_cdMessage.content];
        }else if([type isEqualToString:@"user_comment"]){
            typeStr = @"消息";
            content = _cdMessage.content;
        }else if([type isEqualToString:@"change_comment"]){
            typeStr = @"修改了备注";
        }else if([type isEqualToString:@"change_status"]){
            if([content isEqualToString:@"1"]){
                content = @"接受了邀请";
                typeStr = @"接受";
            }else{
                content = @"拒绝了邀请";
                typeStr = @"拒绝";
            }
        }
        _contentLabel.text = content;
        _contentLabel.layer.borderWidth = 0.5;
        _contentLabel.layer.borderColor = [[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1] CGColor];
        //_contentLabel.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        _typeLabel.text = typeStr;
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
