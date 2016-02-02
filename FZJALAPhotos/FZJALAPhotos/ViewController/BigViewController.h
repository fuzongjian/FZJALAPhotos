//
//  BigViewController.h
//  FZJALAPhotos
//
//  Created by fdkj0002 on 16/1/31.
//  Copyright © 2016年 FZJ.com. All rights reserved.
//

#import "SuperViewController.h"

@interface BigViewController : SuperViewController
@property(nonatomic,strong)NSArray * dataArray;//数据源
@property(nonatomic,copy)void(^returnPhotoArray)(NSArray * array);
@property(nonatomic,strong)NSMutableArray * choosePhotoArray;
@property(nonatomic,assign)NSInteger clickInteger;
@property(nonatomic,assign)NSInteger addNum;
@end
