//
//  UnderTableViewController.m
//  FZJALAPhotos
//
//  Created by fdkj0002 on 16/1/31.
//  Copyright © 2016年 FZJ.com. All rights reserved.
//

#import "UnderTableViewController.h"
#import "EnterAlbumTableViewCell.h"
#import "FZJALAPhotosTool.h"
#import "SmallViewController.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface UnderTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSArray * dataArray;
@end

@implementation UnderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setSureButton:@"确定"];
    [self setBackButton:@"返回"];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"EnterAlbumTableViewCell" bundle:nil] forCellReuseIdentifier:@"EnterCell"];
    [[FZJALAPhotosTool standardFZJALAPhotosTool] getAllALbumListSuccess:^(id data) {
        self.dataArray = [NSArray arrayWithArray:data];
        [self.tableView reloadData];
    } Fail:^(NSError *error) {
        
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CELL = @"EnterCell";
    EnterAlbumTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL forIndexPath:indexPath];
    if (!cell) {
        cell = [[EnterAlbumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL];
    }
    PhotoAblumList * album = self.dataArray[indexPath.row];
    cell.firstImageView.image = album.firstImage;
    cell.numberLable.text = [NSString stringWithFormat:@"%ld",(long)album.count];
    cell.titleLable.text = album.title;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SmallViewController * small = [[SmallViewController alloc] init];
    small.index = indexPath.row;
    small.getPhotoArrayFromAlbum = self.getPhotoArrayFromAlbum;
    [self.navigationController pushViewController:small animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
