//
//  InvitationTableViewController.m
//  HOIH
//
//  Created by 钟路成 on 16/5/30.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "InvitationTableViewController.h"
#import "InvitationCell.h"
#import "CDInvitation.h"
#import "HOIHHTTPClient.h"
#import "DateUtil.h"
#import "InvitationDetailViewController.h"
#import <MapKit/MapKit.h>
#import <LGSideMenuController.h>
#import "AppDelegate.h"

@interface InvitationTableViewController ()

@end

@implementation InvitationTableViewController{
    //CDFriendsManager *memManager;
    CDInvitationManager *invManager;
    NSArray *invitationList;
    NSDictionary *membersList;
    UIActivityIndicatorView *spinner;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"假日潇洒小组";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //HOIHHTTPClient *client = [HOIHHTTPClient sharedHTTPClient];
    //[client getInvitations:@"luchengzhong" Time:@""];
    //fm = [CDFriendsManager new];
    //[fm updateFriends];
    
    //self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_bg3"]];
    self.tableView.backgroundColor =[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    //self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    //self.refreshControl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    
    [self refresh];
    
    /*if(spinner == nil){
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGRect rect = [[UIScreen mainScreen] bounds];
        CGSize size = rect.size;
        CGFloat kScreenWidth = size.width;
        CGFloat kScreenHeight = self.tableView.frame.size.height;
        [spinner setCenter:CGPointMake(kScreenWidth/2.0 - 25, kScreenHeight/2.0)];
    }
    [self.tableView addSubview:spinner]; // spinner is not visible until started
    [spinner startAnimating];*/
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Data load
-(void)refresh{
    invManager = [CDInvitationManager new];
    invManager.delegate = self;
    invitationList = [invManager updateInvitationsForPage:0];
    membersList = invManager.membersDict;
    [self.refreshControl beginRefreshing];
    [self.tableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height) animated:YES];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(invitationList)
        return 1;
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(invitationList)
        return [invitationList count];
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CDInvitation *invitation = invitationList[indexPath.row];
    InvitationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvitationCell" forIndexPath:indexPath];
    [cell setInvitation:invitation MemberList:membersList];
    // Configure the cell...
    
    return cell;
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"ShowInvitationDetail"]) {
        InvitationDetailViewController *controller = [segue destinationViewController];
        controller.invitation = invitationList[self.tableView.indexPathForSelectedRow.row];
        controller.userInfoDict = membersList;
    }
}
- (IBAction)showProfile:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    LGSideMenuController *controller = appDelegate.mainPageController;
    if(controller)
        [controller showLeftViewAnimated:YES completionHandler:nil];
}


#pragma mark - Delegate Methods
//update Invitation first, at this time, update members request has been sent
-(void)CDInvitationManager:(CDInvitationManager *)manager didUpdateInvitations:(NSArray *)invitations{
    if(invitations){
        invitationList = invitations;
    }else{
        [self.refreshControl endRefreshing];
    }
}
//update members
-(void)CDFriendsManager:(CDFriendsManager *)manager didUpdateUserinfos:(NSDictionary *)userinfos Time:(NSString *)date{
    membersList = userinfos;
    [spinner stopAnimating];
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}
@end
