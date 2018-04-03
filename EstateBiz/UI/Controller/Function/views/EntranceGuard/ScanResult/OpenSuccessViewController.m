//
//  OpenSuccessViewController.m
//  colourlife
//
//  Created by mac on 16/1/9.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import "OpenSuccessViewController.h"
//#import "GetDoorInfoModel.h"
//#import "OpenDoorModel.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <CommonCrypto/CommonDigest.h>

static NSString * const kServiceUUID = @"FFE0";
static NSString * const kCharacteristicUUID = @"FFE1";
#define SERVICE_UUID     0xFFE0
#define CHAR_UUID        0xFFE1


@interface OpenSuccessViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commonENtranceGuardBtnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backBtnTop;
@property (weak, nonatomic) IBOutlet UIButton *commonEntranceGuardBtn;
@property (weak, nonatomic) IBOutlet UIImageView *openResultImageView;
@property (weak, nonatomic) IBOutlet UILabel *openResultLabel;
@property (weak, nonatomic) IBOutlet UIButton *rescanBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (nonatomic, copy) NSString *doorinfo;
@property (nonatomic, copy) NSString *doorid;

@property (nonatomic, copy) NSString *doorname;
@property (nonatomic, copy) NSString *dooraddress;

@property (nonatomic, strong) NSString *bid;//小区id

/**
 蓝牙开门相关
 */
@property (nonatomic, retain) CBCentralManager *mgr;//中心设备管理者
@property (nonatomic, retain) CBPeripheral *myPeripheral;//选中的外设
@property (nonatomic, retain) CBService *service;//服务
@property (nonatomic, retain) CBCharacteristic *characteristic;//特征
@property (nonatomic, copy) NSString *qrcode;
@property (nonatomic, copy) NSString *wifienable;
@property (nonatomic, copy) NSString *wificode;//蓝牙Mac地址
@property (nonatomic, assign) BOOL openByNet;//是否通过网络打开
@property (nonatomic, strong) NSArray *doorArray;
@property (nonatomic, strong) NSDate *startDate;//开始时间
@property (nonatomic, assign) BOOL doorOpeded;
@property (nonatomic, assign) BOOL doorOpeningByBle;//是否正在通过蓝牙开门
@property (nonatomic, assign) BOOL isHaveDoorLimit;

@end

@implementation OpenSuccessViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.commonEntranceGuardBtn.clipsToBounds = YES;
    self.commonEntranceGuardBtn.layer.cornerRadius = 8;
    self.commonEntranceGuardBtn.backgroundColor = VIEW_BTNBG_COLOR;
    [self.commonEntranceGuardBtn setTitleColor:VIEW_BTNTEXT_COLOR forState:UIControlStateNormal];
    
    self.rescanBtn.clipsToBounds = YES;
    self.rescanBtn.layer.cornerRadius = 8;
    
    self.backBtn.clipsToBounds = YES;
    self.backBtn.layer.cornerRadius = 8;
}
//普通开门和蓝牙开门
-(instancetype)initWithQrcodeByNet:(NSString *)qrcode{
    if (self = [super init]) {
        self.qrcode = qrcode;
        //网络开门
        self.openByNet = YES;
    }
    return self;
}
//只通过蓝牙开门
-(instancetype)initWithQrcodebyBle:(NSString *)qrcode{
    if (self = [super init]) {
        self.qrcode = qrcode;
        //网络开门
        self.openByNet = NO;
    }
    return self;
}

#pragma mark - 懒加载
- (NSArray *)doorArray{
    if (!_doorArray){
        _doorArray = [NSArray arrayWithObjects:@"rYLTdl8cEUn0x1jH", @"hRDs6uXcWkUx5KSU", @"AyLbIoIAxESIFaJ4", @"KnxL2uHPiZLYf8t2",@"gsQTGUC5Esc4hhvF",@"VEHh0rWNw20L2Js8",@"7FgEevVryWDpHXzq",@"lth55oTh6fFL2jZo",@"LoRpYZMl85CHVytl",@"2VOYAkfOB1ZoeYNd", @"qgkwTZjdfwVzZFl9", @"FG3BHrtZZoKUoArB", @"5LjSFeOZCTz8Ffse", @"KB2okpE6v95B1MwM",@"pOpi1Q63WHCoGdwu", @"teFuwVYW29uJtXV6", @"PZO68GWtUxWTnD49", @"BEyDyurtW9FCiUfk", @"fKccW5JMF4ISz82b",@"a3ajkVGxOz4DQpt2",nil];
    }
    return _doorArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.isHaveDoorLimit = YES;
    if (self.openByNet){
        NSDictionary *door = [LocalData getDoorLimitByQrcode:self.qrcode];
        if ([ISNull isNilOfSender:door]){
            self.isHaveDoorLimit = NO;
        }else{
            self.bid = [door objectForKey:@"bid"];
            self.doorid = [door objectForKey:@"doorid"];
        }
    }
    
    NSString *fitness = [LocalData getBleMacByQrcode:self.qrcode];//
    if ([ISNull isNilOfSender:fitness]){
        if (!self.openByNet){
            //本地不存在蓝牙门禁记录但必须蓝牙开门时
            self.isHaveDoorLimit = NO;
        }
    }else{
        NSArray *array = [fitness componentsSeparatedByString:@"*"];
        self.bid = array[1];
        self.doorid = array[3];
        self.wificode = [NSString stringWithFormat:@"%@",array[0]];//蓝牙Mac地址#通道号
    }
    
    
    
    //设置导航栏的数据
    [self setupNavgationBar];
    
    //开门
    [self openDoor];
    
}
//设置导航栏的数据
-(void)setupNavgationBar{
    self.navigationItem.title=@"门禁";
    self.navigationItem.leftBarButtonItem=[AppTheme backItemWithHandler:^(id sender) {
        
        
        for (UIViewController* tempVC in [self.navigationController viewControllers]) {
            if ([tempVC isKindOfClass:[EntranceGuardController class]]) {
                [self.navigationController popToViewController:tempVC animated:YES];
                return ;
            }
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)openDoor{
    if (!self.qrcode) {
        [self presentFailureTips:@"门禁不存在"];
        self.openResultLabel.text = @"开门失败";
        self.openResultImageView.image = [UIImage imageNamed:@"f4_open_fail"];
        self.rescanBtn.hidden = NO;
        self.backBtn.hidden = NO;
        return;
    }
    
    if (!self.isHaveDoorLimit && !_openByNet){
        [self openDoorFail];
    }
    
    if (_openByNet){
        //开门
        [self presentLoadingTips:nil];
        [[BaseNetConfig shareInstance] configGlobalAPI:WETOWN];
        OpenDoorAPI *openDoorApi = [[OpenDoorAPI alloc]initWithQrcode:self.qrcode];
        openDoorApi.doorType = OPENDOOR;
        
        [openDoorApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            NSDictionary *result = (NSDictionary *)request.responseJSONObject;
            if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
                [self dismissTips];
                
                self.bid = result[@"communityid"];
                
                [self openDoorSuccess];
                
            }else{
                [self dismissTips];
                if (![ISNull isNilOfSender:[LocalData getBleMacByQrcode:self.qrcode]]){
                    self.openResultLabel.text = @"开门失败,尝试蓝牙开门";
                    [self openDoorBle];
                }else{
                    [self openDoorFail];
                }
            }
            
        } failure:^(__kindof YTKBaseRequest *request) {
            [self dismissTips];
            if (![ISNull isNilOfSender:[LocalData getBleMacByQrcode:self.qrcode]]){
                self.openResultLabel.text = @"开门失败,尝试蓝牙开门";
                [self openDoorBle];
            }else{
                [self openDoorFail];
            }
        }];
        
    }else{
        [self openDoorBle];
    }
    
}

//开门失败
- (void)openDoorFail{
    if (self.isHaveDoorLimit){
        //保存开门信息到本地
        NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
        [dictM setObject:self.doorid forKey:@"doorid"];
        [dictM setObject:[NSDate phpTimestampFrom:[NSDate date]] forKey:@"opentime"];
        [dictM setObject:[NSDate phpTimestampFromStartDate:self.startDate ToDate:[NSDate date]] forKey:@"actiontime"];
        [dictM setObject:@"1" forKey:@"result"];
        NSLog(@"%@",dictM);
        [LocalData updateOpenDoorLog:dictM];
    }
    
    [self dismissTips];
    self.openResultLabel.text = @"开门失败";
    self.openResultImageView.image = [UIImage imageNamed:@"f4_open_fail"];
    self.rescanBtn.hidden = NO;
    self.backBtn.hidden = NO;
}
//开门成功
- (void)openDoorSuccess{
    
    if (self.isHaveDoorLimit){
        //保存开门信息到本地
        NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
        [dictM setObject:self.doorid forKey:@"doorid"];
        [dictM setObject:[NSDate phpTimestampFrom:[NSDate date]] forKey:@"opentime"];
        [dictM setObject:[NSDate phpTimestampFromStartDate:self.startDate ToDate:[NSDate date]] forKey:@"actiontime"];
        [dictM setObject:@"0" forKey:@"result"];
        NSLog(@"%@",dictM);
        [LocalData updateOpenDoorLog:dictM];
    }
    
    [self dismissTips];
    
    self.openResultLabel.text = @"开门成功";
    self.openResultImageView.image = [UIImage imageNamed:@"f4_open_successes"];
    
    if (![LocalData containLockBookmark:self.qrcode]) {
        self.commonEntranceGuardBtn.hidden = NO;
        self.backBtn.hidden = NO;
        self.commonENtranceGuardBtnHeight.constant = 42;
        self.backBtnTop.constant = 10;
    }
    else{
        self.commonEntranceGuardBtn.hidden = YES;
        self.backBtn.hidden = NO;
        self.commonENtranceGuardBtnHeight.constant = 0;
        self.backBtnTop.constant = 0;
    }
    self.rescanBtn.hidden = YES;
    
    if (self.bid) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openDoorCommunity" object:self.bid];
    }
    
}

//通过蓝牙开门
- (void)openDoorBle{
    if (![ISNull isNilOfSender:[LocalData getBleMacByQrcode:self.qrcode]]){
        //创建中心管理者，管理中心设备
        self.mgr = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        [self cleanup];
        //开始搜索蓝牙设备
        [self.mgr scanForPeripheralsWithServices:nil options:nil];
        self.doorOpeningByBle = YES;
    }else{
        if (!_openByNet){
            [self presentFailureTips:@"您没有此门权限，请联系管理员"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [self openDoorFail];
        }
    }
}

-(void)getDoorinfo{
    
    [self presentLoadingTips:nil];
    OpenDoorAPI *getDoorInfoApi = [[OpenDoorAPI alloc]initWithQrcode:self.qrcode];
    getDoorInfoApi.doorType = GETDOORINFO;
    
    [[BaseNetConfig shareInstance]configGlobalAPI:WETOWN];
    
    [getDoorInfoApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        if (![ISNull isNilOfSender:result] && [result[@"result"] intValue] == 0) {
            [self dismissTips];
            NSDictionary *door = result[@"door"];
            if (![ISNull isNilOfSender:door]) {
                GetDoorInfoModel *getDoorinfoModel = [GetDoorInfoModel mj_objectWithKeyValues:result[@"door"]];
                self.doorname = getDoorinfoModel.name;
                self.dooraddress = getDoorinfoModel.address;
                self.wifienable = getDoorinfoModel.wifienable;
                
                NSDictionary *lock = [NSDictionary dictionaryWithObjectsAndKeys:self.qrcode,@"qrcode",self.doorname,@"name",self.dooraddress,@"address",self.wifienable,@"wifienable" , nil];
                [LocalData updateLockBookmark:lock];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"COLLECTSUCCESS" object:nil];
                
                for (UIViewController* tempVC in [self.navigationController viewControllers]) {
                    if ([tempVC isKindOfClass:[EntranceGuardController class]]) {
                        [self.navigationController popToViewController:tempVC animated:YES];
                        return ;
                    }
                }
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        }else{
            [self presentFailureTips:result[@"reason"]];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [self presentFailureTips:[NSString stringWithFormat:@"网络错误,%ld",(long)request.responseStatusCode]];
    }];
}

#pragma mark -点击事件
//添加常用门禁
- (IBAction)addCommonEntranceGuardClick:(id)sender {
    //获取门信息
    [self getDoorinfo];
}
//返回
- (IBAction)backClick:(id)sender {
    
    for (UIViewController* tempVC in [self.navigationController viewControllers]) {
        if ([tempVC isKindOfClass:[EntranceGuardController class]]) {
            [self.navigationController popToViewController:tempVC animated:YES];
            return ;
        }
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//重新扫描
- (IBAction)rescanClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - 向蓝牙发送数据
- (void)sendMessageToBle{
    int index =  arc4random() % 20;
    NSString *doorcode = self.doorArray[index];
    
    NSString *dateStr1 = [NSDate stringFromDate:[NSDate date] withFormat:@"yyyyMMdd"];
    NSString *dateStr2 = [NSDate stringFromDate:[NSDate date] withFormat:@"MMddyyyy"];
    NSString *dateStr = [NSString stringWithFormat:@"%@%@",dateStr1,dateStr2];
    
    NSString *strA1 = @"OW15LjrCaY2bfcMl";
    NSString *strB1 = @"aWuK48JRDPePsYXE";
    
    Byte *A = [self strToByte:dateStr];
    Byte *A1 = [self strToByte:strA1];
    Byte *B = [self strToByte:doorcode];
    Byte *B1 = [self strToByte:strB1];
    
    Byte bleData[16] = {0};
    for (int i = 0; i < strA1.length; i ++) {
        Byte left = (Byte)(A[i] & A1[i]);
        Byte right = (Byte)(B[i] | B1[i]);
        
        bleData[i] = (Byte)(left ^ right);
    }
    Byte bleMD5[16] ={0};
    CC_MD5(bleData, 16, bleMD5);
    Byte final[15] = {0};
    final[0] = 15;
    for (int i = 0; i < 12; i ++) {
        final[i + 1] = bleMD5[i];
    }
    final[13] = 13;
    final[14] = 10;
    
    NSString *wificode = [self.wificode trim];
    NSString *headString = [NSString stringWithFormat:@"#72#33#%@#",wificode];
    NSData *headData = [headString dataUsingEncoding:NSASCIIStringEncoding];
    NSData *bodyData = [[NSData alloc] initWithBytes:final length:15];
    NSMutableData *keyData = [[NSMutableData alloc] init];
    [keyData appendData:headData];
    [keyData appendData:bodyData];
    
    [self writeValue:SERVICE_UUID characteristicUUID:CHAR_UUID p:self.myPeripheral data:keyData];
}

#pragma mark - 清理蓝牙
//清理缓存
- (void)cleanup
{
    
    if (!self.myPeripheral) {
        return;
    }
    
    if (self.myPeripheral.state==CBPeripheralStateDisconnected||self.myPeripheral.state == CBPeripheralStateConnecting)
    {
        self.myPeripheral=nil;
        self.characteristic = nil;
        return;
    }
    
    if (self.service != nil&&self.characteristic!=nil)
    {
        if (self.characteristic.isNotifying)
        {
            [self.myPeripheral setNotifyValue:NO forCharacteristic:self.characteristic];
        }
    }
    
    [self.mgr cancelPeripheralConnection:self.myPeripheral];
    
    [self.mgr stopScan];
    
    self.myPeripheral=nil;
    self.service=nil;
    self.characteristic=nil;
}

#pragma mark - CBCentralManagerDelegate
//设备蓝牙状态更新
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
    switch (central.state) {
        case CBCentralManagerStateUnsupported:
            NSLog(@"该设备不支持BLE蓝牙");
            [self presentFailureTips:@"该设备不支持BLE蓝牙"];
            break;
        case CBCentralManagerStateUnauthorized:
            [self presentFailureTips:@"该设备未授权BLE蓝牙"];
            NSLog(@"该设备未授权BLE蓝牙");
            break;
        case CBCentralManagerStatePoweredOff:
            [self presentFailureTips:@"该设备BLE蓝牙已关闭,请前往【设置】中打开蓝牙"];
            NSLog(@"该设备BLE蓝牙已关闭");
            break;
        case CBCentralManagerStateUnknown:
            [self presentFailureTips:@"该设备BLE蓝牙发生未知错误"];
            NSLog(@"该设备BLE蓝牙发生未知错误");
            break;
        case CBCentralManagerStateResetting:
            [self presentFailureTips:@"该设备BLE蓝牙重置中"];
            NSLog(@"该设备BLE蓝牙重置中");
            break;
        case CBCentralManagerStatePoweredOn:
            [self cleanup];
            [self.mgr scanForPeripheralsWithServices:nil options:nil];
            break;
            
        default:
            NSLog(@"Central Manager did change state");
            break;
    }
}

//发现外部设备时候调用此方法
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSString *periName = peripheral.name;
    NSString *wificode = [self.wificode trim];
    NSArray *arr = [wificode componentsSeparatedByString:@"#"];
    NSString *bleName = arr[0];
    self.myPeripheral = peripheral;
    if ([[periName trim] isEqualToString:[bleName trim]]){
        //连接设备
        [self.mgr connectPeripheral:self.myPeripheral options:nil];
        //停止扫描蓝牙
        [self.mgr stopScan];
    }
}

//连接蓝牙成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    //发现服务
    self.myPeripheral .delegate = self;
    [self.myPeripheral  discoverServices:nil];
}

//连接蓝牙失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSString *err = [NSString stringWithFormat:@"连接蓝牙门禁%@失败,原因:%@",peripheral.name,[error localizedDescription]];
    NSLog(@"%@",err);
    [self dismissTips];
}

//断开蓝牙连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [self dismissTips];
}


#pragma mark CBPeripheralDelegate
//外设已经查找到服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) return; //发现服务失败
    
    //遍历所有服务
    for (CBService *service in self.myPeripheral.services) {
        NSLog(@"%@",service.UUID);
        if ([service.UUID isEqual:[CBUUID UUIDWithString:kServiceUUID]]){
            self.service = service;
            break;
        }
    }
    
    if (self.service) {
        
        [self.myPeripheral discoverCharacteristics:nil forService:self.service];
    }
    
}

#pragma mark 找到特征时调用

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error) return; //发现特征失败
    
    for (CBCharacteristic *characteristic in self.service.characteristics)
    {
        NSLog(@"%@",characteristic.UUID);
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kCharacteristicUUID]])
        {
            self.characteristic = characteristic;
            //对此特征设置通知和读取返回数据
            [self.myPeripheral setNotifyValue:YES forCharacteristic:self.characteristic];
            [self.myPeripheral readValueForCharacteristic:self.characteristic];
            [self sendMessageToBle];
            break;
        }
        
    }
}


- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"%@",error);
        return;
    } //发送数据失败
    
}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) return; //接收特征数据失败
    NSString *value = [[NSString alloc] initWithData:characteristic.value encoding:NSASCIIStringEncoding];
    NSLog(@"value==============%@",value);//蓝牙返回的信息，需要对蓝牙设备做特殊处理才能按照一定的格式返回数据
    if ([value hasSuffix:@"#0"]){
        //开门成功
        [self openDoorSuccess];
    }else if ([value hasSuffix:@"#1"]){
        //失败，无权限
        [self presentFailureTips:@"开门失败，无权限"];
        [self openDoorFail];
    }else if ([value hasSuffix:@"#2"]){
        //失败，权限过期
        [self presentFailureTips:@"开门失败，权限过期"];
        [self openDoorFail];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) return; //开启特征数据返回通知失败
    
}

# pragma mark - 发送数据
-(void) writeValue:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p data:(NSData *)data {
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUIDEx:su p:p];
    if (!service) {
        printf("Could not find service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:su],[self UUIDToString:(__bridge CFUUIDRef )p.identifier]);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUIDEx:cu service:service];
    if (!characteristic) {
        printf("Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:cu],[self CBUUIDToString:su],[self UUIDToString:(__bridge CFUUIDRef )p.identifier]);
        return;
    }
    [p setNotifyValue:YES forCharacteristic:characteristic];
    if(characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse)
    {
        [p writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
    }else
    {
        [p writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
}

-(UInt16) swap:(UInt16)s {
    UInt16 temp = s << 8;
    temp |= (s >> 8);
    return temp;
}
-(CBService *) findServiceFromUUIDEx:(CBUUID *)UUID p:(CBPeripheral *)p {
    for(int i = 0; i < p.services.count; i++) {
        CBService *s = [p.services objectAtIndex:i];
        if ([self compareCBUUID:s.UUID UUID2:UUID]) return s;
    }
    return nil; //Service not found on this peripheral
}
-(int) compareCBUUID:(CBUUID *) UUID1 UUID2:(CBUUID *)UUID2 {
    char b1[16];
    char b2[16];
    [UUID1.data getBytes:b1];
    [UUID2.data getBytes:b2];
    if (memcmp(b1, b2, UUID1.data.length) == 0)return 1;
    else return 0;
}
-(const char *) CBUUIDToString:(CBUUID *) UUID {
    return [[UUID.data description] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
}
-(const char *) UUIDToString:(CFUUIDRef)UUID {
    if (!UUID) return "NULL";
    CFStringRef s = CFUUIDCreateString(NULL, UUID);
    return CFStringGetCStringPtr(s, 0);
}

-(CBCharacteristic *) findCharacteristicFromUUIDEx:(CBUUID *)UUID service:(CBService*)service {
    for(int i=0; i < service.characteristics.count; i++) {
        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
        if ([self compareCBUUID:c.UUID UUID2:UUID]) return c;
    }
    return nil; //Characteristic not found on this service
}

//字符串转byte
- (Byte *)strToByte:(NSString *)strBefor{
    Byte *bt = (Byte *)malloc(16);
    for (int i =0; i < strBefor.length; i++) {
        int strInt = [strBefor characterAtIndex:i];
        Byte b =  (Byte) ((0xff & strInt) );//( Byte) 0xff&iByte;
        bt[i] = b;
    }
    return bt;
}

@end
