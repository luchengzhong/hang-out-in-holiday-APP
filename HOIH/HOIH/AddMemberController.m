//
//  AddMemberController.m
//  HOIH
//
//  Created by 钟路成 on 16/7/12.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "AddMemberController.h"
#import "AddInvitationController.h"
#import "CDFriends.h"
#import "CDFriendsManager.h"
#import "ImageUtil.h"
@interface AddMemberController ()

@end

@implementation AddMemberController{
    UIButton *bt;
    NSMutableArray *memArray;
    NSArray *friendsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView setEditing:true];
    CGRect frame = self.view.frame;
    CGFloat height = 40;
    bt = [[UIButton alloc] initWithFrame:CGRectMake(0, frame.origin.y+frame.size.height-height-self.tabBarController.tabBar.frame.size.height, frame.size.width, height)];
    [bt setTitle:@"确认" forState:UIControlStateNormal];
    bt.titleLabel.textColor = [UIColor whiteColor];
    bt.backgroundColor = [UIColor blueColor];
    [self.tableView addSubview:bt];
    [self.view bringSubviewToFront:bt];
    [bt addTarget:self
                 action:@selector(confirm)
       forControlEvents:UIControlEventTouchDown];
    
    CDFriendsManager *fm = [[CDFriendsManager alloc] init];
    friendsArray = [[fm getFriendsFromCoreData] allValues];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect frame = bt.frame;
    frame.origin.y = scrollView.contentOffset.y + self.tableView.frame.size.height - bt.frame.size.height - self.tabBarController.tabBar.frame.size.height;
    bt.frame = frame;
    
    [self.view bringSubviewToFront:bt];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [friendsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if(indexPath.section==0){
        CDFriends *friend = friendsArray[indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:@"AddMemberCell" forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"photo_%@",friend.photo]];
        //[ImageUtil roundedImageNamed:friend.photo toWidth:cell.imageView.frame.size.width height:cell.imageView.frame.size.height];
        cell.textLabel.text = friend.name;
    }
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if(indexPath.section==1)
        return NO;
    return YES;
}

#pragma mark - confirm
-(void)confirm{
    memArray = [NSMutableArray new];
    NSArray *indexPathArray = [self.tableView indexPathsForSelectedRows];
    for(NSIndexPath *index in indexPathArray){
        [memArray addObject:friendsArray[index.row]];
    }
    AddInvitationController *controller = (AddInvitationController *)self.navigationController.viewControllers[[self.navigationController.viewControllers count] - 2];
    if([controller respondsToSelector:@selector(updateMembers:)]){
        [controller updateMembers:memArray];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
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
