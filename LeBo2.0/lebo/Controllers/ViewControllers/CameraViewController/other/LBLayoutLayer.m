//
//  LBLayoutLayer.m
//  LeBo
//
//  Created by 乐播 on 13-3-21.
//
//

#import "LBLayoutLayer.h"

@implementation LBLayoutLayer

- (void)layoutSublayers
{
    if([self.layoutDelegate respondsToSelector:_layoutMethod])
    {
        [self.layoutDelegate performSelector:_layoutMethod withObject:self];
    }
}

- (void)setLayoutMethod: (SEL)method
{
    _layoutMethod = method;
}
@end
