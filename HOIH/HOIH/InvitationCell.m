//
//  InvitationCell.m
//  HOIH
//
//  Created by 钟路成 on 16/5/30.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "InvitationCell.h"
#import "InvitedLayer.h"
#import "ImageUtil.h"
#import "DateUtil.h"
#import "CDFriends.h"

@implementation InvitationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _backgroundRecView.layer.borderColor = [[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1] CGColor];
    _backgroundRecView.layer.borderWidth = 1.f;
    [_backgroundRecView setAlpha:1];
    //_cardView.layer.masksToBounds=false;
    //_backgroundRecView.layer.cornerRadius = 4.0f;
    //_cardView.layer.shadowOffset = CGSizeMake(-0.02f, 0.02f);
    //_cardView.layer.shadowRadius = _cardView.layer.cornerRadius;
    //UIBezierPath* path = [UIBezierPath bezierPathWithRect:_cardView.layer.bounds];
    //_cardView.layer.shadowPath = path.CGPath;
    //_cardView.layer.shadowOpacity = 0.2;
    
    //[_backgroundRecView.layer setBackgroundColor:[UIColor whiteColor].CGColor];
    //[_backgroundRecView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    //[_backgroundRecView.layer setBorderWidth:1.0f];
    
    //[self convertToRoundImage:_invitorPhoto BorderColor:[UIColor whiteColor] BorderWidth:0.0f];
    
    //[_invitedContent addSubview:[[InvitedLayer new] getInvitedLayer:nil SourceView:_invitedContent]];
    //_nameLabel.text = @"钟路成";
    //_placeLabel.text = @"临平大酒店";
    //_dateLabel.text = @"2015-06-13 15:40";
    //self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_bg"]];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _commentLabel.layer.borderColor = [[UIColor colorWithRed:0.2784 green:0.5961 blue:0.7176 alpha:1] CGColor];
    _commentLabel.layer.borderWidth = 0.4f;
    _commentLabel.backgroundColor = [UIColor whiteColor];
    _commentLabel.layer.cornerRadius = 10.0f;
    _commentLabel.layer.masksToBounds=true;
    
    _invitedContent.layer.borderColor = [[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1] CGColor];
    _invitedContent.layer.borderWidth = 1.f;
    _invitedContent.backgroundColor = [UIColor whiteColor];
    _invitedContent.layer.cornerRadius = 10.0f;
    _invitedContent.layer.masksToBounds=true;
    
    _payMethodLabel.textColor = [UIColor whiteColor];
}

#pragma mark - Invitation data source
-(void)setInvitation:(CDInvitation *)invitation MemberList:(NSDictionary*) memberList{
    _memberList = memberList;
    _invitation = invitation;
    _dateLabel.text = [DateUtil formatDateFromDate:invitation.invite_time Type:@"Normal"];
    //_placeLabel.text = [NSString stringWithFormat:@"%ld", [invitation.iid longValue]];
    NSString *comment = invitation.comment;
    /*if(![invitation.pay_method isEqualToString:@"其他"])
        comment = [NSString stringWithFormat:@"%@",invitation.pay_method,comment];*/
    _commentLabel.text = comment;
    if([invitation.pay_method isEqualToString:@"请客"]){
        _payMethodLabel.backgroundColor = [UIColor colorWithRed:0.1529 green:0.6824 blue:0.3764 alpha:1];
    }else if([invitation.pay_method isEqualToString:@"A-A"]){
        _payMethodLabel.backgroundColor = [UIColor redColor];
    }else{
        _payMethodLabel.backgroundColor = [UIColor yellowColor];
    }
    
    _placeLabel.text = invitation.place_name;
    _typeImage.image = [ImageUtil typeImage:invitation.type];
    _typeLabel.text = invitation.type;
    _payMethodLabel.text = invitation.pay_method;
    
    CDFriends *invitor = (CDFriends*)memberList[invitation.inviter_id];
    _nameLabel.text = invitor.name;
    NSString *photoNmae = [NSString stringWithFormat:@"photo_%@",invitor.photo];
    _invitorPhoto.image = [ImageUtil roundedImage:[UIImage imageNamed:photoNmae]];
    
    
    [self addInvitedUsers];
}
-(void)addInvitedUsers{
    NSArray *array = [_invitedContent subviews];
    for(UIView *view in array){
        [view removeFromSuperview];
    }
    [_invitedContent addSubview:[[InvitedLayer new] getInvitedLayer:[_invitation getMembersArray] SourceView:_invitedContent MemberInfo:_memberList]];
    
}
-(void)convertToRoundImage:(UIImageView*)imageView BorderColor:(UIColor*)borderColor BorderWidth:(CGFloat)borderWidth{
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = imageView.frame.size.width * 0.5;
    [imageView.layer setBorderColor:borderColor.CGColor];
    [imageView.layer setBorderWidth:borderWidth];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
