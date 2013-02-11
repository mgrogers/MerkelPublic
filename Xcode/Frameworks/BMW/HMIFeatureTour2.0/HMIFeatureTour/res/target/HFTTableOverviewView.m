#import "HFTTableOverviewView.h"

@interface HFTTableOverviewView() <IDTableDelegate>
@end

@implementation HFTTableOverviewView

- (void)viewWillLoad:(IDView *)view
{
    self.title = @"Tables Sample";
    
    IDLabel *labelTextTable = [IDLabel label];
    labelTextTable.text = @"Table 1 Sample --> 4 Rows 3 Columns";
    
    IDLabel *lableImageTable = [IDLabel label];
    lableImageTable.text = @"Table 2 Sample --> 4 Rows 2 Columns";
    
    IDTable *imageTable = [IDTable table];
    [imageTable setDelegate:self];
    [imageTable setRowCount:4 columnCount:2];
    [imageTable setColumnWidths:[NSArray arrayWithObjects: [NSNumber numberWithInt:80],[NSNumber numberWithInt:250],nil]];
    
    IDTable *textTable = [IDTable table];
    [textTable setDelegate:self];
    [textTable setRowCount:4 columnCount:3];
    [textTable setColumnWidths:[NSArray arrayWithObjects: [NSNumber numberWithInt:180],[NSNumber numberWithInt:180],[NSNumber numberWithInt:180],nil]];
    
    for(int i = 0; i < 4; i++)
    {
        for(int j = 0; j < 3; j++)
        {
            [textTable setCell:[IDTableCell tableCellWithString:[NSString stringWithFormat:@"R:%d - C:%d", i, j]] atRow:i column:j];
        }
    }
    
    // First image loaded from the Image Database, the rest, from resources.
    [imageTable setCell:[IDTableCell tableCellWithImageData:[self.application.imageBundle imageWithName:@"iconOpt" type:@"png"]] atRow:0 column:0];
    [imageTable setCell:[IDTableCell tableCellWithImageData:[self.application.imageBundle imageWithName:@"iconFlag" type:@"png"]] atRow:1 column:0];
    [imageTable setCell:[IDTableCell tableCellWithImageData:[self.application.imageBundle imageWithName:@"iconDislike" type:@"png"]] atRow:2 column:0];
    [imageTable setCell:[IDTableCell tableCellWithImageData:[self.application.imageBundle imageWithName:@"iconLike" type:@"png"]] atRow:3 column:0];
    
    // Text cells load
    [imageTable setCell:[IDTableCell tableCellWithString:@"Image 1"] atRow:0 column:1];
    [imageTable setCell:[IDTableCell tableCellWithString:@"Image 2"] atRow:1 column:1];
    [imageTable setCell:[IDTableCell tableCellWithString:@"Image 3"] atRow:2 column:1];
    [imageTable setCell:[IDTableCell tableCellWithString:@"Image 4"] atRow:3 column:1];
    
    self.widgets = [NSArray arrayWithObjects:
                    labelTextTable,
                    textTable,
                    lableImageTable,
                    imageTable,
                    nil];
}

#pragma mark - IDTableDelegate protocol method
- (void)table:(IDTable*)table didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"Element:%d selected at table:%p", index, table);
}

- (void)table:(IDTable *)table didFocusOnItemAtIndex:(NSInteger)index
{
    NSLog(@"Element:%d focused at table:%p", index, table);
}

@end
