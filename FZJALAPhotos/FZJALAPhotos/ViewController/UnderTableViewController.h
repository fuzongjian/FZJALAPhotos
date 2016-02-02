//
//  UnderTableViewController.h
//  FZJALAPhotos
//
//  Created by fdkj0002 on 16/1/31.
//  Copyright © 2016年 FZJ.com. All rights reserved.
//

#import "SuperViewController.h"

@interface UnderTableViewController : SuperViewController
@property(nonatomic,copy)void(^getPhotoArrayFromAlbum)(NSArray * photoArray);
@property(nonatomic,strong)NSArray * albumList;
@end
