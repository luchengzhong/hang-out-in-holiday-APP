//
//  AddInvitationController.m
//  HOIH
//
//  Created by 钟路成 on 16/7/11.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "AddInvitationController.h"
#import "InvitedLayer.h"
#import "CDFriends.h"
#import "DateUtil.h"
#import "InvitationTableViewController.h"
#import "AddPlaceMapViewController.h"

@interface AddInvitationController ()

@end
@implementation AddInvitationController{
    UIView *memView;
    NSDate *inviteDate;
    NSString *type;
    NSString *locationName;
    CLLocationCoordinate2D Lcoordinate;
    NSString *coordinateStr;
    NSString *pay_method;
    NSString *comment;
    
    NSArray *payMethods;
    NSArray *memArray;
    
    UIView *spinnerView;
    UIActivityIndicatorView * spinner;
    
    Boolean hasPlace;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [_typePicker attachData];
    payMethods = @[@"A-A",@"请客",@"其他"];
    hasPlace=false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Update
-(void)updateMembers:(NSArray*)members{
    memArray = members;
    if(!members)
        return;
    if([members count]==0){
        [_addMemberNotiLabel setHidden:false];
    }else{
        [_addMemberNotiLabel setHidden:true];
    }
    if(memView){
        [memView removeFromSuperview];
    }
    InvitedLayer *layer = [[InvitedLayer alloc] initWithGap:10];
    memView = [layer getInvitedLayer:members SourceView:_membersView];
    [_membersView addSubview:memView];
    [_membersView bringSubviewToFront:memView];
}
-(void)setPlace:(NSString*)name Coordinate:(CLLocationCoordinate2D)coordinate{
    locationName = name;
    Lcoordinate = coordinate;
    coordinateStr = [NSString stringWithFormat:@"%f;%f",Lcoordinate.latitude,Lcoordinate.longitude];
    _placeLabel.text =locationName;
    hasPlace = true;
}
#pragma mark - Button
- (IBAction)confirmInvitation:(id)sender {
    inviteDate = _inviteTimePicker.date;
    type = [_typePicker selectedString];
    locationName = _placeLabel.text;
    pay_method = payMethods[[_payMethodSeg selectedSegmentIndex]];
    comment = _commentTextField.text;
    if(!coordinateStr){
        coordinateStr = @"";
    }
    NSMutableArray *memberIDs = [NSMutableArray new];
    for(CDFriends *mem in memArray){
        [memberIDs addObject:mem.username];
    }
#warning todo .check avaliable
    
    HOIHHTTPClient *client = [HOIHHTTPClient sharedHTTPClient];
    client.delegate = self;
    [client addInvitationTime:[DateUtil formatDateFromDate:inviteDate Type:@"Normal"]
                   MemberUIDs:memberIDs
                         Type:type
                    PayMethod:pay_method
                    PlaceName:locationName
                   Coordinate:coordinateStr
                      Comment:comment];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    CGRect rect = [[UIScreen mainScreen] bounds];
    spinnerView = [[UIView alloc] initWithFrame:rect];
    UIColor *color = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
    [spinnerView setBackgroundColor:color];
    CGSize size = rect.size;
    CGFloat kScreenWidth = size.width;
    CGFloat kScreenHeight = self.tableView.frame.size.height;
    [spinner setCenter:CGPointMake(kScreenWidth/2.0 - 25, kScreenHeight/2.0)];
    [spinnerView addSubview:spinner];
    [self.tableView addSubview:spinnerView]; // spinner is not visible until started
    [spinner startAnimating];
    [self.tableView setUserInteractionEnabled:false];
}

#pragma mark - HTTP
-(void)HOIHHTTPClient:(HOIHHTTPClient *)client didAddInvitation:(id)result{
    NSLog(@"%@",result);
    InvitationTableViewController* controller = (InvitationTableViewController*)self.navigationController.viewControllers[[self.navigationController.viewControllers count] - 2];
    if([controller respondsToSelector:@selector(refresh)]){
        [controller refresh];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)HOIHHTTPClient:(HOIHHTTPClient *)client didFailWithError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失败"
                                                    message:@"网络连接失败，请重试！"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    [self.tableView setUserInteractionEnabled:true];
    [spinnerView removeFromSuperview];
    [spinner stopAnimating];
    [spinner removeFromSuperview];
}
#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}
*/
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
    if([segue.identifier isEqualToString:@"AddPlaceToMapView"]){
        if(hasPlace){
            AddPlaceMapViewController *controller = (AddPlaceMapViewController*)[segue destinationViewController];
            [controller setCoordinate:Lcoordinate Name:_placeLabel.text];
        }
    }
}


@end
