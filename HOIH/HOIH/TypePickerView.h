//
//  TypePickerView.h
//  HOIH
//
//  Created by 钟路成 on 16/7/11.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypePickerView : UIPickerView <UIPickerViewDataSource,UIPickerViewDelegate>
@property NSArray* pickerData;

-(void)attachData;
-(NSString*)selectedString;
@end
