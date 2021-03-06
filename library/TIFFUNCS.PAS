unit TifFuncs;
{ ���������� ��� �������� �������������� TIF-������ }
{ ��� ������������� ���� ������� ���������� ��������������,
  ��� �����-��������� �� ����� � ���������.}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls, Buttons;

const
  Soft    = 'Lanit/LanDocs.Version 1.0. TIF-File functions library'+#0;
  tmpName = 'tiff.tmp';

 { ��������� ����� ������, ������������ ��������� TIFF_x }
type
  TTiffErrors=(
    TIFF_OK,
    TIFF_PAGE_NOT_EXISTS
  );

type
  TLongIntType=record
    case byte of
    0 : (c:array[1..4]of char);
    1 : (l:LongInt);
  end;

  TIntType=record
    case byte of
    0 : (c:array[1..2]of char);
    1 : (i:Integer);
  end;

  TFields=record
    fTag    : TIntType;
    fType   : TIntType;
    fLength : TLongIntType;
    fValue  : TLongIntType;
  end;

  PEntry=^TEntry;
  TEntry=record
    case byte of
      0: ( buf : array[1..12] of char);
      1: ( fields: TFields);
  end;

var
  Win_Path : array [0..200] of Char;

procedure TIFF_MakeFile(const Dest,Source:String);
procedure TIFF_InsertFile(Dest,Source:String; Position :Integer);
procedure TIFF_ReWriteSoftware(var f: File; Entry: PEntry; delta :LongInt);
procedure TIFF_AddFile(const Dest,Source:String);
function  TIFF_PagePos(var F:File; N:Word):LongInt;
function  TIFF_DeletePage(fName:String; N:Integer):TTiffErrors;
procedure TIFF_ChangeStripOffsets(var f:File; Entry : PEntry; delta:LongInt);
function  TIFF_ImageExests(fName:String):Boolean;
procedure FileCopy(dest,sour:String);
function  TIFF_PagesName(FName:String):Word;


implementation

function TIFF_PagesName(FName:String):Word;
var
  k:Word;
  i:TIntType;
  l:TLongIntType;
  NumRead:Word;
  f:File;
begin

  AssignFile(F, FName);
  Reset(F, 1);

  l.l:=4;
  Reset(f,1);
  Seek(f,l.l);
  BlockRead(F, l.c, 4, NumRead); {����� ������ IFD Offset}

  k:=0;
  while l.l<>0 do
  begin
    inc(k);
    Seek(F,l.l);
    BlockRead(F, i.c, 2, NumRead);
    l.l:=l.l + (12*i.i +2);
    Seek(f,l.l);
    BlockRead(F, l.c, 4, NumRead);
  end;
  System.CloseFile(F);

  TIFF_PagesName:=k
end;

procedure TIFF_MakeFile(const Dest,Source:String);
{ ������������ ����/����� ���������� TIF ���� SOURCE
  � ����/����� ���������� TIF ���� DEST � ��������� ��������� ���������
  � ���������, � ������ - ���������� ������������ ���� SoftWare �� ����
  ��������� �����.
}
var
  FromF, ToF : file;
  NumRead, NumWritten : Word;
  Buf : array[1..2048] of Char;
  k : Integer; { Tmp }
  i : TIntType;
  l : TLongIntType;
  entry: TEntry;
begin

  AssignFile(ToF,Dest);
  Rewrite(ToF, 1);

  AssignFile(FromF, Source);
  Reset(FromF, 1);

  { ����������� ��������� ���� ���� }
  repeat
     BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
     BlockWrite(ToF, Buf, NumRead, NumWritten);
  until (NumRead = 0) or (NumWritten <> NumRead);

  Seek(ToF,4); { ��������� ��������� ����� ������ 4 ����� }
  { ����� 1stIFD Offset }
  BlockRead(ToF, l.c, 4 ,NumRead);
  Seek(ToF,l.l);

  { �������� ��� ��� ������� ����� }
  repeat
    { ����� 1stIFD Offset }
    BlockRead(ToF, i.c, 2 ,NumRead);
    for k:=1 to i.i do
    begin
       BlockRead(ToF, entry.buf, 12, NumRead);
       if Entry.Fields.fTag.i=$0131 then
           TIFF_ReWriteSoftware(ToF,@Entry,0)
    end;
    { ����� ���� Next IFD Offset }
    BlockRead(ToF, l.c, 4 ,NumRead);
    Seek(ToF,l.l);
  until l.l=0;

  System.CloseFile(FromF);
  System.CloseFile(ToF)

end; { procedure MakeFirstFile }

(*****************************************************************************)
procedure TIFF_AddFile(const Dest,Source:String);
{ ��������� � ����/����� ����������� TIF ����� DEST
  ����/����� ���������� TIF ���� SOURCE ���� ������ ��������� � ���������.
}
var
  FromF, ToF : file;
  NumRead, NumWritten : Word;
  Buf : array[1..2048] of Char;
  k,size : Integer; { Tmp }
  i : TIntType;
  l : TLongIntType;
  LocalByteRead,LongTmp : Longint; { ���-�� ����������� ��� ���� ��� ������� �� ������ }
  entry: TEntry;
  CurrentToFileSize : LongInt; { �������� ����� ��������� ����� }
begin
  AssignFile(ToF, Dest);
  Reset(ToF, 1);
  {������������� ����-���� ��� ������������� � ���� �� �����}
  CurrentToFileSize := FileSize(ToF);
  seek(ToF,CurrentToFileSize);

  AssignFile(FromF, Source);
  Reset(FromF, 1);
  seek(FromF, 8);

  repeat { ��������� ����-����� � ����� �����-����� }
    BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
    BlockWrite(ToF, Buf, NumRead, NumWritten);
  until (NumWritten=0)or(NumWritten<>NumRead);


 {����� ��� ����������� ����� 1�� ��������}
  LocalByteRead:=4;
  Seek(ToF,LocalByteRead);
  BlockRead(ToF, l.c, 4, NumRead);
  inc(LocalByteRead,NumRead);

  { ����� �� ������ ����������� ����� 1�� ��������}
  Seek(ToF,l.l);
  LocalByteRead:=l.l;

  { ����� �� ��������� �������� }
  repeat
    BlockRead(ToF, i.c, 2, NumRead);
    inc(LocalByteRead,i.i*12 +NumRead);
    seek(ToF, LocalByteRead);
    BlockRead(ToF, l.c, 4, NumRead);
    if l.l>0 then
    begin
      LocalByteRead:=l.l;
      Seek(ToF,LocalByteRead)
    end
  until l.l=0;

  {�� ������ ����������� ����� 1�� �������� �����-������}
  Seek(FromF,4);
  BlockRead(FromF, l.c, 4, NumRead);
  Seek(FromF,l.l);
  l.l:=l.l+CurrentToFileSize-8;

  { ��������� �� ���� NextIFD Offset ��������� �������� �����-����� }
  Seek(ToF,LocalByteRead);

  { ��������� �������� � ���� NextIFD Offset �����-����� }
  BlockWrite(ToF, l.c, NumRead, NumWritten);
  Seek(ToF,l.l);

  { �������� ��� ����-����� � ����� �����-����� }

  { ��������� ��� ���� ������� �����-������ }
  repeat
    BlockRead (FromF, i.c, 2, NumRead);
    BlockWrite(ToF, i.c, NumRead, NumWritten);

    for k:=1 to i.i do
    begin
      BlockRead(FromF, entry.buf, 12, NumRead);
      case Entry.Fields.fType.i of
        1: size := Entry.Fields.fLength.l;  {Byte}
        2: size := Entry.Fields.fLength.l;  {ASCII}
        3: size := Entry.Fields.fLength.l*2;{Short}
        4: size := Entry.Fields.fLength.l*4;{Long}
        5: size := Entry.Fields.fLength.l*8;{Ration}
      end; {case}
{*********************************************************}
      if size>4 then { More then Max size }
      begin
        case Entry.Fields.fTag.i of
         $0131 : TIFF_ReWriteSoftware   (ToF, @Entry, CurrentToFileSize - 8);
         $0111 : TIFF_ChangeStripOffsets(ToF, @entry, CurrentToFileSize - 8);
        else {� �� ���� �� ������ ����, �� ��� ��� ������������};
        end; {case}
        Entry.Fields.fValue.l := Entry.Fields.fValue.l + CurrentToFileSize - 8;
      end else { Size < Max_Size }
      begin
        if Entry.Fields.fTag.i= $0111 then
          Entry.Fields.fValue.l := Entry.Fields.fValue.l + CurrentToFileSize - 8
      end;
{*********************************************************}
      BlockWrite(ToF, entry.buf, NumRead, NumWritten);
    end; { for k:=1 to i.i do }


    BlockRead(FromF, l.c, 4, NumRead);
    if l.l>0 then  { �� ��������� �������� � �����-������ }
    begin { ���������� ��������, �������� ������� ����� �����}
      Seek(FromF,l.l);   { ������������ �� ������ ����������� ����� }
      l.l:=l.l+CurrentToFileSize-8;
      BlockWrite(ToF, l.c, NumRead, NumWritten);
      Seek(ToF,l.l) { ������������ �� ������ ����������� ����� }
    end
  until l.l=0; { ���� �� ��������� �������� �����-������ }

  System.CloseFile(FromF);
  System.CloseFile(ToF);

end; { procedure AddFile }

procedure TIFF_ReWriteSoftware(var f: File; Entry: PEntry; delta :LongInt);
var
  tmpPos : LongInt;
  i : Integer;
  buf : array [0..200] of char;
  l : Longint;
begin
  l:=Length(Soft)+2;
  if Entry^.Fields.fLength.l<l then
     l:=Entry^.Fields.fLength.l;
  strlCopy(Buf,PChar(soft),l);

  tmpPos:=FilePos(f);
  seek(f,Entry^.Fields.fValue.l + delta);
  BlockWrite(F, Buf, l-1, i);
  Seek(f,tmpPos)
end;

procedure  TIFF_ChangeStripOffsets(var f:File; Entry : PEntry; delta:LongInt);
var
  tmpPos : LongInt;
  i : Word;
  Num,off : Longint;
  NumRead, NumWritten : Word;
  l : TLongIntType;
begin
  tmpPos:=FilePos(f);

  Num:=Entry^.Fields.fLength.l;
  off:=Entry^.Fields.fValue.l + delta;
  Seek(f,off);

  for i:=1 to Num do
  begin
    BlockRead(F, l.c, 4, NumRead);
    l.l:=l.l+delta;
    seek(f,off);
    BlockWrite(F, l.c, NumRead, NumWritten);
    inc(off,NumWritten)
  end;
  Seek(f,tmpPos)
end;


procedure TIFF_InsertFile(Dest,Source:String; Position :Integer);
{ ��������� � ����/����� ���������� TIF ���� DEST
  ����/����� ���������� TIF ���� SOURCE ���� ������ ��������� � ���������.
  ������ ������� ����� �������� Position=0.
}
var
  From1F, From2F, ToF : file;
  NumRead, NumWritten : Word;
  Buf : array[1..2048] of Char;
  k : Integer; { Tmp }
  i : TIntType;
  l : TLongIntType;
  From1FilePos:LongInt;
  size : LongInt; { ��� ��������� ����� ����� Entry }
  CurrentToFileSize : LongInt; { �������� ����� ��������� ����� }
  LongTmp : LongInt;  { tmp }
  LocalByteRead : Longint; { ���-�� ����������� ��� ���� ��� ������� �� ������ }
  entry: TEntry;
begin
  {������������� ����-���� ��� ������ � ���� ���� ������:
                               Sourse � Dest}
  AssignFile(ToF, StrPas(Win_Path) +'\'+ tmpName);
  Reset(ToF, 1);

  AssignFile(From1F, Dest);
  Reset(From1F, 1);
  AssignFile(From2F, Source);
  Reset(From2F, 1);
  { ����������� ��������� �� ����� Dest}
  LocalByteRead:=8;
  BlockRead(From1F, buf, LocalByteRead, NumRead);
  BlockWrite(ToF, buf, NumRead, NumWritten);
  {��������� ��������� ����� Source}
  Seek(From2F,LocalByteRead);

  { ����������� �� ����� Dest �������� �� k = Position }
  for k:=0 to Position-1 do
  begin
    inc(k);
    BlockRead(From1F, i.c, 2, NumRead);
    inc(LocalByteRead, i.i*12);
    Reset(From1F,1);
    Seek(From1F, LocalByteRead); { � LocalByteRead �������� ��������}
    BlockRead(ToF, l.c, 4, NumRead); { ���� Next IFD Offset }
    From1FilePos:=l.l; { �������� ������ ��������� �������� � DEST }
    if l.l=0 then
       break;
    LocalByteRead:=l.l;
    Reset(From1F,1);
    Seek(From1F,LocalByteRead);
  end; {while (k<Position) and (l.l<>0)}

  CurrentToFileSize:=LocalByteRead;
  {CurrentToFileSize ��������� ������� ������� ����� TMP }

  { ����������� ��������� �� ����� Source }
  { 1) ����� ���-�� ����������� �����
    2) ����������� ��� ���� � ����� �� ���� Next IFD Offest
    3) ������� �������� ����� ���� �� �����: new = old + LocalByteRead
  }
  repeat { ��������� ��� ���� ��������� ����� Source }
    LocalByteRead:=0;
    BlockRead(From2F, i.c, 2, NumRead);
    BlockWrite(ToF, i.c, NumRead, NumWritten);
    inc(LocalByteRead, NumRead);

    { �����������, ������� ���� - ������ }
    for k:=1 to i.i do
    begin
      BlockRead(From2F, entry.buf, 12, NumRead);
      case Entry.Fields.fType.i of
        1: size := Entry.Fields.fLength.l;  {Byte}
        2: size := Entry.Fields.fLength.l;  {ASCII}
        3: size := Entry.Fields.fLength.l*2;{Short}
        4: size := Entry.Fields.fLength.l*4;{Long}
        5: size := Entry.Fields.fLength.l*8;{Ration}
      end; {case}
      if size>4 then {Out of max size}
      begin
        if Entry.Fields.fTag.i= $0131 then
          TIFF_ReWriteSoftware(From2F, @Entry, CurrentToFileSize - 8);
        Entry.Fields.fValue.l := Entry.Fields.fValue.l + CurrentToFileSize - 8;
      end else { Size < Max_Size}
      begin
        if Entry.Fields.fTag.i= $0111 then
          Entry.Fields.fValue.l := Entry.Fields.fValue.l + CurrentToFileSize - 8;
      end;
      BlockWrite(ToF, entry.buf, NumRead, NumWritten);
      inc(LocalByteRead,NumRead);
    end; { for k:=1 to i.i do }

    { ��������� ������������ ����� � ������ ����������� }
    BlockRead(From2F, l.c, 4, NumRead);
    if l.l>0 then  { �� ��������� �������� � �����-������ }
      l.l:=l.l+CurrentToFileSize-8; { ���������� ��������, �������� ������� ����� �����}
    BlockWrite(ToF, l.c, NumRead, NumWritten); {��������� ������������ �������� � ����-����}
    inc(LocalByteRead,NumRead);
    { l.l ��������� �� ������ ��������� ��������: Number of Entries �����-����� }

    if l.l<>0 then
      repeat { ��������� ������� ������������ ������ � ����������� �� ������ ���� �������� }
        BlockRead(From2F, Buf, SizeOf(Buf), NumRead);
        { ���� �������� ������ ��������� �������� }
        if CurrentToFileSize - 8 + LocalByteRead + NumRead > l.l then
        begin
          NumRead := l.l - (LocalByteRead + CurrentToFileSize );
          reset(From2F,1);
          Seek(From2F,LocalByteRead+NumRead+8)
        end;
        BlockWrite(ToF, Buf, NumRead, NumWritten);
                inc(LocalByteRead,NumRead);
      until (NumWritten=0)or(NumWritten<>NumRead)
            or(CurrentToFileSize + LocalByteRead = l.l)
    else { if l.l<>0 then }
      repeat { ��������� ������� ������������ ������ � ����������� �� ����� ����� }
        BlockRead(From2F, Buf, SizeOf(Buf), NumRead);
        BlockWrite(ToF, Buf, NumRead, NumWritten);
      until (NumWritten=0)or(NumWritten<>NumRead);
  until l.l=0;

{  CurrentToFileSize:=Filepos();
  { LocalByteRead ��������� ������� ������� ����� Dest }
  {CurrentToFileSize ��������� ������� ������� ����� TMP }

  { ����������� ��������� �� ����� Source }
  { 1) ����� ���-�� ����������� �����
    2) ����������� ��� ���� � ����� �� ���� Next IFD Offest
    3) ������� �������� ����� ���� �� �����: new = old + LocalByteRead
  }
  repeat { ��������� ��� ���� ��������� ����� Source }
    LocalByteRead:=0;
    BlockRead(From2F, i.c, 2, NumRead);
    BlockWrite(ToF, i.c, NumRead, NumWritten);
    inc(LocalByteRead, NumRead);

    { �����������, ������� ���� - ������ }
    for k:=1 to i.i do
    begin
      BlockRead(From2F, entry.buf, 12, NumRead);
      case Entry.Fields.fType.i of
        1: size := Entry.Fields.fLength.l;  {Byte}
        2: size := Entry.Fields.fLength.l;  {ASCII}
        3: size := Entry.Fields.fLength.l*2;{Short}
        4: size := Entry.Fields.fLength.l*4;{Long}
        5: size := Entry.Fields.fLength.l*8;{Ration}
      end; {case}
      if size>4 then {Out of max size}
      begin
        if Entry.Fields.fTag.i= $0131 then
          TIFF_ReWriteSoftware(From2F,@Entry,CurrentToFileSize - 8);
        Entry.Fields.fValue.l := Entry.Fields.fValue.l + CurrentToFileSize - 8;
      end else { Size < Max_Size}
      begin
        if Entry.Fields.fTag.i= $0111 then
          Entry.Fields.fValue.l := Entry.Fields.fValue.l + CurrentToFileSize - 8;
      end;
      BlockWrite(ToF, entry.buf, NumRead, NumWritten);
      inc(LocalByteRead,NumRead);
    end; { for k:=1 to i.i do }

    { ��������� ������������ ����� � ������ ����������� }
    BlockRead(From2F, l.c, 4, NumRead);
    if l.l>0 then  { �� ��������� �������� � �����-������ }
      l.l:=l.l+CurrentToFileSize-8; { ���������� ��������, �������� ������� ����� �����}
    BlockWrite(ToF, l.c, NumRead, NumWritten); {��������� ������������ �������� � ����-����}
    inc(LocalByteRead,NumRead);
    { l.l ��������� �� ������ ��������� ��������: Number of Entries �����-����� }

    if l.l<>0 then
      repeat { ��������� ������� ������������ ������ � ����������� �� ������ ���� �������� }
        BlockRead(From2F, Buf, SizeOf(Buf), NumRead);
        { ���� �������� ������ ��������� �������� }
        if CurrentToFileSize - 8 + LocalByteRead + NumRead > l.l then
        begin
          NumRead := l.l - (LocalByteRead + CurrentToFileSize );
          reset(From2F,1);
          Seek(From2F,LocalByteRead+NumRead+8)
        end;
        BlockWrite(ToF, Buf, NumRead, NumWritten);
                inc(LocalByteRead,NumRead);
      until (NumWritten=0)or(NumWritten<>NumRead)
            or(CurrentToFileSize + LocalByteRead = l.l)
    else { if l.l<>0 then }
      repeat { ��������� ������� ������������ ������ � ����������� �� ����� ����� }
        BlockRead(From2F, Buf, SizeOf(Buf), NumRead);
        BlockWrite(ToF, Buf, NumRead, NumWritten);
      until (NumWritten=0)or(NumWritten<>NumRead);
  until l.l=0;


  System.CloseFile(From1F);
  System.CloseFile(From2F);
  System.CloseFile(ToF);
  deleteFile(Source);
  deleteFile(Dest);
  RenameFile(tmpName,Dest);
end; { procedure InsertFile }

function TIFF_PagePos(var F:File; N:Word):LongInt;
var
  k:Word;
  i:TIntType;
  l:TLongIntType;
  NumRead:Word;
begin
  l.l:=4;
  Reset(f,1);
  Seek(f,l.l);
  BlockRead(F, l.c, 4, NumRead); {����� ������ IFD Offset}

  for k:=0 to N-1 do
  begin
    Seek(f,l.l);
    BlockRead(F, i.c, 2, NumRead);
    l.l:=l.l + (12*i.i +2);
    Seek(f,l.l);
    BlockRead(F, l.c, 4, NumRead);
    if l.l=0 then break
  end;

  TIFF_PagePos:=l.l
end;

function TIFF_DeletePage(fName:String; N:Integer):TTiffErrors;
{���������� 0 ���� ���������, <0 - ���� ������}
var
  F,Ftmp : File;
  r : TTiffErrors;
  l : TLongIntType;
  i : TIntType;
  LongTmp : LongInt;
  NumRead,NumWritten:Integer;
  tmpFileName:String;
  Buf:array[0..1000] of char;
begin
  r:=TIFF_OK;
  AssignFile(F, fName);
  if TIFF_PagePos(f,N)=0 then {��������� N �� ���������� }
    r:=TIFF_PAGE_NOT_EXISTS
  else
  begin
    if TIFF_PagePos(f,N+1)>0 then {��������� N - �����������}
    begin
    end
    else{��������� N - ���������}
    begin
      if N>0 then
        l.l:=TIFF_PagePos(f,N-1);
        Reset(f,1);
        Seek(f,l.l);
        BlockRead(F, i.c, 2, NumRead);
        l.l:=l.l + (12*i.i +2);
        Reset(f,1);
        Seek(f,l.l);
        BlockRead(F, l.c, 4, NumRead);
        LongTmp := l.l;
        l.l := 0;
        BlockWrite(F, l.c, 4, NumWritten);
        Reset(f,1);
        Seek(f,longTmp);
        tmpFileName:=StrPas(Win_Path) +'\'+ tmpName;
        AssignFile(Ftmp, tmpFileName);
        Reset(FTmp,1);
        repeat{ ��������� ������� ������������ ������ � ����������� �� ����� ����� }
          BlockRead(Ftmp, Buf, SizeOf(Buf), NumRead);
          BlockWrite(Ftmp, Buf, NumRead, NumWritten);
        until (NumWritten=0)or(NumWritten<>NumRead);
        System.CloseFile(Ftmp);
    end;
  end;
  System.CloseFile(F);

  DeleteFile(fName);
  RenameFile(tmpFileName,fName)
end;

function TIFF_ImageExests(fName:String):Boolean;
var
  F : File;
  n,j : Word;
  l : TLongIntType;
  i : TIntType;
  entry: TEntry;
begin
  AssignFile(F, fName);
  Reset(f,1);

  Seek(f,4);
  BlockRead(F, l.c, 4, n);
  Seek(f,l.l);
  BlockRead(F, i.c, 2, n);
  for j:=1 to i.i do
  begin
    BlockRead(F, entry.buf, 12, n);
    if Entry.Fields.fTag.i = $100 then
    begin
      if Entry.Fields.fValue.l <= 2 then
          i.i:=0;
      break
    end
  end;
  System.CloseFile(F);
  TIFF_ImageExests:= (i.i<>0)
end;

procedure FileCopy(dest,sour:String);
var
  FromF, ToF: file;
  NumRead, NumWritten: Word;
  Buf: array[1..2048] of Char;
begin
  AssignFile(FromF, sour);
  Reset(FromF, 1);
  AssignFile(ToF, dest);
  Rewrite(ToF, 1);
  repeat
    BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
    BlockWrite(ToF, Buf, NumRead, NumWritten);
  until (NumRead = 0) or (NumWritten <> NumRead);
  System.CloseFile(FromF);
  System.CloseFile(ToF)
end;

begin
  GetWindowsDirectory(Win_Path, sizeof(Win_Path))
end.
