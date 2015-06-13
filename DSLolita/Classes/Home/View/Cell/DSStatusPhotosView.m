//
//  DSStatusPhotosView.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/26.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSStatusPhotosView.h"
#import "DSStatusPhotoView.h"
#import "UIImageView+WebCache.h"
#import "DSPhoto.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#define DSStatusPhotosMaxCount 9
#define DSStatusPhotosMaxCols(photosCount) ((photosCount == 4) ? 2 :3)
#define DSStatusPhotosW DSScreenWidth*0.21
#define DSStatusPhotosH DSStatusPhotosW
#define DSStatusPhotosMargin 5



@interface DSStatusPhotosView()

@property (nonatomic , assign) CGRect lastFrame;
@property (nonatomic , weak ) UIImageView *bigImageView;

@end


@implementation DSStatusPhotosView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.userInteractionEnabled = YES;
        //预先创建9个图片控件
        for (int i = 0; i < DSStatusPhotosMaxCount; i++){
            DSStatusPhotoView *photoView = [[DSStatusPhotoView alloc] init];
            photoView.tag = i;
            [self addSubview:photoView];
            
            //添加手势
            UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(statusPhotoOnTap:)];
            [photoView addGestureRecognizer:gestureRecognizer];
        }
    }
    return self;
}

- (void)statusPhotoOnTap:(UITapGestureRecognizer *)recognizer {
    // 1.创建图片浏览器
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    
    // 2.设置图片浏览器显示的所有图片
    NSMutableArray *photos = [NSMutableArray array];
    int count = (int)self.picUrls.count;
    for (int i = 0; i <count; i++){
        DSPhoto *pic = [[DSPhoto alloc] init];
        pic.original_pic = self.picUrls[i];
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:pic.original_pic];
        //设置来源于哪一个UIImageView
        photo.srcImageView = self.subviews[i];
        
        [photos addObject:photo];
    }
    
    browser.photos = photos;
    
    // 3.设置默认显示的图片索引
    browser.currentPhotoIndex = recognizer.view.tag;
    
    // 4.显示浏览器
    [browser show];
}



- (void)setPicUrls:(NSArray *)picUrls {
    
    _picUrls = picUrls;
    
    for (int i = 0; i < DSStatusPhotosMaxCount; i++){
        
        DSStatusPhotoView *photoView = self.subviews[i];
        
        if (i < picUrls.count){
            photoView.photo = picUrls[i];
            photoView.hidden = NO;
        }else{
            photoView.hidden = YES;
        }
    }
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    int count = (int)self.picUrls.count;
    int maxCols = DSStatusPhotosMaxCols(count);

    
    
    for (int i = 0; i < count; i++){
        DSStatusPhotoView *photoView = self.subviews[i];
        photoView.width = DSStatusPhotosW;
        photoView.height = DSStatusPhotosH;
        
        photoView.x = (i % maxCols) * (DSStatusPhotosW + DSStatusPhotosMargin);
        photoView.y = (i / maxCols) * (DSStatusPhotosW + DSStatusPhotosMargin);
        
    }
}


+ (CGSize)sizeWithPhotosCount:(int)photosCount {
    
    int maxCols = DSStatusPhotosMaxCols(photosCount);
    
    // 总列数
    int totalCols = photosCount >= maxCols ? maxCols : photosCount;
    
    // 总行数
    int totalRows = (photosCount + maxCols - 1) / maxCols;
    
    // 计算尺寸
    CGFloat photosW = totalCols * DSStatusPhotosW + (totalCols - 1) * DSStatusPhotosMargin;
    CGFloat photosH = totalRows * DSStatusPhotosH + (totalRows - 1) * DSStatusPhotosMargin;
    
    return CGSizeMake(photosW, photosH);
    
    
}







@end
