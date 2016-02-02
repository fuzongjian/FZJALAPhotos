//
//  SmallViewController.m
//  FZJALAPhotos
//
//  Created by fdkj0002 on 16/1/31.
//  Copyright © 2016年 FZJ.com. All rights reserved.
//

#import "SmallViewController.h"
#import "SmallCollectionViewCell.h"
#import "BigViewController.h"
#import "UnderPhotoModel.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define iPHone6Plus ([UIScreen mainScreen].bounds.size.height == 736) ? YES : NO
#define iPHone6 ([UIScreen mainScreen].bounds.size.height == 667) ? YES : NO
#define iPHone5 ([UIScreen mainScreen].bounds.size.height == 568) ? YES : NO
#define iPHone4oriPHone4s ([UIScreen mainScreen].bounds.size.height == 480) ? YES : NO

@interface SmallViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
/**
 *  创建collectionView用于展示
 */
@property(nonatomic,strong)UICollectionView * smallCollect;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSMutableArray * photoArray;
@property(nonatomic,strong)UILabel * displayLable;
@end

@implementation SmallViewController

-(void)viewWillAppear:(BOOL)animated{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.photoArray = [NSMutableArray array];
    [self setBackButton:@"返回"];
    [self setSureButton:@"确定"];
    [self addDisplayLable];
    
    self.dataArray = [NSMutableArray array];
    UICollectionViewFlowLayout * flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    [flowLayOut setScrollDirection:UICollectionViewScrollDirectionVertical];
    _smallCollect = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44) collectionViewLayout:flowLayOut];
    [self.view addSubview:_smallCollect];
    [_smallCollect registerNib:[UINib nibWithNibName:@"SmallCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SmallCell"];
    _smallCollect.delegate = self;
    _smallCollect.dataSource = self;
    _smallCollect.backgroundColor = [UIColor whiteColor];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[FZJALAPhotosTool standardFZJALAPhotosTool] getAllALbumListSuccess:^(id data) {
            [[FZJALAPhotosTool standardFZJALAPhotosTool] getAllAssetByAlbumName:[[data objectAtIndex:self.index] group]Completion:^(NSMutableArray *array) {
                for (ALAsset * asset in array) {
                    [self.dataArray addObject:[[asset defaultRepresentation]url]];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.smallCollect reloadData];
                });
                
            }];
        } Fail:^(NSError *error) {
            
        }];
        
    });
//This application is modifying the autolayout engin from a background thread,which can lead to engine corruption and weird crashes,This will cause an exception in a future rellease
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SmallCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SmallCell" forIndexPath:indexPath];
    [[FZJALAPhotosTool standardFZJALAPhotosTool] getThumbnailImageByALAssetUrl:self.dataArray[indexPath.row] Completion:^(UIImage *image) {
        cell.imageView.image = image;
    }];
    [cell.cellBtn addTarget:self action:@selector(cellBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.cellBtn.tag = indexPath.row;
    cell.cellBtn.selected = [self currentPhotoHave:indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BigViewController * big = [[BigViewController alloc] init];
    big.dataArray = _dataArray;
    big.choosePhotoArray = _photoArray;
    big.clickInteger = indexPath.row;
    big.returnPhotoArray = ^(NSArray * array){
        self.photoArray = [NSMutableArray arrayWithArray:array];
        [self.smallCollect reloadData];
    };
    [self.navigationController pushViewController:big animated:YES];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (iPHone6) {
        return CGSizeMake(87, 87);
    }else if (iPHone6Plus){
        return CGSizeMake(97, 97);
    }else{
        return CGSizeMake(100, 100);
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(5, 5, 0, 5);//上左下右
    
}
// 单元格最小间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
// 单元格最小行距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)cellBtnClicked:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        UnderPhotoModel * model = [[UnderPhotoModel alloc] init];
        model.url = self.dataArray[sender.tag];
        [_photoArray addObject:model];
        [self upLoadDisplay];
    }else{
        for (UnderPhotoModel * model in self.photoArray) {
            if ([model.url.absoluteString isEqualToString:[self.dataArray[sender.tag] absoluteString]]) {
                [_photoArray removeObject:model];
                [self upLoadDisplay];
                return;
            }
        }
    }
}
-(void)upLoadDisplay{
    _displayLable.text = [NSString stringWithFormat:@"%d/%d",(int)self.photoArray.count,(int)self.addNum];
}
-(BOOL)currentPhotoHave:(NSInteger)integer{
    for (UnderPhotoModel * model in self.photoArray) {
        if ([model.url.absoluteString isEqualToString:[self.dataArray[integer] absoluteString]]) {
            return YES;
        }
    }
    return NO;
}
-(void)addDisplayLable{
    
    UILabel * display = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
    display.font = [UIFont systemFontOfSize:20];
    display.textAlignment = NSTextAlignmentCenter;
    display.textColor = [UIColor blackColor];
    display.text = [NSString stringWithFormat:@"%d/%d",(int)self.photoArray.count,(int)self.addNum];
    display.backgroundColor = [UIColor whiteColor];
    _displayLable = display;
    [self.view addSubview:display];
    
}
-(void)superSureBtnClicked{
    if (self.getPhotoArrayFromAlbum && self.photoArray.count != 0) {
        self.getPhotoArrayFromAlbum(self.photoArray);
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
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
