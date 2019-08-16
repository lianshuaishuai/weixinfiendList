//
//  ViewController.m
//  https://github.com/c6357/YUChineseSorting
//
//  Created by BruceYu on 15/4/19.
//  Copyright (c) 2015年 BruceYu. All rights reserved.
//

#import "ViewController.h"
#import "ChineseString.h"

#define APP_WIDTH [[UIScreen mainScreen]applicationFrame].size.width
#define APP_HEIGHT [[UIScreen mainScreen]applicationFrame].size.height

@interface ViewController ()
@property(nonatomic,strong)NSMutableArray *indexArray;
@property(nonatomic,strong)NSMutableArray *letterResultArr;

@property (nonatomic, strong) UILabel *sectionTitleView;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.sectionTitleView = ({
            UILabel *sectionTitleView = [[UILabel alloc] initWithFrame:CGRectMake((APP_WIDTH-100)/2, (APP_HEIGHT-100)/2,100,100)];
            sectionTitleView.textAlignment = NSTextAlignmentCenter;
            sectionTitleView.font = [UIFont boldSystemFontOfSize:60];
            sectionTitleView.textColor = [UIColor blueColor];
            sectionTitleView.backgroundColor = [UIColor whiteColor];
            sectionTitleView.layer.cornerRadius = 6;
            sectionTitleView.layer.borderWidth = 1.f/[UIScreen mainScreen].scale;
            _sectionTitleView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        sectionTitleView;
    });
    [self.navigationController.view addSubview:self.sectionTitleView];
    self.sectionTitleView.hidden = YES;
    self.tableView.sectionIndexColor= [UIColor redColor];
//    self.tableView.section
    NSArray *stringsToSort = [NSArray arrayWithObjects:
                              @"￥hhh, .$",@" ￥Chin ese ",@"开源中国 ",@"www.oschina.net",
                              @"开源技术",@"社区",@"开发者",@"传播",
                              @"2014",@"a1",@"100",@"中国",@"暑假作业",
                              @"键盘", @"鼠标",@"hello",@"world",@"b1",
                              nil];
    self.indexArray = [ChineseString IndexArray:stringsToSort];
    [self.indexArray insertObject:UITableViewIndexSearch atIndex:0];
    self.letterResultArr = [ChineseString LetterSortArray:stringsToSort];
    [self.letterResultArr insertObject:@[] atIndex:0];
    NSLog(@"%@",self.letterResultArr);
}


#pragma mark -
#pragma mark - UITableViewDataSource

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.indexArray;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    NSString *key = [self.indexArray objectAtIndex:section];
//    return key;
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.indexArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.letterResultArr objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSLog(@"78====%ld",indexPath.section);
    NSLog(@"78====%ld",indexPath.row);
    NSLog(@"78====%@",[self.letterResultArr objectAtIndex:indexPath.section]);
    cell.textLabel.text = [[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    NSLog(@"909090====%ld",section);
    for (UIView *view in [tableView subviews]) {
        if ([view isKindOfClass:[NSClassFromString(@"UITableViewIndex") class]]) {
            // 设置字体大小
            [view setValue:[UIFont systemFontOfSize:15] forKey:@"_font"];
            //设置view的大小
            view.bounds = CGRectMake(0, 0, 30, 30);
            //单单设置其中一个是无效的
        }
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
//    [self showSectionTitle:title];
    if (index == 0) {
        
        [tableView setContentOffset:CGPointZero animated:NO];
        
        return NSNotFound;
        
    }
    
    return index;
    

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.001f;
    }else{
        return 20;
    }
}

#pragma mark - private
- (void)timerHandler:(NSTimer *)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.3 animations:^{
            self.sectionTitleView.alpha = 0;
        } completion:^(BOOL finished) {
            self.sectionTitleView.hidden = YES;
        }];
    });
}

-(void)showSectionTitle:(NSString*)title{
    [self.sectionTitleView setText:title];
    self.sectionTitleView.hidden = NO;
    self.sectionTitleView.alpha = 1;
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerHandler:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}



#pragma mark - 
#pragma mark - UITableViewDelegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lab = [UILabel new];
    lab.backgroundColor = [UIColor groupTableViewBackgroundColor];
    lab.text = [self.indexArray objectAtIndex:section];
    lab.textColor = [UIColor blueColor];
    return lab;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"---->%@",[[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:[[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]
                                                   delegate:nil
                                          cancelButtonTitle:@"YES" otherButtonTitles:nil];
    [alert show];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
