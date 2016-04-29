//
//  NewFeatureViewController.m
//  ShoppingSuzhou
//
//  Created by apple on 15/7/30.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "NewFeatureViewController.h"
#import "TabBarViewController.h"

@interface NewFeatureViewController ()<UIScrollViewDelegate>
{
    BOOL isOut;
}

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIPageControl *pageControl;

@end

@implementation NewFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [super viewDidLoad];
    // self.view.backgroundColor = [UIColor blueColor];
    
    isOut = NO;
    
    //创建scrollerView
    [self createScrollerView];
    
    //给ScrollerView添加图片
    [self addImage];
}

#pragma mark-(ScrollerView添加图片,手势点击到ToolViewController)
-(void)addImage
{
    double w = self.view.bounds.size.width;
    double h = self.view.bounds.size.height;
    int i = 1;
    for(i = 1;i<=3;i++)
    {
        double x = self.view.bounds.size.width*(i-1);
        double y = 0;
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"引导页%d.png",i+1]];
        _imageView.userInteractionEnabled = YES;
        [_scrollView addSubview:_imageView];
    }
}

#pragma mark-(创建ScrollerView)
-(void)createScrollerView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width*5, self.view.bounds.size.height);
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    //打开用户交互属性
    _scrollView.userInteractionEnabled = YES;
    [self.view addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-70, SCREEN_WIDTH, 30)];
    _pageControl.numberOfPages = 3;
    _pageControl.currentPage = 0;
    
    [self.view addSubview:_pageControl];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x>2*SCREEN_WIDTH+30) {
        
        isOut = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [_pageControl setCurrentPage:offset.x / bounds.size.width];
    
    if (isOut == YES) {
        
    //将scrollView移除
        TabBarViewController *vc = [[TabBarViewController alloc] init];//进入主界面
        [self presentViewController:vc animated:NO completion:nil];
    }
    
    
}

-(void)dealWithTap:(UITapGestureRecognizer *)tap
{
    TabBarViewController *rvc = [[TabBarViewController alloc]init];
    [self presentViewController:rvc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
