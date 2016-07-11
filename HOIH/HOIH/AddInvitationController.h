//
//  AddInvitationController.h
//  HOIH
//
//  Created by 钟路成 on 16/7/11.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypePickerView.h"

@interface AddInvitationController : UITableViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *inviteTimePicker;
@property (weak, nonatomic) IBOutlet UITextField *placeLabel;
@property (weak, nonatomic) IBOutlet UIView *membersView;
@property (weak, nonatomic) IBOutlet UIView *labelsView;
@property (weak, nonatomic) IBOutlet TypePickerView *typePicker;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end
