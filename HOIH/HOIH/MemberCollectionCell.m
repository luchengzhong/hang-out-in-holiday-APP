//
//  MemberCollectionCell.m
//  HOIH
//
//  Created by 钟路成 on 16/7/15.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "MemberCollectionCell.h"
#import "ImageUtil.h"

@implementation MemberCollectionCell


-(void)setMember:(NSDictionary*)members{
    if(members){
        _photoView.image = [ImageUtil imageShortNamed:members[@"photo"]];
        _nameLabel.text = members[@"name"];
        NSInteger status = [members[@"status"] integerValue];
        NSString *statusIconName = @"wondering";
        if(status == 0){
            statusIconName = @"wondering";
        }else if(status == -1){
            statusIconName = @"reject";
        }else if(status == 1){
            statusIconName = @"ok";
        }
        _stateImageView.image = [UIImage imageNamed:statusIconName];
    }
}
@end
