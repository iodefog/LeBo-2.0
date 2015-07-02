//
//  AWActionSheet.m
//  AWIconSheet
//
//  Created by Narcissus on 10/26/12.
//  Copyright (c) 2012 Narcissus. All rights reserved.
//

#import "AWActionSheet.h"
#import <QuartzCore/QuartzCore.h>
#define itemPerPage 6

@interface AWActionSheet()<UIScrollViewDelegate>
@property (nonatomic, retain)UIScrollView* scrollView;
@property (nonatomic, retain)UIPageControl* pageControl;
@property (nonatomic, retain)NSMutableArray* items;
@property (nonatomic, assign)id<AWActionSheetDelegate> IconDelegate;
@end
@implementation AWActionSheet
@synthesize scrollView;
@synthesize pageControl;
@synthesize items;
@synthesize IconDelegate;

-(id)initwithIconSheetDelegate:(id<AWActionSheetDelegate>)delegate ItemCount:(int)cout
{
    int rowCount = 2;
    if (cout <=3) {
        rowCount = 1;
    } else if (cout <=6) {
        rowCount = 2;
    }
    NSString* titleBlank = @"\n\n\n\n\n\n";
    for (int i = 1 ; i<rowCount; i++) {
        titleBlank = [NSString stringWithFormat:@"%@%@",titleBlank,@"\n\n\n\n\n\n"];
    }
  AWActionSheet * mSheet = [super initWithTitle:titleBlank
                       delegate:nil
              cancelButtonTitle:@"取消"
         destructiveButtonTitle:nil
              otherButtonTitles:nil];
 
    if (mSheet) {
        [self setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        IconDelegate = delegate;
        mSheet.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, 320, 105*rowCount)];
        [scrollView setPagingEnabled:YES];
        [scrollView setBackgroundColor:[UIColor clearColor]];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setShowsVerticalScrollIndicator:NO];
        [scrollView setDelegate:self];
        [scrollView setScrollEnabled:YES];
        [scrollView setBounces:NO];
        
        [mSheet addSubview:scrollView];
        
        if (cout > 6) {
            mSheet.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 105*rowCount, 0, 20)] ;
            [pageControl setNumberOfPages:0];
            [pageControl setCurrentPage:0];
            [pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
            [mSheet addSubview:pageControl];
        }
        
        
        mSheet.items = [[NSMutableArray alloc] initWithCapacity:cout];
        
    }
    return mSheet;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)showInView:(UIView *)view
{
    [super showInView:view];
  
    [self reloadData];
}

- (void)reloadData
{
    for (AWActionSheetCell* cell in items) {
        [cell removeFromSuperview];
        [items removeObject:cell];
    }
    
    //    if (!IconDelegate) {
    //        return;
    //    }
    
    int count = [IconDelegate numberOfItemsInActionSheet];
    
    if (count <= 0) {
        return;
    }
    
    int rowCount = 2;
    
    if (count <= 3) {
        [self setTitle:@"\n\n\n\n\n\n"];
        [scrollView setFrame:CGRectMake(0, 10, 320, 105)];
        rowCount = 1;
    } else if (count <= 6) {
        [self setTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n"];
        [scrollView setFrame:CGRectMake(0, 10, 320, 210)];
        rowCount = 2;
    }
    [scrollView setContentSize:CGSizeMake(320*(count/itemPerPage+1), scrollView.frame.size.height)];
    [pageControl setNumberOfPages:count/itemPerPage+1];
    [pageControl setCurrentPage:0];
    
    
    for (int i = 0; i< count; i++) {
        AWActionSheetCell* cell = [IconDelegate cellForActionAtIndex:i];
        int PageNo = i/itemPerPage;
        //        NSLog(@"page %d",PageNo);
        int index  = i%itemPerPage;
        
        if (itemPerPage == 6) {
            
            int row = index/3;
            int column = index%3;
            
            
            float centerY = (1+row*2)*self.scrollView.frame.size.height/(2*rowCount);
            float centerX = (1+column*2)*self.scrollView.frame.size.width/6;
            
            //            NSLog(@"%f %f",centerX+320*PageNo,centerY);
            
            [cell setCenter:CGPointMake(centerX+320*PageNo, centerY)];
            [self.scrollView addSubview:cell];
            if (cell.isButton) {
                cell.iconButton.tag = 100 + i;
                [cell.iconButton addTarget:self action:@selector(actionBtnForItem:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionForItem:)];
                [cell addGestureRecognizer:tap];
            }
            //            [cell.iconView addTarget:self action:@selector(actionForItem:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        [items addObject:cell];
    }
    
}

- (void)actionBtnForItem:(UIButton *)sender{
    [IconDelegate DidTapOnItemAtIndex:sender.tag - 100];
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)actionForItem:(UITapGestureRecognizer*)recongizer
{
    AWActionSheetCell* cell = (AWActionSheetCell*)[recongizer view];
    [IconDelegate DidTapOnItemAtIndex:cell.index];
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
- (IBAction)changePage:(id)sender {
    int page = pageControl.currentPage;
    [scrollView setContentOffset:CGPointMake(320 * page, 0)];
}
#pragma mark -
#pragma scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = scrollView.contentOffset.x /320;
    pageControl.currentPage = page;
}


@end

#pragma mark - AWActionSheetCell
@interface AWActionSheetCell ()
@end
@implementation AWActionSheetCell
@synthesize iconView;
@synthesize titleLabel;


-(id)initIsButton:(BOOL)isButton
{
    self.isButton = isButton;
    self = [super initWithFrame:CGRectMake(0, 0, 70, 70)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        if (isButton) {
            self.iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.iconButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.iconButton.frame = CGRectMake(6.5, 0, 57, 57);
            [self addSubview:self.iconButton];
        }else{
            self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(6.5, 0, 57, 57)] ;
            [iconView setBackgroundColor:[UIColor clearColor]];
            [[iconView layer] setCornerRadius:8.0f];
            [[iconView layer] setMasksToBounds:YES];
            
            [self addSubview:iconView];
        }
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, 70, 13)] ;
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setShadowColor:[UIColor blackColor]];
        [titleLabel setShadowOffset:CGSizeMake(0, 0.5)];
        [titleLabel setText:@""];
        [self addSubview:titleLabel];

    }
    return self;
}

@end


