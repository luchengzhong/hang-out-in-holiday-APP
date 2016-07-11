//
//  InvitedMembersCell.m
//  HOIH
//
//  Created by 钟路成 on 16/7/10.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "InvitedMembersCell.h"
#import "InvitedLayer.h"

@implementation InvitedMembersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMembers:(NSArray*)members UsersInfoDict:(NSDictionary*)userInfoDict{
    [_backView addSubview:({
        InvitedLayer* view = [[InvitedLayer alloc] initWithGap:10];
        [view getInvitedLayer:members SourceView:_backView MemberInfo:userInfoDict];
    })];
}

@end
