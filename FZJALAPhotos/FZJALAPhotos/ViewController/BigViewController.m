//
//  BigViewController.m
//  FZJALAPhotos
//
//  Created by fdkj0002 on 16/1/31.
//  Copyright © 2016年 FZJ.com. All rights reserved.
//

#import "BigViewController.h"
#import "FZJBigPhotoCell.h"
#import "FZJALAPhotosTool.h"
#import "UnderPhotoModel.h"
#define margin 30
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define iPHone6Plus ([UIScreen mainScreen].bounds.size.height == 736) ? YES : NO
#define iPHone6 ([UIScreen mainScreen].bounds.size.height == 667) ? YES : NO
#define iPHone5 ([UIScreen mainScreen].bounds.size.height == 568) ? YES : NO
#define iPHone4oriPHone4s ([UIScreen mainScreen].bounds.size.height == 480) ? YES : NO

@interface BigViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
@property(nonatomic,strong)UICollectionView * bigCollect;
@property(nonatomic,strong)UILabel * titleLable;
@property(nonatomic,strong)UILabel * displayLable;
@property(nonatomic,strong)UIButton * select;
@property(nonatomic,assign)float current;
@end

@implementation BigViewController
-(void)viewWillAppear:(BOOL)animated{
    [self.bigCollect setContentOffset:CGPointMake((self.clickInteger) * (SCREEN_WIDTH + margin), 0)];
    _titleLable.text = [NSString stringWithFormat:@"%d/%d",(int)(self.clickInteger + 1),(int)self.dataArray.count];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setSureButton];
    [self setBackButton:@"返回"];
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = margin;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, margin/2, 0, margin/2);
    flowLayout.itemSize = self.view.frame.size;
    
    _bigCollect = [[UICollectionView alloc] initWithFrame:CGRectMake(-margin/2, 0, SCREEN_WIDTH + margin, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
    [_bigCollect registerNib:[UINib nibWithNibName:@"FZJBigPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"BigPhotoCell"];
    _bigCollect.pagingEnabled = YES;
    _bigCollect.dataSource = self;
    _bigCollect.delegate = self;
    [self.view addSubview:_bigCollect];
    [self setTitleLable];
    [self addDisplayLable];
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UICollectionViewCell * )collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FZJBigPhotoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BigPhotoCell" forIndexPath:indexPath];
    cell.ImageView.image = nil;
    [cell showIndicator];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[FZJALAPhotosTool standardFZJALAPhotosTool] getFullScreenImageByALAssetUrl:self.dataArray[indexPath.row] Completion:^(UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.ImageView.image = image;
                [cell hideIndicator];
            });
        }];
    });
    _select.selected = [self currentPhoto:indexPath.row];
    cell.ScrollView.delegate = self;
    [self addGestureTapToScrollView:cell.ScrollView];
    return cell;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == (UIScrollView *)self.bigCollect) {
        CGFloat current = scrollView.contentOffset.x / (SCREEN_WIDTH + margin) + 1;
        _titleLable.text = [NSString stringWithFormat:@"%.f/%d",current,(int)self.dataArray.count];
        _current = current - 1;
    }
}
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    FZJBigPhotoCell * WillCell = (FZJBigPhotoCell *)cell;
    WillCell.ScrollView.zoomScale = 1;
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return scrollView.subviews[0];
}
-(void)addGestureTapToScrollView:(UIScrollView *)scrollView{
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapOnScrollView:)];
    singleTap.numberOfTapsRequired = 1;
    [scrollView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapOnScrollView:)];
    doubleTap.numberOfTapsRequired = 2;
    [scrollView addGestureRecognizer:doubleTap];
}
-(void)singleTapOnScrollView:(UITapGestureRecognizer *)singleTap{
    if (self.navigationController.navigationBar.isHidden) {
        [self showNavBarAndStatusBar];
    }else{
        [self hideNavBarAndStatusBar];
    }
}
-(void)showNavBarAndStatusBar{
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
}
-(void)hideNavBarAndStatusBar{
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarHidden = YES;
}
-(void)doubleTapOnScrollView:(UITapGestureRecognizer *)doubleTap{
    
    UIScrollView * scrollView = (UIScrollView *)doubleTap.view;
    CGFloat scale = 1;
    if (scrollView.zoomScale != 3) {
        scale = 3;
    }else{
        scale = 1;
    }
    [self CGRectForScale:scale WithCenter:[doubleTap locationInView:doubleTap.view] ScrollView:scrollView Completion:^(CGRect Rect) {
        [scrollView zoomToRect:Rect animated:YES];
    }];
}
-(void)CGRectForScale:(CGFloat)scale WithCenter:(CGPoint)center ScrollView:(UIScrollView *)scrollView Completion:(void(^)(CGRect Rect))completion{
    CGRect Rect;
    Rect.size.height = scrollView.frame.size.height / scale;
    Rect.size.width  = scrollView.frame.size.width  / scale;
    Rect.origin.x    = center.x - (Rect.size.width  /2.0);
    Rect.origin.y    = center.y - (Rect.size.height /2.0);
    completion(Rect);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setSureButton{
    UIButton * sure = [UIButton buttonWithType:UIButtonTypeSystem];
    _select = sure;
    sure.frame = CGRectMake(0, 0, 35, 35);
    [sure setBackgroundImage:[UIImage imageNamed:@"No"] forState:UIControlStateNormal];
    [sure setBackgroundImage:[UIImage imageNamed:@"AssetsPickerChecked"] forState:UIControlStateSelected];
    [sure addTarget:self action:@selector(sureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sure];
}
-(void)sureBtnClicked:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        UnderPhotoModel * model = [[UnderPhotoModel alloc] init];
        model.url = self.dataArray[(NSInteger)_current];
        [self.choosePhotoArray addObject:model];
        [self uploadDisplay];
    }else{
        for (UnderPhotoModel * model in self.choosePhotoArray) {
            if ([model.url.absoluteString isEqualToString:[self.dataArray[(NSInteger)_current] absoluteString]]) {
                [self.choosePhotoArray removeObject:model];
                [self uploadDisplay];
                return;
            }
        }
    }
}
-(void)uploadDisplay{
    self.displayLable.text = [NSString stringWithFormat:@"%d/%d",(int)self.choosePhotoArray.count,(int)self.addNum];
}
-(void)setTitleLable{
    _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    _titleLable.text = [NSString stringWithFormat:@"%d/%d",(int)self.clickInteger,(int)self.dataArray.count];
    _titleLable.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = _titleLable;
}
-(void)addDisplayLable{
    
    UILabel * display = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
    display.font = [UIFont systemFontOfSize:20];
    display.textAlignment = NSTextAlignmentCenter;
    display.textColor = [UIColor blackColor];
    display.text = [NSString stringWithFormat:@"%d/%d",(int)self.choosePhotoArray.count,(int)self.addNum];
    display.backgroundColor = [UIColor whiteColor];
    _displayLable = display;
    [self.view addSubview:display];
    
}
-(BOOL)currentPhoto:(NSInteger)integer{
    for (UnderPhotoModel * model in self.choosePhotoArray) {
        if ([model.url.absoluteString isEqualToString:[self.dataArray[integer] absoluteString]]) {
            return YES;
        }
    }
    return NO;
}
-(void)superBackBtnClicked{
    if (self.returnPhotoArray && self.choosePhotoArray.count != 0) {
        self.returnPhotoArray(self.choosePhotoArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
