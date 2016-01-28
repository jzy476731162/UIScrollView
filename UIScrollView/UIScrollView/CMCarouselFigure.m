//
//  ShufflingFigure.m
//
//
//  Created by Ji on 15/9/1.
//
//

#import "CMCarouselFigure.h"
#import "UIImageView+WebCache.h"

#define MY_DEVICE_WIDTH [[UIScreen mainScreen ] bounds].size.width
#define MY_DEVICE_HEIGHT [[UIScreen mainScreen ] bounds].size.height

@interface CMCarouselFigure()<UIScrollViewDelegate>{
    NSInteger                       currentIndex;
    id <CMCarouselFigureDelegate> delegate;
}
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIPageControl *pageControl;

@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat width;

@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSInteger time;

@property (nonatomic) BOOL enableScroll;
@end

@implementation CMCarouselFigure

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.userInteractionEnabled = YES;
        
        _width = frame.size.width;
        _height = frame.size.height;
        
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.center = CGPointMake(frame.size.width / 2 , frame.size.height - 10);
    }
    return self;
}

- (void)addPicture:(NSArray *)imageList labelList:(id)labelList{
    BOOL haveText;
    if ([labelList isKindOfClass:[NSArray class]] && [labelList count] > 0) {
        haveText = YES;
    }else {
        haveText = NO;
    }
    
    for (int i = 1; i <= [imageList count]; i++) {
        UIImageView *image = [self imageViewWithIndex:i imageUrl:[imageList objectAtIndex:i-1]];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
        [image addGestureRecognizer:tapGesture];
        
        [[self scrollView] addSubview:image];
        
        if (haveText) {
            [[self scrollView] addSubview:[self labelWithIndex:i title:[labelList objectAtIndex:i-1]]];
        }
    }
    
    [[self scrollView] addSubview:[self imageViewWithIndex:0 imageUrl:[imageList lastObject]]];
    [[self scrollView] addSubview:[self imageViewWithIndex:([imageList count] + 1) imageUrl:[imageList firstObject]]];
    
    if (haveText) {
        [[self scrollView] addSubview:[self labelWithIndex:0 title:[labelList lastObject]]];
        [[self scrollView] addSubview:[self labelWithIndex:[labelList count] + 1 title:[labelList firstObject]]];
    }
    
    [[self scrollView] setContentSize:CGSizeMake([self width] * ([imageList count]+2), [self height])];
    [self addSubview:[self scrollView]];
    
    [[self scrollView] setContentOffset:CGPointMake([self width], 0)];
    [[self pageControl] setNumberOfPages:[imageList count]];
    [[self pageControl] setCurrentPage:0];
    [[self pageControl] setHidesForSinglePage:YES];
    [self addSubview:[self pageControl]];
    
    if ([imageList count] == 1) {
        [self setEnableScroll:NO];
        [[self scrollView] setScrollEnabled:NO];
    }else if([imageList count] > 1){
        [self setEnableScroll:YES];
        [[self scrollView] setScrollEnabled:YES];
        if (self.time > 0) {
            [self setTimer:[NSTimer scheduledTimerWithTimeInterval:self.time target:self selector:@selector(timerdoWhat) userInfo:nil repeats:YES]];
        }
    }
}

- (void)startTimer {
    if ([self enableScroll]) {
        [self setTimer:[NSTimer scheduledTimerWithTimeInterval:self.time target:self selector:@selector(timerdoWhat) userInfo:nil repeats:YES]];
        [self zero];
    }
}

- (void)stopTimer {
    if ([self enableScroll]) {
        [[self timer] invalidate];
        [self setTimer:nil];
    }
}

- (void)zero {
    [[self scrollView] setContentOffset:CGPointMake([self width], 0)];
    [[self pageControl] setCurrentPage:0];
}

#pragma mark - 添加图或Text
- (UIImageView *)imageViewWithIndex:(NSInteger)index imageUrl:(NSString *)imageURL{
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(index * [self width], 0, [self width], [self height])];
    [image setUserInteractionEnabled:YES];
    
    [image sd_setImageWithURL:[NSURL URLWithString:imageURL]];
    
    [image setContentMode:UIViewContentModeScaleToFill];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0.0f, [self height] - 84.0f, MY_DEVICE_WIDTH, 84.0f);
    
    gradient.colors = @[(id)[[UIColor clearColor] CGColor],
                        (id)[[UIColor colorWithWhite:0.0f alpha:0.4] CGColor]];
    
    [image.layer insertSublayer:gradient atIndex:0];
    
    return image;
}

- (UILabel *)labelWithIndex:(NSInteger)index title:(NSString *)title {
    CGRect frame = [title boundingRectWithSize:CGSizeMake([self width] - 15* 2, [self height] - 15) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]} context:nil];
    
    UILabel *labell = [[UILabel alloc] initWithFrame:CGRectMake(index * [self width] + 15, [self height] - frame.size.height - 15, [self width] - 15 * 2, frame.size.height)];
    [labell setText:title];
    [labell setTextAlignment:NSTextAlignmentCenter];
    
    [labell setNumberOfLines:0];
    [labell setFont:[UIFont boldSystemFontOfSize:16]];
    [labell setTextColor:[UIColor whiteColor]];
    return labell;
}

- (void)setPictureWithDataList:(NSArray *)datalist delegate:(id)delegate_ {
    [self setPictureWithDataList:datalist Time:0 delegate:self];
}

- (void)setPictureWithDataList:(NSArray *)datalist Time:(NSInteger)time delegate:(id)delegate_{
    delegate = delegate_;
    
    //    NSMutableArray *urlList = [[NSMutableArray alloc] init];
    //    NSMutableArray *titleList = [[NSMutableArray alloc] init];
    //    for (NSDictionary *imgDic in datalist) {
    //        if ([imgDic objectForKey:@"image_url"]) {
    //            [urlList addObject:[imgDic objectForKey:@"image_url"]];
    //        }
    //        if ([imgDic objectForKey:@"title"]) {
    //            [titleList addObject:[imgDic objectForKey:@"title"]];
    //        }
    //    }
    
    [self setTime:time];
    [self addPicture:datalist labelList:nil];
}

- (void)timerdoWhat {
    [[self scrollView] setContentOffset:CGPointMake(self.scrollView.contentOffset.x + [self width], 0) animated:YES];
}
#pragma mark - 滑动操作
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self enableScroll]) {
        if ([self timer]) {
            [[self timer] invalidate];
            [self setTimer:nil];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self enableScroll]) {
        if (self.time) {
            [self setTimer:[NSTimer scheduledTimerWithTimeInterval:self.time target:self selector:@selector(timerdoWhat) userInfo:nil repeats:YES]];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x > [self width] && scrollView.contentOffset.x < scrollView.contentSize.width - [self width]) {
        [[self pageControl] setCurrentPage:(NSUInteger)([scrollView contentOffset].x / [self width] -1)];
    }
    if (scrollView.contentOffset.x == 0) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentSize.width - (2 *[self width]), 0) animated:NO];
        [[self pageControl] setCurrentPage:([[self pageControl] numberOfPages] - 1) ];
    }
    if (scrollView.contentOffset.x == scrollView.contentSize.width - [self width]) {
        [scrollView setContentOffset:CGPointMake([self width], 0) animated:NO];
        [[self pageControl] setCurrentPage:0];
    }
}

/**
 *  点击图片跳转webView
 */
- (void)clickImage {
    NSUInteger index = (NSUInteger)[[self scrollView] contentOffset].x / [self width] - 1;
    if ([delegate respondsToSelector:@selector(CarouselFigure:pressAtIndex:)]) {
        [delegate CarouselFigure:self pressAtIndex:index];
    }
}

@end




