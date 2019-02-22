//
//  HScrollTableViewCell.h
//  test
//
//  Created by PerhapYs on 2019/2/15.
//  Copyright © 2019年 cosjiApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
NS_ASSUME_NONNULL_BEGIN
@protocol FloatContainerCellDelegate <NSObject>

@optional

- (void)containerScrollViewDidScroll:(UIScrollView *)scrollView;

- (void)containerScrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end

@interface HScrollTableViewCell : UITableViewCell

@property (nonatomic,weak) id<FloatContainerCellDelegate>delegate;

@property (nonatomic, assign) BOOL objectCanScroll;

@end

NS_ASSUME_NONNULL_END
