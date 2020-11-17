unit untThread;

interface

uses
  Classes, SysUtils;

type
  ThrUpdate = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
    procedure UpdateCaption;
  end;

var
  Counter : integer;

implementation

uses untUpdate;

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,
      Synchronize(UpdateCaption);
  and UpdateCaption could look like,
}
procedure ThrUpdate.UpdateCaption;
begin
  frmUpdate.ProgressBar1.Position := Counter;
end;

{ Update }

procedure ThrUpdate.Execute;
begin
// FreeOnTerminate := true;
 Counter := 0;
 while not Terminated do
 begin
   Synchronize(UpdateCaption);
   sleep(1000);
   Inc(Counter);
   if Counter > frmUpdate.ProgressBar1.Max then
   begin
     Break;
   end;
 end;
  { Place thread code here }
end;

end.
 