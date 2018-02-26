//
//  ViewController.m
//  SHPickerAdressView
//
//  Created by wangsh on 2018/2/24.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "SHPickerView.h"
@interface ViewController ()
@property (nonatomic,strong)UILabel *label;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(30, 200, 280, 30);
    label.backgroundColor = [UIColor groupTableViewBackgroundColor];
    label.userInteractionEnabled = YES;
    [self.view addSubview:label];
    self.label = label;
    
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickLabelSelectAction)];
    [label addGestureRecognizer:tapGest];

    
    NSLog(@"feature");

    NSLog(@"做出了一些修改");

    // Do any additional setup after loading the view, typically from a nib.
}
- (void)clickLabelSelectAction {
    SHPickerView *pickView = [[SHPickerView alloc]initWithFrame:CGRectZero FileName:@"city_full.json"];
    pickView.showSelectTitle = self.label.text;
    [pickView show];
    __weak __typeof(&*self)weakSelf = self;
    pickView.addressBlock = ^(NSString *select, NSString *title) {
        NSLog(@"%@\n%@",select,title);
        weakSelf.label.text = title;
        
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
