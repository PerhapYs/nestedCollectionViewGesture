//
//  ViewController.m
//  test
//
//  Created by PerhapYs on 2019/2/14.
//  Copyright © 2019年 cosjiApp. All rights reserved.
//

#import "ViewController.h"
#import "GestureCollectionView.h"
#import "HScrollTableViewCell.h"


@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,FloatContainerCellDelegate>

@property (nonatomic , strong) GestureCollectionView *collectionView;

@property (nonatomic,strong) HScrollTableViewCell *containerCell;

@property (nonatomic, assign) BOOL scrollStatus;

@end

@implementation ViewController
#pragma mark  --- delegate

- (void)containerScrollViewDidScroll:(UIScrollView *)scrollView{
    self.collectionView.scrollEnabled = NO;
}

- (void)containerScrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.collectionView.scrollEnabled = YES;
}

-(void)changeScrollStatus{
    self.scrollStatus = YES;
    self.containerCell.objectCanScroll = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatus) name:@"leaveTop" object:nil];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        
        CGFloat bottomCellOffset = [self.collectionView rectForSection:1].origin.y;
        bottomCellOffset = floorf(bottomCellOffset);
        
        if (scrollView.contentOffset.y >= bottomCellOffset) {
            scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
            if (self.scrollStatus) {
                self.scrollStatus = NO;
                self.containerCell.objectCanScroll = YES;
            }
        }else{
            //子视图没到顶部
            if (!self.scrollStatus) {
                scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
            }
        }
    }
}
-(GestureCollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = ({
            GestureCollectionView *view = [[GestureCollectionView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            view.backgroundColor = [UIColor redColor];
            view.delegate = self;
            view.dataSource = self;
            view.showsVerticalScrollIndicator = NO;
            
            if (@available(iOS 11.0, *)) {
                view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }
            
            view;
        });
    }
    return _collectionView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test"];
        }
        return cell;
    }
    HScrollTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test2"];
    if (!cell) {
        cell = [[HScrollTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test2"];
    }
    cell.delegate = self;
    self.containerCell=cell;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 1;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 50;
    }
    
    return [UIScreen mainScreen].bounds.size.height - 100;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor yellowColor];
        return view;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 100;
    }
    return 0;
}
@end
