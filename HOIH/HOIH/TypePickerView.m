//
//  TypePickerView.m
//  HOIH
//
//  Created by 钟路成 on 16/7/11.
//  Copyright © 2016年 Lucheng Zhong. All rights reserved.
//

#import "TypePickerView.h"

@implementation TypePickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)attachData{
    _pickerData =@[@"桌游",@"聚餐",@"开黑",@"KTV",@"旅游",@"Party",@"其他"];
    self.dataSource=self;
    self.delegate = self;
    [self reloadAllComponents];
}
// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}

-(NSString*)selectedString{
    return _pickerData[[self selectedRowInComponent:0]];
}
@end
