unit uBaseDShow;

interface

uses
  Winapi.Windows,
  {DirectShow 헤더와 ActiveX 헤더 추가}
  Winapi.ActiveX, Winapi.DirectShow9, DSUtils;

type
  TBaseDShow = class(TObject)
  private
  public
    FilterGraph: IGraphBuilder; // 필터그래프의 인터페이스 중의 하나.
    MediaControl: IMediaControl;
    VideoWindow: IVideoWindow;
    constructor Create;
    destructor Destroy; override;
    function CreateFilterGraph(var Graph: IGraphBuilder): Boolean;
    function CreateFilter(const clsid: TGUID; var Filter: IBaseFilter): Boolean;
    function FindPinOnFilter(const Filter: IBaseFilter; const PinDir: TPinDirection; var Pin: IPin): HRESULT;
    function GetCamFilter: IBaseFilter;
  end;

implementation

{ TBaseDShow }

constructor TBaseDShow.Create;
begin
  inherited Create;
  CoInitialize(nil); // COM을 초기화한다.
  CreateFilterGraph(FilterGraph); // 필터그래프를 생성한다.

  FilterGraph.QueryInterface(IID_IMediaControl, MediaControl);
  FilterGraph.QueryInterface(IID_IVideoWindow, VideoWindow);
end;

function TBaseDShow.CreateFilterGraph(var Graph: IGraphBuilder): Boolean;
var
  ID : Integer;
begin
  Result := False;
  if Failed(CoCreateInstance(CLSID_FilterGraph, nil, CLSCTX_INPROC_SERVER, IID_IFilterGraph, Graph)) then
    Exit;
  Result := True;
end;

function TBaseDShow.CreateFilter(const clsid: TGUID; var Filter: IBaseFilter): Boolean;
begin
  Result := False;
  if Failed(CoCreateInstance(clsid, NIL, CLSCTX_INPROC_SERVER, IID_IBaseFilter, Filter)) then
    Exit;
  Result := True;
end;

function TBaseDShow.GetCamFilter: IBaseFilter;
var
  SysEnum: TSysDevEnum;
begin
  SysEnum := TSysDevEnum.Create;
  try
    SysEnum.SelectGUIDCategory(CLSID_VideoInputDeviceCategory);
    Result := SysEnum.GetBaseFilter(0)// 가장 첫번째 장치를 가져온다.
  finally
    SysEnum.Free;
  end;
end;

function TBaseDShow.FindPinOnFilter(const Filter: IBaseFilter; const PinDir: TPinDirection; var Pin: IPin): HRESULT;
var
  IsConnected : Boolean;
  hr: DWORD;
  EnumPin: IEnumPins;
  ConnectedPin: IPin;
  PinDirection: TPinDirection;
begin
  Result := S_False;
  if not Assigned(Filter) then exit;
  hr := Filter.EnumPins(EnumPin);

  if(SUCCEEDED(hr)) then begin
    while (S_OK = EnumPin.Next(1, Pin, nil)) do begin
      //핀이 연결되었는지 조사.
      hr := Pin.ConnectedTo(ConnectedPin);
      if hr = S_OK then begin
        IsConnected := True;
        ConnectedPin := nil;
      end
      else IsConnected := False;

      //핀의 방향을 검사
      hr := Pin.QueryDirection(PinDirection);
      //매개변수의 핀방향과 동일하고 현재 연결된 상태가 아니라면 루프에서 탈출.
      if (hr = S_OK) and (PinDirection = PinDir)
      and (not IsConnected) then break;

      pin := nil;
    end;

    Result := S_OK;
  end;

  EnumPin := nil;
end;

destructor TBaseDShow.Destroy;
begin
  if Assigned(MediaControl) then MediaControl.Stop; // 비디오 랜더링을 중단한다.
  While Assigned(VideoWindow) do VideoWindow := nil;
  While Assigned(MediaControl) do MediaControl := nil;
  While Assigned(FilterGraph) do FilterGraph := nil; // 필터 그래프를 소멸시킨다.

  CoUninitialize; // COM을 셧다운시킨다.

  inherited Destroy;
end;

end.
