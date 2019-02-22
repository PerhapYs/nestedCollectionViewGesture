//
//  HScrollCollectionViewCell.m
//  test
//
//  Created by PerhapYs on 2019/2/15.
//  Copyright © 2019年 cosjiApp. All rights reserved.
//

#import "HScrollCollectionViewCell.h"
#import "VScrollCollectionViewCell.h"
#import <Masonry.h>
@interface HScrollCollectionViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic , strong) UICollectionView *collectionView;

@property (nonatomic, assign) BOOL scollStatus;

@end

@implementation HScrollCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeSubView];
    }
    return self;
}
-(void)initializeSubView{
    [self.contentView addSubview:self.collectionView];
    [self.collectionView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test:) name:@"test" object:nil];
}
-(void)test:(NSNotification *)status{
    NSNumber *obj = status.object;
    
    if([obj compare:[NSNumber numberWithBool:NO]] == NSOrderedSame){
        self.scollStatus = NO;
    }
    else{
        self.scollStatus = YES;
    }
    
    if (!self.scollStatus) {
        [self.collectionView setContentOffset:CGPointZero animated:NO];
    }
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = ({
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            layout.minimumLineSpacing = 10;
            layout.minimumInteritemSpacing = 10;
            layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 50);
            
            UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
            view.backgroundColor = [UIColor clearColor];
            view.delegate = self;
            view.dataSource = self;
            [view registerClass:[VScrollCollectionViewCell class] forCellWithReuseIdentifier:@"vTest"];
            
            view;
        });
    }
    return _collectionView;
}

#pragma mark - collectionView delegate / dataSource

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VScrollCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"vTest" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor greenColor];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 100;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.scollStatus) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {
        self.scollStatus = NO;
        scrollView.contentOffset = CGPointZero;
        //到顶通知父视图改变状态
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveTop" object:nil];
    }
}
@end
