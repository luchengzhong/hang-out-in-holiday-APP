//
//  InvitedMembersCollectionCell.m
//  HOIH
//
//  Created by 钟路成 on 16/7/15.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "InvitedMembersCollectionCell.h"
#import "MemberCollectionCell.h"

@implementation InvitedMembersCollectionCell{
    NSArray *memberArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setMembers:(NSArray*)members{
    _membersCollection.backgroundColor = [UIColor whiteColor];
    _membersCollection.dataSource = self;
    _membersCollection.delegate =self;
    memberArray = members;
    [_membersCollection reloadData];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    if(indexPath.section == 0){
        MemberCollectionCell *mCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MemberCollectionCell" forIndexPath:indexPath];
        [mCell setMember:memberArray[indexPath.row]];
        CGFloat width = self.frame.size.width/2 - 5;
        CGRect frame = self.frame;
        frame.size.width = width;
        [cell setFrame:frame];
        cell = mCell;
    }
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        CGFloat width = _membersCollection.frame.size.width/2 - 10;
        return CGSizeMake(width, 43.f);
    }
    return CGSizeMake(0, 0);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(section == 0){
        if(memberArray)
            return [memberArray count];
        return 0;
    }
    return 0;
}
@end
