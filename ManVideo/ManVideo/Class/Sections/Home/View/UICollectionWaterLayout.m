//
//  UICollectionWaterLayout.m
//  瀑布流
//
//  Created by FDC-Fabric on 2018/12/14.
//  Copyright © 2018年 FDC-Fabric. All rights reserved.
//

#import "UICollectionWaterLayout.h"
@interface UICollectionWaterLayout ()
@property(nonatomic,strong)NSMutableArray *attrArray;
@property(nonatomic,strong)NSMutableArray *frameYa;

@property(nonatomic,assign)float leftMargin;
@property(nonatomic,assign)float rightMargin;
//@property(nonatomic,assign)int colunms;
@end
@implementation UICollectionWaterLayout
+(instancetype)layoutWithColoumn:(int)coloumn  data:(NSMutableArray *)dataA   verticleMin:(float)minv  horizonMin:(float)minh  leftMargin:(float)leftMargin  rightMargin:(float)rightMargin{
    
    UICollectionWaterLayout *layout = [[UICollectionWaterLayout alloc]init];
    layout.iconArray = dataA;
    layout.minimumLineSpacing = minv;
    layout.minimumInteritemSpacing = minh;
    layout.leftMargin = leftMargin;
    layout.rightMargin = rightMargin;
    layout.colunms = coloumn;
    return layout;
    
    
}

-(void)prepareLayout{
    //计算每个cell的宽度
    self.minimumLineSpacing = 10;
    self.minimumInteritemSpacing = 10;
    self.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    float itemW = (self.collectionView.bounds.size.width - self.leftMargin - self.rightMargin - (self.colunms-1)*self.minimumInteritemSpacing)/self.colunms;
    
   
        for (int i = 0; i<self.colunms; i++) {
            self.frameYa[i] = @(self.sectionInset.top);
        }
 
    //遍历数组m，创建数组那么多的UICollectionViewLayoutAttributes
    for(int i = 0;i<self.iconArray.count;i++){
        VDIconModel *iconModel = self.iconArray[i];
        NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:index];
        [self.attrArray addObject:attributes];
        //计算每个cell的高度
        float itemH = [self getcellHWithOriginSize:CGSizeMake(iconModel.iconW, iconModel.IconH) itemW:itemW];
        //计算当前cell处于第几列
        int lie = [self getMinLie:self.frameYa];
        float itemX = self.sectionInset.left +(self.minimumInteritemSpacing+itemW)*(lie);
        float itemY = [self.frameYa[lie] floatValue];
        float result  = (itemH + self.minimumLineSpacing) + [self.frameYa[lie] floatValue];
        self.frameYa[lie] = @(result);
        attributes.frame = CGRectMake(itemX, itemY, itemW, itemH);
       
    }
   
   
}
//计算没行中每个cell的最大Y值
-(int)getMinLie:(NSMutableArray *)frameYa{
    int col = 0;
    float min = [frameYa[col] floatValue];
    for (int i = 1; i<self.colunms; i++) {
        if(min>[frameYa[i] floatValue]){
            min = [frameYa[i] floatValue];
             col = i;
        }
       
    }
    
    return col;
}
//计算cell的高度
-(float)getcellHWithOriginSize:(CGSize)originSize itemW:(float)itemW{
    
    return itemW*originSize.height/originSize.width;
    
}
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    return self.attrArray;
    
}
- (NSMutableArray *)attrArray{
    if(!_attrArray){
        _attrArray = [NSMutableArray array];
    }
    return _attrArray;
}
-(CGSize)collectionViewContentSize{
    
    int maxindex = 0;
    float max = [self.frameYa[maxindex] floatValue];
    
    for (int i = 1; i<self.colunms; i++) {
        
        if([self.frameYa[i] floatValue]>max){
            
            max = [self.frameYa[i] floatValue];
            maxindex = i;
        }
        
    }
    return CGSizeMake(0, max);
}
- (NSMutableArray *)frameYa{
    if(!_frameYa){
        _frameYa = [NSMutableArray array];
    }
    return _frameYa;
}
@end
