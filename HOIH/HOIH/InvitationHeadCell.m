//
//  InvitationHeadCell.m
//  HOIH
//
//  Created by 钟路成 on 16/7/10.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "InvitationHeadCell.h"
#import "DateUtil.h"
#import "ImageUtil.h"

static NSString *plusImageName = @"Plus";
static NSString *minusImageName = @"Minus";
@implementation InvitationHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setContent:(NSString*)content ShowButton:(Boolean)isShow{
    _contentLabel.text = content;
    [_extendButton setHidden:!isShow];
    _extendButton.imageView.image = [UIImage imageNamed:plusImageName];
    if(isShow){
        [self setSelectionStyle:UITableViewCellSelectionStyleGray];
    }else{
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
}
//-(void)setInvitation:(CDInvitation*)invitation Invitor:(CDFriends*)invitor{
    /*_inviterPhotoView.image =
    [ImageUtil roundedImageNamed:invitor.photo
                         toWidth:_inviterPhotoView.frame.size.width
                          height:_inviterPhotoView.frame.size.height];
    _invitorNameLabel.text = invitor.name;
    _timeLabel.text = [DateUtil formatDateFromDate:invitation.invite_time Type:@"Normal"];
    if(invitation.place_name)
        _placeLabel.text = invitation.place_name;
    else
        _placeLabel.text = @"未指定地点";*/
    /*_payMethodLabel.text = [NSString stringWithFormat:@"支付方式：%@",invitation.pay_method];
    if(invitation.place_name)
        _placeLabel.text = [NSString stringWithFormat:@"地点：%@",invitation.place_name];
    else
        _placeLabel.text = @"未指定地点";
    if(!invitation.coordinate || [invitation.coordinate length] == 0){
        //[self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [_showMapButton setHidden:true];
    }else{
        //[self setSelectionStyle:UITableViewCellSelectionStyleGray];
        [_showMapButton setHidden:false];
        _showMapButton.imageView.image = [UIImage imageNamed:plusImageName];
    }
}*/
-(void)setButton:(Boolean)extended{
    NSString *imgName = plusImageName;
    if(extended){
        imgName = minusImageName;
    }
    _extendButton.imageView.image = [UIImage imageNamed:imgName];
}
@end
