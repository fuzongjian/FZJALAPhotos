//
//  SmallViewController.h
//  FZJALAPhotos
//
//  Created by fdkj0002 on 16/1/31.
//  Copyright © 2016年 FZJ.com. All rights reserved.
//

#import "SuperViewController.h"
#import "FZJALAPhotosTool.h"
@interface SmallViewController : SuperViewController
@property(nonatomic,strong)ALAssetsGroup * group;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,assign)NSInteger addNum;
@property(nonatomic,copy)void(^getPhotoArrayFromAlbum)(NSArray * photoArray);
@end
