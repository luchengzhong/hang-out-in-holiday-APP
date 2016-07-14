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

@implementation InvitationHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setInvitation:(CDInvitation*)invitation Invitor:(CDFriends*)invitor{
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
}
@end
