//
//  InvitationDetailViewController.m
//  HOIH
//
//  Created by 钟路成 on 16/7/10.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "InvitationDetailViewController.h"
#import "InvitationHeadCell.h"
#import "InvitedMembersCell.h"
#import "InvitationMessageCell.h"
#import "ImageUtil.h"
#import "CDFriends.h"
#import "DateUtil.h"

@interface InvitationDetailViewController (){
    NSArray *memArray;
    NSArray *messageArray;
}

@end

@implementation InvitationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if(_invitation){
        memArray = [_invitation getMembersArray];
    }
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];
    HOIHHTTPClient *client = [HOIHHTTPClient sharedHTTPClient];
    client.delegate = self;
    [client getMessages:[NSString stringWithFormat:@"%@",_invitation.iid]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(_invitation && _userInfoDict)
        return 2;
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 2;
    }
    if(section == 1){
        if(messageArray)
            return [messageArray count];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *rCell;
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            InvitationHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvitationHead" forIndexPath:indexPath];
            CDFriends *invitor = (CDFriends*)(_userInfoDict[_invitation.inviter_id]);
            [cell setInvitation:_invitation Invitor:invitor];
            rCell = cell;
        }else if(indexPath.row == 1){
            InvitedMembersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvitedMembers" forIndexPath:indexPath];
            [cell setMembers:memArray UsersInfoDict:_userInfoDict];
            rCell = cell;
        }
    }else if(indexPath.section == 1){
        InvitationMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvitationMessages" forIndexPath:indexPath];
        NSDictionary *message =messageArray[indexPath.row];
        [cell setMessageDict:message Photo:_userInfoDict[message[@"UID"]]];
        rCell = cell;
    }
    
    // Configure the cell...
    
    return rCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    switch(indexPath.section){
        case 0:
            if(indexPath.row==0){
                height = 115;
            }else{
                height =100;
            }
            break;
        case 1:
            height = 60;
            break;
    }
    return height;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - HTTP
-(void)HOIHHTTPClient:(HOIHHTTPClient *)client didUpdateMessages:(id)messages{
    messageArray = messages;
    [self.tableView reloadData];
}
@end
