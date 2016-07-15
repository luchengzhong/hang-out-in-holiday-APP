//
//  InvitedMembersCollectionCell.h
//  HOIH
//
//  Created by 钟路成 on 16/7/15.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvitedMembersCollectionCell : UITableViewCell <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *membersCollection;

-(void)setMembers:(NSArray*)members;
@end
