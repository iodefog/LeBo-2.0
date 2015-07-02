//
//  LBLayoutLayer.h
//  LeBo
//
//  Created by 乐播 on 13-3-21.
//
//

#import <QuartzCore/QuartzCore.h>


@interface LBLayoutLayer : CALayer
{
    SEL _layoutMethod;
}
@property(nonatomic,assign) id layoutDelegate;

- (void)setLayoutMethod: (SEL)method; //- (void)layoutSublayersWithLayer:(CALayer *)layer

@end
