//
//  FriendInfoCell.m
//  HOIH
//
//  Created by 钟路成 on 16/7/11.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "FriendInfoCell.h"
#import "ImageUtil.h"

@implementation FriendInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCDFriend:(CDFriends*)cdFriend{
    _photoView.image = [ImageUtil roundedImageNamed:cdFriend.photo
                                            toWidth:_photoView.frame.size.width height:_photoView.frame.size.height];
    _nameLabel.text = cdFriend.name;
}
@end
