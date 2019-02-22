//
//  HScrollTableViewCell.m
//  test
//
//  Created by PerhapYs on 2019/2/15.
//  Copyright © 2019年 cosjiApp. All rights reserved.
//

#import "HScrollTableViewCell.h"
#import "HScrollCollectionViewCell.h"

@interface HScrollTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic , strong) UICollectionView *collectionView;

@end

@implementation HScrollTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initializeSubView];
    }
    return self;
}

-(void)initializeSubView{
    
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = ({
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            layout.minimumLineSpacing = 0;
            layout.minimumInteritemSpacing = 0;
            
            UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
            view.backgroundColor = [UIColor clearColor];
            view.delegate = self;
            view.dataSource = self;
            view.pagingEnabled = YES;
            [view registerClass:[HScrollCollectionViewCell class] forCellWithReuseIdentifier:@"hTest"];
            
            view;
        });
    }
    return _collectionView;
}
#pragma mark - collectionView delegate / dataSource


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, self.contentView.frame.size.height);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HScrollCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hTest" forIndexPath:indexPath];
    NSInteger row = indexPath.row % 2;
    if (row ==0) {
        cell.contentView.backgroundColor = [UIColor grayColor];
    }
    else{
        cell.contentView.backgroundColor = [UIColor orangeColor];
    }
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 10;
}

#pragma mark ------- 
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 为了横向滑动的时候，外层的tableView不动
    if (scrollView == self.collectionView) {
        if ([self.delegate respondsToSelector:@selector(containerScrollViewDidScroll:)]) {
            [self.delegate containerScrollViewDidScroll:scrollView];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        if ([self.delegate respondsToSelector:@selector(containerScrollViewDidEndDecelerating:)]) {
            [self.delegate containerScrollViewDidEndDecelerating:scrollView];
        }
    }
}

- (void)setObjectCanScroll:(BOOL)objectCanScroll {
    _objectCanScroll = objectCanScroll;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"test" object:@(objectCanScroll)];
}
@end
