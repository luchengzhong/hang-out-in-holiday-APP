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
#import "HOIHUserInfo.h"
#import "InvitationTableViewController.h"
#import "InvSendMessageCell.h"
#import "CDMessageManager.h"
#import "CDMessage.h"

@interface InvitationDetailViewController (){
    NSArray *memArray;
    NSArray *messageArray;
    UIView *confirmView;
    UIButton *confirmBt;
    UIButton *rejectBt;
    Boolean showSendMessageCell;
    
    UIView *sendMessageView;
    
    NSString *NavTitle;
}

@end

@implementation InvitationDetailViewController
static NSInteger invSec = 0;
- (void)viewDidLoad {
    [super viewDidLoad];
    NavTitle = @"";
    showSendMessageCell=false;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    //self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    //self.refreshControl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [self.refreshControl addTarget:self
                            action:@selector(refreshMessages)
                  forControlEvents:UIControlEventValueChanged];
    
    if(_invitation){
        memArray = [_invitation getMembersArray];
    }
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];
    
    NSString *username = [HOIHUserInfo getUsername];
    if([username isEqualToString:_invitation.inviter_id]){
        [self addEditBarButton];
        [self addSendMessageView];
    }else{
        for(NSDictionary *dict in memArray){
            if([dict[@"UID"] isEqualToString:username]){
                if([dict[@"status"] isEqualToString:@"0"]){
                    NavTitle = @"待处理";
                    [self addConfirmButtons];
                }else if([dict[@"status"] isEqualToString:@"1"]){
                    NavTitle = @"已接受";
                    [self addSendMessageView];
                }else if([dict[@"status"] isEqualToString:@"-1"]){
                    NavTitle = @"已拒绝";
                    [self addRejectView];
                }
            }
        }
    }
    self.navigationItem.title = NavTitle;
    
    [self refreshMessages];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)refreshMessages{
    
    CDMessageManager *mMana = [CDMessageManager new];
    messageArray = [mMana getMessageFromCoreData:_invitation.iid];
    
    [self updateMessage];
}
-(void)updateMessage{
    HOIHHTTPClient *client = [HOIHHTTPClient sharedHTTPClient];
    client.delegate = self;
    self.navigationItem.title = @"正在载入消息...";
    [self updateMessageByClient:client];
}
-(void)updateMessageByClient:(HOIHHTTPClient*)client{
    NSString *date = nil;
    if([messageArray count]>0){
        date = [DateUtil formatDateFromDate:((CDMessage*)messageArray[0]).create_time Type:@"Normal"];
    }
    [client getMessages:_invitation.iid Time:date];
}
#pragma mark - Views
-(void)addRejectView{
    self.navigationItem.title = @"已拒绝";
}
-(void)addSendMessageView{
    showSendMessageCell=true;
    [self.tableView reloadData];
}
-(void)addEditBarButton{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editInv)];
    self.navigationItem.rightBarButtonItem = item;
}
-(void)addConfirmButtons{
    CGRect frame = self.view.frame;
    CGFloat height = 40;
    if(confirmView){
        [confirmView removeFromSuperview];
    }
    
    confirmView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.origin.y+frame.size.height-height-self.tabBarController.tabBar.frame.size.height, frame.size.width, height)];
    
    confirmBt = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width/3, 0, frame.size.width/3*2, height)];
    [confirmBt setTitle:@"确认加入" forState:UIControlStateNormal];
    [confirmBt setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    confirmBt.backgroundColor = [UIColor greenColor];
    [confirmBt addTarget:self
           action:@selector(confirmInv)
 forControlEvents:UIControlEventTouchDown];
    
    rejectBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width/3, height)];
    [rejectBt setTitle:@"拒绝" forState:UIControlStateNormal];
    [rejectBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rejectBt.backgroundColor = [UIColor redColor];
    [rejectBt addTarget:self
                  action:@selector(rejectInv)
        forControlEvents:UIControlEventTouchDown];
    
    [confirmView addSubview:confirmBt];
    [confirmView addSubview:rejectBt];
    
    [self.tableView addSubview:confirmView];
    [self.view bringSubviewToFront:confirmView];
    
    [self.tableView scrollsToTop];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect frame = confirmView.frame;
    frame.origin.y = scrollView.contentOffset.y + self.tableView.frame.size.height - confirmView.frame.size.height - self.tabBarController.tabBar.frame.size.height;
    confirmView.frame = frame;
    
    [self.view bringSubviewToFront:confirmView];
}

#pragma mark - Action
-(void)confirmInv{
    HOIHHTTPClient *client = [HOIHHTTPClient sharedHTTPClient];
    client.delegate = self;
    [client updateStatus:@"1" IID:_invitation.iid];
    [confirmView setUserInteractionEnabled:false];
    [self addSpinerToBt:confirmBt];
}
-(void)addSpinerToBt:(UIButton*)bt{
    [confirmBt setTitle:@"" forState:UIControlStateNormal];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    CGRect rect = bt.frame;
    CGSize size = rect.size;
    CGFloat kScreenWidth = size.width;
    CGFloat kScreenHeight = size.height;
    [spinner setCenter:CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0)];
    
    [bt addSubview:spinner];
    [spinner startAnimating];
}

-(void)rejectInv{
    HOIHHTTPClient *client = [HOIHHTTPClient sharedHTTPClient];
    client.delegate = self;
    [client updateStatus:@"-1" IID:_invitation.iid];
    [confirmView setUserInteractionEnabled:false];
    [self addSpinerToBt:confirmBt];
}
-(void)editInv{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(_invitation && _userInfoDict){
        return 2;
    }
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
        CDMessage* message = messageArray[indexPath.row];
        
        NSString *name = @"";
        NSString *photo = @"0";
        if(_userInfoDict[message.uid]){
            CDFriends *sender = _userInfoDict[message.uid];
            name = sender.name;
            photo = sender.photo;
            //[cell setMessage:message Photo:_userInfoDict[message.uid]];
        }else{
            for(NSDictionary *dict in memArray){
                if([dict[@"UID"] isEqualToString:message.uid]){
                    name = dict[@"name"];
                    photo = dict[@"photo"];
                    break;
                }
            }
        }
        [cell setMessage:message SenderName:name SenderPhoto:photo];
        //[cell setMessageDict:message.content Photo:_userInfoDict[message.uid]];
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
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(!sendMessageView){
        InvSendMessageCell *cell;
        if(showSendMessageCell && section==1){
            cell = [tableView dequeueReusableCellWithIdentifier:@"InvSendMessage"];
            if(!cell){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InvSendMessage" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.delegate = self;
        }
        sendMessageView = [[UIView alloc] initWithFrame:[cell frame]];
        [sendMessageView addSubview:cell];
    }
    return sendMessageView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(showSendMessageCell && section==1){
        return 60;
    }
    return 0;
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
-(void)HOIHHTTPClient:(HOIHHTTPClient *)client didUpdateMessages:(id)messages Invitation:(id)invitation{
    
    /*
    NSRange range = NSMakeRange(1, 1);
    NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
    
    [self.tableView beginUpdates];
    [self.tableView reloadSections:section withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];*/
    
    self.navigationItem.title = NavTitle;
    [self.refreshControl endRefreshing];
    //update invitation, core data update in messages
    [_invitation setDict:invitation[0]];
    //update messages
    if([messages count] == 0)
        return;
    NSInteger nbRowToDelete = 0;
    /*if(messageArray)
        nbRowToDelete = [messageArray count];*/
    NSInteger nbRowToInsert = nbRowToDelete + [messages count];
    
    //inser to core data
    CDMessageManager *manager = [CDMessageManager new];
    NSMutableArray *newMessages = [NSMutableArray arrayWithArray:[manager addMessageFromDicts:messages]];
    messageArray = [[newMessages arrayByAddingObjectsFromArray:messageArray] mutableCopy];
    
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < nbRowToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:1]];
    }
    
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < nbRowToDelete; i++) {
        [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:1]];
    }
    
    [self.tableView beginUpdates];
    NSRange range = NSMakeRange(invSec, invSec);
    NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.tableView reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    
}
-(void)HOIHHTTPClient:(HOIHHTTPClient *)client didUpdateStatus:(id)result{
    if([result integerValue] == 1){
        [confirmView removeFromSuperview];
        [self addSendMessageView];
        
    }else if([result integerValue] == -1){
        [confirmView removeFromSuperview];
        
    }else if([result integerValue] == -2){
        [self addConfirmButtons];
    }
    InvitationTableViewController *control = self.navigationController.viewControllers[[self.navigationController.viewControllers count]-2];
    if([control respondsToSelector:@selector(refresh)]){
        [control refresh];
    }
}
-(void)HOIHHTTPClient:(HOIHHTTPClient *)client didFailWithError:(NSError *)error{
    if(confirmView && !confirmView.userInteractionEnabled){
        [self addConfirmButtons];
    }
}

@end
