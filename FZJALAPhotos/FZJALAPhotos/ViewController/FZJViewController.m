//
//  FZJViewController.m
//  FZJALAPhotos
//
//  Created by fdkj0002 on 16/1/30.
//  Copyright © 2016年 FZJ.com. All rights reserved.
//

#import "FZJViewController.h"
#import "FZJALAPhotosTool.h"
#import "UnderTableViewController.h"
#import "DisplayCollectionViewCell.h"
#import "UnderPhotoModel.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface FZJViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property(nonatomic,strong)NSMutableArray * photoArray;
@property(nonatomic,strong)UICollectionView * collect;

@end

@implementation FZJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configFZJViewControllerUI];
}
#pragma mark --
#pragma mark 初始化UI
-(void)configFZJViewControllerUI{
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 100)];
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"bg-4"];
    [self.view addSubview:imageView];
    
    self.photoArray = [NSMutableArray array];
    
    UICollectionViewFlowLayout * layOut = [[UICollectionViewFlowLayout alloc] init];
    [layOut setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    UICollectionView * collect = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 40, 100) collectionViewLayout:layOut];
    collect.backgroundColor = [UIColor whiteColor];
    collect.delegate = self;
    collect.dataSource = self;
    [imageView addSubview:collect];
    _collect = collect;
    [collect registerNib:[UINib nibWithNibName:@"DisplayCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"display"];
    [self enterAlbum];
    
}
#pragma mark--
#pragma mark 数据请求
-(void)enterAlbum{
    UnderTableViewController * under = [[UnderTableViewController alloc] init];
    under.getPhotoArrayFromAlbum = ^(NSArray * photoArray){
        self.photoArray = [NSMutableArray arrayWithArray:photoArray];
        [self.collect reloadData];
    };
    [self.navigationController pushViewController:under animated:YES];
    

}
#pragma mark--
#pragma mark 数据加载

#pragma mark--
#pragma mark 事件

#pragma mark--
#pragma mark  代理
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photoArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DisplayCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"display" forIndexPath:indexPath];
    cell.ImageView.image = nil;
    UnderPhotoModel * model = self.photoArray[indexPath.row];
    [[FZJALAPhotosTool standardFZJALAPhotosTool] getThumbnailImageByALAssetUrl:model.url Completion:^(UIImage *image) {
        cell.ImageView.image = image;
    }];
    return cell;
}
/**
 *  上下左右的间隔
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(5, 5, 5, 5);//上左下右
    
}
/**
 *  单元格最小间距
 */
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
/**
 *  单元格最小行距
 */
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(90, 90);
}
#pragma mark--
#pragma mark 通知注册及销毁


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
