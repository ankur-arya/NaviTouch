//
//  AATabController.m
//  NaviTouch
//
//  Created by Ankur Arya on 06/04/13.
//  Copyright (c) 2013 Arya Corp. All rights reserved.
//

#import "AATabController.h"

@interface AATabController ()

@end

@implementation AATabController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    AAContactsVC *contactsVC = [[AAContactsVC alloc]init];
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:contactsVC];
    NSArray *viewArray = [[NSArray alloc]initWithObjects:nav1, nil];
    self.title = @"Title";
    self.tabBarController.viewControllers = viewArray;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
