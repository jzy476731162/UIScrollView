//
//  ViewController.m
//  UIScrollView
//
//  Created by JI on 16/1/28.
//  Copyright © 2016年 carl J. All rights reserved.
//

#define MY_DEVICE_WIDTH [[UIScreen mainScreen ] bounds].size.width
#define MY_DEVICE_HEIGHT [[UIScreen mainScreen ] bounds].size.height

#import "ViewController.h"
#import "CMCarouselFigure.h"
@interface ViewController ()<CMCarouselFigureDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CMCarouselFigure *figure = [[CMCarouselFigure alloc] initWithFrame:CGRectMake(0, 0, MY_DEVICE_WIDTH, 200)];
    [figure setPictureWithDataList:@[@"http://pic14.nipic.com/20110522/7411759_164157418126_2.jpg",@"http://pic.nipic.com/2007-11-09/200711912453162_2.jpg",@"http://pic2.ooopic.com/01/03/51/25b1OOOPIC19.jpg"] delegate:self];
    [self.view addSubview:figure];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)CarouselFigure:(CMCarouselFigure *)carousel pressAtIndex:(NSInteger)index_ {
    NSLog(@"%ld",index_);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
