#import "HFTGaugeOverviewView.h"

@interface HFTGaugeOverviewView() <IDIntegerGaugeDelegate, IDDateGaugeDelegate, IDDateGaugeDelegate, IDTimeGaugeDelegate>

@property (nonatomic, retain) IDIntegerGauge *simpleGauge;
@property (nonatomic, retain) IDIntegerGauge *balanceGauge;
@property (nonatomic, retain) IDIntegerGauge *gaugeBigNumber;
@property (nonatomic, retain) IDDateGauge *gaugeDate;
@property (nonatomic, retain) IDTimeGauge *gaugeTime;

@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSDateFormatter *timeFormatter;

@end

@implementation HFTGaugeOverviewView

@synthesize simpleGauge = _simpleGauge;
@synthesize balanceGauge = _balanceGauge;
@synthesize gaugeBigNumber = _gaugeBigNumber;
@synthesize gaugeDate = _gaugeDate;
@synthesize gaugeTime = _gaugeTime;
@synthesize dateFormatter = _dateFormatter;
@synthesize timeFormatter = _timeFormatter;

- (void)dealloc
{
    [_dateFormatter release];
    [_simpleGauge release];
    [_balanceGauge release];
    [_gaugeBigNumber release];
    [_gaugeDate release];
    [_gaugeTime release];
    [_timeFormatter release];
    [super dealloc];
}

- (void)viewWillLoad:(IDView *)view
{
    self.title = @"Gauges";
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    _timeFormatter = [[NSDateFormatter alloc] init];
    [self.timeFormatter setDateFormat:@"HH:mm:ss"];
    
    self.simpleGauge = [IDIntegerGauge gaugeWithMin:0 max:10 increment:1 startValue:5];
    self.simpleGauge.delegate = self;
    
    IDIntegerGauge *progressGauge = [IDIntegerGauge gaugeWithMin:0 max:20 increment:1 startValue:0];
    progressGauge.type = IDGaugeTypeProgress;
    progressGauge.delegate = self;
    
    self.balanceGauge = [IDIntegerGauge gaugeWithMin:0 max:100 increment:5 startValue:40];
    self.balanceGauge.type = IDGaugeTypeBalance;
    self.balanceGauge.delegate = self;
    
    self.gaugeBigNumber = [IDIntegerGauge gauge];
    self.gaugeBigNumber.text = @"Big Number";
    self.gaugeBigNumber.type = IDGaugeTypeBigNumber;
    self.gaugeBigNumber.delegate = self;
    
    self.gaugeDate = [IDDateGauge gauge];
    self.gaugeDate.text = @"Date";
    self.gaugeDate.type = IDGaugeTypeDate;
    self.gaugeDate.delegate = self;
    
    self.gaugeTime = [IDTimeGauge gauge];
    self.gaugeTime.text = @"Time";
    self.gaugeTime.type = IDGaugeTypeTime;
    self.gaugeTime.delegate = self;
    
    IDButton *buttonSetInputGauges = [IDButton button];
    buttonSetInputGauges.text = @"Reset Input Values";
    [buttonSetInputGauges setTarget:self selector:@selector(buttonSetInputGaugesPressed:) forActionEvent:IDActionEventSelect];
    
    
    self.widgets = [NSArray arrayWithObjects:
                    self.simpleGauge,
                    progressGauge,
                    self.balanceGauge,
                    self.gaugeBigNumber,
                    self.gaugeDate,
                    self.gaugeTime,
                    buttonSetInputGauges,
                    nil];
}

#pragma mark - Event Handlers
- (void) buttonSetInputGaugesPressed:(IDButton*)button
{
    NSLog(@"%s:%d", __FUNCTION__, __LINE__);
    [self.gaugeBigNumber setValue:0];
    [self.gaugeDate setDate:[NSDate date]];
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
    [components setHour:0];
    [components setMinute:0];
    NSDate *dTime = [calendar dateFromComponents:components];
    [self.gaugeTime setTime:dTime];
}


#pragma mark - IDDateGaugeDelegate Protocol Methods

- (void)gauge:(IDDateGauge *)gauge didEndEditingDate:(NSDate *)date
{
    NSString *theDate = [self.dateFormatter stringFromDate:date];
    NSLog(@"DateGauge %p value Updated:%@",gauge, theDate);
}

- (void)gauge:(IDDateGauge *)gauge didChangeDate:(NSDate *)date
{
    NSString *theDate = [self.dateFormatter stringFromDate:date];
    NSLog(@"DateGauge %p new value Changed:%@",gauge, theDate);
}


#pragma mark - IDIntegerGaugeDelegate Protocol Methods

- (void)gauge:(IDIntegerGauge *)gauge didEndEditingValue:(NSInteger)value
{
    NSLog(@"IntegerGauge %p value Updated:%d",gauge, value);
}

- (void)gauge:(IDIntegerGauge *)gauge didChangeValue:(NSInteger)value
{
    if (gauge == self.simpleGauge)
    {
        self.balanceGauge.value = self.simpleGauge.value*10;
        NSLog(@"Balance Gauge value %d change triggered by simpleGauge change.",self.balanceGauge.value);
    }
    NSLog(@"IntegerGauge %p new value Changed:%d",gauge, value);
}


#pragma mark - IDTimeGaugeDelegate Protocol Methods

- (void)gauge:(IDTimeGauge *)gauge didEndEditingTime:(NSDate *)date
{
    NSString *theTime = [self.timeFormatter stringFromDate:date];
    NSLog(@"TimeGauge %p value Updated:%@",gauge, theTime);
}

- (void)gauge:(IDTimeGauge *)gauge didChangeTime:(NSDate *)date
{
    NSString *theTime = [self.timeFormatter stringFromDate:date];
    NSLog(@"TimeGauge %p new value Changed:%@",gauge, theTime);
}

@end
