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
#import "InvitationMapCell.h"
#import "InvitedMembersCollectionCell.h"
typedef enum {
    rPayMethod,
    rPlaceName,
    rPlaceMap,
    rMemHead,
    rMemCollection,
    rCount
} rowForBasicInfo;
@interface InvitationDetailViewController (){
    CLLocationManager *locationManager;
    NSArray *memArray;
    NSArray *messageArray;
    
    UIView *confirmView;
    UIButton *confirmBt;
    UIButton *rejectBt;
    
    Boolean showSendMessageCell;
    UIView *sendMessageView;
    
    NSString *NavTitle;//navigation title
    
    CGRect initialFrame;//head frame
    HOIHHTTPClient *detailClient;
    
    Boolean showMap;//if show place map
    Boolean showMembers;//if show member collection
}

@end

@implementation InvitationDetailViewController
static NSInteger invSec = 0;
- (void)viewDidLoad {
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    showMap=false;
    showMembers=true;
    NavTitle = @"";
    showSendMessageCell=false;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    //self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
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
                    NavTitle = NSLocalizedString(@"New", nil);
                    [self addConfirmButtons];
                }else if([dict[@"status"] isEqualToString:@"1"]){
                    NavTitle = NSLocalizedString(@"Accepted", nil);
                    [self addSendMessageView];
                }else if([dict[@"status"] isEqualToString:@"-1"]){
                    NavTitle = NSLocalizedString(@"Refused", nil);
                    [self addRejectView];
                }
            }
        }
    }
    self.navigationItem.title = NavTitle;
    [self initHead];
    [self refreshMessages];
    [self.view bringSubviewToFront:self.refreshControl];
    
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
    detailClient = [[HOIHHTTPClient alloc] initWithStaticURL];
    detailClient.delegate = self;
    self.navigationItem.title = NSLocalizedString(@"Loading...", nil);
    [self updateMessageByClient:detailClient];
}
-(void)updateMessageByClient:(HOIHHTTPClient*)client{
    NSString *date = nil;
    if([messageArray count]>0){
        date = [DateUtil formatDateFromDate:((CDMessage*)messageArray[0]).create_time Type:@"Normal"];
    }
    [client getMessages:_invitation.iid Time:date];
}
#pragma mark - scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(confirmView){
        CGRect frame = confirmView.frame;
        frame.origin.y = scrollView.contentOffset.y + self.tableView.frame.size.height - confirmView.frame.size.height - self.tabBarController.tabBar.frame.size.height;
        confirmView.frame = frame;
        
        [self.view bringSubviewToFront:confirmView];
    }
    [self updateScrollLayout];
}
-(void)updateScrollLayout{
    CGRect frame = initialFrame;
    CGRect overlayFrame = initialFrame;
    CGRect textFrame = initialFrame;
    //CGRect temp = self.tableView.frame;
    if(self.tableView.contentOffset.y < 0) {
        frame.origin.x += self.tableView.contentOffset.y/2;
        frame.origin.y += self.tableView.contentOffset.y;
        frame.size.height -= self.tableView.contentOffset.y;
        //frame.origin.y=-900;
        frame.size.width -= self.tableView.contentOffset.y;
        
        textFrame.origin.y -=self.tableView.contentOffset.y;
        textFrame.origin.x -=self.tableView.contentOffset.y/2;
        overlayFrame.origin.x -= self.tableView.contentOffset.y/2;
        overlayFrame.size.height -= self.tableView.contentOffset.y;
    }
    //double dy = frame.origin.y - initialFrame.origin.y -_tripHeaderView.transform.ty;
    //_tripHeaderView.transform = CGAffineTransformMakeTranslation(0,
    //                                                            -900);
    //[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    //self.tableView.tableHeaderView.frame = frame;
    
    _headImageView.frame = frame;
    //_headView.frame = textFrame;
    //_tripHeaderView.bounds = frame;
    //[self.tableView setTableHeaderView:_tripHeaderView];
    
    [self.view bringSubviewToFront:self.refreshControl];
}

#pragma mark - Views
-(void)initHead{
    if(!_invitation)
        return;
    
    //self.navigationController.navigationBar.alpha = 0.9f;
    CDFriends *invitor = _userInfoDict[_invitation.inviter_id];
    _invitorPhotoView.image =
    [ImageUtil roundedImageNamed:invitor.photo
                         toWidth:_invitorPhotoView.frame.size.width
                          height:_invitorPhotoView.frame.size.height];
    _invitorNameLabel.text = invitor.name;
    _inviteTimeLabel.text = [DateUtil formatDateFromDate:_invitation.invite_time Type:@"Normal"];
   /* if(_invitation.place_name)
        .text = _invitation.place_name;
    else
        _placeLabel.text = @"未指定地点";*/
    if(_invitation.comment && [_invitation.comment length]>0){
        _commentLabel.text = _invitation.comment;
    }
    _typeImageView.image = [ImageUtil typeImage:_invitation.type];
    _typeLabel.text = _invitation.type;
    //_headImageView.contentMode = UIViewContentModeScaleAspectFit;
    _headImageView.image = [UIImage imageNamed:@"detail_bg2"];
    initialFrame = _headImageView.frame;
    [_headView sendSubviewToBack:_headImageView];
    
    [self.tableView bringSubviewToFront:self.refreshControl];
    [self.refreshControl setTintColor:[UIColor whiteColor]];
    
    [self updateScrollLayout];
    [self.tableView scrollsToTop];
    
    [self.tableView setTableHeaderView:_headView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self updateScrollLayout];
    });
    /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        UIImage *bk = [ImageUtil typeGaussImage:_invitation.type];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(_headImageView){
                _headImageView.contentMode = UIViewContentModeScaleToFill;
                _headImageView.image = bk;
                [_headView sendSubviewToBack:_headImageView];
                _headView.backgroundColor = [UIColor colorWithPatternImage:bk];
            }
        });
    });*/
}
-(void)addRejectView{
    self.navigationItem.title = NSLocalizedString(@"Refused", nil);;
}
-(void)addSendMessageView{
    showSendMessageCell=true;
    [self.tableView reloadData];
}
-(void)addEditBarButton{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", nil) style:UIBarButtonItemStyleDone target:self action:@selector(editInv)];
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
    [confirmBt setTitle:NSLocalizedString(@"Confirm", nil) forState:UIControlStateNormal];
    [confirmBt setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    confirmBt.backgroundColor = [UIColor colorWithRed:0.1529 green:0.6824 blue:0.3764 alpha:1];
    [confirmBt addTarget:self
           action:@selector(confirmInv)
 forControlEvents:UIControlEventTouchDown];
    
    rejectBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width/3, height)];
    [rejectBt setTitle:NSLocalizedString(@"Refuse", nil) forState:UIControlStateNormal];
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
#pragma mark - Table view action
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        NSIndexPath *modifyPath = nil;
        Boolean isShown =false;
        NSMutableArray *arrayBefore = [self getRowIndexArray];
        NSMutableArray *array;
        if(indexPath.row == [arrayBefore[rPlaceName] integerValue]){
            if(!_invitation.coordinate || [_invitation.coordinate length]==0){
                return;
            }
            if(showMap){
                array = [self getRowIndexArray];
                showMap =!showMap;
            }else{
                showMap =!showMap;
                array = [self getRowIndexArray];
            }
            
            modifyPath = [NSIndexPath indexPathForRow:[array[rPlaceMap] integerValue] inSection:0];
            isShown = showMap;
            
        }if(indexPath.row == [arrayBefore[rMemHead] integerValue]){
            if(showMembers){
                array = [self getRowIndexArray];
                showMembers =!showMembers;
            }else{
                showMembers =!showMembers;
                array = [self getRowIndexArray];
            }
            modifyPath = [NSIndexPath indexPathForRow:[array[rMemCollection] integerValue] inSection:0];
            isShown = showMembers;
        }
        if(modifyPath){
            InvitationHeadCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell setButton:isShown];
            if(isShown){
                [tableView insertRowsAtIndexPaths:@[modifyPath] withRowAnimation:UITableViewRowAnimationTop];
            }else{
                [tableView deleteRowsAtIndexPaths:@[modifyPath] withRowAnimation:UITableViewRowAnimationTop];
            }
            
        }
    }else if(indexPath.section == 1){
        
    }
}

#pragma mark - Table view data source
- (NSMutableArray*)getRowIndexArray{
    NSMutableArray *array = [NSMutableArray new];
    NSInteger index=0;
    while([array count] < rCount){
        NSInteger currentRowIndex = index;
        switch ([array count]) {
            case rPlaceMap:
                if(!showMap){
                    currentRowIndex=-1;
                    index--;
                }
                break;
            case rMemCollection:
                if(!showMembers){
                    currentRowIndex=-1;
                    index--;
                }
                break;
        }
        index++;
        [array addObject:[NSNumber numberWithInteger:currentRowIndex]];
    }
    return array;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(_invitation && _userInfoDict){
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        NSInteger count = rCount;
        if(!showMap)
            count--;
        if(!showMembers)
            count--;
        return count;
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
        NSMutableArray *indexArray = [self getRowIndexArray];
        if(indexPath.row == [indexArray[rPayMethod] integerValue]){
            InvitationHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvitationHead" forIndexPath:indexPath];
            //CDFriends *invitor = (CDFriends*)(_userInfoDict[_invitation.inviter_id]);
            [cell setContent:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Pay:", nil),_invitation.pay_method] ShowButton:false];
            rCell = cell;
        }else if(indexPath.row == [indexArray[rPlaceName] integerValue]){
            InvitationHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvitationHead" forIndexPath:indexPath];
            NSString *placeStr;
            if(_invitation.place_name)
                placeStr = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Place:", nil),_invitation.place_name];
            else
                placeStr = NSLocalizedString(@"No location", nil);
            
            Boolean shown =true;
            if(!_invitation.coordinate || [_invitation.coordinate length] == 0){
                shown=false;
            }
            [cell setContent:placeStr ShowButton:shown];
            [cell setButton:showMap];
            rCell = cell;
        }else if(indexPath.row == [indexArray[rPlaceMap] integerValue]){
            InvitationMapCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvitationMap" forIndexPath:indexPath];
            [cell setCoordinatesStr:_invitation.coordinate];
            rCell = cell;
        }else if(indexPath.row == [indexArray[rMemHead] integerValue]){
            InvitationHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvitationHead" forIndexPath:indexPath];
            //CDFriends *invitor = (CDFriends*)(_userInfoDict[_invitation.inviter_id]);
            [cell setContent:NSLocalizedString(@"Members", nil) ShowButton:true];
            [cell setButton:showMembers];
            rCell = cell;
        }else if(indexPath.row == [indexArray[rMemCollection] integerValue]){
            InvitedMembersCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvitatedMemberCollection" forIndexPath:indexPath];
            //[cell setMembers:memArray UsersInfoDict:_userInfoDict];
            [cell setMembers:memArray];
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
    NSArray *array = [self getRowIndexArray];
    switch(indexPath.section){
        case 0:
            if(indexPath.row == [array[rMemCollection] integerValue]){
                NSInteger num = [memArray count];
                NSInteger rowNum = num/2 +num%2;
                height = rowNum*43 +(rowNum-1)*30;
            }else if(indexPath.row == [array[rPlaceMap] integerValue]){
                height = 200;
            }else{
                height = 34;
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
    if(section == 1){
        if(!sendMessageView){
            InvSendMessageCell *cell;
            if(showSendMessageCell && section==1){
                cell = [tableView dequeueReusableCellWithIdentifier:@"InvSendMessage"];
                if(!cell){
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InvSendMessage" owner:self options:nil];
                    cell = [nib objectAtIndex:0];
                }
                cell.delegate = self;
                
                CGRect frame = [cell frame];
                frame.size.width = tableView.frame.size.width;
                [cell setFrame:frame];
            }
            sendMessageView = [[UIView alloc] initWithFrame:[cell frame]];
            [sendMessageView addSubview:cell];
        }
        return sendMessageView;
    }
    return nil;
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
