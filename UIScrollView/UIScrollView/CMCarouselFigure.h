//
//  ShufflingFigure.h
//  
//
//  Created by Ji on 15/9/1.
//
//


#import <UIKit/UIKit.h>

@interface CMCarouselFigure : UIView
/**
 *  给轮播图增加内容
 *
 *  @param imageList 图片列表@[@"picname",@"xxx"];
 *  @param titleList 文字列表@[@""..] 可以为nil
 *  @param time      自动循环时间
 *  @param delegate  代理
 */

- (void)setPictureWithDataList:(NSArray *)datalist Time:(NSInteger)time delegate:(id)delegate_;
- (void)setPictureWithDataList:(NSArray *)datalist delegate:(id)delegate_;

- (void)stopTimer;
- (void)startTimer;
@end

@protocol CMCarouselFigureDelegate <NSObject>

- (void)CarouselFigure:(CMCarouselFigure *)carousel pressAtIndex:(NSInteger)index_;

@end

