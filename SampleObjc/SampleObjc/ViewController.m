//
//  ViewController.m
//  SampleObjc
//
//  Created by dtissera on 15/08/2014.
//  Copyright (c) 2014 o--O--o. All rights reserved.
//

#import "ViewController.h"
#import "ContentVc.h"

@interface ViewController () <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pages;

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.pages = @[
                   @{@"title": @"Rotating plane", @"color": @"#d35400", @"style": @"rotatingPane"},
                   @{@"title": @"Chasing dots", @"color": @"#f1c40f", @"style": @"chasingDots"}
                   
                   ];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    ContentVc *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    //self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    //self.pageViewController.view.frame = self.view.bounds;
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    // Change the size of page view controller
    self.pageViewController.view.frame = self.view.bounds;
    [self.pageViewController didMoveToParentViewController:self];
}

#pragma mark - private methods
- (ContentVc *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.pages count] == 0) || (index >= [self.pages count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    ContentVc *contentVc = [self.storyboard instantiateViewControllerWithIdentifier:@"ContentVc"];
    
    NSDictionary *page = [self.pages objectAtIndex:index];
    [contentVc configureWithPageIndex:index
                             hexColor:[page objectForKey:@"color"]
                                title:[page objectForKey:@"title"]
                                style:[page objectForKey:@"style"]
     ];
    
    return contentVc;
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = ((ContentVc *) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = ((ContentVc *) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pages count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return [self.pages count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

@end
