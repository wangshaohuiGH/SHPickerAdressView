//
//  SHPickerView.m
//  SHPickerAdressView
//
//  Created by wangsh on 2018/2/24.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "SHPickerView.h"
#import "SHAdressModel.h"

#define SCREEN [UIScreen mainScreen].bounds.size
@interface SHPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>{
    
    SHAdressModel *_selectProvinceModel;
    SHAdressModel *_selectCityModel;
    SHAdressModel *_selectCountryModel;
    
}
@property (nonatomic,strong)UIPickerView *pickerView;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)NSArray *dataArray;
@end

/** 传参回调连接符 */
static NSString *const tempStr = @"-";

@implementation SHPickerView

- (instancetype)initWithFrame:(CGRect)frame FileName:(NSString *)fileName {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self dataConfigWithFileName:fileName];
        [self uiConfiguer];
    }
    return self;
}

- (void)dataConfigWithFileName:(NSString *)fileName {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    
    self.dataArray = [SHAdressModel initDLAddressModelWithArray:[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableLeaves error:nil]];
    
    //取出省
    _selectProvinceModel = self.dataArray.firstObject;
    
    //取市
    _selectCityModel = _selectProvinceModel.city.firstObject;
    
    //取出区
    
    _selectCountryModel = _selectCityModel.city.firstObject;
    
    
}
- (void)setShowSelectTitle:(NSString *)showSelectTitle {
    
    if (![showSelectTitle containsString:showSelectTitle]) {
        return;
    }
    NSArray *titleArray = [showSelectTitle componentsSeparatedByString:tempStr];
    if (titleArray.count == 3) {
        
        NSUInteger index = 0;
        NSUInteger index1 = 0;
        NSUInteger index2 = 0;
        NSUInteger index3 = 0;
        
        for (SHAdressModel *model in self.dataArray) {
            if ([model.name isEqualToString:titleArray.firstObject]) {
                index = [self.dataArray indexOfObject:model];
                _selectProvinceModel = model;
                break;
            }
        }
        index1 = index;
        SHAdressModel *cityModel = self.dataArray[index1];
        for (SHAdressModel *model in cityModel.city) {
            if ([model.name isEqualToString:titleArray[1]]) {
                index = [cityModel.city indexOfObject:model];
                _selectCityModel = model;
                break;
            }
        }
        index2 = index;
        SHAdressModel *countryModel = cityModel.city[index2];
        for (SHAdressModel *model in countryModel.city) {
            if ([model.name isEqualToString:titleArray.lastObject]) {
                index = [countryModel.city indexOfObject:model];
                _selectCountryModel = model;
                break;
            }
        }
        index3 = index;
        
        [self.pickerView selectRow:index1 inComponent:0 animated:NO];
        [self.pickerView selectRow:index2 inComponent:1 animated:NO];
        [self.pickerView selectRow:index3 inComponent:2 animated:NO];
        
    }
    
}
-(void)uiConfiguer{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN.height, SCREEN.width, 260)];
    _bgView.backgroundColor = [UIColor orangeColor];
    _bgView.userInteractionEnabled = YES;
    [self addSubview:_bgView];
    
    UIButton * cancelBtn =[[UIButton alloc]initWithFrame:CGRectMake(15, 5, 40, 30)];
    [cancelBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bgView addSubview:cancelBtn];
    
    UIButton * completeBtn=[[UIButton alloc]initWithFrame:CGRectMake( SCREEN.width-50, 5, 40, 30)];
    [completeBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bgView addSubview:completeBtn];
    
    _pickerView = [[UIPickerView alloc]init];
    _pickerView.frame = CGRectMake(0, CGRectGetMaxY(completeBtn.frame)+5, SCREEN.width, _bgView.frame.size.height-CGRectGetMaxY(completeBtn.frame)-5);
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.backgroundColor = [UIColor whiteColor];
    [_bgView addSubview:_pickerView];
    
    
}
//  设置对应的字体大小
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (SCREEN.width-30)/3,40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component]; // 数据源
    return label;
}
-(void)btnClicked:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"取消"]) {
        [self dismis];
    } else {
        if (self.addressBlock) {
            self.addressBlock( [NSString stringWithFormat:@"%@%@%@%@%@",_selectProvinceModel.address_id,tempStr,_selectCityModel.address_id,tempStr,_selectCountryModel.address_id],[NSString stringWithFormat:@"%@%@%@%@%@",_selectProvinceModel.name,tempStr,_selectCityModel.name,tempStr,_selectCountryModel.name]);
            
        }
        [self dismis];
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
//多少行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger result = 0;
    if (component == 0) {
        result = self.dataArray.count;
    }
    else if (component== 1){
        result = _selectProvinceModel.city.count;
    }
    else if (component == 2){
        result = _selectCityModel.city.count;
    }
    
    return result;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    SHAdressModel *model;
    if (component == 0 ) {
        model = self.dataArray[row];
    } else if (component== 1){
        model = _selectProvinceModel.city[row];
    } else if (component== 2){
        model = _selectCityModel.city[row];
    }
    return model.name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //滚动一区的时候
    if (component == 0) {
        
        _selectProvinceModel = self.dataArray[row];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
        _selectCityModel = _selectProvinceModel.city.firstObject;
        
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        _selectCountryModel = _selectCityModel.city.firstObject;
        
        //滚动二区的时候
    } else if (component == 1) {
        _selectCityModel = _selectProvinceModel.city[row];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        _selectCountryModel = _selectCityModel.city.firstObject;
        
    }else {
        _selectCountryModel = _selectCityModel.city[row];
    }
    
}

- (void)show {
    self.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame =_bgView.frame;
        frame.origin.y = SCREEN.height - _bgView.frame.size.height;
        _bgView.frame = frame;
    }];
}
- (void)dismis {
    [UIView animateWithDuration:0.3 animations:^{
         CGRect frame =_bgView.frame;
        frame.origin.y = SCREEN.height;
        _bgView.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

@end
