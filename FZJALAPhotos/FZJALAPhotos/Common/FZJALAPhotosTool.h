//
//  FZJALAPhotosTool.h
//  FZJALAPhotos
//
//  Created by fdkj0002 on 16/1/30.
//  Copyright © 2016年 FZJ.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface PhotoAblumList:NSObject
@property (nonatomic, copy) NSString *title; //相册名字
@property (nonatomic, assign) NSInteger count; //该相册内相片数量
@property(nonatomic,strong) UIImage * firstImage;//第一张照片
@property(nonatomic,strong) ALAssetsGroup * group;// 相册集  通过该属性可以去到该相册下的所有照片
@end

typedef void(^SuccessBlock) (id data);
typedef void(^FailBlock) (NSError * error);
@interface FZJALAPhotosTool : NSObject

+(instancetype)standardFZJALAPhotosTool;
//获取所有相册
-(void)getAllALbumListSuccess:(SuccessBlock)successBlock Fail:(FailBlock)failBlock;
//获取指定相册的照片
-(void)getAllAssetByAlbumName:(ALAssetsGroup *)newGroup Completion:(void(^)(NSMutableArray * array))completion;
//获取指定照片
//高清
-(void)getFullScreenImageByALAssetUrl:(NSURL *)url Completion:(void(^)(UIImage * image))completion;
//普通
-(void)getThumbnailImageByALAssetUrl:(NSURL *)url Completion:(void(^)(UIImage * image))completion;
@end
