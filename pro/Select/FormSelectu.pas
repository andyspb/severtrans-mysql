unit FormSelectu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, toolbtn, StdCtrls, Buttons, BMPBtn, ToolWin, ComCtrls, Sqlctrls,
  LblCombo, Printers, LblEdtDt, ExtCtrls, TSQLCLS, SqlGrid, DB, Math,
  DBTables, Lbsqlcmb, OleServer, Excel2000, Word2000, XMLDOM, DBClient,
  MConnect, EntrySec;

type
  TFormSelect = class(TForm)
    ToolBar1: TToolBar;
    btPrint: TBMPBtn;
    eExit: TToolbarButton;
    Panel1: TPanel;
    cbxList: TLabelComboBox;
    Panel2: TPanel;
    LabelEditDate1: TLabelEditDate;
    LabelEditDate2: TLabelEditDate;
    Panel3: TPanel;
    cbZak: TLabelSQLComboBox;
    Panel4: TPanel;
    cbxSort: TLabelComboBox;
    WordApplication1: TWordApplication;
    cbCity: TLabelSQLComboBox;
    RadioGroup1: TRadioGroup;
    Panel5: TPanel;
    cbNumber: TLabelSQLComboBox;

    procedure FormCreate(Sender: TObject);
    procedure eExitClick(Sender: TObject);
    procedure btPrintClick(Sender: TObject);
    procedure cbxListChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSelect: TFormSelect;
  sends_view: string;
  order_table: string;
  paysheet_table: string;
  send_table: string;
  invoice_table: string;
  vs1_view: string;
  vs2_view: string;
  orders_view: string;
  // ini files
  sends_no_invoice_ini: string;
  finance_costs_ini: string;
  pay_receipt_ini: string;
  pay_receipt1_ini: string;
  svzaktek_ini: string;
  svzak_ini: string;
  sendgd_ini: string;
  volume_invoice_ini: string;
  paysheets_ini: string;
  svpayreceipt_ini: string;
  sendsppway_ini: string;

implementation

uses SendStr, makerepp, Invoice;
{$R *.dfm}

procedure TFormSelect.FormCreate(Sender: TObject);
var
  all: boolean;
begin
  Caption := '������ ( ������: ' + EntrySec.period + ' )';
  all := EntrySec.bAllData;
  // tables
  order_table := iff(all, '`Order_all`', '`Order`');
  paysheet_table := iff(all, 'PaySheet_all', 'PaySheet');
  send_table := iff(all, 'Send_all', 'Send');
  invoice_table := iff(all, 'invoice_all', 'invoice');
  // views
  sends_view := iff(all, 'sends_all', 'sends');
  vs1_view := iff(all, 'vs1_all', 'vs1');
  vs2_view := iff(all, 'vs2_all', 'vs2');
  orders_view := iff(all, 'orders_all', 'orders');
  // ini files
  sends_no_invoice_ini := iff(all, 'SendsNoInvoice_all', 'SendsNoInvoice');
  finance_costs_ini := iff(all, 'SendsNoInvoice_all', 'SendsNoInvoice');
  pay_receipt_ini := iff(all, 'PayReceipt_all', 'PayReceipt');
  pay_receipt1_ini := iff(all, 'PayReceipt1_all', 'PayReceipt1');
  svzaktek_ini := iff(all, 'SVZakTek_all', 'SVZakTek');
  svzak_ini := iff(all, 'SVZak_all', 'SVZak');
  sendgd_ini := iff(all, 'SendGD_all', 'SendGD');
  volume_invoice_ini := iff(all, 'VolumeInvoice_all', 'VolumeInvoice');
  paysheets_ini := iff(all, 'PaySheets_all', 'PaySheets');
  svpayreceipt_ini := iff(all, 'SVPayReceipt_all', 'SVPayReceipt');
  sendsppway_ini := iff(all, 'SendsPPWay_all', 'SendsPPWay');

  cbxList.ComboBox.DropDownCount := 30;

  cbxList.ComboBox.Items.Add('��������� ������'); {0}
  cbxList.ComboBox.Items.Add('��������'); {1}
  cbxList.ComboBox.Items.Add('������ ��� ���������'); {2}
  //cbxList.ComboBox.Items.Add('�/� ��������')    ;          {3}
  cbxList.ComboBox.Items.Add('����� ���������'); {3}
  cbxList.ComboBox.Items.Add('������ �� ����-��������'); {4}
  cbxList.ComboBox.Items.Add('��������'); {5}
  cbxList.ComboBox.Items.Add('����� ������'); {6}
  cbxList.ComboBox.Items.Add('��������� ���������'); {7}
  cbxList.ComboBox.Items.Add('������'); {8}
  cbxList.ComboBox.Items.Add('������ �� �� ����������� �����'); {9}
  cbxList.ComboBox.Items.Add('������ �� "-" ������'); {10}
  //cbxList.ComboBox.Items.Add('������ �� ��������� ���������� (�/�)');   {12}
  cbxList.ComboBox.Items.Add('������� ���������'); {11}
  cbxList.ComboBox.Items.Add('����� ��������� (��.)'); {12}
  cbxList.ComboBox.Items.Add('������ (��.)'); {13}
  cbxList.ComboBox.Items.Add('����� ��������� (�� �/�)'); {14}
  //cbxList.ComboBox.Items.Add('������ (04)')  ;                     {17}
  cbxList.ComboBox.Items.Add('������ ��� ��������� ���'); {15}
  cbxList.ComboBox.Items.Add('����� � ��������� ���������'); {16}
  cbxList.ComboBox.Items.Add('������� ��������� �� ����� �����1'); {17}
  cbxList.ComboBox.Items.Add('������� ��������� �� ����� �����2'); {18}
  cbxList.ComboBox.Items.Add('������� ��������� �� �/�'); {19}
  cbxList.ComboBox.Items.Add('������ �� ����������'); {20}
  cbxList.ComboBox.Items.Add('������ ��� ������'); {21}
  cbxList.ComboBox.Items.Add('����� ������� � ��������'); {22}
  cbxList.ComboBox.Items.Add('����� � ��������� ��������� ���'); {23}
  //cbxList.ComboBox.Items.Add('������� ��������� 2007')  ;                 {27}
  cbxList.ComboBox.Items.Add('������� ��������� ���'); {24}
  cbxList.ComboBox.Items.Add('������ �� "+" ������'); {25}
  cbxList.ComboBox.Items.Add('�������� ����-������'); {26}
  cbxList.ComboBox.Items.Add('�������� ��� ����-������'); {27}
  cbxList.ComboBox.Items.Add('����������� ������ ����-������'); {28}
  cbxList.ComboBox.Items.Add('������ �� �� ����������� ����� ���'); {29}
  //cbxList.ComboBox.Items.Add('������ (04)')  ;
  //------------------------------------
  cbxSort.ComboBox.Items.Add('��������');
  cbxSort.ComboBox.Items.Add('����');
  // cbxSort.ComboBox.Items.Add('�����')    ;
  //cbxSort.ComboBox.Items.Add('')

  //cbZak.SQLComboBox.Sorted:=true;
end;

procedure TFormSelect.eExitClick(Sender: TObject);
begin
  close;
end;

procedure TFormSelect.btPrintClick(Sender: TObject);
var
  //   C:TextFile;
  cond, cond1, cd, vs, str, credit1: string;
  l, i, sort, Num, CLI: integer;
  ReportMakerWP: TReportMakerWP;
  Fil, FilIni, FilOut, tempStr: string;
  str1, sql_str: TStringList;
  q, qCL: TQuery;
  Sum, WR, WC, F, ASP, Iv, ASPack: real;
  p, w1, w2, w3, w4, w5: OleVariant;
  SG, NG, SAv, NAV, SA, NA, SP, NP, SPA, NPA, SS, NS, SSA, NSA, SNDS: real;
  n, FilOp: integer;
  IdSend: longint;
  RowIndex: LongInt;
  //label T;
  booksel_file: TextFile;
  curr_date: string;
  curr_time: string;
  booksel_csv_path: string;
  booksel_index: Integer;
  data_and_number_sf: string;
  booksel_name: string;
  booksel_inn_kpp: string;
  booksel_doc_name: string;
  booksel_seller_name: string;
  booksel_seller_inn_kpp: string;
  booksel_sale_period: string;
label
  FO;
begin
  cond := '';
  cond1 := '';
  cd := '';
  l := cbxList.ComboBox.ItemIndex;
  sort := cbxSort.ComboBox.ItemIndex;
  //--------------------
  if l = -1 then
  begin
    Application.MessageBox('�������� ��� ������ ��� ������!', '������!', 0);
    exit
  end;
  if ((LabelEditDate1.Text = '  .  .    ') or (LabelEditDate2.Text =
    '  .  .    '))
    and (l <> 5) and (l <> 10) and (l <> 25) and (l <> 26) then
  begin
    Application.MessageBox('������� ����!', '������!', 0);
    exit
  end;

  //--------------------
  if (l <> 5) and (l <> 9) and (l <> 10) and (l <> 25) and (l <> 26) then
    {��� ���� ����� ��������� � ������ �� �� ����. �����}
  begin
    try
      if (strToDate(LabelEditDate1.Text) > StrToDate(LabelEditDate2.Text)) then
      begin
        Application.MessageBox('���� "�" ������ ���� "��"!', '������!', 0);
        exit
      end;
      { if (l=27) and (strToDate(LabelEditDate1.Text)< strToDate('01.01.2007'))then
      begin
        Application.MessageBox('���� "�" ������ ���� "01.01.2007"!','������!',0);
        exit
      end  }
    except
      Application.MessageBox('��������� ������������ ��������� ���!', '������!',
        0);
      exit
    end;
  end;
  try
    ReportMakerWP := TReportMakerWP.Create(Application);
    ReportMakerWP.ClearParam;
    cond := '';
    case l of
      0: {��������� ������}
        begin
          if sort = 0 then
            cond := 'ClientName'
          else if sort = 1 then
            cond := 'Dat';
          ReportMakerWP.AddParam('1=' + cond);
          cond := '';
          cond1 := '';
          if LabelEditDate1.text <> '  .  .    ' then
            cond1 := 'Dat>=''' + FormatDateTime('yyyy-mm-dd',
              StrToDate(LabelEditDate1.text)) + '''';
          cond := 'Dat>=' + FormatDateTime('yyyy-mm-dd',
            StrToDate(LabelEditDate1.text));

          if LabelEditDate2.text <> '  .  .    ' then
            if cond <> '' then
              cond := cond + ' and ';
          if cond1 <> '' then
            cond1 := cond1 + ' and ';
          cond1 := cond1 + 'Dat<=''' + FormatDateTime('yyyy-mm-dd',
            StrToDate(LabelEditDate2.text)) + '''';
          cond := cond + 'Dat<=''' + FormatDateTime('yyyy-mm-dd',
            StrToDate(LabelEditDate2.text)) + '''';
          if cbZak.SQLComboBox.GetData <> 0 then
          begin
            if cond <> '' then
              cond := cond + ' and Client_Ident=' +
                IntToStr(cbZak.SQLComboBox.GetData)
            else
              cond := 'Client_Ident=' + IntToStr(cbZak.SQLComboBox.GetData);
            if cond1 <> '' then
              cond1 := cond1 + ' and Client_Ident=' +
                IntToStr(cbZak.SQLComboBox.GetData)
            else
              cond1 := 'Client_Ident=' + IntToStr(cbZak.SQLComboBox.GetData);
          end;
          ReportMakerWP.AddParam('2=' + cond1);
          if LabelEditDate1.text <> '  .  .    ' then
            ReportMakerWP.AddParam('3=' + '� ' + LabelEditDate1.text)
          else
            ReportMakerWP.AddParam('3=' + '');
          if LabelEditDate2.text <> '  .  .    ' then
            ReportMakerWP.AddParam('4=' + '�� ' + LabelEditDate2.text)
          else
            ReportMakerWP.AddParam('4=' + '');
          ReportMakerWP.AddParam('5=' + '��������� ������');
          q := sql.select(order_table, '', cond1, '');
          Sum := 0;
          while (not q.eof) do
          begin
            Sum := Sum + q.fieldByName('SumNDS').asFloat;
            q.next;
          end;
          q.Free;
          ReportMakerWP.AddParam('6=' + StrTo00(FloatToStr(Sum)));
          Fil := 'PayReceipt';
          FilIni := pay_receipt_ini;
        end;
      //--------------------
      1: {��������}
        begin
          Cond := 'Acronym';
          if (sort = 0) then
            cond := 'Acronym'
          else if (sort = 1) then
            cond := 'Dat';
          ReportMakerWP.AddParam('1=' + cond);
          cond := '';
          if (LabelEditDate1.text <> '  .  .    ') then
            cond := 'Dat>=''' + FormatDateTime('yyyy-mm-dd',
              StrToDate(LabelEditDate1.text)) + '''';
          if (LabelEditDate2.text <> '  .  .    ') then
            if (cond <> '') then
              cond := cond + ' and ';
          cond := cond + 'Dat<=''' + FormatDateTime('yyyy-mm-dd',
            StrToDate(LabelEditDate2.text)) + '''';
          if (cbZak.SQLComboBox.GetData <> 0) then
          begin
            if (cond <> '') then
              cond := cond + ' and Client_Ident=' +
                IntToStr(cbZak.SQLComboBox.GetData)
            else
              cond := 'Client_Ident=' + IntToStr(cbZak.SQLComboBox.GetData);
          end;
          ReportMakerWP.AddParam('2=' + cond);
          if (LabelEditDate1.text <> '  .  .    ') then
            ReportMakerWP.AddParam('3=' + '� ' + LabelEditDate1.text)
          else
            ReportMakerWP.AddParam('3=' + '');
          if (LabelEditDate2.text <> '  .  .    ') then
            ReportMakerWP.AddParam('4=' + '�� ' + LabelEditDate2.text)
          else
            ReportMakerWP.AddParam('4=' + '');
          ReportMakerWP.AddParam('5=' + '��������');
          q := sql.select(paysheet_table, '', cond, '');
          Sum := 0;
          while (not q.eof) do
          begin
            Sum := Sum + q.fieldByName('Sum').asFloat;
            q.next;
          end;
          q.Free;
          ReportMakerWP.AddParam('6=' + StrTo00(FloatToStr(Sum)));
          Fil := 'PayReceipt';
          FilIni := pay_receipt1_ini;
        end;

      //--------------------
      2, 15: {������ ��� ���������}
        begin
          cd := '';
          cd := CreditDate(cbZak.SQLComboBox.GetData,
            StrToDate(LabelEditDate1.text));
          ReportMakerWP.AddParam('13=' + cd);
          cond := '';
          ReportMakerWP.AddParam('1=' + IntTostr(cbZak.SQLComboBox.GetData));
          ReportMakerWP.AddParam('2=' + '' + sql.SelectString('Clients', 'Name',
            'Ident=' + IntTostr(cbZak.SQLComboBox.GetData)));
          // ReportMakerWP.AddParam('2='+''+cbZak.SQLComboBox.Text);
          ReportMakerWP.AddParam('3=' + '� ' +
            SendStr.DataDMstrY(StrToDate(LabelEditDate1.text)));
          ReportMakerWP.AddParam('4=' + '�� ' +
            SendStr.DataDMstrY(StrToDate(LabelEditDate2.text)));
          ReportMakerWP.AddParam('14=' + '�� ' +
            SendStr.DataDMstrY(StrToDate(LabelEditDate2.text)));
          ReportMakerWP.AddParam('5=' + sql.MakeStr(FormatDateTime('yyyy-mm-dd',
            StrToDate(LabelEditDate1.text))));
          ReportMakerWP.AddParam('6=' + sql.MakeStr(FormatDateTime('yyyy-mm-dd',
            StrToDate(LabelEditDate2.text))));

          ReportMakerWP.AddParam('21=' + sql.MakeStr(orders_view));
          ReportMakerWP.AddParam('22=' + sql.MakeStr(paysheet_table));
          ReportMakerWP.AddParam('23=' + sql.MakeStr(sends_view));

          //ReportMakerWP.AddParam('16='+SendStr.DataDMstrY(now));
          if (sql.selectString('Boss', 'Person', 'Ident=1') <> '') then
            ReportMakerWP.AddParam('17=' + sql.selectString('Boss', 'Person',
              'Ident=1'))
          else
            ReportMakerWP.AddParam('17=' + '');
          if (sql.selectString('Boss', 'PersonBug', 'Ident=1') <> '') then
            ReportMakerWP.AddParam('18=' + sql.selectString('Boss', 'PersonBug',
              'Ident=1'))
          else
            ReportMakerWP.AddParam('18=' + '');
          //-----------------------------------------------------------------
          q := sql.select(order_table, 'SumNDS', 'Client_Ident=' +
            IntTostr(cbZak.SQLComboBox.GetData) +
            ' and dat>=' + sql.MakeStr(FormatDateTime('yyyy-mm-dd',
            StrToDate(LabelEditDate1.text))) +
            ' and dat<=' + sql.MakeStr(FormatDateTime('yyyy-mm-dd',
            StrToDate(LabelEditDate2.text))), '');
          Sum := 0;
          while (not q.eof) do
          begin
            sum := sum + q.fieldByName('SumNDS').asfloat;
            q.Next;
          end;
          q.Free;
          ReportMakerWP.AddParam('7=' + StrTo00(FloatToStr(Sum)));
          //--------------------------------------------------------------------
          q := sql.select(paysheet_table, 'Sum', 'Client_Ident=' +
            IntTostr(cbZak.SQLComboBox.GetData) +
            ' and dat>=' + sql.MakeStr(FormatDateTime('yyyy-mm-dd',
            StrToDate(LabelEditDate1.text))) +
            ' and dat<=' + sql.MakeStr(FormatDateTime('yyyy-mm-dd',
            StrToDate(LabelEditDate2.text))), '');
          WR := 0;
          while (not q.eof) do
          begin
            WR := WR + q.fieldByName('Sum').asfloat;
            q.Next;
          end;
          q.Free;
          ReportMakerWP.AddParam('8=' + StrTo00(FloatToStr(WR)));
          //-------------------------------------------------------------------------
          q := sql.select(send_table, 'SumCount', 'Client_Ident=' +
            IntTostr(cbZak.SQLComboBox.GetData) +
            ' and `Start`>=' + sql.MakeStr(FormatDateTime('yyyy-mm-dd',
            StrToDate(LabelEditDate1.text))) +
            ' and `Start`<=' + sql.MakeStr(FormatDateTime('yyyy-mm-dd',
            StrToDate(LabelEditDate2.text))), '');
          WC := 0;
          while not q.eof do
          begin
            WC := WC + q.fieldByName('SumCount').asfloat;
            q.Next;
          end;
          q.Free;
          ReportMakerWP.AddParam('9=' + StrTo00(FloatToStr(WC)));
          //--------------------------------------------------------------------------
          Sum := Sum + Wr;
          cd := '';
          if (Sum < Wc) then
          begin
            Wc := Wc - Sum;
            cd := '-';
          end
          else
            WC := Sum - WC;
          // ReportMakerWP.AddParam('10='+cd+StrTo00(FloatToStr(WC)));
          ReportMakerWP.AddParam('11=' +
            SendStr.DataDMstrY((StrToDate(LabelEditDate1.text))));
          //---------------------------------------------------
          cd := '';
          cd := CreditDate(cbZak.SQLComboBox.GetData,
            StrToDate(LabelEditDate2.text) + 1);
          ReportMakerWP.AddParam('10=' + StrTo00(cd));
          //----------------------------------------------------
          if (l = 15) then
          begin
            ReportMakerWP.AddParam('15=' + ' ��� "���������� ���"');
            Fil := 'SVZakTek';
            FilIni := svzaktek_ini;
            cd := '';
            cd := sql.selectString('Clients', 'KreditTEK', 'Ident=' +
              IntTostr(cbZak.SQLComboBox.GetData)); //kreditTek
            if (trim(cd) <> '') then
            begin
              if (StrTo00(trim(cd)) <> '0.00') then
                //  ���� ������� ��������� ������� 13-11-2013
                //  ReportMakerWP.AddParam('19='+'������ �� 01.01.2012: '+StrTo00(cd));
            end
          end
          else
          begin
            if sql.selectString('Boss', 'Name', 'Ident=1') <> '' then
              ReportMakerWP.AddParam('15=' + sql.selectString('Boss', 'Name',
                'Ident=1'))
            else
              ReportMakerWP.AddParam('15=' + '');

            Fil := 'SVZak';
            FilIni := svzak_ini;
          end;
          {application.MessageBox('� �������� ����������!','���������!',0);
          exit }
        end;
      //--------------------
      //3:  {�/� ��������}
      //    begin
      //    cond:='';
      //    if sort=0 then cond:='ClientAcr'
      //     else if sort=1 then cond:='CityName,'
      //      else  cond:='`Start`,Ident';
      //    ReportMakerWP.AddParam('1='+cond);
      //     ReportMakerWP.AddParam('2='+'�������� �/�');
      //     ReportMakerWP.AddParam('3='+'� '+
      //                            SendStr.DataDMstrY(StrToDate(LabelEditDate1.text)));
      //     ReportMakerWP.AddParam('4='+'�� '+
      //                            SendStr.DataDMstrY(StrToDate(LabelEditDate2.text)));
      //     cond:='';
      //    if cbZak.SQLComboBox.GetData=0 then  cond:=''
      //     else cond:=' Client_Ident='+IntToStr(cbZak.SQLComboBox.GetData);
      //     if cond='' then cd:=''
      //       else cd:=' and ';
      //    if cbCity.SQLComboBox.GetData=0 then cond:=cond+''
      //     else cond:=cond+cd+' City_Ident='+IntToStr(cbCity.SQLComboBox.GetData);
      //     if cond='' then cd:=''
      //       else cd:=' and ';
      //     cond:=cond+cd+' DateSupp>='+sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate1.Text)))+
      //           ' and DateSupp<='+sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate2.Text)));
      //    cond:=cond+' and ContractType_Ident=1' ;
      //    ReportMakerWP.AddParam('13='+cond);
      //    Sum:=0; {������ �����}
      //    WR:=0; {��� ���}
      //    WC:=0;   {������ ����� }
      //    F:=0;   {������ ��� ��� }
      //    ASP:=0; {������ ��� }
      //    Iv:=0;  {������ ��� ��� }
      //    CLI:=0;  {��� ����}
      //    ASPack:=0;  {������ ���}
      //    Num:=0;
      //    q:=sql.select(sends_view,'*',cond,'');
      //    while not q.eof do
      //    begin
      //    Num:=Num+1;
      //     CLI:=CLI+q.fieldbyName('PlaceC').asInteger;
      //     WR:=WR+q.fieldbyName('Weight').asfloat;
      //     WC:=WC+q.fieldbyName('SumServ').asfloat;
      //     if q.fieldbyName('PayTypeWay_Ident').asInteger =1 then
      //         F:=F+q.fieldbyName('SumWay').asfloat;
      //     if q.fieldbyName('PayTypeWay_Ident').asInteger =2 then
      //         ASP:=ASP+q.fieldbyName('SumWay').asfloat;
      //     if q.fieldbyName('PayTypeServ_Ident').asInteger =1 then
      //          Iv:=IV+q.fieldbyName('SumServ').asfloat;
      //     Sum:=Sum+q.fieldbyName('SumWay').asfloat;
      //     if q.fieldbyName('PayTypeServ_Ident').asInteger =2 then
      //          ASPack:=ASPack+q.fieldbyName('SumServ').asfloat;
      //    q.Next;
      //    end;
      //    q.Free;
      //    ReportMakerWP.AddParam('5='+IntToStr(CLI)); {��� ����}
      //    ReportMakerWP.AddParam('6='+FloatToStr(WR)); {��� ���}
      //    ReportMakerWP.AddParam('7='+FloatToStr(WC));  {������ ����� }
      //    ReportMakerWP.AddParam('8='+StrTo00(FloatToStr(F)));  {������ ��� ��� }
      //    ReportMakerWP.AddParam('9='+StrTo00(FloatToStr(ASP))); {������ ��� }
      //    ReportMakerWP.AddParam('10='+StrTo00(FloatToStr(Iv)));   {������ ��� ��� }
      //    ReportMakerWP.AddParam('11='+StrTo00(FloatToStr(Sum)));  {������ �����}
      //    ReportMakerWP.AddParam('12='+StrTo00(FloatToStr(ASPack))); {������ ���}
      //    ReportMakerWP.AddParam('43='+IntToStr(Num)); {���������� ��������}

      //     Fil:='SendGD'  ;
      //     FilIni:=sendgd_ini  ;
      //   { application.MessageBox('� �������� ����������!','���������!',0);
      //     exit }
      //    end;

      //--------------------
      3, 12, 14: {����� ���������}
        begin
          cond := '';
          cond := 'ClientAcr';
          if (sort = 0) then
            cond := 'ClientAcr'
          else if sort = 1 then
            cond := 'ClientAcr';
          ReportMakerWP.AddParam('1=' + cond);
          if (l = 12) then
            ReportMakerWP.AddParam('2=' + '����� ��������� (��.)')
          else if (l = 3) then
            ReportMakerWP.AddParam('2=' + '����� ���������')
          else
            ReportMakerWP.AddParam('2=' + '����� ��������� �� �/�');
          ReportMakerWP.AddParam('3=' + '� ' +
            SendStr.DataDMstrY(StrToDate(LabelEditDate1.text)));
          ReportMakerWP.AddParam('4=' + '�� ' +
            SendStr.DataDMstrY(StrToDate(LabelEditDate2.text)));
          cond := '';
          if ((l = 12) or (l = 3)) then
            vs := vs1_view;
          if (l = 14) then
            vs := vs2_view;
          if (cbZak.SQLComboBox.GetData = 0) then
            cond := ''
          else
            cond := ' and ' + vs + '.Client_Ident=' +
              IntToStr(cbZak.SQLComboBox.GetData);
          if (cbCity.SQLComboBox.GetData = 0) then
            cond := cond + ''
          else
            cond := cond + ' and ' + vs + '.City_Ident=' +
              IntToStr(cbCity.SQLComboBox.GetData);

          cd := '';
          if ((l = 3) or (l = 12)) then
          begin
            if (RadioGroup1.ItemIndex = 0) then
              cd := vs + '.`Start`';
            if (RadioGroup1.ItemIndex = 1) then
              cd := vs + '.DateSupp';
          end
          else
            cd := vs + '.Invoice_Data';
          cond1 := '';
          if ((l = 12) or (l = 14)) then
          begin
            cond1 := ' ClientsNotTek left outer join ' + vs + ' on (' + vs +
              '.Client_Ident=ClientsNotTek.Ident) ';
            cond := cond + ' and ClientsNotTek.PersonType_Ident=1 '
          end;
          if (l = 3) then
            cond1 := ' ' + vs + ' ';
          str1 := TStringList.Create;
          str1.Add('alter view VolumeSends '); //+
          str1.Add('as select ' + vs + '.ClientAcr,Count(' + vs +
            '.Ident) as CI,'); //+
          str1.Add('Sum(' + vs + '.Weight) as W,'); //+
          str1.Add('Sum(' + vs + '.CountWeight) as CW,'); //+
          str1.Add('cast(cast(Sum(' + vs +
            '.Fare) as decimal(10,2))as char(12)) as F,'); //+
          str1.Add('cast(cast(Sum(' + vs +
            '.AddServicePrace) as decimal(10,2))as char(12)) as ASe,'); //+
          str1.Add('cast(cast(Sum(' + vs +
            '.PackTarif) as decimal(10,2))as char(12)) as ASp,'); //+
          str1.Add('cast(cast(Sum(' + vs +
            '.InsuranceValue) as decimal(10,2))as char(12)) as IV,'); //+
          str1.Add('cast(cast(Sum(' + vs +
            '.SumCount) as decimal(10,2))as char(12)) as SC '); //+
          str1.Add('from '); //+
          str1.Add(cond1);
          str1.Add('where ' + cd + '>=' +
            sql.MakeStr(FormatDateTime('yyyy-mm-dd',
            StrToDate(LabelEditDate1.Text)))); //+
          str1.Add(' and ' + cd + '<=' +
            sql.MakeStr(FormatDateTime('yyyy-mm-dd',
            StrToDate(LabelEditDate2.Text)))); //+
          str1.Add(cond + ' group by ClientAcr;'); //;

          sql.ExecSQL(str1);
          str1.free;
          Sum := 0;
          WR := 0;
          WC := 0;
          F := 0;
          ASP := 0;
          Iv := 0;
          CLI := 0;
          ASPack := 0;
          q := sql.Select('VolumeSends', '*', '', '');
          while (not q.Eof) do
          begin
            Sum := Sum + q.fieldbyName('SC').asfloat;
            WR := WR + q.fieldbyName('W').asfloat;
            WC := WC + q.fieldbyName('CW').asfloat;
            F := F + q.fieldbyName('F').asfloat;
            ASP := ASP + q.fieldbyName('ASe').asfloat;
            if q.fieldbyName('IV').asString <> '' then
              Iv := IV + q.fieldbyName('IV').asfloat
            else
              Iv := IV + 0;
            CLI := CLI + q.fieldbyName('CI').asInteger;
            ASPack := ASPack + q.fieldbyName('ASP').asfloat;
            q.Next;
          end;
          q.free;
          ReportMakerWP.AddParam('5=' + IntToStr(CLI));
          ReportMakerWP.AddParam('6=' + FloatToStr(WR));
          ReportMakerWP.AddParam('7=' + FloatToStr(WC));
          ReportMakerWP.AddParam('8=' + StrTo00(FloatToStr(F)));
          ReportMakerWP.AddParam('9=' + StrTo00(FloatToStr(ASP)));
          ReportMakerWP.AddParam('10=' + StrTo00(FloatToStr(Iv)));
          ReportMakerWP.AddParam('11=' + StrTo00(FloatToStr(Sum)));
          ReportMakerWP.AddParam('12=' + StrTo00(FloatToStr(ASPack)));
          ReportMakerWP.AddParam('13=' + cbCity.SQLComboBox.Text);

          Fil := 'VolumeSend';
          FilIni := 'VolumeSend';
          // application.MessageBox('� �������� ����������!','���������!',0);
          // exit
        end;
      //--------------------
      4: {������ �� ����-��������}
        begin
          cond := '';
          if (cbZak.SQLComboBox.GetData <> 0) then
            ReportMakerWP.AddParam('3=' + '�� ' + sql.selectstring('Clients',
              'Acronym', 'Ident=' + IntToStr(cbZak.SQLComboBox.GetData)))
          else
            ReportMakerWP.AddParam('3=' + ' ');
          ReportMakerWP.AddParam('1=' + '� ' +
            SendStr.DataDMstrY(StrToDate(LabelEditDate1.text)));
          ReportMakerWP.AddParam('2=' + '�� ' +
            SendStr.DataDMstrY(StrToDate(LabelEditDate2.text)));
          if (cbZak.SQLComboBox.GetData = 0) then
            cond := ''
          else
            cond := ' and Clients_Ident=' + IntToStr(cbZak.SQLComboBox.GetData);
          str1 := TStringList.Create;
          str1.Add('alter view VolumeInvoice '); //+
          str1.Add('as select c.Acronym,c.Ident,');
          //i.Clients_Ident,');//+
          //str1.Add('i.Number,');//+
          //str1.Add('i.Data,');//+
          str1.Add('cast(cast(Sum(i.SumGD) as decimal(10,2))as char(12)) as SG,');
          str1.Add('cast(cast(Sum(i.NDSGD) as decimal(10,2))as char(12)) as NG,');
          str1.Add('cast(cast(Sum(i.SUMAvt) as decimal(10,2))as char(12)) as SAv,');
          str1.Add('cast(cast(Sum(i.NDSAvt) as decimal(10,2))as char(12)) as NAv,');
          str1.Add('cast(cast(Sum(i.SumAg) as decimal(10,2))as char(12)) as SA ,');
          str1.Add('cast(cast(Sum(i.NDSAg) as decimal(10,2))as char(12)) as NA ,');
          str1.Add('cast(cast(Sum(i.SumPak) as decimal(10,2))as char(12)) as SP ,');
          str1.Add('cast(cast(Sum(i.NDSPak) as decimal(10,2))as char(12)) as NP, ');
          str1.Add('cast(cast(Sum(i.SumPakAg) as decimal(10,2))as char(12)) as SPA ,');
          str1.Add('cast(cast(Sum(i.NDSPakAg) as decimal(10,2))as char(12)) as NPA ,');
          str1.Add('cast(cast(Sum(i.SumSt) as decimal(10,2))as char(12)) as SS, ');
          str1.Add('cast(cast(Sum(i.NDSSt) as decimal(10,2))as char(12)) as NS ,');
          str1.Add('cast(cast(Sum(i.SumStAg) as decimal(10,2))as char(12)) as SSA ,');
          str1.Add('cast(cast(Sum(i.NDSStAg) as decimal(10,2))as char(12)) as NSA ,');
          str1.Add('cast(cast(Sum(i.Sum) as decimal(10,2))as char(12)) as SNDS ');
          str1.Add('from ' + invoice_table +
            ' as i left outer join Clients as c on');
          str1.Add('(i.Clients_Ident=c.Ident)');
          str1.Add('where Data>=' + sql.MakeStr(FormatDateTime('yyyy-mm-dd',
            StrToDate(LabelEditDate1.Text)))); //+
          str1.Add(' and Data<=' + sql.MakeStr(FormatDateTime('yyyy-mm-dd',
            StrToDate(LabelEditDate2.Text)))); //+
          str1.Add(cond + ' group by c.Ident,c.Acronym;'); //;

          sql.ExecSQL(str1);
          str1.free;
          cond := 'Data>=' + sql.MakeStr(FormatDateTime('yyyy-mm-dd',
            StrToDate(LabelEditDate1.Text))) +
            ' and Data<=' + sql.MakeStr(FormatDateTime('yyyy-mm-dd',
            StrToDate(LabelEditDate2.Text))) +
            cond;
          SG := 0;
          NG := 0;
          SAv := 0;
          NAV := 0;
          SA := 0;
          NA := 0;
          SP := 0;
          NP := 0;
          SPA := 0;
          NPA := 0;
          SS := 0;
          NS := 0;
          SSA := 0;
          NSA := 0;
          SNDS := 0;

          q := sql.Select('VolumeInvoice', '', '', '');
          while (not q.eof) do
          begin
            SG := SG + q.fieldbyName('SG').asfloat;
            NG := NG + q.fieldbyName('NG').asfloat;
            SAv := SAv + q.fieldbyName('SAv').asfloat;
            NAV := NAv + q.fieldbyName('NAv').asfloat;
            SA := SA + q.fieldbyName('SA').asfloat;
            NA := NA + q.fieldbyName('NA').asfloat;
            SP := SP + q.fieldbyName('SP').asfloat;
            NP := NP + q.fieldbyName('NP').asfloat;
            SPA := SPA + q.fieldbyName('SPA').asfloat;
            NPA := NPA + q.fieldbyName('NPA').asfloat;
            SS := SS + q.fieldbyName('SS').asfloat;
            NS := NS + q.fieldbyName('NS').asfloat;
            SSA := SSA + q.fieldbyName('SSA').asfloat;
            NSA := NSA + q.fieldbyName('NSA').asfloat;
            SNDS := SNDS + q.fieldbyName('SNDS').asfloat;
            q.Next;
          end;
          q.Free;

          ReportMakerWP.AddParam('10=' + cond);
          ReportMakerWP.AddParam('11=' + StrTo00(FloatToStr(SG)));
          ReportMakerWP.AddParam('12=' + StrTo00(FloatToStr(NG)));
          ReportMakerWP.AddParam('13=' + StrTo00(FloatToStr(SAv)));
          ReportMakerWP.AddParam('14=' + StrTo00(FloatToStr(NAv)));
          ReportMakerWP.AddParam('15=' + StrTo00(FloatToStr(SA)));
          ReportMakerWP.AddParam('16=' + StrTo00(FloatToStr(NA)));
          ReportMakerWP.AddParam('17=' + StrTo00(FloatToStr(SP)));
          ReportMakerWP.AddParam('18=' + StrTo00(FloatToStr(NP)));
          ReportMakerWP.AddParam('19=' + StrTo00(FloatToStr(SPA)));
          ReportMakerWP.AddParam('20=' + StrTo00(FloatToStr(NPA)));
          ReportMakerWP.AddParam('21=' + StrTo00(FloatToStr(SS)));
          ReportMakerWP.AddParam('22=' + StrTo00(FloatToStr(NS)));
          ReportMakerWP.AddParam('23=' + StrTo00(FloatToStr(SSA)));
          ReportMakerWP.AddParam('24=' + StrTo00(FloatToStr(NSA)));
          ReportMakerWP.AddParam('25=' + StrTo00(FloatToStr(SNDS)));

          Fil := 'VolumeInvoice';
          FilIni := volume_invoice_ini;

        end;
      //--------------------
      5: {��������}
        begin
          ReportMakerWP.AddParam('1=' + '�� ' + SendStr.DataDMstrY(now));
          Fil := 'ContractSelect';
          FilIni := 'ContractSelect';
        end;
      //--------------------
      6: {����� ������}
        begin
          // files
          curr_date := FormatDateTime('dd_mm_yy', Now);
          curr_time := FormatDateTime('hh_nn_ss', Now);
          booksel_csv_path := GetEnvironmentVariable('USERPROFILE');
          if (booksel_csv_path = '') then
            booksel_csv_path := 'c:'
          else
            booksel_csv_path := booksel_csv_path + '\Desktop\';

          booksel_csv_path := booksel_csv_path + '\Kniga_Prodazh_date_' +
            curr_date
            + '_time_' +
            curr_time +
            '.csv';
          AssignFile(booksel_file, booksel_csv_path);
          Rewrite(booksel_file);

          // alter view booksel
          sql_str := TStringList.Create;
          sql_str.Add('call  `BookselSetRowNumber`;');
          sql.ExecSQL(sql_str);
          sql_str.free;
          str1 := TStringList.Create;
          str1.Add('alter view booksel '); //+
          str1.Add('AS select `i`.`Ident` AS `Ident`,`i`.`Data` ');
          str1.Add('AS `Data`,`i`.`SumAVT` AS `Fee`,`i`.`Number` ');
          str1.Add('AS `Number`,`i`.`Clients_Ident` AS `Clients_Ident`,`c`.`Acronym` ');
          str1.Add('AS `Acronym`,`c`.`Fullname` AS `FullName`,`c`.`Name` ');
          str1.Add('AS `Name`,cast(substr(`i`.`Number`,1,(length(`i`.`Number`) - 3)) as unsigned) ');
          str1.Add('AS `NUM`,`c`.`Inn` AS `INN`,`c`.`KPP` AS `KPP`,`severtrans`.`booksel_NDSFee`(`i`.`Data`,`i`.`SumAVT`) ');
          str1.Add('AS `NDSFee`,`severtrans`.`booksel_ClearFee`(`i`.`Data`,`i`.`SumAVT`) ');
          str1.Add('AS `ClearFee`, ');
          str1.Add('RowNumber() as `row_num`');
          str1.Add(' from (`' + invoice_table +
            '` `i` left join `clients` `c` on((`i`.`Clients_Ident` = `c`.`Ident`)))');
          sql.ExecSQL(str1);
          str1.free;

          // write empty line
          Writeln(booksel_file, '');

          booksel_doc_name := '����� ������';
          ReportMakerWP.AddParam('2=' + booksel_doc_name);
          Writeln(booksel_file, booksel_doc_name + ',,,,,,,,,,,,,,,,,,');
          Writeln(booksel_file, ',,,,,,,,,,,,,,,,,,,');
          booksel_seller_name := '';
          tempStr := sql.SelectString('Boss', 'Name', 'Ident=1');
          if (tempStr <> '') then
          begin
            ReportMakerWP.AddParam('9=' + tempStr);
            booksel_seller_name := '�������� ' + tempStr
          end
          else
          begin
            ReportMakerWP.AddParam('9=' + '��� "����������"');
            booksel_seller_name := '�������� ��� "����������"';
          end;
          Writeln(booksel_file, booksel_seller_name);

          booksel_seller_inn_kpp := '';
          tempStr := sql.SelectString('Boss', 'INN', 'Ident=1');
          if (tempStr <> '') then
          begin
            ReportMakerWP.AddParam('10=' + tempStr);
            booksel_seller_inn_kpp := tempStr
          end
          else
          begin
            ReportMakerWP.AddParam('10=' + '7810819094');
            booksel_seller_inn_kpp := '7810819094';
          end;

          tempStr := sql.SelectString('Boss', 'KPP', 'Ident=1');
          if (tempStr <> '') then
          begin
            ReportMakerWP.AddParam('11=' + tempStr);
            booksel_seller_inn_kpp := booksel_seller_inn_kpp + '/' + tempStr;
          end
          else
          begin
            ReportMakerWP.AddParam('11=' + '781001001');
            booksel_seller_inn_kpp := booksel_seller_inn_kpp + '/781001001';
          end;
          booksel_seller_inn_kpp :=
            '����������������� ����� � ��� ������� ���������� �� ���� �����������������-����������: ' +
            booksel_seller_inn_kpp;
          Writeln(booksel_file, booksel_seller_inn_kpp);

          ReportMakerWP.AddParam('3=' + '� ' +
            SendStr.DataDMstrY(StrToDate(LabelEditDate1.text)));
          ReportMakerWP.AddParam('4=' + '�� ' +
            SendStr.DataDMstrY(StrToDate(LabelEditDate2.text)));
          booksel_sale_period := '������� �� ������ � ' +
            FormatDateTime('dd.mm.yyyy',
            StrToDate(LabelEditDate1.Text)) + ' �� ' +
            FormatDateTime('dd.mm.yyyy',
            StrToDate(LabelEditDate2.Text));
          Writeln(booksel_file, booksel_sale_period);
          Writeln(booksel_file, ',,,,,,,,,,,,,,,,,,,');

          cond := '';
          cond := 'Data>=' + sql.MakeStr(FormatDateTime('yyyy-mm-dd',
            StrToDate(LabelEditDate1.Text))) +
            ' and Data<=' + sql.MakeStr(FormatDateTime('yyyy-mm-dd',
            StrToDate(LabelEditDate2.Text)));
          ReportMakerWP.AddParam('5=' + cond);

          // write table header1
          Write(booksel_file,
            '"��/�",��� ���� �����-���,"����� � ���� �����-������� ��������",');
          Write(booksel_file,
            '"����� � ���� ����������� �����-������� ��������",');
          Write(booksel_file,
            '"����� � ���� ����������-������� �����-������� ��������",');
          Write(booksel_file,
            '"����� � ���� ����������� ����������-������� �����-������� ��������",');
          Write(booksel_file,
            '������������ ����������,"���/��� ����������","�������� � ���������� (������������, ������)",,');
          Write(booksel_file,
            '"����� � ���� ���������, ����������-����� ������","�����-������� � ��� ������",');
          Write(booksel_file,
            '"��������� ������ �� �����- �������, ������� ��������� �� ����������������� �����-������� (������� ���) � ������ �����-�������",,');
          Write(booksel_file,
            '"��������� ������, ���������� �������, �� �����-�������, ������� ��������� �� ��������-��������� �����-������� (��� ���) � ������ � �������� �� ������",,,');
          Write(booksel_file,
            '"����� ��� �� �����-�������, ������� ��������� �� ��������-��������� �����-������� � ���-��� � ��������, �� ������",,');
          Write(booksel_file,
            '"��������� ������, ������������� �� ������, �� �����-�������, ������� ���������  �� ����������-������� �����-������� � ������ � ��������"');
          Writeln(booksel_file);
          // write table header2
          Write(booksel_file,
            ',,,,,,,,"������������ ����������","���/��� ����������",,,"� ������ �����-�������",');
          Write(booksel_file,
            '"� ������ � ��������",18 ���������,10 ���������,0 ���������,18 ���������,10 ���������,');
          Writeln(booksel_file);

          q := sql.select('BookSel',
            'Name, Number, INN, KPP, Data, Fee, NDSFee, ClearFee', cond,
            '');
          Sum := 0;
          F := 0;
          SNDS := 0;
          booksel_index := 0;
          data_and_number_sf := '';
          booksel_name := '';
          booksel_inn_kpp := '';
          Writeln(booksel_file,
            '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20');
          while not q.Eof do
          begin
            booksel_index := booksel_index + 1;
            data_and_number_sf := '"' + q.FieldByName('Number').asString + ',' +
              q.FieldByName('Data').asString + '"';
            booksel_name := q.FieldByName('Name').asString;
            booksel_inn_kpp := q.FieldByName('INN').asString + '/ ' +
              q.FieldByName('KPP').asString;
            Writeln(booksel_file, IntToStr(booksel_index) + ',="01",' +
              data_and_number_sf +
              ',,,,' + booksel_name + ',' + booksel_inn_kpp + ',,,,,,' +
              '="' + StrTo00(FloatToStr(q.FieldByName('Fee').asFloat)) + '"' +
              ',' +
              '="' + StrTo00(FloatToStr(q.FieldByName('ClearFee').asFloat)) + '"'
              +
              ',,,' +
              '="' + StrTo00(FloatToStr(q.FieldByName('NDSFee').asFloat)) + '"'
              +
              ',,,');
            Sum := Sum + q.FieldByName('ClearFee').asFloat;
            F := F + q.FieldByName('Fee').asFloat;
            SNDS := SNDS + q.FieldByName('NDSFee').asFloat;
            q.Next;
          end;
          q.Free;
          Writeln(booksel_file,
            ',,,,,,,,,,,,' +
            '�����,' +
            '="' + StrTo00(FloatToStr(F)) + '"' + ',' +
            '="' + StrTo00(FloatToStr(Sum)) + '"' +
            ',,,' +
            '="' + StrTo00(FloatToStr(SNDS)) + '"' +
            ',,,');

          // write 2 empty lines
          Writeln(booksel_file, '');
          Writeln(booksel_file, '');

          Writeln(booksel_file,
            '������������ ����������� ��� ���� �������������� ����,,,,,,____________________________________________');
          Writeln(booksel_file,
            '�������������� ���������������,,,,,,____________________________________________');
          Writeln(booksel_file,
            '��������� ������������� � ��������������� ����������� ��������������� ���������������,,,,,,____________________________________________');

          ReportMakerWP.AddParam('6=' + StrTo00(FloatToStr(F)));
          ReportMakerWP.AddParam('7=' + StrTo00(FloatToStr(Sum)));
          ReportMakerWP.AddParam('8=' + StrTo00(FloatToStr(SNDS)));

          CloseFile(booksel_file);
          Fil := 'BookSel';
          FilIni := 'BookSel';
        end;
      //--------------------
      7: {��������� ���������}
        begin
          cond := '';
          cond := 'Dat>=' + sql.MakeStr(FormatDateTime('yyyy-mm-dd',
            StrToDate(LabelEditDate1.Text))) +
            ' and Dat<=' + sql.MakeStr(FormatDateTime('yyyy-mm-dd',
            StrToDate(LabelEditDate2.Text)));
          if (cbZak.SQLComboBox.GetData <> 0) then
            cond := cond + ' and Client_Ident=' +
              IntToStr(cbZak.SQLComboBox.GetData);
          ReportMakerWP.AddParam('1=' + cond);
          if (l = 15) then
            ReportMakerWP.AddParam('2=' + ' (��.) � ' +
              SendStr.DataDMstrY(StrToDate(LabelEditDate1.text)))
          else
            ReportMakerWP.AddParam('2=' + ' � ' +
              SendStr.DataDMstrY(StrToDate(LabelEditDate1.text)));
          ReportMakerWP.AddParam('3=' + ' �� ' +
            SendStr.DataDMstrY(StrToDate(LabelEditDate2.text)));

          if cbZak.SQLComboBox.GetData <> 0 then
            ReportMakerWP.AddParam('4=' + ' �� ' +
              sql.selectString('Clients', 'Acronym', 'Ident=' +
              IntToStr(cbZak.SQLComboBox.GetData)))
          else
            ReportMakerWP.AddParam('4=' + '');
          //---------------------
          q := sql.select(EntrySec.paysheet_table {'PaySheet'}, 'Sum', cond,
            '');
          Sum := 0;
          i := 0;
          while (not q.eof) do
          begin
            Sum := Sum + q.fieldByName('Sum').AsFloat;
            i := i + 1;
            q.Next;
          end;
          q.Free;
          //--------------------------
          ReportMakerWP.AddParam('5=' + StrTo00(FloatToStr(Sum)));
          ReportMakerWP.AddParam('6=' + '�����: ' + IntToStr(i));

          Fil := 'PaySheets';
          FilIni := paysheets_ini;

        end;
      //--------------------
      8, 11, 13, 19, {17,27,} 24: {������} {������� ���������}
        begin
          sql.Delete('Kredit', '');
          ReportMakerWP.AddParam('1=' + ' � ' +
            SendStr.DataDMstrY(StrToDate(LabelEditDate1.text)));
          ReportMakerWP.AddParam('2=' + ' �� ' +
            SendStr.DataDMstrY(StrToDate(LabelEditDate2.text)));
          ReportMakerWP.AddParam('10=' + LabelEditDate1.text);
          ReportMakerWP.AddParam('11=' + LabelEditDate2.text);
          if cbZak.SQLComboBox.GetData <> 0 then
            ReportMakerWP.AddParam('3=' + ' �� ' +
              sql.selectString('Clients', 'Acronym', 'Ident=' +
              IntToStr(cbZak.SQLComboBox.GetData)))
          else
            ReportMakerWP.AddParam('3=' + '');

          cond1 := ''; {������ �� ���� "�" - 1}
          NG := 0; {���������}
          SAv := 0; {������ ����}
          NAv := 0; {������ �����}
          SA := 0; {����� �� ������}
          NA := 0; {������ �� ���� "��"}
          cond := '';
          if (cbZak.SQLComboBox.GetData <> 0) then
            cond := 'Ident=' + IntToStr(cbZak.SQLComboBox.GetData);
          if ((l = 13) or {(l=17) or}(l = 11) {or (l=27)}) then
          begin
            if (cond <> '') then
              cond := cond +
                ' and PersonType_Ident=1 and (not((Acronym like ''"%'')))'
            else
              cond := '(not((Acronym like ''"%''))) and PersonType_Ident=1';
            qCL := sql.Select('Clients', 'Ident,Acronym', cond, 'Ident');
          end
          else if (l = 19) then
          begin
            if (cond <> '') then
              cond := cond + ' and PersonType_Ident=2'
            else
              cond := 'PersonType_Ident=2';
            qCL := sql.Select('ClientsNotTek', 'Ident,Acronym', cond,
              'Acronym');
          end;
          if (l = 24) then
            qCL := sql.Select('ClientsTek', 'Ident,Acronym', cond, 'Ident')
          else
            qCL := sql.Select('Clients', 'Ident,Acronym', cond, 'Acronym');

          while (not qCL.Eof) do
          begin
            CLI := 0;
            CLI := qCL.fieldByName('Ident').AsInteger;
            //-----------------------------------
            cd := '';
            cd := cd + sql.MakeStr(qCL.fieldByName('Acronym').AsString);
            //-----------------------------
            cond1 := ''; {������ �� ���� "�" - 1}
            credit1 := '';
            {if l=17 then
              cond1:=StrTo00(CreditDate2004(CLI,StrToDate(LabelEditDate1.Text)))
            else
              if l=27 then
                cond1:=StrTo00(CreditDate2007(CLI,StrToDate(LabelEditDate1.Text)))
              else   }
            cond1 := StrTo00(CreditDate(CLI, StrToDate(LabelEditDate1.Text)));
            credit1 := cond1;
            if (cond1 <> '') then
              cd := cd + ',' + sql.MakeStr(cond1)
            else
              cd := cd + ',NULL';
            //---------------------------------------
            cond := '';
            cond := '`Start`>=' + sql.MakeStr(FormatDateTime('yyyy-mm-dd',
              StrToDate(LabelEditDate1.Text))) +
              ' and `Start`<=' + sql.MakeStr(FormatDateTime('yyyy-mm-dd',
              StrToDate(LabelEditDate2.Text)));
            if CLI <> 0 then
              cond := cond + ' and Client_Ident=' + IntToStr(CLI);
            NG := 0; {���������}
            if ((L = 11) {or (L=27)}) then
              {�������� ������ �� �������� �� ������� ���������� ���� ������� � ��������� ������}
            begin
              q := sql.Select(send_table, 'SumCount',
                'Invoice_ident in (Select Ident from ' + EntrySec.invoice_table
                +
                ' where Data>=' +
                sql.MakeStr(FormatDateTime('yyyy-mm-dd',
                StrToDate(LabelEditDate1.Text))) +
                ' and Data<=' + sql.MakeStr(FormatDateTime('yyyy-mm-dd',
                StrToDate(LabelEditDate2.Text))) +
                ' and Clients_Ident=' + IntToStr(CLI) + ' ) ', '')
            end
            else
              q := sql.Select(send_table, 'SumCount', cond, '');
            while (not q.eof) do
            begin
              NG := NG + q.FieldByName('SumCount').asFloat;
              q.Next;
            end;
            q.free;
            cond1 := '';
            cond1 := StrTo00(FloatToStr(NG));
            if (cond1 <> '') then
              cd := cd + ',' + sql.MakeStr(cond1)
            else
              cd := cd + ',NULL';

            //--------------------------
            cond := ''; {����� ������� ��� ����� � �����}
            cond := 'Dat>=' + sql.MakeStr(FormatDateTime('yyyy-mm-dd',
              StrToDate(LabelEditDate1.Text))) +
              ' and Dat<=' + sql.MakeStr(FormatDateTime('yyyy-mm-dd',
              StrToDate(LabelEditDate2.Text)));
            if (CLI <> 0) then
              cond := cond + ' and Client_Ident=' + IntToStr(CLI);
            //-----------------------------
            sav := 0; {������ ����}
            q := sql.select(paysheet_table, 'Sum', cond, '');
            while (not q.Eof) do
            begin
              sav := sav + q.FieldByName('Sum').asFloat;
              q.Next;
            end;
            q.Free;
            cond1 := '';
            sav := SimpleRoundTo(sav, -4);
            cond1 := StrTo00(FloatToStr(sav));
            if (cond1 <> '') then
              cd := cd + ',' + sql.MakeStr(cond1)
            else
              cd := cd + ',NULL';
            //-----------------------------
            NAv := 0; {������ �����}
            if ({(l=17) or }(l = 11) {or (l=27)}) then
              NAv := 0
            else
            begin
              q := sql.select(order_table, 'SumNDS', cond, '');
              while (not q.Eof) do
              begin
                Nav := NAv + q.FieldByName('SumNDS').asFloat;
                q.Next;
              end;
              q.Free;
            end;
            cond1 := '';
            cond1 := StrTo00(FloatToStr(Nav));
            if (cond1 <> '') then
              cd := cd + ',' + sql.MakeStr(cond1)
            else
              cd := cd + ',NULL';
            //-----------------------------
            SA := 0; {����� �� ������}
            Sa := Sav + Nav;
            cond1 := '';
            cond1 := StrTo00(FloatToStr(Sa));
            if (cond1 <> '') then
              cd := cd + ',' + sql.MakeStr(cond1)
            else
              cd := cd + ',NULL';
            //-----------------------
            cond1 := ''; {������ �� ���� "��"}

            {if (l=17) then
              cond1:=StrTo00(CreditDate2004(CLI,StrToDate(LabelEditDate2.Text)+1))
            else
              if l=27 then
                cond1:=StrTo00(CreditDate2007(CLI,StrToDate(LabelEditDate2.Text)+1))
            else}
            cond1 := StrTo00(CreditDate(CLI, StrToDate(LabelEditDate2.Text) +
              1));
            if (cond1 <> '') then
              cd := cd + ',' + sql.MakeStr(cond1)
            else
              cd := cd + ',NULL';
            //---------------------------------------
            if ((l = 11) {or (l=27)} or (l = 24)) then
            begin
              if ((Sav <> 0) or (NG <> 0) or (credit1 <> '0.00')) then
                sql.Insertstring('Kredit', 'Acr,Sal1,NG,Sav,Nav,Sa,Sal2', cd);
            end
            else
              sql.Insertstring('Kredit', 'Acr,Sal1,NG,Sav,Nav,Sa,Sal2', cd);
            //---------------------
            qCL.Next;
          end;
          qCL.Free;
          //-------------------------------------
          SG := 0;
          NG := 0; {���������}
          SAv := 0; {������ ����}
          NAv := 0; {������ �����}
          SA := 0; {����� �� ������}
          NA := 0; {������ �� ���� "��"}

          q := sql.select('Kredit', '', '', '');
          while (not q.eof) do
          begin
            SG := SG + q.fieldByName('Sal1').AsFloat;
            NG := NG + q.fieldByName('NG').AsFloat;
            SAv := SAv + q.fieldByName('SAv').AsFloat;
            NAv := NAv + q.fieldByName('NAv').AsFloat;
            SA := SA + q.fieldByName('SA').AsFloat;
            NA := NA + q.fieldByName('Sal2').AsFloat;
            q.Next;
          end;
          q.Free;
          cond1 := '';
          cond1 := StrTo00(FloatToStr(SG));
          ReportMakerWP.AddParam('4=' + cond1);
          cond1 := '';
          cond1 := StrTo00(FloatToStr(NG));
          ReportMakerWP.AddParam('5=' + cond1);
          cond1 := '';
          cond1 := StrTo00(FloatToStr(Sav));
          ReportMakerWP.AddParam('6=' + cond1);
          cond1 := '';
          cond1 := StrTo00(FloatToStr(Nav));
          ReportMakerWP.AddParam('7=' + cond1);
          cond1 := '';
          cond1 := StrTo00(FloatToStr(Sa));
          ReportMakerWP.AddParam('8=' + cond1);
          cond1 := '';
          cond1 := StrTo00(FloatToStr(NA));
          ReportMakerWP.AddParam('9=' + cond1);

          if (l = 8) then
            Fil := 'Kredit';
          if (l = 13) then
            Fil := 'Kredit';
          //if l=17) then  Fil:='Kredit'  ;
          if (l = 24) then
            Fil := 'Kredit';
          if ((l = 11) {or (l=27)}) then
            Fil := 'Kredit1';
          if (l = 19) then
            Fil := 'Kredit2';
          FilIni := 'Kredit';
        end;
      //--------------------
      9, 29: {������ �� �� ����������� �����}
        {������ �� �� ����������� ����� ���}
        begin
          cond := '';
          if LabelEditDate1.text <> '  .  .    ' then
            cond1 := 'Data>=''' + FormatDateTime('yyyy-mm-dd',
              StrToDate(LabelEditDate1.text)) + '''';
          if LabelEditDate2.text <> '  .  .    ' then
          begin
            if (cond1 <> '') then
              cond1 := cond1 + ' and ';
            cond1 := cond1 + 'Data<=''' + FormatDateTime('yyyy-mm-dd',
              StrToDate(LabelEditDate2.text)) + '''';
          end;
          if (cond1 <> '') then
            cond1 := cond1 + ' and ';
          cond1 := cond1 + 'ReportReturn=0 ';
          //ReportMakerWP.AddParam('2='+ 'ReportReturn=0 ');
          if cbZak.SQLComboBox.GetData <> 0 then
          begin
            ReportMakerWP.AddParam('1=' + ' �� "' +
              sql.selectString('Clients', 'Acronym', 'Ident=' +
              IntToStr(cbZak.SQLComboBox.GetData)) +
              '" �� ��������� c ' + LabelEditDate1.text + ' �� ' +
              LabelEditDate2.text + '.');
            cond1 := cond1 + 'and Clients_Ident=' +
              IntToStr(cbZak.SQLComboBox.GetData);
          end
          else
          begin
            ReportMakerWP.AddParam('1=' + ' �� ��������� c ' +
              LabelEditDate1.text + ' �� ' +
              LabelEditDate2.text + '.');
          end;
          if (l = 9) then
            cond1 := cond1 + ' and (not((Acronym like ''"%'')))'; {NOT TEK}
          if (l = 29) then
            cond1 := cond1 + ' and ((Acronym like ''"%''))'; {TEK}
          ReportMakerWP.AddParam('2=' + cond1);
          if sql.SelectString('Boss', 'PersonBug', 'Ident=1') <> '' then
            ReportMakerWP.AddParam('5=' + sql.SelectString('Boss', 'PersonBug',
              'Ident=1'))
          else
            ReportMakerWP.AddParam('5=' + '');

          if (l = 9) then
            Fil := 'SVPayReceipt';
          if l = 29 then
            Fil := 'SVPayReceiptTEK';
          FilIni := svpayreceipt_ini;
        end;
      //--------------------
      10: {������ �� "-" ������}
        begin
          sql.Delete('Kredit', ''); {������� �������}
          if sort = 0 then
            cond := 'Sal2Real'
          else if sort = 1 then
            cond := 'Dat';
          ReportMakerWP.AddParam('1=' + cond);
          cond := '';
          qcl := sql.Select('Clients', 'Ident,Acronym,City_Ident,Telephone',
            'PersonType_Ident=1 ', 'Acronym');
          while not qcl.Eof do
          begin
            cd := '';
            //-----------------------
            cond1 := ''; {������ �� ������� }
            //               AssignFile(c,systemdir+'uuuu');
            //               {$I-}
            //               Append(c)  ;
            //               {$I-}
            //               Writeln (c,qcl.fieldbyname('Ident').asstring);
            //                CloseFile(c);

            cond1 := STRTo00(CreditDate(qcl.fieldbyname('Ident').asinteger, now
              + 1));
            SA := 0;
            Sa := StrToFloat(cond1);
            if (Sa < 0) then {������ ������ "-"}
            begin
              cd := sql.MakeStr(cond1);
              cd := cd + ',' + cond1
            end
            else
              cd := '';
            //---------------------------------------
            if (cd <> '') then
            begin
              { ��� �������}
              cd := cd + ',' + sql.MakeStr(qcl.fieldByName('Acronym').asString);
              //-------------------------------------------
              {���� ��������� ������}
              q := sql.Select(paysheet_table, 'Dat', 'Client_Ident=' +
                qcl.fieldbyname('Ident').asString,
                'Dat DESC');
              if not q.eof then
                cd := cd + ',' + sql.MakeStr(FormatDateTime('yyyy-mm-dd',
                  StrToDate(q.FieldByName('Dat').AsString)))
              else
                cd := cd + ',NULL';
              q.Free;
              //--------------------------------------------
              {����� �������}
              if (qcl.fieldbyname('City_Ident').asString <> '') then
              begin
                cond := sql.SelectString('City', 'Name', 'Ident=' +
                  qcl.fieldbyname('City_Ident').asString);
                if (cond <> '') then
                  cd := cd + ',' + sql.MakeStr(cond)
                else
                  cd := cd + ',NULL';
              end
              else
                cd := cd + ',NULL';
              //----------------------
              {������� �������}
              if (qcl.fieldbyname('Telephone').asString <> '') then
                cd := cd + ',' +
                  sql.MakeStr(qcl.fieldbyname('Telephone').asString)
              else
                cd := cd + ',NULL';
              //------------
              sql.Insertstring('Kredit', 'Sal2,Sal2Real,Acr,Dat,City,Phone',
                cd);
            end;
            qcl.next;
          end;
          qcl.free;
          //--------------------------------------
          {�������� ������������� �� ����������� ����}
          q := sql.select('Kredit', '', '', '');
          NA := 0;
          while (not q.eof) do
          begin
            NA := NA + q.fieldByName('Sal2').AsFloat;
            q.Next;
          end;
          q.Free;
          ReportMakerWP.AddParam('2=' + StrTo00(FloatToStr(NA)));
          ReportMakerWP.AddParam('3=' + '�� ' + FormatDateTime('dd.mm.yyyy',
            now));
          //------------------
          Fil := 'Saldo';
          FilIni := 'Saldo';
        end;
      //--------------------
      //12: {������ �� ��������� ���������� (�/�)}
      { begin
          if cbNumber.SQLComboBox.GetData<>0 then
         begin
         If  cbNumber.SQLComboBox.Text='' then
         begin
             ReportMakerWP.AddParam('1='+'Number is NULL') ;
             ReportMakerWP.AddParam('2='+'NumberPP is NULL and SumServ is not NULL') ;
             ReportMakerWP.AddParam('3='+' ') ;
             ReportMakerWP.AddParam('4='+' ') ;
             ReportMakerWP.AddParam('5='+' ') ;
             ReportMakerWP.AddParam('6='+'Ident is NULL') ;
         end else
             begin
             ReportMakerWP.AddParam('1='+'Number='+sql.MakeStr(cbNumber.SQLComboBox.Text)) ;
             ReportMakerWP.AddParam('2='+trim('NumberPP='+'''~1~''')) ;
             ReportMakerWP.AddParam('3='+' ') ;
             ReportMakerWP.AddParam('4='+' ') ;
             ReportMakerWP.AddParam('5='+' ') ;
             ReportMakerWP.AddParam('6='+'Ident is NULL') ;
             end;
         end
           else   begin
                   ReportMakerWP.AddParam('1='+'Number is not NULL ');
                   ReportMakerWP.AddParam('2='+'NumberPP=''~1~''') ;
                   ReportMakerWP.AddParam('3='+'��� ������ �/�') ;
                   ReportMakerWP.AddParam('4='+'����� ��� ������ �/�:') ;
                   ReportMakerWP.AddParam('5='+sql.selectstring('SendsPPWay','Sum','Number is Null')) ;
                   ReportMakerWP.AddParam('6='+'NumberPP is NULL and SumServ <> ''0.00''') ;
                  end;
       //------------------
           Fil:='SendsPPWay';
           FilIni:=sendsppway_ini;
       end;  }
      //--------------------
      16, 23: {����� � ��������� ��������� }
        begin
          cond := '';
          fil := '';
          str := '';
          FilIni := '';
          vs := sends_view; // was 'Sends'
          if (l = 16) then
          begin
            cond := ' PersonType_Ident=1 ';
            fil := ' and ';
          end;
          if cbCity.SQLComboBox.GetData = 0 then
          begin
            cond := cond + '';
            ReportMakerWP.AddParam('5=' + ' ');
          end
          else
          begin
            cond := cond + fil + vs + '.City_Ident=' +
              IntToStr(cbCity.SQLComboBox.GetData);
            ReportMakerWP.AddParam('5=' + ' �� ' + cbCity.SQLComboBox.text);
            fil := ' and ';
          end;
          cond := cond + fil + vs + '.DateSupp is not NULL';
          cd := '';
          if (RadioGroup1.ItemIndex = 0) then
          begin
            cd := vs + '.`Start`';
            ReportMakerWP.AddParam('3=' + ' ������������ � ' +
              SendStr.DataDMstrY(StrToDate(LabelEditDate1.text)));
            ReportMakerWP.AddParam('4=' + '�� ' +
              SendStr.DataDMstrY(StrToDate(LabelEditDate2.text)));
          end;
          if (RadioGroup1.ItemIndex = 1) then
          begin
            cd := vs + '.DateSupp';
            ReportMakerWP.AddParam('3=' + ' ������������ � ' +
              SendStr.DataDMstrY(StrToDate(LabelEditDate1.text)));
            ReportMakerWP.AddParam('4=' + '�� ' +
              SendStr.DataDMstrY(StrToDate(LabelEditDate2.text)));
          end;
          cond1 := '';
          { if l=16 then
          begin
            cond1:= ' ' + vs+  ' left outer join ClientsNotTEK on ('+vs+'.Client_Ident=ClientsNotTek.Ident) ';
            FilIni:='ClientsNotTek'
          end else
            begin
            cond1:=' ' + vs + ' left outer join ClientsTek on ('+vs+'.Client_Ident=ClientsTek.Ident) ';
            FilIni:='ClientsTek'
            end;

          str1:=TStringList.Create;
          str1.Add('alter view VolumeSumSends ');//+
          str1.Add('as select '+vs+'.AcceptorName,'+vs+'.Client_Ident,');//+
          str1.Add(vs+'.Ident,');
          str1.Add(vs+'.ContractType_Ident,');
          str1.Add(vs+'.SumWay,');
          str1.Add(vs+'.SumServ,');
          str1.Add(vs+'.InsuranceValue,');
          str1.Add(vs+'.AddServiceExp,');
          str1.Add(vs+'.ExpCount,');
          str1.Add(vs+'.ExpTarif,');
          str1.Add(vs+'.AddServiceProp,');
          str1.Add(vs+'.PropCount,');
          str1.Add(vs+'.PropTarif,');
          str1.Add(vs+'.Weight,');//+
          str1.Add(vs+'.PlaceC,');//+
          str1.Add(vs+'.Fare,');//+
          str1.Add(vs+'.Volume,');//+
          str1.Add(vs+'.PackCount,');//+
          str1.Add(vs+'.ClientSenderAcr,');//+
          str1.Add(vs+'.AcceptorAddress,');//+
          str1.Add(vs+'.DateSupp,');
          str1.Add(vs+'.CityName,');//+
          str1.Add(vs+'.Invoice_ident,');//+
          str1.Add(vs+'.Namber,');//+
          str1.Add(vs+'.InvoiceNumber,');//+
          str1.Add(FilIni+'.PersonType_Ident' );
          str1.Add(' from ');//+
          str1.Add(cond1);
          str1.Add('where '+cd+'>='+sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate1.Text))));//+
          str1.Add(' and '+cd+'<='+sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate2.Text))));//+
          str1.Add(' and '+cond+' ;');

          sql.ExecSQL(str1);
          str1.free;

       }
          cond1 := '';
          cond1 := cd + '>=' + sql.MakeStr(FormatDateTime('yyyy-mm-dd',
            StrToDate(LabelEditDate1.Text))) +
            ' and ' + cd + '<=' + sql.MakeStr(FormatDateTime('yyyy-mm-dd',
            StrToDate(LabelEditDate2.Text)));
          if cond <> '' then
            cond1 := cond1 + ' and ' + cond;

          if l = 16 then
            cond1 := cond1 + ' and (not((ClientAcr like ''"%'')))'
          else
            cond1 := cond1 + ' and (ClientAcr like ''"%'')';

          //  q:=sql.Select('VolumeSumSends ','*','','');
          q := sql.Select(sends_view, '*', cond1, '');
          Sql.Delete('PrintVolSumSend', '');
          Sum := 0;
          Wr := 0;
          WC := 0;
          i := 0;
          CLI := 0;
          if (not q.eof) then
          begin
            while not (q.eof) do
            begin
              IdSend := q.fieldByName('Ident').AsInteger;
              str := IntTOstr(IdSend);
              Wr := Invoice.AftoSumCount(IdSend);
              Sum := Sum + wr;
              i := i + q.fieldByName('PlaceC').AsInteger;
              CLI := CLI + q.fieldByName('Weight').AsInteger;
              WC := WC + q.fieldByName('Volume').AsFloat;
              str := str + ',' + sql.MakeStr(StrTo00(FloatToStr(Wr)));
              sql.InsertString('PrintVolSumSend', 'Send_Ident,AvtoSumNDS', str);
              q.Next;
            end;
          end
          else
          begin
            application.MessageBox('�� ��������� ������ � ����� ������ �� ��������!',
              '������!', 0);
            q.Free;
            exit
          end;
          q.Free;
          {    str1:=TStringList.Create;
              str1.Add('alter view VolumeSumSends ');//+
              str1.Add('as select '+vs+'.AcceptorName,'+vs+'.Client_Ident,');//+
              str1.Add(vs+'.Ident,');
              str1.Add(vs+'.ContractType_Ident,');
              str1.Add(vs+'.SumWay,');
              str1.Add(vs+'.SumServ,');
              str1.Add(vs+'.InsuranceValue,');
              str1.Add(vs+'.AddServiceExp,');
              str1.Add(vs+'.ExpCount,');
              str1.Add(vs+'.ExpTarif,');
              str1.Add(vs+'.AddServiceProp,');
              str1.Add(vs+'.PropCount,');
              str1.Add(vs+'.PropTarif,');
              str1.Add(vs+'.Weight,');//+
              str1.Add(vs+'.PlaceC,');//+
              str1.Add(vs+'.Fare,');//+
              str1.Add(vs+'.Volume,');//+
              str1.Add(vs+'.PackCount,');//+
              str1.Add(vs+'.ClientSenderAcr,');//+
              str1.Add(vs+'.AcceptorAddress,');//+
              str1.Add(vs+'.CityName,');//+
              str1.Add(vs+'.Invoice_ident,');//+
              str1.Add(vs+'.Namber,');//+
              str1.Add(vs+'.InvoiceNumber,');//+
              str1.Add(vs+'.DateSupp,');
              str1.Add(FilIni+'.PersonType_Ident,' );
              str1.Add('PrintVolSumSend.Send_Ident,')  ;
              str1.Add('PrintVolSumSend.AvtoSumNDS');
              str1.Add(' from ');//+
              str1.Add(cond1);
              str1.Add(' left outer join PrintVolSumSend on ('+vs+'.Ident=PrintVolSumSend.Send_Ident) ') ;
              str1.Add('where '+cd+'>='+sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate1.Text))));//+
              str1.Add(' and '+cd+'<='+sql.MakeStr(FormatDateTime('yyyy-mm-dd',StrToDate(LabelEditDate2.Text))));//+
              str1.Add(' and '+cond+' ;');

              sql.ExecSQL(str1);
              str1.free;    }
          str1 := TStringList.Create;
          str1.Add('alter view VolumeSumSends '); //+
          str1.Add('as select ' + vs + '.AcceptorName,' + vs +
            '.Client_Ident,');
          //+
          str1.Add(vs + '.Ident,');
          str1.Add(vs + '.ContractType_Ident,');
          str1.Add(vs + '.SumWay,');
          str1.Add(vs + '.SumServ,');
          str1.Add(vs + '.InsuranceValue,');
          str1.Add(vs + '.AddServiceExp,');
          str1.Add(vs + '.ExpCount,');
          str1.Add(vs + '.ExpTarif,');
          str1.Add(vs + '.AddServiceProp,');
          str1.Add(vs + '.PropCount,');
          str1.Add(vs + '.PropTarif,');
          str1.Add(vs + '.Weight,'); //+
          str1.Add(vs + '.PlaceC,'); //+
          str1.Add(vs + '.Fare,'); //+
          str1.Add(vs + '.Volume,'); //+
          str1.Add(vs + '.PackCount,'); //+
          str1.Add(vs + '.ClientSenderAcr,'); //+
          str1.Add(vs + '.AcceptorAddress,'); //+
          str1.Add(vs + '.CityName,'); //+
          str1.Add(vs + '.Invoice_ident,'); //+
          str1.Add(vs + '.Namber,'); //+
          str1.Add(vs + '.InvoiceNumber,'); //+
          str1.Add(vs + '.DateSupp,');
          str1.Add(vs + '.PersonType_Ident,');
          str1.Add('PrintVolSumSend.Send_Ident,');
          str1.Add('PrintVolSumSend.AvtoSumNDS');
          str1.Add(' from ' + vs); //+
          str1.Add(' left outer join PrintVolSumSend on (' + vs +
            '.Ident=PrintVolSumSend.Send_Ident) ');
          str1.Add(' where ' + cond1 + ' ;');

          sql.ExecSQL(str1);
          str1.free;

          ReportMakerWP.AddParam('11=' + StrTo00(FloatToStr(Sum)));
          ReportMakerWP.AddParam('14=' + StrTo00(FloatToStr(WC)));
          ReportMakerWP.AddParam('13=' + Inttostr(CLI));
          ReportMakerWP.AddParam('12=' + IntToStr(I));

          //------------------
          Fil := 'VolumeSumSend';
          FilIni := 'VolumeSumSend';
        end;
      //------------------
      17, 18: {������� ��������� �� �����}
        begin
          cond := '';
          if l = 17 then
            cond := ' �����1 ';
          if l = 18 then
            cond := ' �����2 ';
          ReportMakerWP.AddParam('2=' + '������� ��������� �� �����' + cond);
          ReportMakerWP.AddParam('3=' + '� ' +
            SendStr.DataDMstrY(StrToDate(LabelEditDate1.text)));
          ReportMakerWP.AddParam('4=' + '�� ' +
            SendStr.DataDMstrY(StrToDate(LabelEditDate2.text)));
          cond := '';
          vs := EntrySec.sends_view {'Sends'};
          if l = 17 then
            cond := 'CitySklad1';
          if l = 18 then
            cond := 'CitySklad2';
          cd := '';

          if (RadioGroup1.ItemIndex = 0) then
            cd := vs + '.`Start`';
          if (RadioGroup1.ItemIndex = 1) then
            cd := vs + '.DateSupp';
          cond1 := ' ' + vs + ' right outer join ' + cond + ' on (' + cond +
            '.City_Ident=' + vs + '.City_Ident) ';

          str1 := TStringList.Create;
          str1.Add('alter view VolumeSklad '); //+
          str1.Add('as select ' + vs + '.CityName,'); //+
          str1.Add('Sum(' + vs + '.Weight) as W,'); //+
          str1.Add('Sum(' + vs + '.PlaceC) as P,'); //+
          str1.Add('cast(cast(Sum(' + vs +
            '.Volume) as decimal(10,2))as char(12)) as V,'); //+
          str1.Add('cast(cast(Sum(' + vs +
            '.SumCount) as decimal(10,2))as char(12)) as SC '); //+
          str1.Add('from '); //+
          str1.Add(cond1);
          str1.Add('where ' + cd + '>=' +
            sql.MakeStr(FormatDateTime('yyyy-mm-dd',
            StrToDate(LabelEditDate1.Text)))); //+
          str1.Add(' and ' + cd + '<=' +
            sql.MakeStr(FormatDateTime('yyyy-mm-dd',
            StrToDate(LabelEditDate2.Text)))); //+
          str1.Add(' group by CityName;'); //;

          sql.ExecSQL(str1);
          str1.free;
          Sum := 0;
          WR := 0;
          WC := 0;
          F := 0;
          ASP := 0;
          Iv := 0;
          CLI := 0;
          ASPack := 0;
          q := sql.Select('VolumeSklad', '*', '', '');
          while not q.Eof do
          begin
            Sum := Sum + q.fieldbyName('SC').asfloat;
            WR := WR + q.fieldbyName('W').asfloat;
            WC := WC + q.fieldbyName('P').asfloat;
            F := F + q.fieldbyName('V').asfloat;
            q.Next;
          end;
          q.free;
          ReportMakerWP.AddParam('6=' + FloatToStr(WR));
          ReportMakerWP.AddParam('7=' + FloatToStr(WC));
          ReportMakerWP.AddParam('8=' + StrTo00(FloatToStr(F)));
          ReportMakerWP.AddParam('9=' + StrTo00(FloatToStr(Sum)));
          Fil := 'VolumeSklad';
          FilIni := 'VolumeSklad';
          // application.MessageBox('� �������� ����������!','���������!',0);
          // exit
        end;
      //------------------
      20: {������ �� ����������'  }
        begin
          ReportMakerWP.AddParam('1=' + 'c ' +
            SendStr.DataDMstrY(StrToDate(LabelEditDate1.text)));
          ReportMakerWP.AddParam('2=' + '�� ' +
            SendStr.DataDMstrY(StrToDate(LabelEditDate2.text)));
          cond1 := '';
          if (LabelEditDate1.text <> '  .  .    ') then
            cond1 := '`Start`>=''' + FormatDateTime('yyyy-mm-dd',
              StrToDate(LabelEditDate1.text)) + '''';
          if (LabelEditDate2.text <> '  .  .    ') then
          begin
            if (cond1 <> '') then
              cond1 := cond1 + ' and ';
            cond1 := cond1 + '`Start`<=''' + FormatDateTime('yyyy-mm-dd',
              StrToDate(LabelEditDate2.text)) + '''';
          end;
          str1 := TStringList.Create;
          str1.Add('alter view InspectorCount '); //+
          str1.Add('as select Inspector_Ident,'); //+
          str1.Add('PeopleFIO,'); //+
          str1.Add('Count(Inspector_Ident) as Counts '); //+
          str1.Add('from ' + sends_view + ' where '); //+
          str1.Add(cond1);
          str1.Add(' Group by Inspector_Ident, PeopleFIO;'); //;

          sql.ExecSQL(str1);
          str1.free;
          Fil := 'InspectorCount';
          FilIni := 'InspectorCount';
        end;

      //------------------
      21: {'������ ��� ������'}
        begin
          ReportMakerWP.AddParam('1=' + 'c ' +
            SendStr.DataDMstrY(StrToDate(LabelEditDate1.text)));
          ReportMakerWP.AddParam('2=' + '�� ' +
            SendStr.DataDMstrY(StrToDate(LabelEditDate2.text)));
          cond1 := '';
          if (LabelEditDate1.text <> '  .  .    ') then
            cond1 := '`Start`>=''' + FormatDateTime('yyyy-mm-dd',
              StrToDate(LabelEditDate1.text)) + '''';
          if LabelEditDate2.text <> '  .  .    ' then
          begin
            if cond1 <> '' then
              cond1 := cond1 + ' and ';
            cond1 := cond1 + '`Start`<=''' + FormatDateTime('yyyy-mm-dd',
              StrToDate(LabelEditDate2.text)) + '''';
          end;
          str1 := TStringList.Create;
          str1.Add('alter view InspectorCount '); //+
          str1.Add('as select Client_Ident,'); //+
          str1.Add('ClientName,'); //+
          str1.Add('Namber,'); //+
          str1.Add('Client_Ident_Sender,'); //+
          str1.Add('ClientSenderName,'); //+
          str1.Add('AcceptorName,'); //+
          str1.Add('SumCount '); //+
          str1.Add('from ' + sends_view + ' where '); //+
          str1.Add(cond1 + ' and Client_Ident != Client_Ident_Sender;');

          sql.ExecSQL(str1);
          str1.free;
          Fil := 'RegionCount';
          FilIni := 'RegionCount';
        end;

      //------------------
      22: {'����� ������� � ��������'}
        begin
          cond1 := '';
          if (LabelEditDate1.text <> '  .  .    ') then
            cond1 := 'Dat>=''' + FormatDateTime('yyyy-mm-dd',
              StrToDate(LabelEditDate1.text)) + '''';
          if LabelEditDate2.text <> '  .  .    ' then
          begin
            if cond1 <> '' then
              cond1 := cond1 + ' and ';
            cond1 := cond1 + 'Dat<=''' + FormatDateTime('yyyy-mm-dd',
              StrToDate(LabelEditDate2.text)) + '''';
          end;
          ReportMakerWP.AddParam('1=' + cond1);
          Fil := 'FinanceCosts';
          //Fil:='RegionCount';
          FilIni := finance_costs_ini;
        end;

      //------------------
      25: {������ �� "+" ������}
        begin
          sql.Delete('Kredit', ''); {������� �������}
          if (sort = 0) then
            cond := 'Sal2Real'
          else if sort = 1 then
            cond := 'Dat';
          ReportMakerWP.AddParam('1=' + cond);
          cond := '';
          qcl := sql.Select('Clients', 'Ident,Acronym,City_Ident,Telephone',
            'PersonType_Ident=1 ', 'Acronym');
          while not qcl.Eof do
          begin
            cd := '';
            //-----------------------
            cond1 := ''; {������ �� ������� }
            //               AssignFile(c,systemdir+'uuuu');
            //               {$I-}
            //               Append(c)  ;
            //               {$I-}
            //               Writeln (c,qcl.fieldbyname('Ident').asstring);
            //                CloseFile(c);

            cond1 := STRTo00(CreditDate(qcl.fieldbyname('Ident').asinteger, now
              + 1));
            SA := 0;
            Sa := StrToFloat(cond1);
            if (Sa > 0) {������ ������ "+"} then
            begin
              cd := sql.MakeStr(cond1);
              cd := cd + ',' + cond1
            end
            else
              cd := '';
            //---------------------------------------
            if (cd <> '') then
            begin
              { ��� �������}
              cd := cd + ',' + sql.MakeStr(qcl.fieldByName('Acronym').asString);
              //-------------------------------------------
              {���� ��������� ������}
              q := sql.Select(paysheet_table, 'Dat', 'Client_Ident=' +
                qcl.fieldbyname('Ident').asString,
                'Dat DESC');
              if not q.eof then
                cd := cd + ',' + sql.MakeStr(FormatDateTime('yyyy-mm-dd',
                  StrToDate(q.FieldByName('Dat').AsString)))
              else
                cd := cd + ',NULL';
              q.Free;
              //--------------------------------------------
              {����� �������}
              if (qcl.fieldbyname('City_Ident').asString <> '') then
              begin
                cond := sql.SelectString('City', 'Name', 'Ident=' +
                  qcl.fieldbyname('City_Ident').asString);
                if cond <> '' then
                  cd := cd + ',' + sql.MakeStr(cond)
                else
                  cd := cd + ',NULL';
              end
              else
                cd := cd + ',NULL';
              //----------------------
              {������� �������}
              if qcl.fieldbyname('Telephone').asString <> '' then
                cd := cd + ',' +
                  sql.MakeStr(qcl.fieldbyname('Telephone').asString)
              else
                cd := cd + ',NULL';
              //------------
              sql.Insertstring('Kredit', 'Sal2,Sal2Real,Acr,Dat,City,Phone',
                cd);
            end;
            qcl.next;
          end;
          qcl.free;
          //--------------------------------------
          {�������� ������������� �� ����������� ����}
          q := sql.select('Kredit', '', '', '');
          NA := 0;
          while (not q.eof) do
          begin
            NA := NA + q.fieldByName('Sal2').AsFloat;
            q.Next;
          end;
          q.Free;
          ReportMakerWP.AddParam('2=' + StrTo00(FloatToStr(NA)));
          ReportMakerWP.AddParam('3=' + '�� ' + FormatDateTime('dd.mm.yyyy',
            now));
          //------------------
          Fil := 'Saldo';
          FilIni := 'Saldo';
        end;
      //------------------
      26: {�������� ����-������}
        begin
          cond1 := '';
          if (LabelEditDate1.Text <> '  .  .    ') then
          begin
            cond1 := ' where data >= ''' +
              FormatDateTime('yyyy-mm-dd', StrToDate(LabelEditDate1.text)) +
              '''';
          end;

          if (LabelEditDate2.Text <> '  .  .    ') then
          begin
            if cond1 <> '' then
              cond1 := cond1 + ' and data <= ''' +
                FormatDateTime('yyyy-mm-dd', StrToDate(LabelEditDate2.text)) +
                ''''
            else
              cond1 := ' where data <=''' +
                FormatDateTime('yyyy-mm-dd', StrToDate(LabelEditDate2.text)) +
                '''';
          end;

          str1 := TStringList.Create;
          str1.Add('alter view Checkinvoice '); //+
          str1.Add('as select ' + invoice_table + '.ident, ' + invoice_table +
            '.number,'); //+
          str1.Add('' + invoice_table + '.Sum as invoicesum,'); //+
          str1.Add('' + invoice_table + '.Data as data,'); //+
          str1.Add('Sum(' + send_table + '.sumcount) as sendsum from ' +
            invoice_table + '');
          //+
          str1.Add('left outer join ' + send_table + ' on '); //+
          str1.Add(send_table + '.invoice_ident=' + invoice_table + '.ident ');
          //+
          str1.Add(cond1); //+
          str1.Add('group by ident '); //+

          sql.ExecSQL(str1);
          str1.free;

          q := sql.select('Checkinvoice', '', 'Round(sendsum,2) <> invoicesum',
            '');
          if q.Eof then
          begin
            application.MessageBox('�� ��������� ������ ������������ ����-������ �� ��������!', '���������!', 0);
            q.Free;
            exit
          end;
          q.Free;
          ReportMakerWP.AddParam('1=' + '�������� ����-������ �� ������ c ' +
            FormatDateTime('yyyy-mm-dd', StrToDate(LabelEditDate1.text)) + ' �� '
            +
            FormatDateTime('yyyy-mm-dd', StrToDate(LabelEditDate2.text)));
          Fil := 'Checkinvoice';
          FilIni := 'checkinvoice';
        end;
      //------------------
      27: { �������� ��� ����-������     }
        begin
          cond := FormatDateTime('yyyy-mm-dd', StrToDate(LabelEditDate1.text));
          cond1 := FormatDateTime('yyyy-mm-dd', StrToDate(LabelEditDate2.text));
          str := '';
          str := ' (NumberCountPattern is NULL) and (DateSupp is not NULL) and '
            +
            ' DateSupp >= ' + sql.MakeStr(cond) + ' and ' +
            ' DateSupp <= ' + sql.MakeStr(cond1) +
            ' and (CountInvoice is not NULL) ' +
            ' and (not((ClientAcr like ''"%''))) ';
          q := sql.select(sends_view, '', str, '');
          if q.Eof then
          begin
            application.MessageBox('�� ��������� ������ ��� �������� ��� ����-������!', '���������!', 0);
            q.Free;
            exit
          end;
          q.Free;
          ReportMakerWP.AddParam('1=' + str);
          cond1 := '';
          cond1 := ' ClientAcr, DateSupp ';
          ReportMakerWP.AddParam('2=' + cond1);
          ReportMakerWP.AddParam('3=' +
            '�������� � ������� ��� ����-������� �� ������ � ' +
            cond + ' �� ' + FormatDateTime('yyyy-mm-dd',
            StrToDate(LabelEditDate2.text)));

          Fil := 'SendsNoInvoice';
          FilIni := sends_no_invoice_ini;
        end;

      //------------------
      28: {����������� ������ ����-������}
        begin
          cond := '';
          cond := 'b.Data >=' + sql.MakeStr(FormatDateTime('yyyy-mm-dd',
            StrToDate(LabelEditDate1.text))) +
            ' and  b.Data <=' + sql.MakeStr(FormatDateTime('yyyy-mm-dd',
            StrToDate(LabelEditDate2.text)));
          str1 := TStringList.Create;
          str1.Add('alter view InvNumDiff as select '); //+
          str1.Add(' Data, Number, Num, InvoiceNumDiff(Num) as numdiff '); //+
          str1.Add(' from booksel as b'); //+
          str1.Add(' where ' + cond); //+
          str1.Add(' order by b.num '); //+

          sql.ExecSQL(str1);
          str1.free;
          q := sql.select('InvNumDiff', '', '', '');
          l := 0;
          num := 0;
          cond := '';
          while not q.Eof do
          begin
            l := q.fieldByName('numdiff').AsInteger;
            num := q.fieldByName('num').AsInteger;
            if l > 0 then
            begin
              while not (l = 0) do
              begin
                cond := cond + IntToStr((num - l)) + ';';
                l := l - 1;
              end;
            end;
            q.Next;
          end;
          q.free;
          if cond = '' then
          begin
            application.MessageBox('�� ��������� ������ ����������� ������� ��� ����-������ �� ��������!', '���������!', 0);
            exit
          end;
          ReportMakerWP.AddParam('1=' +
            '����������� ������ ����-������ �� ������ ');
          ReportMakerWP.AddParam('3=' + 'c ' + FormatDateTime('yyyy-mm-dd',
            StrToDate(LabelEditDate1.text)) +
            ' �� ' + FormatDateTime('yyyy-mm-dd',
            StrToDate(LabelEditDate2.text)));
          ReportMakerWP.AddParam('2=' + cond);
          // ReportMakerWP.AddParam('2='+ ArrToString(myArray));
          Fil := 'InvNumDiff';
          FilIni := 'InvNumDiff';
        end;
    end;

    n := 0;
    FilOut := 'out.rtf';
    //----------------------------
    {FO:
    FilOp:= FileOpen(systemdir+'select\'+FilOut,fmOpenWrite) ;
    if FilOp=-1 then
    begin
     FilOut:='Out'+IntToStr(n)+'.rtf' ;
     n:=n+1;
     goto FO;
     exit;
    end else FileClose(FilOp);  }
    //------------------------------

    if ReportMakerWP.DoMakeReport(systemdir + 'select\' + Fil + '.rtf',
      systemdir + 'select\' + FilIni + '.ini',
      systemdir + 'select\' + FilOut) <> 0 then
    begin
      ReportMakerWP.Free;
      // application.messagebox('�������� �������� �������� � WINWORD!',
      // '�����!',0);
  //                          goto T;
      exit
    end;

    ReportMakerWP.Free;
    WordApplication1 := TWordApplication.Create(Application);
    p := systemdir + 'select\' + FilOut;

    //w1:=1;
    //w2:=sql.SelectString('Printer','NameA4','');
    WordApplication1.Documents.Open(p,
      EmptyParam, EmptyParam, EmptyParam,
      EmptyParam, EmptyParam, EmptyParam,
      EmptyParam, EmptyParam, EmptyParam,
      EmptyParam, EmptyParam);
    //WordApplication1.WindowState:=1;
   //w3:=sql.SelectString('Printer','ComNameA4','');

   //w4:=WordApplication1.UserName;
   //if w3<>w4 then   w2:= '\\'+w3+'\'+w2;

   //WordApplication1.ActivePrinter:=w2;
   {WordApplication1.ActiveDocument.PrintOut(
    EmptyParam,EmptyParam,EmptyParam,
    EmptyParam, EmptyParam,EmptyParam,
    EmptyParam,w1,EmptyParam,
    EmptyParam,EmptyParam,EmptyParam,
           w2,EmptyParam,EmptyParam,
           EmptyParam,EmptyParam,EmptyParam);

           T: WordApplication1.Documents.Close(EmptyParam,EmptyParam,
           EmptyParam);
           WordApplication1.WindowState:=2;  }
   //WordApplication1.Free;

  except
    WordApplication1.Documents.Close(EmptyParam, EmptyParam,
      EmptyParam);

    application.MessageBox('��������� ��� ��������� ��� ������!', '������!', 0);
    exit
  end;
end;

procedure TFormSelect.cbxListChange(Sender: TObject);
var
  index: integer;
begin
  index := cbxList.ComboBox.ItemIndex;
  // -----------------------------------------------------
  if ((index = 0) or (index = 1)) then {�������}
  begin
    LabelEditDate2.Visible := true;
    LabelEditDate1.Visible := true;
    cbZak.Visible := true;
    cbZak.SQLComboBox.Table := 'Clients';
    cbZak.SQLComboBox.Recalc;
    cbxSort.Visible := true;
    cbCity.Visible := false;
    cbxSort.ComboBox.Clear;
    cbxSort.ComboBox.items.Insert(0, '��������');
    cbxSort.ComboBox.items.Insert(1, '����');
    RadioGroup1.Visible := false;
    cbNumber.Visible := false;
  end;
  // -----------------------------------------------------
  if (index = 2) then {������ ��� ���������}
  begin
    LabelEditDate2.Visible := true;
    LabelEditDate1.Visible := true;
    cbZak.Visible := true;
    cbZak.SQLComboBox.Table := 'ClientsNotTek';
    cbZak.SQLComboBox.Recalc;
    cbxSort.Visible := false;
    cbCity.Visible := false;
    RadioGroup1.Visible := false;
    cbNumber.Visible := false;
  end;
  // -----------------------------------------------------
  if (index = 15) then {������ ��� ��������� TEK}
  begin
    LabelEditDate2.Visible := true;
    LabelEditDate1.Visible := true;
    cbZak.Visible := true;
    cbZak.SQLComboBox.Table := 'ClientsTek';
    cbZak.SQLComboBox.Recalc;
    cbxSort.Visible := false;
    cbCity.Visible := false;
    RadioGroup1.Visible := false;
    cbNumber.Visible := false;
  end;
  // -----------------------------------------------------
  // if l=3 then    {�/� ��������}
  { begin
  LabelEditDate2.Visible:=true;
  LabelEditDate1.Visible:=true;
  cbZak.Visible:=true;
  cbZak.SQLComboBox.Table:='Clients';
  cbZak.SQLComboBox.Recalc  ;
  cbxSort.Visible:=true;
  cbCity.Visible:=false;
  cbxSort.ComboBox.Clear;
  cbxSort.ComboBox.items.Insert(0,'��������');
  cbxSort.ComboBox.items.Insert(1,'�����')    ;
  RadioGroup1.Visible:=false;
  cbNumber.Visible:=false;
  end;   }
  // -----------------------------------------------------
  if (index = 3) then {����� ���������}
  begin
    LabelEditDate2.Visible := true;
    LabelEditDate1.Visible := true;
    cbZak.Visible := true;
    cbZak.SQLComboBox.Table := 'Clients';
    cbZak.SQLComboBox.Recalc;
    cbxSort.Visible := false;
    cbCity.Visible := true;
    RadioGroup1.Visible := true;
    cbNumber.Visible := false;
  end;
  // -----------------------------------------------------
  if (index = 4) then {������ �� ����-��������}
  begin
    LabelEditDate2.Visible := true;
    LabelEditDate1.Visible := true;
    cbZak.Visible := true;
    cbZak.SQLComboBox.Table := 'Clients';
    cbZak.SQLComboBox.Recalc;
    RadioGroup1.Visible := false;
    cbxSort.Visible := false;
    cbCity.Visible := false;
    cbNumber.Visible := false;
  end;
  // -----------------------------------------------------
  if (index = 5) then {��������}
  begin
    LabelEditDate2.Visible := false;
    LabelEditDate1.Visible := false;
    cbZak.Visible := false;
    //   cbZak.SQLComboBox.Table:='Clients';
    //       cbZak.SQLComboBox.Recalc  ;
    RadioGroup1.Visible := false;
    cbxSort.Visible := false;
    cbCity.Visible := false;
    cbNumber.Visible := false;
  end;
  // -----------------------------------------------------
  if ((index = 6) or (index = 26) or (index = 28)) then
    {����� ������}{26 - �������� ����-������}{����������� ������ ����-������}
  begin
    LabelEditDate2.Visible := true;
    LabelEditDate1.Visible := true;
    cbZak.Visible := false;
    //   cbZak.SQLComboBox.Table:='Clients';
    //       cbZak.SQLComboBox.Recalc  ;
    RadioGroup1.Visible := false;
    cbxSort.Visible := false;
    cbCity.Visible := false;
    cbNumber.Visible := false;
  end;
  // -----------------------------------------------------
  if (index = 7) then {��������� ���������}
  begin
    LabelEditDate2.Visible := true;
    LabelEditDate1.Visible := true;
    cbZak.Visible := true;
    cbZak.SQLComboBox.Table := 'Clients';
    cbZak.SQLComboBox.Recalc;
    RadioGroup1.Visible := false;
    cbxSort.Visible := false;
    cbCity.Visible := false;
    cbNumber.Visible := false;
  end;
  // -----------------------------------------------------
  if (index = 8) then {������}
  begin
    LabelEditDate2.Visible := true;
    LabelEditDate1.Visible := true;
    cbZak.Visible := true;
    cbZak.SQLComboBox.Table := 'Clients';
    cbZak.SQLComboBox.Recalc;
    RadioGroup1.Visible := false;
    cbxSort.Visible := false;
    cbCity.Visible := false;
    cbNumber.Visible := false;
  end;
  // -----------------------------------------------------
  if ((index = 9) or (index = 29)) then {������ �� �� ����������� �����}
  begin
    LabelEditDate2.Visible := true;
    LabelEditDate1.Visible := true;
    cbZak.Visible := true;
    if (index = 9) then
      cbZak.SQLComboBox.Table := 'ClientsNotTek'
    else
      cbZak.SQLComboBox.Table := 'ClientsTek';
    cbZak.SQLComboBox.Recalc;
    RadioGroup1.Visible := false;
    cbxSort.Visible := false;
    cbCity.Visible := false;
    cbNumber.Visible := false;
  end;
  // -----------------------------------------------------
  if ((index = 10) or (index = 25)) then {������ �� "-" ������}
  begin
    LabelEditDate2.Visible := false;
    LabelEditDate1.Visible := false;
    cbZak.Visible := false;
    // cbZak.SQLComboBox.Table:='Clients';
    // cbZak.SQLComboBox.Recalc  ;
    RadioGroup1.Visible := false;
    cbxSort.Visible := true;
    //cbxSort.ComboBox.items.Delete(0);
    cbxSort.ComboBox.Clear;
    cbxSort.ComboBox.items.Insert(0, '������');
    cbxSort.ComboBox.items.Insert(1, '����');
    //cbxSort.ComboBox.Items.Add('������');
    cbCity.Visible := false;
    cbNumber.Visible := false;
  end;
  // -----------------------------------------------------
  //if l=12 then   {������ �� ��������� ���������� (�/�)}
  { begin
      LabelEditDate2.Visible:=false;
      LabelEditDate1.Visible:=false;
      cbZak.Visible:=false;
      cbZak.SQLComboBox.Table:='Clients';
      cbZak.SQLComboBox.Recalc  ;
      RadioGroup1.Visible:=false;
      cbxSort.Visible:=false;
      cbCity.Visible:=false;
      cbNumber.Visible:=true;
    end;}
  // -----------------------------------------------------
  if ((index = 11) or (index = 19) {or (l=27)} or (index = 24)) then
    {������� ���������}
  begin
    LabelEditDate2.Visible := true;
    LabelEditDate1.Visible := true;
    cbZak.Visible := false;
    // cbZak.SQLComboBox.Table:='Clients';
    // cbZak.SQLComboBox.Recalc  ;
    RadioGroup1.Visible := false;
    cbxSort.Visible := false;
    { cbxSort.Visible:=true;
    cbxSort.ComboBox.Clear;
    cbxSort.ComboBox.items.Insert(0,'������');
    cbxSort.ComboBox.items.Insert(1,'������');   }
    cbCity.Visible := false;
    cbNumber.Visible := false;
  end;
  // -----------------------------------------------------
  if (index = 12) then {����� ��������� (��.)}
  begin
    LabelEditDate2.Visible := true;
    LabelEditDate1.Visible := true;
    cbZak.Visible := true;
    cbZak.SQLComboBox.Table := 'Clients';
    cbZak.SQLComboBox.Recalc;
    cbxSort.Visible := false;
    cbCity.Visible := true;
    RadioGroup1.Visible := true;
    cbNumber.Visible := false;
  end;
  // -----------------------------------------------------
  if (index = 13) then {������ (��.)}
  begin
    LabelEditDate2.Visible := true;
    LabelEditDate1.Visible := true;
    cbZak.Visible := true;
    cbZak.SQLComboBox.Table := 'Clients';
    cbZak.SQLComboBox.Recalc;
    RadioGroup1.Visible := false;
    cbxSort.Visible := false;
    cbCity.Visible := false;
    cbNumber.Visible := false;
  end;
  // -----------------------------------------------------
  if (index = 14) then {����� ��������� �� �/�}
  begin
    LabelEditDate2.Visible := true;
    LabelEditDate1.Visible := true;
    cbZak.Visible := true;
    cbZak.SQLComboBox.Table := 'Clients';
    cbZak.SQLComboBox.Recalc;
    cbxSort.Visible := false;
    cbCity.Visible := true;
    RadioGroup1.Visible := false;
    cbNumber.Visible := false;
  end;
  // -----------------------------------------------------
  // if l=17 then   {������ (04)}
  { begin
    LabelEditDate2.Visible:=true;
    LabelEditDate1.Visible:=true;
    cbZak.Visible:=true;
    cbZak.SQLComboBox.Table:='Clients';
    cbZak.SQLComboBox.Recalc  ;
    RadioGroup1.Visible:=false;
    cbxSort.Visible:=false;
    cbCity.Visible:=false;
    cbNumber.Visible:=false;
  end; }
  // -----------------------------------------------------
  if (index = 15) then {������ ��� ��������� TEK}
  begin
    LabelEditDate2.Visible := true;
    LabelEditDate1.Visible := true;
    cbZak.Visible := true;
    cbZak.SQLComboBox.Table := 'ClientsTek';
    cbZak.SQLComboBox.Recalc;
    cbxSort.Visible := false;
    cbCity.Visible := false;
    RadioGroup1.Visible := false;
    cbNumber.Visible := false;
  end;
  // -----------------------------------------------------
  if ((index = 16) or (index = 23)) then {����� � ��������� ���������}
  begin
    LabelEditDate2.Visible := true;
    LabelEditDate1.Visible := true;
    cbZak.Visible := false;
    // -----------------------------------------------------
    //if l=16 then
      //     cbZak.SQLComboBox.Table:='ClientsNotTek'
      //     else cbZak.SQLComboBox.Table:='ClientsTek';
      //     cbZak.SQLComboBox.Recalc  ;
    cbxSort.Visible := false;
    cbCity.Visible := true;
    RadioGroup1.Visible := true;
    cbNumber.Visible := false;
  end;
  // -----------------------------------------------------
  if (index = 17) then {������� ��������� �� ����� �����1}
  begin
    LabelEditDate2.Visible := true;
    LabelEditDate1.Visible := true;
    cbZak.Visible := false;
    //cbZak.SQLComboBox.Table:='Clients';
    //cbZak.SQLComboBox.Recalc  ;
    cbxSort.Visible := false;
    cbCity.Visible := false;
    RadioGroup1.Visible := true;
    cbNumber.Visible := false;
  end;
  // -----------------------------------------------------
  if (index = 18) then {������� ��������� �� ����� �����1}
  begin
    LabelEditDate2.Visible := true;
    LabelEditDate1.Visible := true;
    cbZak.Visible := false;
    //cbZak.SQLComboBox.Table:='Clients';
    //cbZak.SQLComboBox.Recalc  ;
    cbxSort.Visible := false;
    cbCity.Visible := false;
    RadioGroup1.Visible := true;
    cbNumber.Visible := false;
  end;
  // -----------------------------------------------------
  if (index = 20) then {'������ �� ����������'}
  begin
    LabelEditDate2.Visible := true;
    LabelEditDate1.Visible := true;
    cbZak.Visible := false;
    // cbZak.SQLComboBox.Table:='Clients';
    // cbZak.SQLComboBox.Recalc  ;
    cbxSort.Visible := false;
    cbCity.Visible := false;
    RadioGroup1.Visible := false;
    cbNumber.Visible := false;
  end;
  // -----------------------------------------------------
  if (index = 21) then {'������ ��� ������'}
  begin
    LabelEditDate2.Visible := true;
    LabelEditDate1.Visible := true;
    cbZak.Visible := false;
    // cbZak.SQLComboBox.Table:='Clients';
    // cbZak.SQLComboBox.Recalc  ;
    cbxSort.Visible := false;
    cbCity.Visible := false;
    RadioGroup1.Visible := false;
    cbNumber.Visible := false;
  end;
  // -----------------------------------------------------
  if (index = 22) then {'����� ������� � ��������'}
  begin
    LabelEditDate2.Visible := true;
    LabelEditDate1.Visible := true;
    cbZak.Visible := false;
    //   cbZak.SQLComboBox.Table:='Clients';
    //        cbZak.SQLComboBox.Recalc  ;
    cbxSort.Visible := false;
    cbCity.Visible := false;
    RadioGroup1.Visible := false;
    cbNumber.Visible := false;
  end;
  // -----------------------------------------------------
  if (index = 27) then {�������� ��� ����-������}
  begin
    LabelEditDate2.Visible := true;
    LabelEditDate1.Visible := true;
    cbZak.Visible := false;
    // cbZak.SQLComboBox.Table:='Clients';
    // cbZak.SQLComboBox.Recalc  ;
    RadioGroup1.Visible := false;
    cbxSort.Visible := false;
    cbCity.Visible := false;
    cbNumber.Visible := false;
  end;
end;

procedure TFormSelect.FormKeyDown(Sender: TObject; var Key: Word; Shift:
  TShiftState);
begin
  if (key = VK_Return) then
    btPrintClick(Sender)
end;
end.

