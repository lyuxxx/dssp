//
//  FeedbackShowImageView.m
//  dssp
//
//  Created by dy on 2018/5/23.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "FeedbackShowImageView.h"

#define kImageTag 9999

@interface FeedbackShowImageView ()<UIScrollViewDelegate>

@end

@implementation FeedbackShowImageView
{
    UIScrollView *_scrollView;
    CGRect self_Frame;
    NSInteger page;
    BOOL doubleClick;
}

- (instancetype)initWithFrame:(CGRect)frame byClick:(NSInteger)clickTag appendArray:(NSArray *)appendArray {
    if (self = [super initWithFrame:frame]) {
        
        self_Frame = frame;
        
        self.alpha = 0.0f;
        page = 0;
        doubleClick = YES;
        
        NSMutableArray *array = [NSMutableArray arrayWithArray:appendArray];
        [array removeLastObject];
        
        [self configScrollViewWith:clickTag andAppendArray:array];
        
        UITapGestureRecognizer *tapGser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappear)];
        tapGser.numberOfTouchesRequired = 1;
        tapGser.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGser];
        
        UITapGestureRecognizer *doubleTapGser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeBig:)];
        doubleTapGser.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTapGser];
        [tapGser requireGestureRecognizerToFail:doubleTapGser];
    }
    
    return self;
}

- (void)configScrollViewWith:(NSInteger)clickTag andAppendArray:(NSArray *)appendArray {
    _scrollView = [[UIScrollView alloc] initWithFrame:self_Frame];
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.pagingEnabled = true;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * appendArray.count, 0);
    [self addSubview:_scrollView];
    
    float W = self.frame.size.width;
    
    for (int i = 0; i < appendArray.count; i ++) {
        UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
        imageScrollView.backgroundColor = [UIColor blackColor];
        imageScrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        imageScrollView.delegate = self;
        imageScrollView.maximumZoomScale = 4;
        imageScrollView.minimumZoomScale = 1;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        UIImage *img = [appendArray objectAtIndex:i];
        imageView.image = img;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageScrollView addSubview:imageView];
        [_scrollView addSubview:imageScrollView];
        
        imageScrollView.tag = 100 + i ;
        imageView.tag = 1000 + i;
        
    }
    
    [_scrollView setContentOffset:CGPointMake(W * (clickTag - kImageTag), 0) animated:YES];
    page = clickTag - kImageTag;
}

- (void)disappear {
    
    _removeImg();
    
}

- (void)changeBig:(UITapGestureRecognizer *)tapGes {
    CGFloat newscale = 1.9;
    UIScrollView *currentScrollView = (UIScrollView *)[self viewWithTag:page + 100];
    CGRect zoomRect = [self zoomRectForScale:newscale withCenter:[tapGes locationInView:tapGes.view] andScrollView:currentScrollView];
    
    if (doubleClick == YES)  {
        [currentScrollView zoomToRect:zoomRect animated:YES];
    }else {
        [currentScrollView zoomToRect:currentScrollView.frame animated:YES];
    }
    
    doubleClick = !doubleClick;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    UIImageView *imageView = (UIImageView *)[self viewWithTag:scrollView.tag + 900];
    
    return imageView;
}

- (CGRect)zoomRectForScale:(CGFloat)newscale withCenter:(CGPoint)center andScrollView:(UIScrollView *)scrollV {
    CGRect zoomRect = CGRectZero;
    
    zoomRect.size.height = scrollV.frame.size.height / newscale;
    zoomRect.size.width = scrollV.frame.size.width  / newscale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (void)show:(UIView *)bgView didFinish:(didRemoveImage)tempBlock {
    [bgView addSubview:self];
    
    _removeImg = tempBlock;
    
    [UIView animateWithDuration:.4f animations:^{
        self.alpha = 1.0f;
    }];
}


#pragma mark - ScorllViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint offset = _scrollView.contentOffset;
    page = offset.x / self.frame.size.width ;
    
    UIScrollView *scrollV_next = (UIScrollView *)[self viewWithTag:page + 100 + 1];    /** 前一页*/
    
    if (scrollV_next.zoomScale != 1.0){
        scrollV_next.zoomScale = 1.0;
    }
    
    UIScrollView *scollV_pre = (UIScrollView *)[self viewWithTag:page + 100 - 1];    /** 后一页*/
    if (scollV_pre.zoomScale != 1.0){
        scollV_pre.zoomScale = 1.0;
    }
}

@end

