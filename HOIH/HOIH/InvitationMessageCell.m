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
            typeStr = NSLocalizedString(@"Change Place", nil);
            content = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"New Place", nil),_cdMessage.content];
        }else if([type isEqualToString:@"change_time"]){
            typeStr = NSLocalizedString(@"Change Date", nil);
            content = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"New Date", nil),_cdMessage.content];
        }else if([type isEqualToString:@"user_comment"]){
            typeStr = NSLocalizedString(@"Message", nil);
            content = _cdMessage.content;
        }else if([type isEqualToString:@"change_comment"]){
            typeStr = NSLocalizedString(@"Change Comment", nil);
        }else if([type isEqualToString:@"change_status"]){
            if([content isEqualToString:@"1"]){
                content = NSLocalizedString(@"Accepted the invitaion", nil);
                typeStr = NSLocalizedString(@"Accepted", nil);
            }else{
                content = NSLocalizedString(@"Refused the invitation", nil);
                typeStr = NSLocalizedString(@"Refused", nil);
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
