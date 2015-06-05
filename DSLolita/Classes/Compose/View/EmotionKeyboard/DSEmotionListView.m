//
//  DSEmotionListView.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/28.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSEmotionListView.h"
#import "DSEmotionGridView.h"


@interface DSEmotionListView()<UIScrollViewDelegate>
//显示所有表情的scrollView
@property (nonatomic , weak) UIScrollView *scrollView;
//显示页码的UIPageControl
@property (nonatomic , weak) UIPageControl *pageControl;

@end

@implementation DSEmotionListView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self){
        
        // 1.显示所有表情的scrollview
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        // 滚动条是uiscrollview的子控件，隐藏滚动条，可以屏蔽多余的子控件
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        // 2.显示页码
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        // 通过KVC修改系统自带的图片
        [pageControl setValue:[UIImage imageWithName:@"compose_keyboard_dot_selected"] forKey:@"_currentPageImage"];
        [pageControl setValue:[UIImage imageWithName:@"compose_keyboard_dot_normal"] forKey:@"_pageImage"];
        [self addSubview:pageControl];
        self.pageControl = pageControl;
    }
    
    return self;
}


- (void)setEmotions:(NSArray *)emotions {
    
    // 设置总页数
    int totalPages = ((int)emotions.count + DSEmotionMaxCountPerPage - 1) / DSEmotionMaxCountPerPage;
    int currentGridViewCount = (int)self.scrollView.subviews.count;
    self.pageControl.numberOfPages = totalPages;
    self.pageControl.currentPage = 0;
    self.pageControl.hidesForSinglePage = YES;//一页时候隐藏
    
    // 循环利用，决定scrollview显示多少页表情
    for (int i = 0; i<totalPages;i++){
        DSEmotionGridView *gridView = nil;
        if (i >=currentGridViewCount){
            gridView = [[DSEmotionGridView alloc] init];
            [self.scrollView addSubview:gridView];
        }else{
            
            gridView = self.scrollView.subviews[i];
        }
        
        //给grid设置表情数据
        int loc = i * DSEmotionMaxCountPerPage;
        int len = DSEmotionMaxCountPerPage;
        if (loc + len > emotions.count){
            len = (int)emotions.count - loc;
        }
        NSRange gridViewEmotionRange = NSMakeRange(loc, len);
        NSArray *gridViewEmotions = [emotions subarrayWithRange:gridViewEmotionRange];
        gridView.emotions = gridViewEmotions;
        gridView.hidden = NO;
    }
    
    // 隐藏后面的不需要的gridView
    for (int i = totalPages ; i< currentGridViewCount ; i++){
        DSEmotionGridView *gridView = self.scrollView.subviews[i];
        gridView.hidden = YES;
    }
    
    // 重新布局子控件
    [self setNeedsLayout];
    
    // 表情滚动到最前面
    self.scrollView.contentOffset = CGPointZero;
    
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    // 1.UIPageControl的frame
    self.pageControl.width = self.width;
    self.pageControl.height = 35;
    self.pageControl.y = self.height - self.pageControl.height;
    
    // 2.UIScrollView的frame
    self.scrollView.width = self.width;
    self.scrollView.height = self.pageControl.y;
    
    // 3.设置UIScrollView内部空间的尺寸
    int count = (int)self.pageControl.numberOfPages;
    CGFloat gridW = self.scrollView.width;
    CGFloat gridH = self.scrollView.height;
    
    //设置滚动范围
    self.scrollView.contentSize = CGSizeMake(count * gridW, 0);
    for (int i = 0 ; i < count ; i++){
        DSEmotionGridView *gridView = self.scrollView.subviews[i];
        gridView.width = gridW;
        gridView.height = gridH;
        gridView.x = i * gridW;
    }
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.pageControl.currentPage = (int)(scrollView.contentOffset.x / scrollView.width + 0.5);
}


@end
