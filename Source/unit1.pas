unit Unit1;

//{$mode objfpc}{$H+}
{$mode delphi}{$H+}
interface

uses

  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls, Windows, CustApp, LCLIntf;

type
  TFNWndEnumProc = function(hwnd: HWND; lParam: LPARAM): BOOL; stdcall;
  function EnumWindows(lpEnumFunc: TFNWndEnumProc; lParam: LPARAM): BOOL;stdcall; external user32;
type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ListBox1: TListBox;
    Panel1: TPanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Label3Click(Sender: TObject);
  private

  public
    //function EnumWindowsProc(WHandle: HWND; lb: TListBox): LongBool;StdCall;

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

//function EnumWindows(lpEnumFunc: TFNWndEnumProc; lParam: LPARAM): BOOL;stdcall; external  user32;
function EnumWindowsProc(WHandle: HWND; lb: TListBox): BOOL;StdCall;
var Title,ClassName:array[0..128] of char;
    sTitle,sClass,Linia:STRING ;
    wRect:TRect;
begin
 Result:=True;
 GetWindowText(wHandle, Title,128);
 GetClassName(wHandle, ClassName, 128);
 if Title<>'' then begin // avoid returned programs without titles
   if IsWindowVisible(wHandle) then begin
     // restore minimised windows so we can get their position, as minimised windows are pos -32000,-32000
     if (isIconic(wHandle)=true) then begin
       ShowWindow(wHandle,SW_RESTORE);
     end;
     GetWindowRect(wHandle,wRect); // get the window rect
     //lb.items.add(wRect.Left.ToString);
     // if the window is off the primary monitor left right top or bottom....
     if ((wRect.Left+(wRect.Width/2))<0) or (wRect.Left > (screen.Width-64)) or (wRect.Top<-8) or (wRect.Top > screen.Height-64) then begin
      // move the window to 0,0 and dont resize, ignoring cx, cy
      SetWindowPos(wHandle,HWND_TOPMOST,screen.width-wRect.Width, lb.items.Count*64 ,0,0,SWP_NOSIZE);
      lb.Items.Add(string(ClassName) + '-' + string(Title));
      result:=true;
    end; // eo if window off screen
   end; // eo is window visible
 end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  ListBox1.Items.Clear;
  EnumWindows(@EnumWindowsProc, LPARAM(ListBox1));
end;

procedure TForm1.Label3Click(Sender: TObject);
begin
  OpenDocument(TLabel(Sender).Caption);
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
 ListBox1.Items.Clear;
 EnumWindows(@EnumWindowsProc, LPARAM(ListBox1));
end;

end.

