//
//  SHAdressModel.m
//  SHPickerAdressView
//
//  Created by wangsh on 2018/2/24.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "SHAdressModel.h"

@implementation SHAdressModel
+ (NSArray *)initDLAddressModelWithArray:(NSArray *)array {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        SHAdressModel *model = [SHAdressModel new];
        model.type = DLAddressProvince;
        model.name = dic[@"name"];
        model.address_id = dic[@"id"];
        NSMutableArray *arr2 = [NSMutableArray array];
        for (NSDictionary *temp in dic[@"city"]) {
            SHAdressModel *model = [SHAdressModel new];
            model.type = DLAddressCity;
            model.name = temp[@"name"];
            model.address_id = temp[@"id"];
            NSMutableArray *arr3 = [NSMutableArray array];
            for (NSDictionary *temp2 in temp[@"city"]) {
                SHAdressModel *model = [SHAdressModel new];
                model.type = DLAddressCounty;
                model.name = temp2[@"name"];
                model.address_id = temp2[@"id"];
                model.city = @[];
                [arr3 addObject:model];
            }
            model.city = [NSArray arrayWithArray:arr3];
            [arr2 addObject:model];
        }
        model.city = [NSArray arrayWithArray:arr2];
        [arr addObject:model];
    }
    return [NSArray arrayWithArray:arr];
}
@end
