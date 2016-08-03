//
//  ViewController.m
//  test1
//
//  Created by LOVE on 16/8/3.
//  Copyright © 2016年 LOVE. All rights reserved.
//

#import "ViewController.h"
#import "BaseNavViewController.h"
#import "AttentionViewController.h"
#import "FavouriteViewController.h"
#import "GachincoViewController.h"
#import "UIView+HHExtension.h"
#define   ScreenW  [UIScreen mainScreen].bounds.size.width
#define   ScreenH  [UIScreen mainScreen].bounds.size.height

#define kHeight 30
#define TitleView_Y 64
@interface ViewController ()<UIScrollViewDelegate>
/* <#注释#>*/
@property(nonatomic,weak)UIScrollView *scollView;
/* */
@property(nonatomic,weak)UIButton *selectedbutton;

/* <#注释#>*/
@property(nonatomic,weak)UIView * selectedView;

@property(nonatomic,weak)UIView *titleView;

@end

@implementation ViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createChildVC];
    
    [self createTitlesView];
    
    [self  creascrollView];
    
}
#pragma mark - CreateChildController
-(void)createTitlesView{

    //UIView整体
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, TitleView_Y, ScreenW, kHeight)];
    titleView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:titleView];
    _titleView = titleView;
   
    UIView *selectedView =[[UIView alloc]init];
    selectedView.backgroundColor = [UIColor redColor];
    selectedView.y = titleView.height- selectedView.height;
    selectedView.height = 2;
    _selectedView = selectedView;
    

    for (int i = 0; i<self.childViewControllers.count; i++) {
        
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        UIViewController *vc = self.childViewControllers[i];
        [button setTag:i];
        [button setTitle:vc.title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
        button.frame= CGRectMake(i*(ScreenW/self.childViewControllers.count), 0, ScreenW/self.childViewControllers.count,kHeight );
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:button];
        
        if (i==0) {
            
            
            button.enabled = NO;
            self.selectedbutton = button;;
            [button.titleLabel sizeToFit];
            _selectedView.width = button.titleLabel.width;
            _selectedView.centerX = button.centerX;
        
        }
        
    }
    
    [titleView addSubview:selectedView];
    
}
-(void)creascrollView{
    self.automaticallyAdjustsScrollViewInsets  = NO;
    UIScrollView *scrollView =[[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollView.contentInset = UIEdgeInsetsMake(TitleView_Y, 0, 0, 0);
    scrollView.contentSize = CGSizeMake(scrollView.width*self.childViewControllers.count, 0);
    [self.view insertSubview:scrollView atIndex:0];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    self.scollView = scrollView;
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
}
-(void)createChildVC{
    
    [self setVC:[[AttentionViewController alloc]init] title:@"关注"];
    
    [self setVC:[[FavouriteViewController alloc]init] title:@"热门"];
    
    [self setVC:[[GachincoViewController alloc]init] title:@"最新"];
    
}
#pragma mark - ClickMethods
- (void)buttonClick:(UIButton *)btn{
    self.selectedbutton.enabled = YES;
    btn.enabled = NO;
    
    self.selectedbutton= btn;
    
    [UIView animateWithDuration:0.3 animations:^{
       
        self.selectedView.width = btn.titleLabel.width;
        self.selectedView.centerX = btn.centerX;
    }];
    
    CGPoint offset = self.scollView.contentOffset;
    offset.x = btn.tag *self.scollView.width;
    [self.scollView setContentOffset:offset animated:YES];
    
}

- (void)setVC:(UIViewController *)VC title:(NSString *)title{

    VC.title = title;
    [self addChildViewController:VC];

}
#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{

    NSInteger index = scrollView.contentOffset.x/ScreenW;
    
    UIViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0;
    vc.view.height = scrollView.height;
    [scrollView addSubview:vc.view];

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    NSInteger index = scrollView.contentOffset.x/ScreenW;
    
    [self buttonClick:self.titleView.subviews[index]];

}

@end
