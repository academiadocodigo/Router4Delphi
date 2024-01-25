<p align="center">
  <a href="https://github.com/academiadocodigo/Router4Delphi/blob/master/assets/logo.fw.png">
    <img alt="router4d" src="https://github.com/academiadocodigo/Router4Delphi/blob/master/assets/logo.fw.png">
  </a>  
</p>
<br>
<p align="center">
  <img src="https://img.shields.io/github/v/release/bittencourtthulio/Router4Delphi?style=flat-square">
  <img src="https://img.shields.io/github/stars/bittencourtthulio/Router4Delphi?style=flat-square">
  <img src="https://img.shields.io/github/contributors/bittencourtthulio/Router4Delphi?color=orange&style=flat-square">
  <img src="https://img.shields.io/github/forks/bittencourtthulio/Router4Delphi?style=flat-square">
   <img src="https://tokei.rs/b1/github/bittencourtthulio/Router4Delphi?color=red&category=lines">
  <img src="https://tokei.rs/b1/github/bittencourtthulio/Router4Delphi?color=green&category=code">
  <img src="https://tokei.rs/b1/github/bittencourtthulio/Router4Delphi?color=yellow&category=files">
</p>

# Router4Delphi
Framework for Creating Screen Routes for FMX and VCL

Router4Delphi aims to facilitate the calling of screens and embed Layouts in FMX applications, and Panels in VCL applications, reducing the coupling of screens and providing more dynamism and practicality in the construction of rich Delphi interfaces.

## Instalation

Simply register the path to the library's SRC folder in the Library Path of your Delphi, or if you prefer, you can use [**Boss**](https://github.com/HashLoad/boss) (dependency manager for Delphi) To perform the installation:
```
boss install https://github.com/academiadocodigo/Router4Delphi
```

## First Steps - Tutorial

To use Router4Delphi to create your routes, you must use Router4D.

#### Observation

Inside the src folder contains Router4D.inc, this file has the compilation directive for Firemonkey, with this directive commented out the Framework will have VCL support, and when uncommenting it you will have FMX support.

## Creating a Screen for Routing

For the Route system to work you must create a new FMX or VCL form and Implement the iRouter4DComponent Interface, it belongs to the Router4D.Interfaces unit so it must be included in your Units.

All route-based screen construction uses TLayouts and TPanels to embed the screen calls, so your new screen must have a TLayout or a main TPanel and all other components must be included within this layout or panel.

The iRouter4DComponent Interface Implementation requires the declaration of two methods (Render and UnRender), Render is called whenever a route activates the screen, and UnRender whenever it leaves the display.

Below is the code for a simple screen implementing the iRouter4DComponent interface and ready to be used.

#### FMX Sample

Create a New Form in your Application, include an AlClient aligned Layout in it and implement the methods as below.

```delphi

unit PrimeiraTela;

interface

uses
  System.SysUtils, 
  System.Types, 
  System.UITypes, 
  System.Classes, 
  System.Variants,
  FMX.Types, 
  FMX.Controls, 
  FMX.Forms, 
  FMX.Graphics, 
  FMX.Dialogs,
  Router4D.Interfaces;

type
  TFirstScreen = class(TForm, iRouter4DComponent)
    Layout1: TLayout;
  private
    { Private declarations }
  public
    { Public declarations }
    function Render : TFMXObject;
    procedure UnRender;
  end;

var
  FirstScreen: TFirstScreen;

implementation

{$R *.fmx}

{ TForm3 }

function TFirstScreen.Render: TFMXObject;
begin
  Result := Layout1;
end;

procedure TFirstScreen.UnRender;
begin

end;

end.
```

Note that in the Render method we define Layout1 as Result, this is necessary because this layout will be embedded whenever the route is activated.

## Registering the Route to the Screen

Now that we have a screen ready to be registered, let's move on to the process that will make our screen ready to be activated at any time.

To register a route it is necessary to declare Uses Router4D, it provides access to all library methods and in many cases it will be the only coupling necessary in your Views.

Once declared, simply activate the method below to declare the form we created previously as a route.

In the Main form of your Application, within the onCreate method, execute the method below to register the Route for the Form TFirstScreen

```delphi

procedure TMainForm.FormCreate(Sender: TObject);
begin 
    TRouter4D.Switch.Router('Inicio', TFirstScreen);
end;
```

We now have a Route created, so our forms no longer need to know the uses of our screen, just activate our route system and ask for the creation of the "Start" route and it will be displayed in the application's LayoutMain.

You can create a separate Unit just to Register the Routes or call a method in the onCreate of your main form for this.

## Defining the Main Render

We already have a screen and a route to use, now we just need to define where this route will render the layout, that is, what will be our Object that will receive the embedded screens.

To do this, in the formPrincipal of your application, declare uses Router4D and in its onCreate make the following call.

Remembering that in the previous step we had already used the onCreate formPrincipal to Register the Route.

```delphi

procedure TMainForm.FormCreate(Sender: TObject);
begin  
    TRouter4D.Switch.Router('Inicio', TFirstScreen);

    TRouter4D.Render<TFirstScreen>.SetElement(Layout1, Layout1);
end;

```

The Render method is responsible for defining the Application's LayoutsMain and Index in the library.

The Render receives the name of the Class from our home screen as a generic, it will be rendered when the application opens within the Layout that was informed as the first parameter of the SetElement

The first parameter of the SetElement is defining in which Layout the library will render a new screen whenever a Route Link is called.

The second parameter of the SetElement is defining the Index layout of the application, so when an IndexLink is called it will be rendered in that layout, later I will explain about the IndexLink.

Okay, now when you open your application you will already have the TPrimeiraTela Form Layout being rendered within Layout1 of your application's Main form.

## Creating a Second Screen

So that we can actually see the component in action and all its benefits, create a new screen similar to the one we did at the beginning, adding an alClient Layout to it and implementing the Render and UnRender methods.

Place a Label inside the Layout, for example, written on the second screen, just to make sure everything worked correctly.

```delphi

unit SecondScreen;

interface

uses
  System.SysUtils, 
  System.Types, 
  System.UITypes, 
  System.Classes, 
  System.Variants,
  FMX.Types, 
  FMX.Controls, 
  FMX.Forms, 
  FMX.Graphics, 
  FMX.Dialogs,
  Router4D.Interfaces;

type
  TSecondScreen = class(TForm, iRouter4DComponent)
    Layout1: TLayout;
  private
    { Private declarations }
  public
    { Public declarations }
    function Render : TFMXObject;
    procedure UnRender;
  end;

var
  SecondScreen: TSecondScreen;

implementation

{$R *.fmx}

{ TSecondScreen }

function TSecondScreen.Render: TFMXObject;
begin
  Result := Layout1;
end;

procedure TSecondScreen.UnRender;
begin

end;

end.
```
## Registering the Second Screen on the Route

Now that we have created a new screen we need to register it in the Routes system, so let's go back to onCreate and make this registration, let's call this screen Screen2.

```delphi

procedure TMainForm.FormCreate(Sender: TObject);
begin  
    TRouter4D.Switch.Router('Inicio', TFirstScreen);

    TRouter4D.Switch.Router('Tela2', TSecondScreen);

    TRouter4D.Render<TFirstScreen>.SetElement(Layout1, Layout1);
end;

```


## Activating the new screen through the Route using the Link

Now that the magic comes, go back to the TFirstScreen and place a button there and we will use the Router4D Links system to call the TSegundaScreen without having to use it.

Just call the method below in the Button Click Event.

```delphi
procedure TFirstScreen.Button1Click(Sender: TObject);
begin
  TRouter4D.Link.&To('Tela2');
end;
```

Note that TFirstScreen does not know TSecondScren because its uses were only given in the formPrincipal where it is necessary for Route Registration.

If you want to make this more organized, I even suggest that you create a separate Unit just to register the Routes with a class procedure and call this method in the MainForm's onCreate.

This way we put an end to a lot of cross-references and coupling between screens.


## Resources - Render

```delphi
TRouter4D.Render<T>.SetElement(MainContainer, IndexContainer);
```

Render is the first action to be done to work with Router4D, as in it you will configure the main and index containers.

MainContainer = The container where the forms will be embedded

IndexContainer = The main container of the application (useful when you have more than one type of layout in the application)

## SWITCH

```delphi
TRouter4D.Switch.Router(aPath : String; aRouter : TPersistentClass);
```
On the Switch you register your routes, passing the name of the route and the object that is opened when this route is activated.

```delphi
TRouter4D.Switch.Router(aPath : String; aRouter : TPersistentClass; aSidebarKey : String = 'SBIndex'; isVisible : Boolean = True);
```

In Swith there are some additional parameters that already have default values

aSidebarKey: This parameter allows you to separate routes by category for creating dynamic menus with the SideBar class, I will explain more about it below.

isVisible: Allows you to hide the route when dynamically generating menus with SideBar.

## LINK

```delphi

TRouter4D.Link.&To ( aPatch : String; aComponent : TFMXObject );

TRouter4D.Link.&To ( aPatch : String);
    
TRouter4D.Link.&To ( aPatch : String; aProps : TProps; aKey : String = '');
    
```

Links are the actions to trigger the routes you registered on the Switch

There are 3 ways to call the links:

```delphi
TRouter4D.Link.&To ( aPatch : String);
```
Passing only the Route Path, this way the form associated with the route will be embedded within the MainContainer that you defined in Render

```delphi
TRouter4D.Link.&To ( aPatch : String; aComponent : TFMXObject );
```

Passing the Path and the Component, it will embed the form registered in the path within the component that you are passing in the parameter.

```delphi
TRouter4D.Link.&To ( aPatch : String; aProps : TProps; aKey : String = '');
```

You can trigger a route by passing Props, which are values that your form will receive at the time of Render, I will explain below how this works in detail, but this is useful for example when you want to send an ID to a screen to perform a query in the database and be loaded with the data.

## PROPS

```delphi
TRouter4D.Link.&To ( aPatch : String; aProps : TProps; aKey : String = '');
```

The Router4D Library incorporates the Delphi Event Bus to perform Pub and Sub actions, so you can register your forms to receive events when calling links.

To receive a Props you need to add uses Router4D.Props to your form and implement the following method with the [Subscribe] attribute

```delphi
[Subscribe]
procedure Props ( aValue : TProps);
```

and implement it

```delphi
procedure TPageCadastros.Props(aValue: TProps);
begin
    if aValue.Key = 'telacadastro' then
        Label1.Text := aValue.PropString;
  aValue.Free;
end;
```
This way, your form is prepared, for example, to receive a string passed in the link call.

To call a link by passing a Props you use the following code:

```delphi
TRouter4D.Link.&To('Cadastros', TProps.Create.PropString('Olá').Key('telacadastro'));
```
Passing the TProps object with a PropString and a Key to the Link so that the receiving screen can be sure that that prop was sent to it.

## SideBar

With registered routes you can create an automatic menu of registered routes dynamically, simply register a new route and it will be available in all your menus.

```delphi
TRouter4D
    .SideBar
      .MainContainer(Layout5)
      .LinkContainer(Layout4)
      .FontSize(15)
      .FontColor(4294967295)
      .ItemHeigth(60)
    .RenderToListBox;
```

In the example above we are generating a menu in listbox format within Layout5 and all links clicked on this menu will be rendered in Layout4, if you do not pass the LinkContainer it will be rendered in the MainContainer informed in the Router4D Render.

You can also create menus based on categorized routes, just enter the category in which the route belongs when registering the route.

```delphi
TRouter4D.Switch.Router('Clientes', TPagePrincipal, 'cadastros');
  TRouter4D.Switch.Router('Fornecedores', TSubCadastros, 'cadastros');
  TRouter4D.Switch.Router('Produtos', TSubCadastros, 'cadastros');
```

This way we created 3 routes in the registration category. To generate a menu with just these links, simply inform this when building the SideBar.

```delphi
TRouter4D
    .SideBar
      .Name('cadastros')
      .MainContainer(Layout5)
      .LinkContainer(Layout4)
      .FontSize(15)
      .FontColor(4294967295)
      .ItemHeigth(60)
    .RenderToListBox;
```
## Documentação
[English (en)](https://github.com/academiadocodigo/Router4Delphi/blob/master/README-en.md)<br>
[Português (ptBR)](https://github.com/academiadocodigo/Router4Delphi/blob/master/README.md)<br>
