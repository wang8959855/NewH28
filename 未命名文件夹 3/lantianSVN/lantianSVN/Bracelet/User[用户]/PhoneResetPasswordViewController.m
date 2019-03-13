//
//  PhoneResetPasswordViewController.m
//  Bracelet
//
//  Created by panzheng on 2017/5/8.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import "PhoneResetPasswordViewController.h"
#import "SecondResetPassworldViewController.h"
#import "XWCountryCodeController.h"

@interface PhoneResetPasswordViewController ()

@property (nonatomic, weak) UIView *backgroundView;

@property (nonatomic, weak) UIButton *countyCodeButton;

@property (nonatomic, weak) UITextField *phoneNumberTF;



@end

@implementation PhoneResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KCOLOR(42, 167, 155);
    [self loadUI];
    
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];

    NSDictionary *dictCodes = [NSDictionary dictionaryWithObjectsAndKeys:@"972", @"IL",
                               @"93", @"AF", @"355", @"AL", @"213", @"DZ", @"1", @"AS",
                               @"376", @"AD", @"244", @"AO", @"1", @"AI", @"1", @"AG",
                               @"54", @"AR", @"374", @"AM", @"297", @"AW", @"61", @"AU",
                               @"43", @"AT", @"994", @"AZ", @"1", @"BS", @"973", @"BH",
                               @"880", @"BD", @"1", @"BB", @"375", @"BY", @"32", @"BE",
                               @"501", @"BZ", @"229", @"BJ", @"1", @"BM", @"975", @"BT",
                               @"387", @"BA", @"267", @"BW", @"55", @"BR", @"246", @"IO",
                               @"359", @"BG", @"226", @"BF", @"257", @"BI", @"855", @"KH",
                               @"237", @"CM", @"1", @"CA", @"238", @"CV", @"345", @"KY",
                               @"236", @"CF", @"235", @"TD", @"56", @"CL", @"86", @"CN",
                               @"61", @"CX", @"57", @"CO", @"269", @"KM", @"242", @"CG",
                               @"682", @"CK", @"506", @"CR", @"385", @"HR", @"53", @"CU",
                               @"537", @"CY", @"420", @"CZ", @"45", @"DK", @"253", @"DJ",
                               @"1", @"DM", @"1", @"DO", @"593", @"EC", @"20", @"EG",
                               @"503", @"SV", @"240", @"GQ", @"291", @"ER", @"372", @"EE",
                               @"251", @"ET", @"298", @"FO", @"679", @"FJ", @"358", @"FI",
                               @"33", @"FR", @"594", @"GF", @"689", @"PF", @"241", @"GA",
                               @"220", @"GM", @"995", @"GE", @"49", @"DE", @"233", @"GH",
                               @"350", @"GI", @"30", @"GR", @"299", @"GL", @"1", @"GD",
                               @"590", @"GP", @"1", @"GU", @"502", @"GT", @"224", @"GN",
                               @"245", @"GW", @"595", @"GY", @"509", @"HT", @"504", @"HN",
                               @"36", @"HU", @"354", @"IS", @"91", @"IN", @"62", @"ID",
                               @"964", @"IQ", @"353", @"IE", @"972", @"IL", @"39", @"IT",
                               @"1", @"JM", @"81", @"JP", @"962", @"JO", @"77", @"KZ",
                               @"254", @"KE", @"686", @"KI", @"965", @"KW", @"996", @"KG",
                               @"371", @"LV", @"961", @"LB", @"266", @"LS", @"231", @"LR",
                               @"423", @"LI", @"370", @"LT", @"352", @"LU", @"261", @"MG",
                               @"265", @"MW", @"60", @"MY", @"960", @"MV", @"223", @"ML",
                               @"356", @"MT", @"692", @"MH", @"596", @"MQ", @"222", @"MR",
                               @"230", @"MU", @"262", @"YT", @"52", @"MX", @"377", @"MC",
                               @"976", @"MN", @"382", @"ME", @"1", @"MS", @"212", @"MA",
                               @"95", @"MM", @"264", @"NA", @"674", @"NR", @"977", @"NP",
                               @"31", @"NL", @"599", @"AN", @"687", @"NC", @"64", @"NZ",
                               @"505", @"NI", @"227", @"NE", @"234", @"NG", @"683", @"NU",
                               @"672", @"NF", @"1", @"MP", @"47", @"NO", @"968", @"OM",
                               @"92", @"PK", @"680", @"PW", @"507", @"PA", @"675", @"PG",
                               @"595", @"PY", @"51", @"PE", @"63", @"PH", @"48", @"PL",
                               @"351", @"PT", @"1", @"PR", @"974", @"QA", @"40", @"RO",
                               @"250", @"RW", @"685", @"WS", @"378", @"SM", @"966", @"SA",
                               @"221", @"SN", @"381", @"RS", @"248", @"SC", @"232", @"SL",
                               @"65", @"SG", @"421", @"SK", @"386", @"SI", @"677", @"SB",
                               @"27", @"ZA", @"500", @"GS", @"34", @"ES", @"94", @"LK",
                               @"249", @"SD", @"597", @"SR", @"268", @"SZ", @"46", @"SE",
                               @"41", @"CH", @"992", @"TJ", @"66", @"TH", @"228", @"TG",
                               @"690", @"TK", @"676", @"TO", @"1", @"TT", @"216", @"TN",
                               @"90", @"TR", @"993", @"TM", @"1", @"TC", @"688", @"TV",
                               @"256", @"UG", @"380", @"UA", @"971", @"AE", @"44", @"GB",
                               @"1", @"US", @"598", @"UY", @"998", @"UZ", @"678", @"VU",
                               @"681", @"WF", @"967", @"YE", @"260", @"ZM", @"263", @"ZW",
                               @"591", @"BO", @"673", @"BN", @"61", @"CC", @"243", @"CD",
                               @"225", @"CI", @"500", @"FK", @"44", @"GG", @"379", @"VA",
                               @"852", @"HK", @"98", @"IR", @"44", @"IM", @"44", @"JE",
                               @"850", @"KP", @"82", @"KR", @"856", @"LA", @"218", @"LY",
                               @"853", @"MO", @"389", @"MK", @"691", @"FM", @"373", @"MD",
                               @"258", @"MZ", @"970", @"PS", @"872", @"PN", @"262", @"RE",
                               @"7", @"RU", @"590", @"BL", @"290", @"SH", @"1", @"KN",
                               @"1", @"LC", @"590", @"MF", @"508", @"PM", @"1", @"VC",
                               @"239", @"ST", @"252", @"SO", @"47", @"SJ", @"963", @"SY",
                               @"886", @"TW", @"255", @"TZ", @"670", @"TL", @"58", @"VE",
                               @"84", @"VN", @"1", @"VG", @"1", @"VI", nil];

    NSString *displayNameString = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
    NSString * getCode = dictCodes[countryCode];
    [_countyCodeButton setTitle:[NSString stringWithFormat:@"%@ +%@ ▼",displayNameString,getCode] forState:UIControlStateNormal];    
}

- (void)loadUI
{
    [self backgroundView];
    [self countyCodeButton];
    [self phoneNumberTF];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = NSLocalizedString(@"找回密码",nil);
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    [self.view addSubview:titleLabel];
    titleLabel.sd_layout.topSpaceToView(self.view, 30)
    .centerXIs(ScreenW / 2.0)
    .heightIs(30);
    
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    backButton.sd_layout.topSpaceToView(self.view, 30)
    .leftSpaceToView(self.view, 12)
    .widthIs(60)
    .heightIs(30);
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextButton.backgroundColor = KCOLOR(35, 145, 136);
    [nextButton setTitle:NSLocalizedString(@"下一步",nil) forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    nextButton.frame = [self setCGRectWithX:35 Y:463 Width:375-70 Heigth:46];
    nextButton.layer.cornerRadius = 5;
    [self.view addSubview:nextButton];
}

- (void)next:(id)sender
{
    if (![Common validatePhoneNumber:_phoneNumberTF.text])
    {
        [self.view makeToast:NSLocalizedString(@"请输入正确的手机号码",nil) duration:2.5f position:[NSValue valueWithCGPoint:self.view.center]];
        return;
    }

    NSScanner *scanner = [NSScanner scannerWithString:_countyCodeButton.titleLabel.text];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    int number;
    [scanner scanInt:&number];
    NSString *nationCode =[NSString stringWithFormat:@"%d",number];
    NSDictionary *param = @{@"name":_phoneNumberTF.text,
                            @"nationCode":nationCode};
    
    
    [self.activityView startAnimating];
    adaLog(@"%@",param);
    kWEAKSELF;
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_GET RequestURL:@"Reset" ParametersDictionary:param Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
        adaLog(@"%@",responseObject);
        if (responseObject)
        {
            [weakSelf.activityView stopAnimating];
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]] ;
            if ([code isEqualToString:@"0"])
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"验证码已发送至您的手机,请注意查收",nil) preferredStyle:UIAlertControllerStyleAlert];
                
                kWEAKSELF;
                UIAlertAction *okButton = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    SecondResetPassworldViewController *secondVC = [SecondResetPassworldViewController new];
                    secondVC.nameString =weakSelf.phoneNumberTF.text;
                    [weakSelf.navigationController pushViewController:secondVC animated:YES];
                }];
                [alert addAction:okButton];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                [self.view makeToast:@"发送失败" duration:2. position:[NSValue valueWithCGPoint:self.view.center]];
            }
        }else
        {
            [self.view makeToast:@"发送失败" duration:2. position:[NSValue valueWithCGPoint:self.view.center]];
        }
    }];
    
    

}

- (void)countryCodeAction {
    NSLog(@"进入选择国际代码界面");
    XWCountryCodeController *CountryCodeVC = [[XWCountryCodeController alloc] init];
    
    //block
    [CountryCodeVC toReturnCountryCode:^(NSString *countryCodeStr) {
        [self.countyCodeButton setTitle:[NSString stringWithFormat:@"%@ ▼",countryCodeStr] forState:UIControlStateNormal];
    }];
    
    [self presentViewController:CountryCodeVC animated:YES completion:nil];
}

- (void)back:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- GET方法

- (UIView *)backgroundView
{
    if (!_backgroundView)
    {
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = KCOLOR(35, 145, 136);
        backView.frame = [self setCGRectWithX:35 Y:151 Width:375 - 70 Heigth:197];
        _backgroundView = backView;
        _backgroundView.layer.cornerRadius = 5;
        [self.view addSubview:_backgroundView];
    }
    return _backgroundView;
}

- (UIButton *)countyCodeButton
{
    if (!_countyCodeButton)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:NSLocalizedString(@"国家码 ▼",nil) forState:UIControlStateNormal];
        button.frame = [self setCGRectWithX:25 Y:40 Width:252 Heigth:40];
        [button addTarget:self action:@selector(countryCodeAction) forControlEvents:UIControlEventTouchUpInside];
        [self.backgroundView addSubview:button];
        _countyCodeButton = button;
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = KCOLOR(122, 175, 166);
        [self.backgroundView addSubview:lineView];
        lineView.sd_layout.topSpaceToView(button, 0)
        .leftEqualToView(button)
        .rightEqualToView(button)
        .heightIs(1);
    }
    return _countyCodeButton;
}

- (UITextField *)phoneNumberTF
{
    if (!_phoneNumberTF)
    {
        UITextField *nameTextField = [[UITextField alloc] init];
        nameTextField.borderStyle = UITextBorderStyleNone;
        nameTextField.frame = [self setCGRectWithX:25 Y:100 Width:252 Heigth:40];
        nameTextField.textAlignment = NSTextAlignmentCenter;
        nameTextField.textColor = [UIColor whiteColor];
        nameTextField.keyboardType = UIKeyboardTypePhonePad;
        _phoneNumberTF = nameTextField;
        [self.backgroundView addSubview:_phoneNumberTF];
        _phoneNumberTF.placeholder = NSLocalizedString(@"手机", nil);
        
        [self configTextField:_phoneNumberTF];
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = KCOLOR(122, 175, 166);
        [self.backgroundView addSubview:lineView];
        lineView.sd_layout.topSpaceToView(nameTextField, 0)
        .leftEqualToView(nameTextField)
        .rightEqualToView(nameTextField)
        .heightIs(1);
    }
    return _phoneNumberTF;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
