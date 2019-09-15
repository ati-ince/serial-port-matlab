function varargout = FTDI_cirrus(varargin)
%ati' nin malidir.......
% Last Modified by GUIDE v2.5 07-Oct-2013 07:23:45
%%
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FTDI_cirrus_OpeningFcn, ...
                   'gui_OutputFcn',  @FTDI_cirrus_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1}) 
    gui_State.gui_Callback = str2func(varargin{1});
end
%
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
%%
% --- Executes just before FTDI_cirrus is made visible.
function FTDI_cirrus_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FTDI_cirrus (see VARARGIN)

%% Burada ilk acilirken yapilacaklari koyalim
% asm = NET.addAssembly('System.Threading');
% import System.Threading.*;
MS_NET_SerialPortClass=System.IO.Ports.SerialPort;
NET_GetPortName= System.IO.Ports.SerialPort.GetPortNames;%Burada t�m COM portlar�n�n ismini ald�k(MS .NET yardimi ile)
%�uraya bir uyari koyalim
 asm = NET.addAssembly('System.Windows.Forms');
 import System.Windows.Forms.*;
 MessageBox.Show('UYARI!!! Programin hata vermesi durumunda: USB kablosunu cikartip tekrar takin, programi yeniden baslatin...                                                                                          NOT: Program sadece FTDI chip barindiran USB birimleri ile calismaktadir...')
 %% Burada com portlarini .NET yardimi ile bulup yazdiriyoruz
%% Ayrica ftdi portlarinin uzunlugu ile ac-kapa yaparak hangi COM portuna ait oldugunu girecegiz
%handles.FTDI_Assembly= NET.addAssembly('D:\xbee_test_yazilimlarim\FTD2XX_NET.dll');
handles.FTDI_Assembly= NET.addAssembly([pwd '\FTD2XX_NET.dll']);%bu pwd bulundugu konumu vermekte.
%burada lib yuklemenin dogrudan yolunu bulmak lazim
handles.PortOBJ=FTD2XX_NET.FTDI;%FTDI nesnesini ekleyelim
handles.FT_OK=FTD2XX_NET.FT_STATUS.FT_OK;%Burada da dogru-yanlis islem karsilastirmasi yapacagiz
handles.FT_OTHER_ERROR=FTD2XX_NET.FT_STATUS.FT_OTHER_ERROR;
%
GetNumberOfDevices_count=uint32(0);%Buras� uint32 buffer de�eri, i�eri�inin ne oldu�u �nemli de�il kendisi de�i�tiriryor zaten
[status_GetNumberOfDevices,GetNumberOfDevices_count]=handles.PortOBJ.GetNumberOfDevices(GetNumberOfDevices_count);%Burada kac tane FTDI cihaz bagli onu gormekteyiz
handles.GetNumberOfDevices_count=GetNumberOfDevices_count; %burada OOP icin handles turune donusturmek zorundayim (her birsey  icin bunu yapmal�y�m aslimnda)
if ((status_GetNumberOfDevices==handles.FT_OK)&&(handles.GetNumberOfDevices_count~=0))
     for i=1:handles.GetNumberOfDevices_count%Tabi bu nesne-obj her ne ise icerisinde gerek duymuyorum handles demeye
              if(handles.PortOBJ.IsOpen~=1)
              handles.PortOBJ.OpenByIndex(i-1);
              [status_GetCOMPort,name_GetCOMPort]=handles.PortOBJ.GetCOMPort;
              a=name_GetCOMPort;
              handles.port_names{i}=a.char;%cell metodu ile her bir h�cereye string ifadesini yazdiriyoruz(istenildiginde kullanalim yeniden)
              handles.PortOBJ.Close;%kapamayi unutmayalim
              end
    end

set(handles.popupmenu1,'String',handles.port_names);   % Writes in a popupmenu the s_port elements
%% Baudrate listesi (sergilenecek olan)
handles.BaudRateList=[9600;600;1200;2400;4800;9600;19200;38400;57600;115200;230400;460800;921600];%istersek dusuk data rate cikartilabilir
set(handles.popupmenu2,'String',handles.BaudRateList); %Orjinalde 9600'e ayarl� ilk durum icin
%% Data bits  listesi (sergilenecek olan)
handles.DataBitsList=[8;7;6;5];
set(handles.popupmenu3,'String',handles.DataBitsList); %Orjinalde 9600'e ayarl� ilk durum icin
%% disconnect butonu da off olsun
set(handles.pushbutton3,'Enable','off');      % Actives the 'Disconnect' button
%% Ba�lang�cta secili olacaklari isaretleyelim
set(handles.radiobutton15,'Value',1);set(handles.radiobutton15,'Enable','off');
set(handles.radiobutton9,'Value',1);set(handles.radiobutton9,'Enable','off');
set(handles.radiobutton12,'Value',1);set(handles.radiobutton12,'Enable','off');
set(handles.radiobutton14,'Value',1);set(handles.radiobutton14,'Enable','off');
set(handles.radiobutton18,'Value',1);set(handles.radiobutton18,'Enable','off');
%% if ko�ulunun sonu 
 else
      MessageBox.Show('UYARI!!! FTDI herhangi bir USB cihaz bulunamadi, kontrol edip programi tekrardan baslatiniz...')
 end
 
% Choose default command line output for FTDI_cirrus
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes FTDI_cirrus wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%%
% --- Outputs from this function are returned to the command line.

% --- Executes during object creation, after setting all properties.
function pushbutton2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
function varargout = FTDI_cirrus_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
%
function popupmenu1_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

function popupmenu1_CreateFcn(hObject, eventdata, handles)
% Hint: popupmenu controls usually have a white background on Windows.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%
function popupmenu2_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2

function popupmenu2_CreateFcn(hObject, eventdata, handles)
% Hint: popupmenu controls usually have a white background on Windows.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%
function popupmenu3_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3

function popupmenu3_CreateFcn(hObject, eventdata, handles)
% Hint: popupmenu controls usually have a white background on Windows.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%
%% RADIO
function radiobutton9_Callback(hObject, eventdata, handles)
set(handles.radiobutton10,'Value',0);
set(handles.radiobutton9,'Enable','off');
set(handles.radiobutton10,'Enable','on');
% Hint: get(hObject,'Value') returns toggle state of radiobutton9

function radiobutton10_Callback(hObject, eventdata, handles)
set(handles.radiobutton9,'Value',0);
set(handles.radiobutton10,'Enable','off');
set(handles.radiobutton9,'Enable','on');
% Hint: get(hObject,'Value') returns toggle state of radiobutton10

function radiobutton11_Callback(hObject, eventdata, handles)
set(handles.radiobutton12,'Value',0);
set(handles.radiobutton11,'Enable','off');
set(handles.radiobutton12,'Enable','on');
% Hint: get(hObject,'Value') returns toggle state of radiobutton11

function radiobutton12_Callback(hObject, eventdata, handles)
set(handles.radiobutton11,'Value',0);
set(handles.radiobutton12,'Enable','off');
set(handles.radiobutton11,'Enable','on');
% Hint: get(hObject,'Value') returns toggle state of radiobutton12

function radiobutton13_Callback(hObject, eventdata, handles)
set(handles.radiobutton14,'Value',0);
set(handles.radiobutton13,'Enable','off');
set(handles.radiobutton14,'Enable','on');
% Hint: get(hObject,'Value') returns toggle state of radiobutton13

function radiobutton14_Callback(hObject, eventdata, handles)
set(handles.radiobutton13,'Value',0);
set(handles.radiobutton14,'Enable','off');
set(handles.radiobutton13,'Enable','on');
% Hint: get(hObject,'Value') returns toggle state of radiobutton14

function radiobutton15_Callback(hObject, eventdata, handles)
set(handles.radiobutton17,'Value',0);
set(handles.radiobutton15,'Enable','off');
set(handles.radiobutton17,'Enable','on');
% Hint: get(hObject,'Value') returns toggle state of radiobutton15

function radiobutton17_Callback(hObject, eventdata, handles)
set(handles.radiobutton15,'Value',0);
set(handles.radiobutton17,'Enable','off');
set(handles.radiobutton15,'Enable','on');
% Hint: get(hObject,'Value') returns toggle state of radiobutton17

function radiobutton18_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of radiobutton18

%% Connect button
function pushbutton2_Callback(hObject, eventdata, handles)
set(handles.pushbutton2,'Enable','off');     % Disables the 'Connect' button
set(handles.pushbutton3,'Enable','on');      % Actives the 'Disconnect' button


%renk icin
h4 = hObject(1); % Get the caller's handle.
set(h4,'backg',[0 1 0]); % Change color of button.
set(handles.pushbutton3,'backg',[1 1 1]);
%
set(h4,'UserData',1) % Degerini degistirmek
set(handles.pushbutton3,'UserData',0) % Degerini degistirmek
%% Buras� Serial Porta ba�lanmak i�in kullan�lacak
COMPortNumber=double(get(handles.popupmenu1 ,'Value')); %Buradan pop-up bardaki kacinci eleman , matristeki onu ogrendik(unutma MATLAB da matris 1. elemandan baslamakta)
BaudRateNumber=get(handles.popupmenu2,'Value'); %Buradan pop-up bardaki kacinci eleman , matristeki onu ogrendik     
% usette tanimlamistik dizileri = handles.BaudRateList[9600......] ve handles.DataBitsList=[8;7;6;5];
DataBitsNumber=double(get(handles.popupmenu3 ,'Value')); %Buradan pop-up bardaki kacinci eleman , matristeki onu ogrendik     
%devaminda alinan ayarlamalar yapilarak port baslatilacak
if(handles.PortOBJ.IsOpen~=1)
    [status_OpenByIndex]=handles.PortOBJ.OpenByIndex(COMPortNumber-1)%1 den basladigi icin matris ici -1 yapiyorum
    [status_GetCOMPort,name_GetCOMPort]=handles.PortOBJ.GetCOMPort%exede gorunecek bu
    handles.name_GetCOMPort =name_GetCOMPort;
    %ayarlarini Set et
    [status_SetBaudRate]=handles.PortOBJ.SetBaudRate(handles.BaudRateList(BaudRateNumber))%matristen istedigimiz degeri cektik
    disp('Baudrate='); disp(handles.BaudRateList(BaudRateNumber));   
    DataBits=uint8(handles.DataBitsList(DataBitsNumber))  
    if (1 == double(get(handles.radiobutton15,'Value')))
         StopBits=uint8(1);%burasinda 1 yaziyor
              elseif (1 == double(get(handles.radiobutton17,'Value')))
                      StopBits=uint8(2);%burasinda 2 yaziyor
    end%biraz aptalca yontem ama yapcak birsey yok......
    disp('Stop Bits=');disp(StopBits);%Burada da yazdiralim stop bitini    
    Parity=uint8(0);%parity=0 NONE oluyor galiba  
    disp('Parity= None');
    [status_SetDataCharacteristics]=handles.PortOBJ.SetDataCharacteristics(DataBits,StopBits,Parity)%Burada tum aranan ayarlar yapilmis oldu galiba
   %
    if (1 == double(get(handles.radiobutton11,'Value')))%DTR on olan kisim, logic deger giris yapilabiliyor
    [status_SetDTR]=handles.PortOBJ.SetDTR(true)%disaridan gor
      disp('true');
   else
       [status_SetDTR]=handles.PortOBJ.SetDTR(false)%disaridan gor
         disp('false');
   end
   %
   if (1 == double(get(handles.radiobutton13,'Value')))%RTS  on olan kisim, sadece logic
    [status_SetRTS]=handles.PortOBJ.SetRTS(true)%disaridan gor
    disp('true');
     else
     [status_SetRTS]=handles.PortOBJ.SetRTS(false)%disaridan gor
      disp('false');
   end
      %% Giden gelen datalar PORT open (connect) durumunda iken buradan kontrol edelim....
      %donguye girmeden gecmisi kayit et
      %%
     guidata(hObject,handles);
     %
     % gelen data icin dongu ici giris degerleri
             
      %%
else
  disp('Programi kapatip yeniden acin, port baslatilamadi!.....');
end%NOT!!! kapatmayi unutma
%kayit et(Update handles structure)
guidata(hObject,handles);
%
%% Disconnect button
function pushbutton3_Callback(hObject, eventdata, handles)
set(handles.pushbutton3,'Enable','off');     % Disables the 'Connect' button
set(handles.pushbutton2,'Enable','on');      % Actives the 'Disconnect' button
%renk icin
%
%
h4 = hObject(1); % Get the caller's handle.
set(h4,'backg',[1 0 0]) % Change color of button.
set(handles.pushbutton2,'backg',[1 1 1])
% Degerini de degistirelim
set(h4,'UserData',1) % Degerini degistirmek
set(handles.pushbutton2,'UserData',0) % Degerini degistirmek
%kayit et
guidata(hObject,handles);
 pause(0.01);%100ms bekle
%% Buras� Serial Porttan ayr�lmak i�in kullan�lacak
 disp('name_GetCOMPort =')
 disp(handles.name_GetCOMPort.char)
[status_PortOBJClose]=handles.PortOBJ.Close%kapattik geri
%kayit et
guidata(hObject,handles);
%
