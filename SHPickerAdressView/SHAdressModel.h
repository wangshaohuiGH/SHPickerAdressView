//
//  SHAdressModel.h
//  SHPickerAdressView
//
//  Created by wangsh on 2018/2/24.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, DLAddressTpye) {
    DLAddressProvince,
    DLAddressCity,
    DLAddressCounty,
};
@interface SHAdressModel : NSObject

@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *address_id;
@property (nonatomic,strong)NSArray *city;
@property (nonatomic,assign)DLAddressTpye type;

+ (NSArray *)initDLAddressModelWithArray:(NSArray *)array;
@end
