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

@implementation InvitationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_backgroundRecView setAlpha:1];
    //_cardView.layer.masksToBounds=false;
    _backgroundRecView.layer.cornerRadius = 4.0f;
    //_cardView.layer.shadowOffset = CGSizeMake(-0.02f, 0.02f);
    //_cardView.layer.shadowRadius = _cardView.layer.cornerRadius;
    //UIBezierPath* path = [UIBezierPath bezierPathWithRect:_cardView.layer.bounds];
    //_cardView.layer.shadowPath = path.CGPath;
    //_cardView.layer.shadowOpacity = 0.2;
    
    [_backgroundRecView.layer setBackgroundColor:[UIColor whiteColor].CGColor];
    [_backgroundRecView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_backgroundRecView.layer setBorderWidth:1.0f];
    
    //[self convertToRoundImage:_invitorPhoto BorderColor:[UIColor whiteColor] BorderWidth:0.0f];
    
    //[_invitedContent addSubview:[[InvitedLayer new] getInvitedLayer:nil SourceView:_invitedContent]];
    //_nameLabel.text = @"钟路成";
    //_placeLabel.text = @"临平大酒店";
    //_dateLabel.text = @"2015-06-13 15:40";
    _invitorPhoto.image = [ImageUtil roundedImage:[UIImage imageNamed:@"zhonglucheng"]];
}
-(void)addInvitedUsers{
    [_invitedContent addSubview:[[InvitedLayer new] getInvitedLayer:nil SourceView:_invitedContent]];
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
