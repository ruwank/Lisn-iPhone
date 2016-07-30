//
//  TurtorialViewController.m
//  Lisn
//
//  Created by Rasika Kumara on 7/29/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "TurtorialViewController.h"
#import "TurtorialContentViewController.h"
#import "AppConstant.h"

@interface TurtorialViewController ()

@end

@implementation TurtorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageImages = @[@"page1", @"page2", @"page3", @"page4"];
    
     // Create page view controller
    // self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
     self.pageViewController.dataSource = self;
     
     TurtorialContentViewController *startingViewController = [self viewControllerAtIndex:0];
     NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

     //[self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
     
     // Change the size of page view controller
     self.pageViewController.view.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44);
     
     [self addChildViewController:_pageViewController];
     [self.view addSubview:_pageViewController.view];
     [self.pageViewController didMoveToParentViewController:self];
    
    for (UIView *subview in self.pageViewController.view.subviews) {
        if ([subview isKindOfClass:[UIPageControl class]]) {
            UIPageControl *pageControl = (UIPageControl *)subview;
            pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
            pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
            pageControl.backgroundColor = [UIColor whiteColor];
        }
    }
    [self saveData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelButtonTapped:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // [self startWalkthrough];
    
    
    
}

-(void)saveData
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:IS_SHOW_TURTORIAL])
    {
    [[NSUserDefaults standardUserDefaults]
     setObject:[NSNumber numberWithBool:YES] forKey:IS_SHOW_TURTORIAL];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
- (void)startWalkthrough{
    TurtorialContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

- (TurtorialContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageImages count] == 0) || (index >= [self.pageImages count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    TurtorialContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TurtorialContentViewController"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((TurtorialContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((TurtorialContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageImages count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageImages count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
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
