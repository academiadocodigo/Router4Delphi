<p align="center">
  <a href="https://github.com/bittencourtthulio/Router4Delphi/blob/master/assets/logo.fw.png">
    <img alt="router4d" src="https://github.com/bittencourtthulio/Router4Delphi/blob/master/assets/logo.fw.png">
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
Framework para Criação de Rotas de Telas para FMX e VCL

O Router4Delphi tem o objetivo de facilitar a chamada de telas e embed de Layouts em aplicações FMX, e Panels em aplicações VCL, reduzindo o acoplamento das telas de dando mais dinâmismo e práticidade na construção de interfaces ricas em Delphi

## Instalação

Basta registrar no Library Path do seu Delphi o caminho da pasta SRC da biblioteca, ou se preferir, pode utilizar o [**Boss**](https://github.com/HashLoad/boss) (gerenciador de dependências para Delphi) para realizar a instalação:
```
boss install https://github.com/bittencourtthulio/Router4Delphi
```

## Primeiros Passos - Tutorial

Para utilizar o Router4Delphi para criar suas rotas, você deve realizar a uses do Router4D.

#### Observação

Dentro da pasta src contém o Router4D.inc, esse arquivo possui a diretiva de compilação para o Firemonkey, com essa diretiva comentada o Framework terá suporte a VCL, e ao descomentar você terá suporte ao FMX.

## Criação de uma Tela para Roteamento

Para que o sistema  de Rotas funcione você deve criar um novo formulário FMX ou VCL e Implementar a Interface iRouter4DComponent ela pertence a unit Router4D.Interfaces portanto a mesma deve ser incluida nas suas Units.

Toda a construção das telas baseadas em rotas utilizar TLayouts e TPanels para embedar as chamadas das telas, dessa forma é preciso que sua nova tela tenha um TLayout ou um TPanel principal e todos os demais componentes devem ser incluídos dentro desse layout ou panel.

A Implementação da Interface iRouter4DComponent requer a declaração de dois métodos ( Render e UnRender ), o Render é chamado sempre que uma rota aciona a tela, e o UnRender sempre que ela saí de exibição.

Abaixo o Código de uma tela simples implementando a interface iRouter4DComponent e pronta para ser utilizada.

#### Exemplo em FMX

Crie um Novo Formulario na sua Aplicação, inclua nele um Layout alinhado AlClient e implemente os métodos como abaixo.

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
  TPrimeiraTela = class(TForm, iRouter4DComponent)
    Layout1: TLayout;
  private
    { Private declarations }
  public
    { Public declarations }
    function Render : TFMXObject;
    procedure UnRender;
  end;

var
  PrimeiraTela: TPrimeiraTela;

implementation

{$R *.fmx}

{ TForm3 }

function TPrimeiraTela.Render: TFMXObject;
begin
  Result := Layout1;
end;

procedure TPrimeiraTela.UnRender;
begin

end;

end.
```

Perceba que no método Render nós definimos como Result o Layout1, isso é necessário pois esse layout será embedado sempre que a rota for acionada.

## Registrando a Rota para a Tela

Agora que já temos uma tela pronta para ser registrada vamos ao processo que deixará a nossa tela pronta para ser acionada a qualquer momento.

Para registrar uma rota é necessário declarar a Uses Router4D ela fornece acesso a todos os métodos da biblioteca e em muito dos casos será o único acoplamento necessário nas suas Views.

Uma vez declarada basta acionar o método abaixo para declarar o form que criamos anteriormente como uma rota.

No formPrincipal da sua Aplicação, dentro do método onCreate execute o método abaixo para registrar a Rota para o Form TPrimeiraTela

```delphi

procedure TformPrincipal.FormCreate(Sender: TObject);
begin 
    TRouter4D.Switch.Router('Inicio', TPrimeiraTela);
end;
```

Pronto já temos uma Rota criada, dessa forma os nossos forms não precisam mais conhecer a uses da nossa tela, basta acionar nosso sistema de rotas e pedir a criação da rota "Inicio" que a mesma será exibida no LayoutMain da aplicação.

Você pode criar uma Unit Separada somente para Registrar as Rotas ou então chamar um metodo no onCreate do seu formulario principal para isso.

## Definindo o Render Principal

Já temos uma tela e uma rota para utilizarmos, agora precisamos definir apenas onde está rota renderizará o layout, ou seja, qual será o nosso Objeto que vai receber as telas embedadas.

Para isso no formPrincipal da sua aplicação, declare a uses Router4D e no onCreate do mesmo faça a seguinte chamada.

Lembrando que no passo anterios nós já tinhamos usado o onCreate do formPrincipal para Registrar a Rota.

```delphi

procedure TformPrincipal.FormCreate(Sender: TObject);
begin  
    TRouter4D.Switch.Router('Inicio', TPrimeiraTela);

    TRouter4D.Render<TPrimeiraTela>.SetElement(Layout1, Layout1);
end;

```

O método Render é responsável por definir na biblioteca quais serão os LayoutsMain e Index da Aplicação.

O Render recebe como genéric o nome da Classe da nossa tela inicial, ela será renderizada quando a aplicação abrir dentro do Layout que foi informado como primeiro parametro do SetElement

O primeiro parametro do SetElement está definindo em qual Layout a biblioteca irá renderizar uma nova tela sempre que um Link da rota for chamado.

O Segundo parametro do SetElement está definindo qual é o layout Index da aplicação, assim quando um IndexLink for chamado ele será renderizado nesse layout, mais para frente explicarei sobre o IndexLink.

Pronto, agora ao abrir a sua aplicação você já terá o Layout do Formulario TPrimeiraTela sendo renderizado dentro do Layout1 do formPrincipal da sua aplicação.

## Criando uma Segunda Tela

Para que possamos ver o componente em ação de fato e todos os seus benefícios, crie uma nova tela semelhante a que fizemos no inicio, adicionando um Layout alClient nela e implementando os métodos Render e UnRender.

Coloque dentro do Layout um Label por exemplo, escrito segunda tela apenas para termos a certeza que tudo funcionou corretamente.

```delphi

unit SegundaTela;

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
  TSegundaTela = class(TForm, iRouter4DComponent)
    Layout1: TLayout;
  private
    { Private declarations }
  public
    { Public declarations }
    function Render : TFMXObject;
    procedure UnRender;
  end;

var
  SegundaTela: TSegundaTela;

implementation

{$R *.fmx}

{ TSegundaTela }

function TSegundaTela.Render: TFMXObject;
begin
  Result := Layout1;
end;

procedure TSegundaTela.UnRender;
begin

end;

end.
```
## Registrando a Segunda tela na Rota

Agora que criamos uma nova tela precisamos registrar ela no sistema de Rotas, então vamos voltar ao onCreate e fazer esse registros, vamos chamar essa tela de Tela2.

```delphi

procedure TformPrincipal.FormCreate(Sender: TObject);
begin  
    TRouter4D.Switch.Router('Inicio', TPrimeiraTela);

    TRouter4D.Switch.Router('Tela2', TSegundaTela);

    TRouter4D.Render<TPrimeiraTela>.SetElement(Layout1, Layout1);
end;

```


## Acionando a nova tela atráves da Rota utilizando o Link

Agora que vem a mágica, volte na TPrimeiraTela e coloque um botão lá e vamos usar o sistema de Links do Router4D para chamar a TSegundaTela sem precisar dar uses nela.

Basta chamar o método abaixo no Evento de Clique do Botão.

```delphi
procedure TPrimeiraTela.Button1Click(Sender: TObject);
begin
  TRouter4D.Link.&To('Tela2');
end;
```

Perceba que a TPrimeiraTela não conhece a TSegundaTela pois o uses da mesma foi dado apenas no formPrincipal onde é necessário para o Registro das Rotas.

Se você deseja deixar isso mais organizado, eu sugiro inclusive que você crie uma Unit separada apenas para registro das Rotas com um class procedure e faça a chamada desse método no onCreate do formPrincipal.

Dessa forma damos fim a um monte de referencias cruzadas e acoplamento entre as telas.


## RECURSOS - RENDER

```delphi
TRouter4D.Render<T>.SetElement(MainContainer, IndexContainer);
```

O Render é a primeira ação a ser feita para trabalhar com o Router4D, pois nele você irá configurar os container main e index.

MainContainer = O container onde os formularios serão embedados

IndexContainer = O container principal da aplicação (util quando você tem mais de um tipo de layout na aplicação)

## SWITCH

```delphi
TRouter4D.Switch.Router(aPath : String; aRouter : TPersistentClass);
```
No Switch você registra suas rotas, passando o nome da rota e o objeto que seja aberto quando essa rota for acionada.

```delphi
TRouter4D.Switch.Router(aPath : String; aRouter : TPersistentClass; aSidebarKey : String = 'SBIndex'; isVisible : Boolean = True);
```

No Swith existem alguns parametros a mais que já possuem valores default

aSidebarKey: Este parametro permite você separar as rotas por categoria para a criação de menus dinâmicos com a classe SideBar, vou explicar mais abaixo sobre ela.

isVisible: Permite você ocultar a rota na geração dinamica dos menus com a SideBar.

## LINK

```delphi

TRouter4D.Link.&To ( aPatch : String; aComponent : TFMXObject );

TRouter4D.Link.&To ( aPatch : String);
    
TRouter4D.Link.&To ( aPatch : String; aProps : TProps; aKey : String = '');
    
```

Os links são as ações para acionar as rotas que você registrou no Switch

Existem 3 formas de chamar os links:

```delphi
TRouter4D.Link.&To ( aPatch : String);
```
Passando apenas o Path da Rota, dessa forma o formulario associado a rota será embedado dentro do MainContainer que você definiu no Render

```delphi
TRouter4D.Link.&To ( aPatch : String; aComponent : TFMXObject );
```

Passando o Path e o Component, ele irá embedar o formulario registrado no path dentro do componente que você está passando no parametro.

```delphi
TRouter4D.Link.&To ( aPatch : String; aProps : TProps; aKey : String = '');
```

Você pode acionar uma rota passando Props, que são valores que o seu formulário irá receber no momento do Render, vou explicar mais abaixo como isso funciona em detalhes, mas isso é util por exemplo quando você deseja enviar um ID para uma tela realizar uma consulta no banco e ser carregada com os dados.

## PROPS

```delphi
TRouter4D.Link.&To ( aPatch : String; aProps : TProps; aKey : String = '');
```

A Biblioteca Router4D incopora o Delphi Event Bus para realizar ações de Pub e Sub, com isso você pode registrar seus formularios para receber eventos na chamada dos links.

Para receber uma Props você precisa adicionar a uses Router4D.Props no seu formulario e implementar o seguinte método com o atributo [Subscribe]

```delphi
[Subscribe]
procedure Props ( aValue : TProps);
```

e implementa-lo 

```delphi
procedure TPageCadastros.Props(aValue: TProps);
begin
    if aValue.Key = 'telacadastro' then
        Label1.Text := aValue.PropString;
  aValue.Free;
end;
```
Dessa forma seu formulario está preparado por exemplo para receber uma string passada na chamada do link.

Para chamar um link passando um Props você utiliza o seguinte código:

```delphi
TRouter4D.Link.&To('Cadastros', TProps.Create.PropString('Olá').Key('telacadastro'));
```
Passando no Link o objeto TProps com uma PropString e uma Chave para que a tela que vai receber tenha certeza que aquela props foi enviada para ela.

## SideBar

Com as rotas registradas você pode criar um menu automático das rotas registradas de forma dinâmica, basta registrar uma nova rota que a mesma estará disponível em todos os seus menus.

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

No exemplo acima estamos gerando um menu em formato de listbox dentro do Layout5 e todos os links clicados nesse menu serão renderizados no Layout4, se você não passar o LinkContainer o mesmo será renderizado no MainContainer informado no Render do Router4D.

Você ainda pode criar menus baseados em rotas categorizadas, basta no registro da rota você informar a categoria que a rota pertence

```delphi
TRouter4D.Switch.Router('Clientes', TPagePrincipal, 'cadastros');
  TRouter4D.Switch.Router('Fornecedores', TSubCadastros, 'cadastros');
  TRouter4D.Switch.Router('Produtos', TSubCadastros, 'cadastros');
```

Dessa forma criamos 3 rotas da categoria cadastro, para gerar um menu apenas com esses link basta informar isso na construção da SideBar.

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
