unit cmpExWebBrowser;

interface

uses
  Windows, SysUtils, Classes, Controls, OleCtrls, SHDocVw, ActiveX, Forms, URLMon;

type
  TDocHostUIInfo = packed record
    cbSize : ULONG;
    dwFlags : DWORD;
    dwDoubleClick : DWORD;
    pchHostCss : polestr;
    pchHostNS : polestr;
  end;
  pDocHostUIInfo = ^TDocHostUIInfo;

  IDocHostUIHandler = interface(IUnknown)
    ['{bd3f23c0-d43e-11cf-893b-00aa00bdce1a}']
    function ShowContextMenu(const dwID: DWORD; const ppt: PPOINT; const pcmdtReserved: IUnknown; const pdispReserved: IDispatch):HRESULT; stdcall;
    function GetHostInfo(var pInfo: TDOCHOSTUIINFO): HRESULT; stdcall;
    function ShowUI(const dwID: DWORD; const pActiveObject: IOleInPlaceActiveObject; const pCommandTarget: IOleCommandTarget; const pFrame: IOleInPlaceFrame;const pDoc: IOleInPlaceUIWindow): HRESULT; stdcall;
    function HideUI: HRESULT; stdcall;
    function UpdateUI: HRESULT; stdcall;
    function EnableModeless(const fEnable: BOOL): HRESULT; stdcall;
    function OnDocWindowActivate(const fActivate: BOOL): HRESULT; stdcall;
    function OnFrameWindowActivate(const fActivate: BOOL): HRESULT; stdcall;
    function ResizeBorder(const prcBorder: PRECT; const pUIWindow: IOleInPlaceUIWindow; const fRameWindow: BOOL): HRESULT; stdcall;
    function TranslateAccelerator(const lpMsg: PMSG; const pguidCmdGroup:PGUID; const nCmdID: DWORD): HRESULT; stdcall;
    function GetOptionKeyPath(var pchKey: POLESTR; const dw: DWORD):HRESULT; stdcall;
    function GetDropTarget(const pDropTarget: IDropTarget; out ppDropTarget: IDropTarget): HRESULT; stdcall;
    function GetExternal(out ppDispatch: IDispatch): HRESULT; stdcall;
    function TranslateUrl(const dwTranslate: DWORD; const pchURLIn: POLESTR; var ppchURLOut: POLESTR): HRESULT; stdcall;
    function FilterDataObject(const pDO: IDataObject; out ppDORet: IDataObject): HRESULT; stdcall;
  end;

  ICustomDoc = interface (IUnknown)
  ['{3050f3f0-98b5-11cf-bb82-00aa00bdce0b}']
    function SetUIHandler (const pUIHandler : IDocHostUIHandler) : HRESULT; stdcall;
  end;

  TExWebBrowser = class;

  TUIProperties = class (TPersistent)
  private
    fOwner : TExWebBrowser;

    fEnableContextMenu: boolean;
    fEnableScrollBars: boolean;
    fFlatScrollBars: boolean;
    fHas3DBorder: boolean;
    fOpenLinksInNewWindow: boolean;
    fEnableScripting: boolean;
    fShowImages: boolean;
    fShowActiveX: boolean;
    fEnableDownloadActiveX: boolean;
    fEnableJava: boolean;
  public
    constructor Create (AOwner : TExWebBrowser);
  published
    property EnableContextMenu : boolean read fEnableContextMenu write fEnableContextMenu;
    property EnableScrollBars : boolean read fEnableScrollBars write fEnableScrollBars;
    property FlatScrollBars : boolean read fFlatScrollBars write fFlatScrollBars;
    property Has3DBorder : boolean read fHas3DBorder write fHas3DBorder;
    property OpenLinksInNewWindow : boolean read fOpenLinksInNewWindow write fOpenLinksInNewWindow;

    property EnableScripting : boolean read fEnableScripting write fEnableScripting;
    property EnableJava : boolean read fEnableJava write fEnableJava;
    property EnableDownloadActiveX : boolean read fEnableDownloadActiveX write fEnableDownloadActiveX;

    property ShowImages : boolean read fShowImages write fShowImages default True;
    property ShowActiveX : boolean read fShowActiveX write fShowActiveX default True;
  end;

  TExWebBrowser = class(TWebBrowser, IDocHostUIHandler, IDispatch)
  private
    fUIProperties : TUIProperties;
    fURL : string;
    fInternetSession : IInternetSession;

    { IDispatch }
    function IDispatch.Invoke = Invoke;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;

    { IDocHostUIHandler }
    function ShowContextMenu(const dwID: DWORD; const ppt: PPOINT; const pcmdtReserved: IUnknown; const pdispReserved: IDispatch):HRESULT; stdcall;
    function GetHostInfo(var pInfo: TDOCHOSTUIINFO): HRESULT; stdcall;
    function ShowUI(const dwID: DWORD; const pActiveObject: IOleInPlaceActiveObject; const pCommandTarget: IOleCommandTarget; const pFrame: IOleInPlaceFrame;const pDoc: IOleInPlaceUIWindow): HRESULT; stdcall;
    function HideUI: HRESULT; stdcall;
    function UpdateUI: HRESULT; stdcall;
    function EnableModeless(const fEnable: BOOL): HRESULT; stdcall;
    function OnDocWindowActivate(const fActivate: BOOL): HRESULT; stdcall;
    function OnFrameWindowActivate(const fActivate: BOOL): HRESULT; stdcall;
    function ResizeBorder(const prcBorder: PRECT; const pUIWindow: IOleInPlaceUIWindow; const fRameWindow: BOOL): HRESULT; stdcall;
    function TranslateAccelerator(const lpMsg: PMSG; const pguidCmdGroup:PGUID; const nCmdID: DWORD): HRESULT; stdcall;
    function GetOptionKeyPath(var pchKey: POLESTR; const dw: DWORD):HRESULT; stdcall;
    function GetDropTarget(const pDropTarget: IDropTarget; out ppDropTarget: IDropTarget): HRESULT; stdcall;
    function GetExternal(out ppDispatch: IDispatch): HRESULT; stdcall;
    function TranslateUrl(const dwTranslate: DWORD; const pchURLIn: POLESTR; var ppchURLOut: POLESTR): HRESULT; stdcall;
    function FilterDataObject(const pDO: IDataObject; out ppDORet: IDataObject): HRESULT; stdcall;
    function GetURL: string;
    procedure SetURL(const Value: string);
  protected
    procedure Loaded; override;
  public
    constructor Create (AOwner : TComponent); override;
    destructor Destroy; override;

    procedure LoadFromString (const st : string);
    procedure LoadFromStream (s : TStream; takeOwnership : boolean = false);
  published
    property UIProperties : TUIProperties read fUIProperties write fUIProperties;
    property URL : string read GetURL write SetURL;
  end;

implementation

uses ComObj;

const
  DOCHOSTUIFLAG_DIALOG = $00000001;
  DOCHOSTUIFLAG_DISABLE_HELP_MENU = $00000002;
  DOCHOSTUIFLAG_NO3DBORDER = $00000004;
  DOCHOSTUIFLAG_SCROLL_NO = $00000008;
  DOCHOSTUIFLAG_DISABLE_SCRIPT_INACTIVE = $00000010;
  DOCHOSTUIFLAG_OPENNEWWIN = $00000020;
  DOCHOSTUIFLAG_DISABLE_OFFSCREEN = $00000040;
  DOCHOSTUIFLAG_FLAT_SCROLLBAR = $00000080;
  DOCHOSTUIFLAG_DIV_BLOCKDEFAULT = $00000100;
  DOCHOSTUIFLAG_ACTIVATE_CLIENTHIT_ONLY = $00000200;
  DOCHOSTUIFLAG_OVERRIDEBEHAVIOURFACTORY = $00000400;
  DOCHOSTUIFLAG_CODEPAGELINKEDFONTS = $00000800;
  DOCHOSTUIFLAG_URL_ENCODING_DISABLE_UTF8 = $00001000;
  DOCHOSTUIFLAG_URL_ENCODING_ENABLE_UTF8 = $00002000;
  DOCHOSTUIFLAG_ENABLE_FORMS_AUTOCOMPLETE = $00004000;

{ TExWebBrowser }

constructor TExWebBrowser.Create(AOwner: TComponent);
///var
//  Factory : IClassFactory;
begin
  inherited Create (AOwner);
  fUIProperties := TUIProperties.Create (self);
  OleCheck (CoInternetGetSession (0, fInternetSession, 0));

  if fInternetSession <> Nil then
  begin
//    CoGetClassObject(Class_CIDMimeFilter, CLSCTX_SERVER, nil, IClassFactory, Factory);
//    OleCheck (fInternetSession.RegisterMimeFilter(Factory, Class_CIDMimeFilter, 'cid'));
//    OleCheck (fInternetSession.RegisterNameSpace(Factory, CLASS_CIDMIMEFilter, 'cid', 0, nil, 0))
  end
end;

destructor TExWebBrowser.Destroy;
begin
  fUIProperties.Free;

  inherited;
end;

(*----------------------------------------------------------------------*
 | TExWebBrowser.EnableModeless                                         |
 |                                                                      |
 | IE calls this to tell us that our dialogs should be modeless.        |
 *----------------------------------------------------------------------*)
function TExWebBrowser.EnableModeless(const fEnable: BOOL): HRESULT;
begin
  result := S_OK;
end;

(*----------------------------------------------------------------------*
 | TExWebBrowser.FilterDataObject                                       |
 |                                                                      |
 | IE calls this before putting data objects on the clipboard.  It      |
 | allows us to replace them or set them to nil.                        |
 |                                                                      |
 | The function returns S_FALSE meaning we didn't replace the object    |
 *----------------------------------------------------------------------*)
function TExWebBrowser.FilterDataObject(const pDO: IDataObject;
  out ppDORet: IDataObject): HRESULT;
begin
  ppDORet := Nil;
  result := S_FALSE;
end;

(*----------------------------------------------------------------------*
 | TExWebBrowser.GetDropTarget                                          |
 |                                                                      |
 | The IE control calls this when it's used as a drop target so we can  |
 | provide a different ppDropTarget if we want.  We don't.              |
 |                                                                      |
 | Parameters:                                                          |
 |   const pDropTarget: IDropTarget; out ppDropTarget: IDropTarget
 |                                                                      |
 | The function returns HRESULT
 *----------------------------------------------------------------------*)
function TExWebBrowser.GetDropTarget(const pDropTarget: IDropTarget;
  out ppDropTarget: IDropTarget): HRESULT;
begin
  ppDropTarget := Nil;
  result := E_NOTIMPL
end;

(*----------------------------------------------------------------------*
 | TExWebBrowser.GetExternal                                            |
 |                                                                      |
 | IE calls this to determine our IDispatch interface.  We don't have   |
 | one...                                                               |
 *----------------------------------------------------------------------*)
function TExWebBrowser.GetExternal(out ppDispatch: IDispatch): HRESULT;
begin
  ppDispatch := Application;
  result := S_OK
end;

function TExWebBrowser.GetHostInfo(var pInfo: TDOCHOSTUIINFO): HRESULT;
begin
  FillChar (pInfo, SizeOf (pInfo), 0);

  pInfo.cbSize := sizeof (TDOCHOSTUIINFO);
  pInfo.cbSize := SizeOf(pInfo);
  pInfo.dwFlags := 0;

  if not UIProperties.EnableScrollBars then
    pInfo.dwFlags := pInfo.dwFlags or DOCHOSTUIFLAG_SCROLL_NO;

  if UIProperties.FlatScrollBars then
    pInfo.dwFlags := pInfo.dwFlags or DOCHOSTUIFLAG_FLAT_SCROLLBAR;

  if not UIProperties.Has3DBorder then
    pInfo.dwFlags := pInfo.dwFlags or DOCHOSTUIFLAG_NO3DBORDER;

  if UIProperties.OpenLinksInNewWindow then
    pInfo.dwFlags := pInfo.dwFlags or DOCHOSTUIFLAG_OPENNEWWIN;

  if not UIProperties.EnableScripting then
    pInfo.dwFlags := pInfo.dwFlags or DOCHOSTUIFLAG_DISABLE_SCRIPT_INACTIVE;

  result := S_OK;
end;

function TExWebBrowser.GetOptionKeyPath(var pchKey: POLESTR;
  const dw: DWORD): HRESULT;
begin
  result := S_FALSE;
end;

function TExWebBrowser.GetURL: string;
begin
  if (csDesigning in ComponentState) then
    result := fURL
  else
    result := self.LocationURL
end;

function TExWebBrowser.HideUI: HRESULT;
begin
  result := S_OK;
end;

function TExWebBrowser.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
  ArgErr: Pointer): HResult;

  const
  DISPID_AMBIENT_DLCONTROL  = -5512;
  DLCTL_DLIMAGES            = $00000010;
  DLCTL_NO_SCRIPTS          = $00000080;
  DLCTL_NO_JAVA             = $00000100;
  DLCTL_NO_RUNACTIVEXCTLS   = $00000200;
  DLCTL_NO_DLACTIVEXCTLS    = $00000400;
  DLCTL_DOWNLOADONLY        = $00000800;

var
  ort : HRESULT;
  dlc : Integer;
begin
  result := inherited Invoke (DispID, IID, LocaleID, Flags, Params, VarResult, ExcepInfo, ArgErr);
  if (Flags and DISPATCH_PROPERTYGET <> 0) and (VarResult <> nil) then
  begin
    ort := result;
    result := S_OK;
    case DispID of
(*
      DISPID_AMBIENT_USERMODE:
        PVariant(VarResult)^ := True; // not (csDesigning in ComponentState);
*)

      DISPID_AMBIENT_DLCONTROL:
        begin
          if UIProperties.ShowImages then
            dlc := DLCTL_DLIMAGES
          else
            dlc := 0;

          if not UIProperties.EnableJava then
            dlc := dlc or DLCTL_NO_JAVA;

          if not UIProperties.EnableScripting then
            dlc := dlc or DLCTL_NO_SCRIPTS;

          if not UIProperties.EnableDownloadActiveX then
            dlc := dlc or DLCTL_NO_DLACTIVEXCTLS;

          if not UIPRoperties.ShowActiveX then
            dlc := dlc or DLCTL_NO_RUNACTIVEXCTLS;

          PVariant(VarResult)^ := dlc
        end;
      else
        result := ort
    end
  end
end;

procedure TExWebBrowser.Loaded;
begin
  inherited;

  if not (csDesigning in ComponentState) then
    if fURL = '' then
      Navigate ('about:blank')
    else
      Navigate (fURL);
end;

procedure TExWebBrowser.LoadFromStream(s: TStream; takeOwnership: boolean);
var
  ownership : TStreamOwnership;
  persistStreamInit : IPersistStreamInit;
  adapter : TStreamAdapter;

begin
  if Document = Nil then
    Navigate ('about:blank');
  if Supports (Document, IPersistStreamInit, persistStreamInit) then
  begin
    if takeOwnership then
      ownership := soOwned
    else
      ownership := soReference;
    adapter := TStreamAdapter.Create(s, ownership);
    OleCheck (persistStreamInit.InitNew);
    OleCheck (persistStreamInit.Load(adapter))
  end
end;

procedure TExWebBrowser.LoadFromString(const st: string);
begin
  LoadFromStream (TStringStream.Create(st), True);
end;

function TExWebBrowser.OnDocWindowActivate(const fActivate: BOOL): HRESULT;
begin
  result := S_OK;
end;

function TExWebBrowser.OnFrameWindowActivate(
  const fActivate: BOOL): HRESULT;
begin
  result := S_OK;
end;

function TExWebBrowser.ResizeBorder(const prcBorder: PRECT;
  const pUIWindow: IOleInPlaceUIWindow; const fRameWindow: BOOL): HRESULT;
begin
  result := S_OK;
end;

procedure TExWebBrowser.SetURL(const Value: string);
begin
  fURL := Value;

  if (csLoading in ComponentState) or (csDesigning in ComponentState) then
    Exit;

  if Value = '' then
    Navigate ('about:blank')
  else
    Navigate (value);
end;

function TExWebBrowser.ShowContextMenu(const dwID: DWORD;
  const ppt: PPOINT; const pcmdtReserved: IInterface;
  const pdispReserved: IDispatch): HRESULT;
begin
  if UIProperties.EnableContextMenu then
    result := S_FALSE
  else
  begin
    result := S_OK;
    if Assigned (PopupMenu) then
      PopupMenu.Popup(ppt.X, ppt.Y)
  end;
end;

function TExWebBrowser.ShowUI(const dwID: DWORD;
  const pActiveObject: IOleInPlaceActiveObject;
  const pCommandTarget: IOleCommandTarget; const pFrame: IOleInPlaceFrame;
  const pDoc: IOleInPlaceUIWindow): HRESULT;
begin
  result := S_FALSE;  // IE will display the UI
end;

function TExWebBrowser.TranslateAccelerator(const lpMsg: PMSG;
  const pguidCmdGroup: PGUID; const nCmdID: DWORD): HRESULT;
begin
  result := S_FALSE;
end;

function TExWebBrowser.TranslateUrl(const dwTranslate: DWORD;
  const pchURLIn: POLESTR; var ppchURLOut: POLESTR): HRESULT;
begin
  result := S_FALSE;   // URL was not translated
end;

function TExWebBrowser.UpdateUI: HRESULT;
begin
  result := S_FALSE;
end;

{ TUIProperties }

constructor TUIProperties.Create(AOwner: TExWebBrowser);
begin
  fOwner := AOwner;
  fShowImages := True;
  fShowActiveX := True;
end;

end.
