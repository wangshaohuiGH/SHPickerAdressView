//
//  SHPickerView.h
//  SHPickerAdressView
//
//  Created by wangsh on 2018/2/24.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectAddressBlock)(NSString *select,NSString *title);

@interface SHPickerView : UIView

/** 设置选中的省-市-区 要有连接符(-) */
@property (nonatomic,strong)NSString *showSelectTitle;

/** block 选择回调 */
@property (nonatomic,copy)SelectAddressBlock addressBlock;

/** 初始化方法 CGRectZero  */
- (instancetype)initWithFrame:(CGRect)frame FileName:(NSString *)fileName;

/** show */
-(void)show;
@end
