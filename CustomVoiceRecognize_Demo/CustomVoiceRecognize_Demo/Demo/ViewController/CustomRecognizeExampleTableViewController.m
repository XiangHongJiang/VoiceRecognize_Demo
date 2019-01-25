//
//  CustomDrawExampleTableViewController.m
//  CustomVoiceRecognize_Demo
//
//  Created by MrYeL on 2018/7/19.
//  Copyright © 2018年 MrYeL. All rights reserved.
//

#import "CustomRecognizeExampleTableViewController.h"
#import "VoiceRecognizerManager.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

//  是否是iPhoneX
#define iPhoneX (([UIScreen mainScreen].bounds.size.height / [UIScreen mainScreen].bounds.size.width) > 1.78 ? YES : NO)
//  导航栏高度
#define NAVIGATION_BAR_HEIGHT (iPhoneX ? 88.f : 64.f)



@interface CustomRecognizeExampleTableViewController ()

/** 数据Array*/
@property (nonatomic, copy) NSArray * dataArray;
/** HeaderView*/
@property (nonatomic, strong) UIView * headerView;
/** 识别的文字*/
@property (nonatomic, weak) UILabel * textLabel;
/** 识别对象*/
@property (nonatomic, strong) VoiceRecognizerManager * voiceManager;

@end

@implementation CustomRecognizeExampleTableViewController

#pragma mark - Lazy Load
- (UIView *)headerView {
    
    if (_headerView == nil) {
        
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, kScreenWidth, 200)];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 20)];
        titleLabel.text = @"识别结果";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_headerView addSubview:titleLabel];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20 + 20 + 20, kScreenWidth - 30, 100)];
        [_headerView addSubview:textLabel];
        self.textLabel = textLabel;
    }
    return _headerView;
    
}
- (VoiceRecognizerManager *)voiceManager {
    if (_voiceManager == nil) {
        _voiceManager = [VoiceRecognizerManager VoiceRecognizerWithRecognizeType:RecognizeType_Online];
    }
    return _voiceManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = @[@"开始识别",@"停止"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    UIView *headerView = self.headerView;
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableFooterView = [UIView new];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = indexPath.row;
    UITableViewCell *baseCell  = [tableView cellForRowAtIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    
    switch (index) {
        case 0://开始识别
        {
            self.textLabel.text = @"识别中…";
            [self.voiceManager startRecognizeWithFile:nil andComplete:^(VoiceRecognizerManager *manger, NSString *resultStr, NSString *errorStr) {
                
                weakSelf.textLabel.text = resultStr.length>0?resultStr:errorStr;
                
            }];
            baseCell.textLabel.text = @"重新开始";
        }
            break;
            
        case 1://停止识别
            [self.voiceManager stopRecognize:nil];
            self.textLabel.text = @"";
            
            break;
        default:
            break;
    }
    
}
- (void)dealloc {
    
    NSLog(@"deallocd:");
}

@end
