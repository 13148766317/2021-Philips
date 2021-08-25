//
//  PLPDeviceUIActionsCollectionView.m
//  Pages
//
//  Created by Apple on 2021/5/27.
//

#import "PLPDeviceUIActionsCollectionView.h"
#import "PLPDeviceUIActionCell.h"
NSString * const PLPDeviceUIActionsDefaultCellWithReuseIdentifier = @"cell";

@implementation PLPDeviceUIActionsCollectionView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self configure];
    }
    return self;
}

-(void) configure {
    self.dataSource = self;
    self.delegate = self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark 定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.actionsDataSource.count;
}

#pragma mark 定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark 每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    
    PLPDeviceUIActionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    if (!cell) {
        cell = [[PLPDeviceUIActionCell alloc] init];
    }
    [cell sizeToFit];
    cell.data = self.actionsDataSource[indexPath.row];
    
    return cell;
}

#pragma mark UICollectionView被选中时调用的方法

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectRowBlock) {
        self.didSelectRowBlock(self.actionsDataSource[indexPath.row]);
    }
}

#pragma mark - Utils
//计算单元格大小
+(CGSize) itemSizeWithColNum:(NSUInteger) colNum layoutWidth:(CGFloat)layoutWidth rowHeight:(CGFloat) height minimumInteritemSpacing:(CGFloat) minimumInteritemSpacing edgeLeft:(CGFloat) edgeLeft edageRight:(CGFloat) edgeRight {
    CGSize itemSize;
    
    CGFloat interitemSpacing = ((colNum-1) * minimumInteritemSpacing);
    itemSize = CGSizeMake(floorf((layoutWidth - interitemSpacing  - edgeRight-edgeLeft)/colNum), height);
    
    return itemSize;
}

+(UICollectionViewFlowLayout *) collectionViewFlowLayoutWithItemSize:(CGSize) itemSize minimumLineSpacing:(CGFloat) minimumLineSpacing minimumInteritemSpacing:(CGFloat) minimumInteritemSpacing {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = itemSize;
    layout.minimumLineSpacing = minimumLineSpacing;
    layout.minimumInteritemSpacing = minimumInteritemSpacing;
    return layout;
}

@end
