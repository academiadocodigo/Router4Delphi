unit Router4D.Interfaces;

interface

uses
  System.Classes,
  System.Generics.Collections,
  System.UITypes,
  SysUtils,
  FMX.Types,
  Router4D.Props;

type

  iRouter4D = interface
    ['{56BF88E9-25AB-49C7-8CB2-F89C95F34816}']
  end;

  iRouter4DComponent = interface
    ['{C605AEFB-36DC-4952-A3D9-BA372B998BC3}']
    function Render : TFMXObject;
    procedure UnRender;
  end;

  iRouter4DComponentProps = interface
    ['{FAF5DD55-924F-4A8B-A436-208891FFE30A}']
    procedure Props ( aProps : TProps );
  end;

  iRouter4DLink = interface
    ['{3C80F86A-D6B8-470C-A30E-A82E620F6F1D}']
    function &To ( aPatch : String; aComponent : TFMXObject ) : iRouter4DLink; overload;
    function &To ( aPatch : String) : iRouter4DLink; overload;
    function &To ( aPatch : String; aProps : TProps; aKey : String = '') : iRouter4DLink; overload;
    function &To ( aPatch : String; aNameContainer : String) : iRouter4DLink; overload;
    function Animation ( aAnimation : TProc<TFMXObject> ) : iRouter4DLink;
    function IndexLink ( aPatch : String ) : iRouter4DLink;
  end;

  iRouter4DRender = interface
    ['{2BD026ED-3A92-44E9-8CD4-38E80CB2F000}']
    function SetElement ( aComponent : TFMXObject; aIndexComponent : TFMXObject = nil ) : iRouter4DRender;
  end;

  iRouter4DSwitch = interface
    ['{0E49AFE7-9329-4F0C-B289-A713FA3DFE45}']
    function Router(aPath : String; aRouter : TPersistentClass; aSidebarKey : String = 'SBIndex'; isVisible : Boolean = True) : iRouter4DSwitch;
    function UnRouter(aPath : String) : iRouter4DSwitch;
  end;

  iRouter4DSidebar = interface
    ['{B4E8C229-A801-4FCA-AF7B-DEF8D0EE5DFE}']
    function Name ( aValue : String ) : iRouter4DSidebar; overload;
    function MainContainer ( aValue : TFMXObject ) : iRouter4DSidebar; overload;
    function Name  : String; overload;
    function MainContainer  : TFMXObject; overload;
    function FontSize ( aValue : Integer ) : iRouter4DSidebar;
    function FontColor ( aValue : TAlphaColor ) : iRouter4DSidebar;
    function ItemHeigth ( aValue : Integer ) : iRouter4DSidebar;
    function LinkContainer ( aValue : TFMXObject ) : iRouter4DSidebar;
    function RenderToListBox : iRouter4DSidebar;
    function Animation ( aAnimation : TProc<TFMXObject> ) : iRouter4DSidebar;
  end;

implementation

end.
