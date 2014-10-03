unit FAKT;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, LblEdtDt, Sqlctrls, Lbsqlcmb, StdCtrls, Buttons, BMPBtn,
  ComCtrls, DB, TSQLCLS, DBTables, Tadjform, SqlGrid, OleServer,
  Word2000, Menus, Lbledit, DateUtils, QDialogs, EntrySec, Logger;

type
  TFormAkt = class(TForm)
    HeaderControl1: THeaderControl;
    btOk: TBMPBtn;
    btPrint: TBMPBtn;
    btCansel: TBMPBtn;
    cbClient: TLabelSQLComboBox;
    LabelEditDate1: TLabelEditDate;
    eNumber: TLabelEdit;
    CheckBox1: TCheckBox;
    WordApplication1: TWordApplication;
    procedure btCanselClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btPrintClick(Sender: TObject);
    procedure cbClientChange(Sender: TObject);
    procedure LabelEditDate1Exit(Sender: TObject);
    procedure Print;
    procedure SaveAkt;
    procedure eNumberChange(Sender: TObject);
    procedure erExit(Sender: TObject);
    procedure btOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    function AddRecord(i: longint): longint;
    function EditRecord(Iden: longInt): longint;
    function Num: string;
    { Public declarations }
  end;

var
  FormAkt: TFormAkt;
  Ident: longint; {����� �������}
  IdInv: longint; {����� ���� �������}
  Number: string;
  NumberChange: string; {����� ����������}
  Dat: string;
  SumNDS: real; {����� � ���}
  Sum: real; {����� ��� ���}
  StrIdSend: string;
  code: integer; {������������� 0-������� �����, 1-������� �� ���, 2-����������}
  erExitTest: boolean;

implementation
uses makerepp, SendStr, Invoice, Menu;
{$R *.dfm}

procedure TFormAkt.btCanselClick(Sender: TObject);
begin
  case Application.MessageBox('��� ��������� ��������� �� ����� ���������!',
    '��������������!', MB_YESNO + MB_ICONQUESTION) of
    IDYES: ModalResult := mrCancel;
    IDNO: exit;
  end;
end;

procedure TFormAkt.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_Return) then
    btPrintClick(Sender)
end;

function TFormAkt.AddRecord(i: longint): longint;
begin
  NumberChange := '';
  code := 0;
  Ident := 0;
  IdInv := 0;
  Number := '';
  LabelEditDate1.enabled := true;
  cbClient.enabled := true;
  LabelEditDate1.Text := FormatDateTime('dd.mm.yyyy', now);
  Dat := LabelEditDate1.Text;
  CheckBox1.Visible := false;
  btOk.Visible := false;
  if (i <> 0) then
  begin
    Ident := i;
    cbClient.SetActive(Ident);
    code := 1;
  end;
  if (showModal = mrOk) then
  begin
    AddRecord := IdInv;
  end
  else
    AddRecord := 0;
end;

function TFormAkt.EditRecord(Iden: longInt): longint;
var
  q: TQuery;
  s: string;
  update_thread: TUpdateThread;
  upd_thread: TUpdateThread;
begin
  IdInv := 0;
  Number := '';
  NumberChange := '';
  IdInv := Iden;
  q := sql.Select(EntrySec.akttek_table {'AktTek'}, '', 'Ident=' +
    IntToStr(IdInv), '');
  Number := q.FieldByName('Number').AsString;
  NumberChange := q.FieldByName('Number').AsString;
  eNumber.Text := q.FieldByName('Number').AsString;
  LabelEditDate1.text := FormatDateTime('dd.mm.yyyy',
    StrToDate(q.FieldByName('Data').AsString));
  Dat := FormatDateTime('dd.mm.yyyy',
    StrToDate(q.FieldByName('Data').AsString));
  cbClient.SetValue(q);
  CheckBox1.Visible := true;
  if q.FieldByName('ReportReturn').AsInteger = 1 then
    CheckBox1.checked := true
  else
    CheckBox1.checked := false;
  //LabelEditDate1.enabled:=false;
  //cbClient.enabled:=false;
  btOk.Visible := true;
  q.Free;
  Code := 2;
  if showModal = mrOk then
  begin
    strIdSend := '';
    q := sql.Select(EntrySec.send_table {'Send'}, 'DateSupp,Ident,CountInvoice',
      'Akttek_Ident=' + IntToStr(IdInv)
      , 'DateSupp');
    if (not q.Eof) then
    begin
      while (not q.Eof) do
      begin
        strIdSend := strIdSend + ',' + q.FieldByName('Ident').AsString;
        q.Next;
      end;
      if (Pos(',', strIdSend) = 1) then
        Delete(strIdSend, 1, 1);
      AktCount(Ident, StrIdSend);
      // Print;
    end
    else
    begin
      ShowMessage('��������� �������� �� ��� � ������� ' + Number + '!');
      EditRecord := 0;
      exit;
    end;
    q.Free;
    //---------------------------------------

    Sum := 0;
    SumNDS := 0;
    q := sql.Select('PrintInvoice', 'SumNDS', 'Send_Ident in (' + StrIdSend +
      ')', '');
    if (q.Eof) then
    begin
      EditRecord := 0;
      exit
    end
    else
    begin
      while (not q.eof) do
      begin
        SumNDS := SumNDS + q.FieldByName('SumNDS').AsFloat;
        q.Next;
      end;
    end;
    q.Free;
    //----------------------
    if CheckBox1.Checked then
      s := 'ReportReturn=' + IntToStr(1)
    else
      s := 'ReportReturn=' + IntToStr(0);
    //----------------------
    if (Dat <> '  .  .    ') then
      s := s + ', Data = ' + sql.MakeStr(FormatDateTime('yyyy-mm-dd',
        StrToDate(Dat)))
    else
      s := s + ',Data = NULL';
    //----------------------
    if (Ident <> 0) then
      s := s + ', Clients_Ident=' + IntToStr(Ident)
    else
      s := s + ', Clients_Ident=NULL';
    //----------------------
    s := S + ', Sum = ' + sql.MakeStr(StrTo00(FloatToStr(SumNDS)));
    //----------------------
    if (NumberChange <> '') then
      s := s + ', Number = ' + sql.MakeStr(NumberChange)
    else
      s := s + ', Number = ' + sql.MakeStr(Number);
    //----------------------
    if sql.UpdateString(EntrySec.akttek_table {'AktTek'}, s, 'Ident=' +
      IntToStr(IdInv)) <> 0 then
    begin
      EditRecord := 0;
      sql.Rollback;
      exit
    end
    else
    begin
      // success
      update_thread := TUpdateThread.Create(True, EntrySec.akttek_table_other,
        s,
        'Ident=' + IntToStr(IdInv));
      update_thread.Resume();
    end;
    //----------------------
    if (NumberChange <> '') then
      Number := NumberChange;
    //----------------------
    if sql.UpdateString(EntrySec.send_table {'Send'}, 'Akttek_Ident=' +
      IntToStr(IdInv),
      'Ident in (' + StrIdSend + ')') <> 0 then
    begin
      sql.Rollback;
      EditRecord := 0;
      exit;
    end
    else
    begin
      // success
      upd_thread := TUpdateThread.Create(True, EntrySec.send_table_other,
        'Akttek_Ident=' + IntToStr(IdInv),
        'Ident in (' + StrIdSend + ')');
      upd_thread.Resume();
    end;
    sql.Delete('PrintInvoice', 'Send_Ident in (' + StrIdSend + ')');
    EditRecord := IdInv;
  end
  else
    EditRecord := IdInv;
end;

procedure TFormAkt.btPrintClick(Sender: TObject);
var
  q: TQUery;
  i: integer;
  j: integer;
  poin: string;
  DateS: TDate;
  test: boolean;
begin
  if (cbClient.GetData = 0) then
  begin
    Application.MessageBox('�������� ���������!', '������!', 0);
    cbClient.SetFocus;
    exit;
  end;
  //----------------------
  if (LabelEditDate1.text = '  .  .    ') then
  begin
    Application.MessageBox('������� ���� ������������ ���� �������!', '������!',
      0);
    LabelEditDate1.SetFocus;
    exit;
  end;
  //----------------------
  if (NumberChange <> '') then
    if sql.SelectString(EntrySec.akttek_table {'AktTek'}, 'Number', 'Number=' +
      sql.MakeStr(NumberChange) +
      ' and Ident <> ' + IntToStr(IdInv)) <> '' then
    begin
      Application.MessageBox('��� � ����� ������� ��� �������,' +
        '������� ������ �����!', '������!', 0);
      eNumber.SetFocus;
      exit;
    end;
  //----------------------

  erExit(Sender);
  if not erExitTest then
  begin
    eNumber.SetFocus;
    exit;
  end;
  //----------------------
  if ((Code = 0) or (Code = 1)) then {������� �����}
  begin
    test := false;
    q := sql.Select(EntrySec.send_table {'Send'}, 'DateSupp,Ident,CountInvoice',
      'Client_Ident=' + IntToStr(Ident) +
      ' and AktTek_Ident is NULL and( (ContractType_Ident=2 and ' +
      'DateSupp is not NULL) or (ContractType_Ident=1 and ' +
      'DateSupp is not NULL and SumWay is not NULL and ' +
      'SumServ is not NULL)) and DateSupp<=' +
      sql.MakeStr(FormatDateTime('yyyy-mm-dd', StrToDate(Dat))) +
      ' and CountInvoice is not NULL', 'DateSupp');
    if q.Eof then
    begin
      ShowMessage('� ������� ' + sql.Selectstring('Clients', 'Name', 'Ident=' +
        IntToStr(Ident)) +
        ' ��� ������������ ��� ������������ ��������!');
      exit;
    end
    else
    begin
      strIdSend := '';
      i := 0;
      while (not q.Eof) do
      begin
        j := 2;
        if i + j < 24 then
        begin
          i := i + j;
          strIdSend := strIdSend + ',' + q.FieldByName('Ident').AsString;
        end
        else if (I + J = 24) then
        begin
          if (Pos(',', strIdSend) = 1) then
            Delete(strIdSend, 1, 1);
          AktCount(Ident, StrIdSend);
          if NumberChange <> '' then
            number := NumberChange
          else
            Number := Num;
          SaveAkt;
          Print;
          sql.Delete('PrintInvoice', 'Send_Ident in (' + StrIdSend + ')');
          StrIdSend := '';
          i := 0;
        end
        else
        begin
          if (Pos(',', strIdSend) = 1) then
            Delete(strIdSend, 1, 1);
          AktCount(Ident, StrIdSend);
          if NumberChange <> '' then
            number := NumberChange
          else
            Number := Num;
          SaveAkt;
          Print;
          sql.Delete('PrintInvoice', 'Send_Ident in (' + StrIdSend + ')');
          StrIdSend := q.FieldByName('Ident').AsString;
          i := j;
        end;
        q.Next;
      end;
      //----------------------------------
      //DateS:=0;
      if StrIdSend <> '' then
      begin
        if (Pos(',', strIdSend) = 1) then
          Delete(strIdSend, 1, 1);
        q := sql.Select(EntrySec.send_table {'Send'}, 'DateSupp', 'Ident in (' +
          StrIdSend + ')', 'DateSupp');
        DateS := 0;
        if not q.eof then
          DateS := q.FieldByName('DateSupp').AsDateTime;
        if DateS<(Now - 4) then
          Test := true;
      end;
      //---------------------------------
      if ((i < 21)) and (i > 0) and (Code = 0) and (not test) then
      begin
        poin := '�������� �� ������������� ' + IntToStr(i) + ' �����!';

        if InputQuery('���������!', '���������� ������?', poin) then
        begin
          if (Pos(',', strIdSend) = 1) then
            Delete(strIdSend, 1, 1);
          AktCount(Ident, StrIdSend);
          if NumberChange <> '' then
            number := NumberChange
          else
            Number := Num;
          SaveAkt;
          Print;
          sql.Delete('PrintInvoice', 'Send_Ident in (' + StrIdSend + ')');
          StrIdSend := '';
          i := 0;
        end;
      end
      else if ((i > 21) and (i > 0)) or test then
      begin
        if (Pos(',', strIdSend) = 1) then
          Delete(strIdSend, 1, 1);
        AktCount(Ident, StrIdSend);
        if NumberChange <> '' then
          number := NumberChange
        else
          Number := Num;
        SaveAkt;
        Print;
        sql.Delete('PrintInvoice', 'Send_Ident in (' + StrIdSend + ')');
        StrIdSend := '';
        i := 0;
      end;
      q.Free;
    end;
  end
  else if Code = 2 then {���������� ��� ������������}
  begin
    strIdSend := '';
    q := sql.Select(EntrySec.send_table {'Send'}, 'DateSupp,Ident,CountInvoice',
      'Akttek_Ident=' + IntToStr(IdInv)
      , 'DateSupp');
    if not q.Eof then
    begin
      while not q.Eof do
      begin
        strIdSend := strIdSend + ',' + q.FieldByName('Ident').AsString;
        q.Next;
      end;
      if (Pos(',', strIdSend) = 1) then
        Delete(strIdSend, 1, 1);
      AktCount(Ident, StrIdSend);
      Print;
      sql.Delete('PrintInvoice', 'Send_Ident in (' + StrIdSend + ')');
    end
    else
    begin
      ShowMessage('��������� �������� �� ��� � ������� ' +
        Number + '!');
      exit;
    end;
    q.Free;
  end;
  ModalResult := mrOk;
end;

procedure TFormAkt.Print;
var
  ReportMakerWP: TReportMakerWP;
  p, w1, w2, w3, w4: OleVariant;
  s, mach: string;
  q: tQuery;
  i1, i2, i3, i4: integer;
  certificatetek_ini: string;
label
  T1;
begin
  Logger.LogError(EntrySec.version + '[TFormAkt.Print] >>>> ');
  try
    if (Application = nil) then
    begin
      application.MessageBox('[TFormAkt.Print] O����� ����� � �����������',
        'Error', 0);
      Logger.LogError(EntrySec.version +
        '[TFormInvoice.Print] Error !!! Application == nil');
    end;
    Logger.LogError(EntrySec.version +
      '[TFormAkt.Print] TReportMakerWP.Create(Application)');
    ReportMakerWP := TReportMakerWP.Create(Application);
    if (ReportMakerWP = nil) then
    begin
      Logger.LogError(EntrySec.version +
        '[TFormAkt.Print] Error !!! ReportMakerWP == nil');
    end;

    Logger.LogError(EntrySec.version +
      '[TFormAkt.Print] ReportMakerWP.ClearParam');
    ReportMakerWP.ClearParam;
    //--------
    Logger.LogError(EntrySec.version + '[TFormAkt.Print] sql.Select(BOSS....');
    q := sql.Select('BOSS', '*', '', '');
    ReportMakerWP.AddParam('1=' + Number);
    s := SendStr.DataDMstrY(StrToDate(Dat));
    ReportMakerWP.AddParam('2=' + s);
    ReportMakerWP.AddParam('3=' + '��� "���������� ���"');

    ReportMakerWP.AddParam('14=' + q.FieldByName('Person').asstring);
    ReportMakerWP.AddParam('15=' + q.FieldByName('PersonBug').asstring);
    q.Free;
    //--------------------------------------------------
    Logger.LogError(EntrySec.version +
      '[TFormAkt.Print] sql.Select(ClientsAll....');
    q := sql.Select('ClientsAll', 'FullName,inPerson,OnReason',
      'Ident=' + IntToStr(Ident), '');
    ReportMakerWP.AddParam('4=' + q.FieldByName('FullName').asstring);
    ReportMakerWP.AddParam('5=' + q.FieldByName('inPerson').asstring);
    ReportMakerWP.AddParam('6=' + q.FieldByName('OnReason').asstring);
    q.Free;
    //----------------------------------------------------
    Logger.LogError(EntrySec.version +
      '[TFormAkt.Print] sql.Select(PrintInvoice....');
    q := sql.Select('PrintInvoice', 'Sum,SumNDS,NDS', 'Send_Ident in (' +
      StrIdSend + ')', '');
    Sum := 0;
    SumNDS := 0;

    if (q.Eof) then
      exit
    else
    begin
      while (not q.eof) do
      begin
        Sum := Sum + q.FieldByName('Sum').AsFloat;
        SumNDS := SumNDS + q.FieldByName('SumNDS').AsFloat;
        q.Next;
      end;
    end;
    q.Free;

    ReportMakerWP.AddParam('32=' + StrTo00(FloatToStr(Sum)));
    ReportMakerWP.AddParam('34=' + StrTo00(FloatToStr(SumNDS)));
    s := SendStr.MoneyToString(StrTo00(FloatToStr(SumNDS)));
    ReportMakerWP.AddParam('35=' + s);
    s := 'Ident in (' + StrIdSend + ')';
    ReportMakerWP.AddParam('38=' + s);
    certificatetek_ini := iff(EntrySec.bAllData, 'CertificateTEK_all.ini',
      'CertificateTEK.ini');
    Logger.LogError(EntrySec.version + '[TFormAkt.Print] certificatetek_ini=' +
      certificatetek_ini);

    //-----------------------------------------------------------------------------------------------
    // open close word - remove if it is not working
    Logger.LogError(EntrySec.version +
      '[TFormAkt.Print] 1 TWordApplication.Create');

    if (Application = nil) then
    begin
      Logger.LogError(EntrySec.version + '[FInvoice] (Application is null');
      application.MessageBox('O����� ����� � �����������', 'Error', 0);
    end;

    //-----------------------------------------------------------------------------------------------
    //    WordApplication1:=TWordApplication.Create(Application);
    //    if (WordApplication1 <> nil) then
    //    begin
    //      Logger.LogError(EntrySec.version + '[TFormAkt.Print] 1 TWordApplication.Visible=true');
    //      WordApplication1.Visible := true;
    //      if (WordApplication1.Documents <> nil) then
    //      begin
    //        try
    //          WordApplication1.Documents.Close(EmptyParam,EmptyParam, EmptyParam);
    //        except
    //        on E: Exception do
    //          begin
    //            Logger.LogError(EntrySec.version + '[TFormAkt.Print] Exceptions happened on WordApplication1.Documents.Close(): ' + E.Message);
    //          end;
    //        end;
    //        Logger.LogError(EntrySec.version + '[TFormAkt.Print] 1 TWordApplication.WindowState=2');
    //        WordApplication1.WindowState:=2;
    //        Logger.LogError(EntrySec.version + '[TFormAkt.Print] 1 TWordApplication.Free');
    //        WordApplication1.Free;
    //      end;
    //    end;
    //-----------------------------------------------------------------------------------------------

    if (ReportMakerWP.DoMakeReport(systemdir + 'Invoice\CertificateTEK.rtf',
      systemdir + 'Invoice\' + certificatetek_ini, systemdir +
      'Invoice\out1.rtf') <> 0) then
    begin
      Logger.LogError(EntrySec.version +
        '[TFormAkt.Print] failed ReportMakerWP.DoMakeReport <> 0');
      ReportMakerWP.Free;
      //application.messagebox('�������� �������� �������� � WINWORD!',
      //'�����!',0);
      //goto T1;
      Logger.LogError(EntrySec.version + '[TFormAkt.Print] exit <<<');
      exit
    end;

    Logger.LogError(EntrySec.version + '[TFormAkt.Print] ReportMakerWP.Free');
    ReportMakerWP.Free;
    Logger.LogError(EntrySec.version +
      '[TFormAkt.Print] TWordApplication.Create2');
    WordApplication1 := TWordApplication.Create(Application);
    Logger.LogError(EntrySec.version +
      '[TFormAkt.Print] TWordApplication.Visible=true');
    WordApplication1.Visible := true;

    p := systemdir + 'Invoice\out1.rtf';
    w1 := 2;
    if (Code = 2) then
      {��� ��������� ������ ���� ����������� ������ ��� ����� �� 0 �� 2}
    begin
      i1 := 0;
      i2 := 0;
      i3 := 2;
      i4 := 1;
      if (InputQuery('������!', '����� ���������� ����� ���� �����������?', i1,
        i2, i3, i4)) then
        w1 := i1;
    end;
    if (w1 = 0) then {�� ��������, ���� ������������ ������ "0" ���������� �����}
    begin
      goto T1;
      // do wee need exit ?
      // exit;
    end;
    mach := '';
    mach := trim(WordApplication1.UserName);
    w2 := sql.SelectString('Printer', 'NameA4', 'ComputerName=' +
      sql.MakeStr(mach));
    Logger.LogError(EntrySec.version +
      '[TFormAkt.Print] WordApplication1.Documents.Open p=' + p);
    WordApplication1.Documents.Open(p,
      EmptyParam, EmptyParam, EmptyParam,
      EmptyParam, EmptyParam, EmptyParam,
      EmptyParam, EmptyParam, EmptyParam,
      EmptyParam, EmptyParam);

    w3 := sql.SelectString('Printer', 'ComNameA4', 'ComputerName=' +
      sql.MakeStr(mach));
    if ((VarToStr(w2) = '') or (VarToStr(w3) = '')) then
    begin
      Logger.LogError(EntrySec.version + '[TFormAkt.Print] Printer not in DB');
      application.MessageBox('���������� � ��������� �� ������� � ���� ��� ������ ������' +
        ' ��� � ���������� WinWord �� ����� ������� ��� ������!', '������!', 0);
      goto T1;
      exit;
    end;

    Logger.LogError(EntrySec.version +
      '[TFormAkt.Print] WordApplication1.UserName');
    w4 := WordApplication1.UserName;
    //----------------------------------
    if (w3 <> w4) then
      w2 := '\\' + w3 + '\' + w2;
    //----------------------------
    Logger.LogError(EntrySec.version +
      '[TFormAkt.Print] WordApplication1.ActivePrinter=' + w2);
    WordApplication1.ActivePrinter := w2;
    Logger.LogError(EntrySec.version +
      '[TFormAkt.Print] WordApplication1.ActiveDocument.PrintOut');
    WordApplication1.ActiveDocument.PrintOut(
      EmptyParam, EmptyParam, EmptyParam,
      EmptyParam, EmptyParam, EmptyParam,
      EmptyParam, w1, EmptyParam,
      EmptyParam, EmptyParam, EmptyParam,
      w2, EmptyParam, EmptyParam,
      EmptyParam, EmptyParam, EmptyParam);
    // Label
    T1:
    Logger.LogError(EntrySec.version + '[TFormAkt.Print] label T1');
    if (WordApplication1 <> nil) then
    begin

      begin
        try
          WordApplication1.Documents.Close(EmptyParam, EmptyParam,
            EmptyParam);
        except
          on E: Exception do
          begin
            Logger.LogError(EntrySec.version +
              '[TFormAkt.Print] T1: Exceptions happened on WordApplication1.Documents.Close(): ' +
              E.Message);
          end;
        end;
      end;

      Logger.LogError(EntrySec.version +
        '[TFormAkt.Print] WordApplication1.WindowState=2');
      WordApplication1.WindowState := 2;
      Logger.LogError(EntrySec.version +
        '[TFormAkt.Print] WordApplication1.Free');
      WordApplication1.Free;
    end;
  except
    on E: Exception do
    begin
      Logger.LogError(EntrySec.version + '[TFormAkt.Print] Exceptions happened: '
        + E.Message);
      if (WordApplication1 <> nil) then
      begin
        if (WordApplication1.Documents <> nil) then
        begin
          Logger.LogError(EntrySec.version +
            '[TFormAkt.Print] E WordApplication1.Documents.Close');
          try
            WordApplication1.Documents.Close(EmptyParam, EmptyParam,
              EmptyParam);
          except
            on E: Exception do
            begin
              Logger.LogError(EntrySec.version +
                '[TFormAkt.Print] Exceptions happened on WordApplication1.Documents.Close(): ' +
                E.Message);
            end;
          end;
        end;
        Logger.LogError(EntrySec.version +
          '[TFormAkt.Print] E WordApplication1.WindowState.2');
        WordApplication1.WindowState := 2;
        Logger.LogError(EntrySec.version +
          '[TFormAkt.Print] E WordApplication1.Free.');
        WordApplication1.Free;
      end;
      application.MessageBox('��������� ��� ��������� ��� ������!', 'Error!',
        0);
      Logger.LogError(EntrySec.version + '[TFormAkt.Print] E exit <<<');
      exit;
    end;
  end;
  Logger.LogError(EntrySec.version + '[TFormAkt.Print] <<<<');
end;

procedure TFormAkt.SaveAkt;
var
  str: string;
  q: TQuery;
  l: longInt;
  SumNDS: real;

  fields: string;
  ins_thread: TInsertThread;
  upd_thread: TUpdateThread;

label
  Ins;
label
  Control;

begin
  q := sql.Select('PrintInvoice', 'SumNDS', 'Send_Ident in (' + StrIdSend + ')',
    '');
  SumNDS := 0;

  if q.Eof then
    exit
  else
  begin
    while (not q.eof) do
    begin
      SumNDS := SumNDS + q.FieldByName('SumNDS').AsFloat;
      q.Next;
    end;
  end;
  q.Free;
  //----------------

  l := sql.FindNextInteger('Ident', EntrySec.akttek_table {'AktTek'}, '',
    MaxLongint);
  str := IntToStr(l);
  str := str + ',' + sql.MakeStr(FormatDateTime('yyyy-mm-dd', StrToDate(Dat)));
  str := str + ',' + IntToStr(Ident);
  str := Str + ',' + sql.MakeStr(StrTo00(FloatToStr(SumNDS)));
  str := str + ',' + IntToStr(0);
  control:
  if sql.SelectString(EntrySec.akttek_table {'AktTek'}, 'Number', 'Number=' +
    sql.MakeStr(Number)) <> '' then
  begin
    if NumberChange <> '' then
    begin
      Application.MessageBox('��� � ����� ������� ��� �������,' +
        '������� ������ �����!', '������!', 0);
      eNumber.SetFocus;
      exit
    end;
    Number := Num;
    goto Control;
  end
  else
    goto Ins;
  Ins: str := str + ',' + sql.MakeStr(Number);
  fields := 'Ident,Data,Clients_Ident,Sum,' + 'ReportReturn,Number';
  if sql.InsertString(EntrySec.akttek_table {'AktTek'}, fields, str) <> 0 then
  begin
    sql.Rollback;
    exit;
  end
  else
  begin
    // success
    // update other tables
    ins_thread := TInsertThread.Create(True, EntrySec.akttek_table_other,
      fields, str);
    ins_thread.Resume();
  end;

  if sql.UpdateString(EntrySec.send_table {'Send'}, 'Akttek_Ident=' +
    IntToStr(l),
    'Ident in (' + StrIdSend + ')') <> 0 then
  begin
    sql.Rollback;
    exit;
  end
  else
  begin
    // success
    // update other tables
    upd_thread := TUpdateThread.Create(True, EntrySec.send_table_other,
      'Akttek_Ident=' + IntToStr(l), 'Ident in (' + StrIdSend + ')');
    upd_thread.Resume();

  end;
  IdInv := l;
end;

function TFormAkt.Num: string;
var
  q: TQuery;
  Year, Month, Day: Word;
  Num1, Num2: string;
  N1, N2: integer;
begin
  if Dat <> '  .  .    ' then
    DecodeDate(StrToDate(Dat), Year, Month, Day)
  else
  begin
    Application.MessageBox('������� ���� �����������!', '������!', 0);
    exit
  end;
  q := sql.select(EntrySec.akttekview_view {'AktTekView'}, 'Number,`Year`',
    '`Year`=' + IntToStr(Year), '');
  if q.eof then
    Num := '1/' + FormatDateTime('yy', StrToDate(Dat))
  else
  begin
    Num1 := q.fieldByName('Number').AsString;
    N1 := pos('/', Num1);
    delete(Num1, N1, Length(Num1) - N1 + 1);
    N1 := StrToInt(Num1);
    while not q.Eof do
    begin
      Num2 := q.fieldByName('Number').AsString;
      N2 := pos('/', Num2);
      delete(Num2, N2, Length(Num2) - N2 + 1);
      N2 := StrToInt(Num2);
      if N1 < N2 then
        N1 := N2;
      q.Next;
    end;
    Num := IntToStr(N1 + 1) + '/' + FormatDateTime('yy', StrToDate(Dat));
  end;

  q.free;
end;

procedure TFormAkt.cbClientChange(Sender: TObject);
begin
  Ident := cbClient.SQLComboBox.GetData;
end;

procedure TFormAkt.LabelEditDate1Exit(Sender: TObject);
begin
  Dat := LabelEditDate1.text;
end;

procedure TFormAkt.eNumberChange(Sender: TObject);
begin
  if eNumber.Text <> '' then
    NumberChange := trim(eNumber.Text)
  else
    NumberChange := '';
end;

procedure TFormAkt.erExit(Sender: TObject);
var
  numtest, num1: string;
  j: integer;
  y: Word;
begin
  numtest := '';
  erExitTest := true;
  if (NumberChange <> '') then
  begin
    try
      numtest := trim(NumberChange);
      delete(numtest, length(numtest) - 2, 3);
      j := StrToInt(numtest);
    except
      ShowMessage('������ ����� ������ - ��� �����!');
      eNumber.SetFocus;
      erExitTest := false;
      exit;
    end;
    if (LabelEditDate1.text <> '  .  .    ') then
    begin
      y := YearOf(StrToDate(LabelEditDate1.text));
      numtest := IntToStr(y);
      delete(numtest, 1, 2);
      numtest := '/' + numtest;
      num1 := Trim(NumberChange);
      delete(num1, 1, Length(num1) - 3);
      if (numtest <> num1) then
      begin
        ShowMessage('������ ����� ������ - ��� "/" � ��� ��������� ����� �� ����,'
          +
          ' �� ���� ������������ ����-�������!');
        erExitTest := false;
        eNumber.SetFocus;
        exit;
      end;
    end;
  end;
end;

procedure TFormAkt.btOkClick(Sender: TObject);
begin
  if (cbClient.GetData = 0) then
  begin
    Application.MessageBox('�������� ���������!', '������!', 0);
    cbClient.SetFocus;
    exit;
  end;
  if (LabelEditDate1.text = '  .  .    ') then
  begin
    Application.MessageBox('������� ���� ������������!', '������!', 0);
    LabelEditDate1.SetFocus;
    exit;
  end;
  erExit(Sender);

  if (not erExitTest) then
  begin
    eNumber.SetFocus;
    exit;
  end;
  if (sql.SelectString(EntrySec.akttek_table {'AktTek'}, 'Number', 'Number=' +
    sql.MakeStr(NumberChange) +
    ' and Ident <> ' + IntToStr(IdInv)) <> '') then
  begin
    Application.MessageBox('��� � ����� ������� ��� ��������,' +
      '������� ������ �����!', '������!', 0);
    eNumber.SetFocus;
    exit
  end
  else
    ModalResult := mrOk;
end;

end.

