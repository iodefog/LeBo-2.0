#import "CustomSearchBar.h"

@implementation CustomSearchBar


-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
      
    }    
    return self;
} 

- (void)drawRect:(CGRect)rect {
    [[[self subviews] objectAtIndex:0] setAlpha:0.0];
    UIImage *image = [UIImage imageNamed: @"searchBar_background.png"];    
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

-(void)layoutSubviews {
    for(UIView *subView in self.subviews) {
        if(!(subView == nil)) {
            if ([subView isKindOfClass:[UIButton class]]) {
                UIButton *sbtn = (UIButton *)subView;
                [sbtn setTitle:@"取消"  forState:UIControlStateNormal];
                [sbtn setBackgroundImage:[UIImage imageNamed:@"searchBar_cancel.png"] forState:UIControlStateNormal];
                [sbtn setBackgroundImage:[UIImage imageNamed:@"searchBar_cancel_tape"] forState:UIControlStateHighlighted];
            }
            
            if([subView isKindOfClass:[UITextField class]]) {
                    UITextField *searchField = (UITextField*)subView;
                    searchField.textColor = [UIColor blackColor];
                    [searchField.leftView setHidden:NO];
                    [searchField setBackground: [[UIImage imageNamed:@"searchBar_search.png"] stretchableImageWithLeftCapWidth:18. topCapHeight:0]];
                    [searchField setBorderStyle:UITextBorderStyleNone];
                
                    UIImageView *imageView = (UIImageView*)searchField.leftView;
                    [imageView setImage:[UIImage imageNamed:@"searchBar_icon.png"]];
            }

        }
    }
    [super layoutSubviews];
}
@end