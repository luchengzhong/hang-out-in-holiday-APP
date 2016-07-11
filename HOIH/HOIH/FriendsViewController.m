//
//  FriendsViewController.m
//  HOIH
//
//  Created by 钟路成 on 16/7/11.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendInfoCell.h"

@interface FriendsViewController (){
    CDFriendsManager *friendManager;
    NSArray *friendsArray;
}

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    friendManager = [CDFriendsManager new];
    friendManager.delegate = self;
    friendsArray = [self dictToArray:[friendManager updateFriends]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray*)dictToArray:(NSDictionary*)dict{
    NSArray *keys = [dict allKeys];
    NSMutableArray *array = [NSMutableArray new];
    for(NSString* key in keys){
        [array addObject:dict[key]];
    }
    return array;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [friendsArray count];;
}

#pragma mark - HTTP
-(void)CDFriendsManager:(CDFriendsManager *)manager didUpdateUserinfos:(NSDictionary *)userinfos Time:(NSString *)date{
    friendsArray = [self dictToArray:userinfos];
    [self.tableView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendInfoCell" forIndexPath:indexPath];
    [cell setCDFriend:friendsArray[indexPath.row]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
