//
//  FZJALAPhotosTool.m
//  FZJALAPhotos
//
//  Created by fdkj0002 on 16/1/30.
//  Copyright © 2016年 FZJ.com. All rights reserved.
//

#import "FZJALAPhotosTool.h"
@implementation PhotoAblumList
@end
@implementation FZJALAPhotosTool
+(instancetype)standardFZJALAPhotosTool{
    static FZJALAPhotosTool * photoTool = nil;
    @synchronized(photoTool) {
        if (photoTool == nil) {
            photoTool = [[self alloc] init];
        }
    }
    return photoTool;
}
-(void)getAllALbumListSuccess:(SuccessBlock)successBlock Fail:(FailBlock)failBlock{
    ALAssetsLibrary * assetsLibrary = [[ALAssetsLibrary alloc] init];
    NSMutableArray * groupArray = [NSMutableArray array];
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(dispatchQueue, ^{
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group) {
                PhotoAblumList * album = [[PhotoAblumList alloc] init];
                album.count = [group numberOfAssets];
                album.title = [self transformAblumTitle:[group valueForProperty:ALAssetsGroupPropertyName]];
                if (![album.title length]) {
                    album.title = [group valueForProperty:ALAssetsGroupPropertyName];
                }
                album.group = group;
                album.firstImage = [UIImage imageWithCGImage:[group posterImage]];
                [groupArray addObject:album];
            }else{
                successBlock(groupArray);
            }
        } failureBlock:^(NSError *error) {
            failBlock(error);
        }];
    });

}
-(void)getAllAssetByAlbumName:(ALAssetsGroup *)NewGroup Completion:(void(^)(NSMutableArray * array))completion{
    NSMutableArray * array = [NSMutableArray array];
    [NewGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [array addObject:result];
        }else{
            completion(array);
        }
    }];
}
-(void)getFullScreenImageByALAssetUrl:(NSURL *)url Completion:(void(^)(UIImage * image))completion{
    ALAssetsLibrary * alassetLibray = [[ALAssetsLibrary alloc] init];
    [alassetLibray assetForURL:url resultBlock:^(ALAsset *asset) {
         completion([UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]);
    } failureBlock:^(NSError *error) {
        
    }];
}
-(void)getThumbnailImageByALAssetUrl:(NSURL *)url Completion:(void(^)(UIImage * image))completion{
    
    ALAssetsLibrary * alassetLibray = [[ALAssetsLibrary alloc] init];
    [alassetLibray assetForURL:url resultBlock:^(ALAsset *asset) {
        
        completion([UIImage imageWithCGImage:[asset thumbnail]]);
        // completion([UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]);
    } failureBlock:^(NSError *error) {
        
    }];
}
- (NSString *)transformAblumTitle:(NSString *)title
{
    if ([title isEqualToString:@"Slo-mo"]) {
        return @"慢动作";
    } else if ([title isEqualToString:@"Recently Added"]) {
        return @"最近添加";
    } else if ([title isEqualToString:@"Favorites"]) {
        return @"最爱";
    } else if ([title isEqualToString:@"Recently Deleted"]) {
        return @"最近删除";
    } else if ([title isEqualToString:@"Videos"]) {
        return @"视频";
    } else if ([title isEqualToString:@"All Photos"]) {
        return @"所有照片";
    } else if ([title isEqualToString:@"Selfies"]) {
        return @"自拍";
    } else if ([title isEqualToString:@"Screenshots"]) {
        return @"屏幕快照";
    } else if ([title isEqualToString:@"Camera Roll"]) {
        return @"相机胶卷";
    }else if ([title isEqualToString:@"My Photo Stream"]){
        return @"我的照片流";
    }
    return nil;
}
@end
