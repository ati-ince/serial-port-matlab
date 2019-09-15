function varargout = FTDI_cirrus_hex(varargin)
%ati' nin malidir.......
% Last Modified by GUIDE v2.5 17-Oct-2013 15:23:40
%%
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FTDI_cirrus_hex_OpeningFcn, ...
                   'gui_OutputFcn',  @FTDI_cirrus_hex_OutputFcn, ...
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
% --- Executes just before FTDI_cirrus_hex is made visible.
function FTDI_cirrus_hex_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FTDI_cirrus_hex (see VARARGIN)
handles.degisken=1;
handles.buffer=cell((handles.degisken),1);
%bir digeri
handles.degisken_HEX=1;
handles.buffer_HEX=cell((handles.degisken_HEX),2);
%Baska global sabitlerimiz 
handles.Cirrus_Page_Addr_ConstName=[0;16;17;18];
handles.Cirrus_Register_Addr_ConstName=[(0:63)];
handles.Cirrus_Instructor_ConstName=cell(12,1);
handles.Cirrus_Instructor_ConstName{1,1}='Soft. reset (Control)';handles.Cirrus_Instructor_ConstName{2,1}='Standby (Control)';handles.Cirrus_Instructor_ConstName{3,1}='Wakeup (Control)';handles.Cirrus_Instructor_ConstName{4,1}='Single conv. (Control)';handles.Cirrus_Instructor_ConstName{5,1}='Continuous Conv. (Control)';handles.Cirrus_Instructor_ConstName{6,1}='Halt Conv. (Control)';handles.Cirrus_Instructor_ConstName{7,1}='DC Offset (Calibr.)';handles.Cirrus_Instructor_ConstName{8,1}='AC Offset (Calibr.)';handles.Cirrus_Instructor_ConstName{9,1}='Gain (Calibr.)';handles.Cirrus_Instructor_ConstName{10,1}='I (Calibr.)';handles.Cirrus_Instructor_ConstName{11,1}='V (Calibr.)';handles.Cirrus_Instructor_ConstName{12,1}='I&V (Calibr.)';
%% Burada ilk acilirken yapilacaklari koyalim
% asm = NET.addAssembly('System.Threading');
% import System.Threading.*;
MS_NET_SerialPortClass=System.IO.Ports.SerialPort;
NET_GetPortName= System.IO.Ports.SerialPort.GetPortNames;%Burada tüm COM portlarýnýn ismini aldýk(MS .NET yardimi ile)
%Þuraya bir uyari koyalim
 asm = NET.addAssembly('System.Windows.Forms');
 import System.Windows.Forms.*;
 MessageBox.Show('UYARI!!! Programin hata vermesi durumunda: USB kablosunu cikartip tekrar takin, programi yeniden baslatin...NOT: Program sadece FTDI chip barindiran USB birimleri ile calismaktadir...')
 %% Burada com portlarini .NET yardimi ile bulup yazdiriyoruz
%% Ayrica ftdi portlarinin uzunlugu ile ac-kapa yaparak hangi COM portuna ait oldugunu girecegiz
handles.FTDI_Assembly= NET.addAssembly([pwd '\FTD2XX_NET.dll']);%bu pwd bulundugu konumu vermekte.
%burada lib yuklemenin dogrudan yolunu bulmak lazim
handles.PortOBJ=FTD2XX_NET.FTDI;%FTDI nesnesini ekleyelim
handles.FT_OK=FTD2XX_NET.FT_STATUS.FT_OK;%Burada da dogru-yanlis islem karsilastirmasi yapacagiz
handles.FT_OTHER_ERROR=FTD2XX_NET.FT_STATUS.FT_OTHER_ERROR;
%sonra silersin
%methodsview('FTD2XX_NET.FTDI');%Sonra istersek ekleriz.....
%
GetNumberOfDevices_count=uint32(0);%Burasý uint32 buffer deðeri, içeriðinin ne olduðu önemli deðil kendisi deðiþtiriryor zaten
[status_GetNumberOfDevices,GetNumberOfDevices_count]=handles.PortOBJ.GetNumberOfDevices(GetNumberOfDevices_count);%Burada kac tane FTDI cihaz bagli onu gormekteyiz
handles.GetNumberOfDevices_count=GetNumberOfDevices_count; %burada OOP icin handles turune donusturmek zorundayim (her birsey  icin bunu yapmalýyým aslimnda)
if ((status_GetNumberOfDevices==handles.FT_OK)&&(handles.GetNumberOfDevices_count~=0))
     for i=1:handles.GetNumberOfDevices_count%Tabi bu nesne-obj her ne ise icerisinde gerek duymuyorum handles demeye
              if(handles.PortOBJ.IsOpen~=1)
              handles.PortOBJ.OpenByIndex(i-1);
              [status_GetCOMPort,name_GetCOMPort]=handles.PortOBJ.GetCOMPort;
              a=name_GetCOMPort;
              handles.port_names{i}=a.char;%cell metodu ile her bir hücereye string ifadesini yazdiriyoruz(istenildiginde kullanalim yeniden)
              handles.PortOBJ.Close;%kapamayi unutmayalim
              end
    end

set(handles.popupmenu1,'String',handles.port_names);   % Writes in a popupmenu the s_port elements
%% Baudrate listesi (sergilenecek olan)
handles.BaudRateList=[9600;600;1200;2400;4800;9600;19200;38400;57600;115200;230400;460800;921600;1500000;3000000];%istersek dusuk data rate cikartilabilir
set(handles.popupmenu2,'String',handles.BaudRateList); %Orjinalde 9600'e ayarlý ilk durum icin
%% Data bits  listesi (sergilenecek olan)
handles.DataBitsList=[8;7;6;5];
set(handles.popupmenu3,'String',handles.DataBitsList); %Orjinalde 9600'e ayarlý ilk durum icin
%% disconnect butonu da off olsun
set(handles.pushbutton3,'Enable','off');      % Actives the 'Disconnect' button
%% ilk acilistaki secili olmasi gereken radio buttonlarim
set(handles.pushbutton1,'Enable','off');%pushbutton1(send button)kapali olsun
%
%sunlar simdilik kapali dursunlar
set(handles.radiobutton1,'Enable','off');
set(handles.radiobutton2,'Enable','off');
set(handles.radiobutton3,'Enable','off');
%
set(handles.radiobutton4,'Value',1);set(handles.radiobutton4,'Enable','off');
set(handles.radiobutton15,'Value',1);set(handles.radiobutton15,'Enable','off');
set(handles.radiobutton9,'Value',1);set(handles.radiobutton9,'Enable','off');%None handshake()
set(handles.radiobutton10,'Value',0);set(handles.radiobutton10,'Enable','off');%Xon/Xoff
set(handles.radiobutton12,'Value',1);set(handles.radiobutton12,'Enable','off');
set(handles.radiobutton14,'Value',1);set(handles.radiobutton14,'Enable','off');
set(handles.radiobutton18,'Value',1);set(handles.radiobutton18,'Enable','off');%Parity
%% Cirrrus radio butonlari vs... lerde burada (ilkin connect basilana kadar disable olsunlar)
set(handles.radiobutton19,'Value',0);set(handles.radiobutton19,'Enable','off');%Read
set(handles.radiobutton20,'Value',0);set(handles.radiobutton20,'Enable','off');%Write
set(handles.radiobutton21,'Value',0);set(handles.radiobutton21,'Enable','off');%Instruction
% Bunlar hep kapalý olacak, simdilik bunlari calistirma planim yok!
set(handles.radiobutton5,'Value',0);set(handles.radiobutton5,'Enable','off');%Read
set(handles.radiobutton6,'Value',0);set(handles.radiobutton6,'Enable','off');%Read
set(handles.radiobutton7,'Value',0);set(handles.radiobutton7,'Enable','off');%Read
set(handles.radiobutton8,'Value',1);set(handles.radiobutton8,'Enable','off');%Read simdilik HEX yapamasin artik
set(handles.radiobutton2,'Value',0);set(handles.radiobutton2,'Enable','off');%Read
set(handles.radiobutton3,'Value',0);set(handles.radiobutton3,'Enable','off');%Read
%popupmenu'ler, edit' ler
set(handles.popupmenu4,'Enable','off');%Read/page
set(handles.popupmenu5,'Enable','off');%Read/register
set(handles.popupmenu6,'Enable','off');%Write/page
set(handles.popupmenu7,'Enable','off');%Write/register
set(handles.edit2,'Enable','off');%Write/register
set(handles.popupmenu8,'Enable','off');%Instruction
set(handles.pushbutton4,'Enable','off');%CirrusButton
set(handles.text9,'Enable','off');%CirrusText
%% if koþulunun sonu 
 else
      MessageBox.Show('UYARI!!! FTDI herhangi bir USB cihaz bulunamadi, kontrol edip programi tekrardan baslatiniz...')
 end
 
% Choose default command line output for FTDI_cirrus_hex
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes FTDI_cirrus_hex wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%%
% --- Outputs from this function are returned to the command line.

% --- Executes during object creation, after setting all properties.
function pushbutton2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
function varargout = FTDI_cirrus_hex_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5


% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6


% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu7


% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%

% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu8


% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%

function radiobutton1_Callback(hObject, eventdata, handles)
set(handles.radiobutton2,'Value',0);
set(handles.radiobutton3,'Value',0);
set(handles.radiobutton4,'Value',0);
set(handles.radiobutton1,'Enable','off');
set(handles.radiobutton2,'Enable','on');
set(handles.radiobutton3,'Enable','on');
set(handles.radiobutton4,'Enable','on');
%densir
set(handles.radiobutton1,'UserData',1);
set(handles.radiobutton4,'UserData',0);
% Hint: get(hObject,'Value') returns toggle state of radiobutton1

function radiobutton2_Callback(hObject, eventdata, handles)
set(handles.radiobutton1,'Value',0);
set(handles.radiobutton3,'Value',0);
set(handles.radiobutton4,'Value',0);
set(handles.radiobutton2,'Enable','off');
set(handles.radiobutton1,'Enable','on');
set(handles.radiobutton3,'Enable','on');
set(handles.radiobutton4,'Enable','on');
% Hint: get(hObject,'Value') returns toggle state of radiobutton2

function radiobutton3_Callback(hObject, eventdata, handles)
set(handles.radiobutton1,'Value',0);
set(handles.radiobutton2,'Value',0);
set(handles.radiobutton4,'Value',0);
set(handles.radiobutton3,'Enable','off');
set(handles.radiobutton1,'Enable','on');
set(handles.radiobutton2,'Enable','on');
set(handles.radiobutton4,'Enable','on');
% Hint: get(hObject,'Value') returns toggle state of radiobutton3

function radiobutton4_Callback(hObject, eventdata, handles)
set(handles.radiobutton1,'Value',0);
set(handles.radiobutton2,'Value',0);
set(handles.radiobutton3,'Value',0);
set(handles.radiobutton4,'Enable','off');
set(handles.radiobutton1,'Enable','on');
set(handles.radiobutton2,'Enable','on');
set(handles.radiobutton3,'Enable','on');
%densir
set(handles.radiobutton1,'UserData',0);
set(handles.radiobutton4,'UserData',1);%deger denisir
% Hint: get(hObject,'Value') returns toggle state of radiobutton4

function radiobutton5_Callback(hObject, eventdata, handles)
%eger basilir ise neler olacagini yazalim
set(handles.radiobutton5,'UserData',1);
set(handles.radiobutton6,'UserData',0);
%
set(handles.radiobutton6,'Value',0);
set(handles.radiobutton7,'Value',0);
set(handles.radiobutton8,'Value',0);
set(handles.radiobutton5,'Enable','off');
set(handles.radiobutton6,'Enable','on');
set(handles.radiobutton7,'Enable','on');
set(handles.radiobutton8,'Enable','on');
% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton5

function radiobutton6_Callback(hObject, eventdata, handles)
%eger basilir ise neler olacagini yazalim
set(handles.radiobutton5,'UserData',0);
set(handles.radiobutton6,'UserData',1);
%
set(handles.radiobutton5,'Value',0);
set(handles.radiobutton7,'Value',0);
set(handles.radiobutton8,'Value',0);
set(handles.radiobutton6,'Enable','off');
set(handles.radiobutton5,'Enable','on');
set(handles.radiobutton7,'Enable','on');
set(handles.radiobutton8,'Enable','on');
% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton6

function radiobutton7_Callback(hObject, eventdata, handles)
set(handles.radiobutton5,'Value',0);
set(handles.radiobutton6,'Value',0);
set(handles.radiobutton8,'Value',0);
set(handles.radiobutton7,'Enable','off');
set(handles.radiobutton5,'Enable','on');
set(handles.radiobutton6,'Enable','on');
set(handles.radiobutton8,'Enable','on');
% Hint: get(hObject,'Value') returns toggle state of radiobutton7

function radiobutton8_Callback(hObject, eventdata, handles)
set(handles.radiobutton5,'Value',0);
set(handles.radiobutton6,'Value',0);
set(handles.radiobutton7,'Value',0);
set(handles.radiobutton8,'Enable','off');
set(handles.radiobutton5,'Enable','on');
% Hint: get(hObject,'Value') returns toggle state of radiobutton8
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

% --- Executes on button press in radiobutton19.
function radiobutton19_Callback(hObject, eventdata, handles)
h_ReadReg=hObject(1); % Get the caller's handle.
set(h_ReadReg,'Value',1);set(h_ReadReg,'UserData',1);
set(h_ReadReg,'Enable','off');
set(handles.popupmenu4,'Enable','on');set(handles.popupmenu5,'Enable','on');
set(handles.popupmenu4,'String',handles.Cirrus_Page_Addr_ConstName);   % Writes in a popupmenu the xxx elements
set(handles.popupmenu5,'String',handles.Cirrus_Register_Addr_ConstName);   % Writes in a popupmenu the xxx elements
%
set(handles.pushbutton4,'Enable','on');set(handles.text9,'Enable','on');
set(handles.edit3,'Enable','off');set(handles.edit4,'Enable','off');set(handles.edit5,'Enable','off');set(handles.edit6,'Enable','off');set(handles.edit7,'Enable','off');
%digerleri pasif
set(handles.radiobutton20,'Enable','on');set(handles.radiobutton20,'Value',0);set(handles.radiobutton20,'UserData',0);%diðerleri 0 olsun
set(handles.radiobutton21,'Enable','on');set(handles.radiobutton21,'Value',0);set(handles.radiobutton21,'UserData',0);
set(handles.popupmenu6,'Enable','off');set(handles.popupmenu7,'Enable','off');set(handles.popupmenu8,'Enable','off');set(handles.edit2,'Enable','off');%digerleri pasif olsun tamamen
%% sabit data matrislerini yazdirmak

% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton19


% --- Executes on button press in radiobutton20.
function radiobutton20_Callback(hObject, eventdata, handles)
h_WriteReg=hObject(1); % Get the caller's handle.
set(h_WriteReg,'Value',1);set(h_WriteReg,'UserData',1);
set(h_WriteReg,'Enable','off');
set(handles.popupmenu6,'Enable','on');set(handles.popupmenu7,'Enable','on');set(handles.edit2,'Enable','on');
set(handles.popupmenu6,'String',handles.Cirrus_Page_Addr_ConstName);   % Writes in a popupmenu the xxx elements
set(handles.popupmenu7,'String',handles.Cirrus_Register_Addr_ConstName);   % Writes in a popupmenu the xxx elements
%
set(handles.pushbutton4,'Enable','on');set(handles.text9,'Enable','on');
set(handles.edit3,'Enable','off');set(handles.edit4,'Enable','off');set(handles.edit5,'Enable','off');set(handles.edit6,'Enable','off');set(handles.edit7,'Enable','off');
%digerleri pasif
set(handles.radiobutton19,'Enable','on');set(handles.radiobutton19,'Value',0);set(handles.radiobutton19,'UserData',0);
set(handles.radiobutton21,'Enable','on');set(handles.radiobutton21,'Value',0);set(handles.radiobutton21,'UserData',0);
set(handles.popupmenu4,'Enable','off');set(handles.popupmenu5,'Enable','off');set(handles.popupmenu8,'Enable','off');%digerleri pasif olsun tamamen
% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton20


% --- Executes on button press in radiobutton21.
function radiobutton21_Callback(hObject, eventdata, handles)
h_Instruct=hObject(1); % Get the caller's handle.
set(h_Instruct,'Value',1);set(h_Instruct,'UserData',1);
set(h_Instruct,'Enable','off');
set(handles.popupmenu8,'Enable','on');
set(handles.popupmenu8,'String',handles.Cirrus_Instructor_ConstName);   % Writes in a popupmenu the xxx elements
%
set(handles.pushbutton4,'Enable','on');set(handles.text9,'Enable','on');
%digerleri pasif
set(handles.radiobutton19,'Enable','on');set(handles.radiobutton19,'Value',0);set(handles.radiobutton19,'UserData',0);
set(handles.radiobutton20,'Enable','on');set(handles.radiobutton20,'Value',0);set(handles.radiobutton20,'UserData',0);
set(handles.popupmenu4,'Enable','off');set(handles.popupmenu5,'Enable','off');set(handles.popupmenu6,'Enable','off');set(handles.popupmenu7,'Enable','off');set(handles.edit2,'Enable','off');%digerleri pasif olsun tamamen
%Bazi yapilacak isler
if ((7<=get(handles.popupmenu8,'Value'))&&(9>=get(handles.popupmenu8,'Value')))
    set(handles.edit5,'Enable','on');set(handles.edit6,'Enable','on');set(handles.edit7,'Enable','on');
elseif (((10<=get(handles.popupmenu8,'Value'))&&(12>=get(handles.popupmenu8,'Value'))))
    set(handles.edit3,'Enable','on');set(handles.edit4,'Enable','on');
end      
% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton21


%% Send button (classical)
function pushbutton1_Callback(hObject, eventdata, handles)
TxQueue=uint32(0);
num_tx=uint32(0);
                        Sending_Data_Array_uint8 = uint8(get(handles.edit1,'String'));
                                   %Sending_Data_Array_uint8=uint8([126,0,15,16,1,0,0,0,0,0,0,255,255,255,255,0,0,170,72])  ;                                                   
                                   Tx_Data_length_int32=int32(length(Sending_Data_Array_uint8));
                                   [status_Tx_Available,TxQueue]=GetTxBytesWaiting(handles.PortOBJ,TxQueue);

% bu kisim ise gonderilecek data string yada hex girilme istegi uzerine ayar cekiyor
% eger string girilmis ise prosedur aynen devam ediyor, girilen dataya
% dokunulmuyor, ancak hex girilmis ise ornegin FF A1 10 girilmis ise alinan
% data yine string aliniyor ama 2ser 2ser isleme sokuluyor ve hex'e
% cevriliyor.          
              
%% Hata almamak icin bosluk doldurmaca
                     if isempty(Sending_Data_Array_uint8)
                           Sending_Data_Array_uint8=uint8([0 0]);
                     elseif length(Sending_Data_Array_uint8)==1
                           Sending_Data_Array_uint8=uint8([0 Sending_Data_Array_uint8]);
                     end
%                                          
%% Hex ayarlama kismi
 for (i=1:length(Sending_Data_Array_uint8))%kontrol hex2dec icin
                   
     if (~(  ((65<=uint8(Sending_Data_Array_uint8(i))) && (70>=uint8(Sending_Data_Array_uint8(i)))) || ((48<=uint8(Sending_Data_Array_uint8(i))) && (57>=uint8(Sending_Data_Array_uint8(i)))) || ((97<=uint8(Sending_Data_Array_uint8(i))) && (102>=uint8(Sending_Data_Array_uint8(i))))  ))
         %Burada hex hatasi verecek degerleri sifirliyoruz
         %(65<=79>=)(48<=57>=)(97<=102>=)  tabi baþýna degilini koyarak eger boyle degilse sifirliyor
         Sending_Data_Array_uint8(i)=uint8(0);%degilse hata vermemesi icin sifirladik
     end
     Sending_Data_Array_hex(i) = hex2dec(char(Sending_Data_Array_uint8(i)));
     
 end                                            
%% NOT: Buraya kadar Sending_Data_Array_hex dizisi hexadecimal dizi her bir eleman, bunlari 2li gruplara cevirecegim ve araya bosluk koyacagým
%Burada uzunluk yonunden (3un katlari) ayarlayalim
if mod(length(Sending_Data_Array_hex),3)==2
    Sending_Data_Array_hex=[Sending_Data_Array_hex 0]
elseif mod(length(Sending_Data_Array_hex),3)==1
    Sending_Data_Array_hex=Sending_Data_Array_hex(1:(end-1));
end
%þimdi hex donusumu

for i=1:(length(Sending_Data_Array_hex)/3)
  Hex_Data(i)=16*Sending_Data_Array_hex(3*i-2)+ Sending_Data_Array_hex(3*i-1) ;
end
%%
           if isempty(Hex_Data)
                           Hex_Data=uint8([0 0]);
           elseif length(Hex_Data)==1
                           Hex_Data=uint8([0 Hex_Data]);
           end
                     %%

                               if ((status_Tx_Available==handles.FT_OK)&&(TxQueue==0))
                                              Tx_New_length_int32=int32(length(Hex_Data));%burasi
                                              [status_Write,num_tx]=Write(handles.PortOBJ,uint8(Hex_Data),Tx_New_length_int32,num_tx);
                                             set(handles.text9,'String',Tx_New_length_int32);
                               end
                               pause(0.01);%10ms bekle
                                 
%kayit et(simdilik gerek yok)
%guidata(hObject,handles);
% --- Executes on button press in pushbutton2.
%
%% Connect button
function pushbutton2_Callback(hObject, eventdata, handles)
set(handles.pushbutton2,'Enable','off');     % Disables the 'Connect' button
set(handles.pushbutton3,'Enable','on');      % Actives the 'Disconnect' button
%pushbutton1_send button acilsin geri
set(handles.pushbutton1,'Enable','on');%pushbutton1(send button)kapali olsun
%Cirrus icin aktif kisimlar
set(handles.radiobutton19,'Enable','on');%Read
set(handles.radiobutton20,'Enable','on');%Write
set(handles.radiobutton21,'Enable','on');%Instruction
%renk icin
h4 = hObject(1); % Get the caller's handle.
set(h4,'backg',[0 1 0]); % Change color of button.
set(handles.pushbutton3,'backg',[1 1 1]);
%
set(h4,'UserData',1) % Degerini degistirmek
set(handles.pushbutton3,'UserData',0) % Degerini degistirmek
%% Burasý Serial Porta baðlanmak için kullanýlacak
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
               rx_available=uint32(0);  % TxQueue=uint32(0);
               num_rx=uint32(0);% num_tx=uint32(0);              
              [status_rx,rx_available] =GetRxBytesAvailable(handles.PortOBJ, rx_available);
              rx_ava_buff=rx_available;
     %
     Rx_Data_Byte= NET.createArray('System.Byte',256);% for buffer (ZigBee ve xtender icin max 256 byte buffer yeterli)
     %
          while(true)%sonsuz dongu icinde kontrol edecegiz
                   %% GELEN DATALARIN OKUNDUGU KISIM (while ici)
                    [status_rx,rx_available] =GetRxBytesAvailable(handles.PortOBJ,rx_available);
                   if  ((rx_ava_buff ~= rx_available)&&(handles.FT_OK==status_rx)) %bura olmasa da olur ama olursa daha hýzlý çalýþýyor sistem....
                              data_sayisi=rx_available-rx_ava_buff ;%farkini alalim
                              [status_Read,num_rx] = Read( handles.PortOBJ,Rx_Data_Byte,rx_available, num_rx);%Burada r status2u gosteriyor;num ise her an için gonderilen data(byte ) sayýsýný;objemizi gösterdik;x ise gonderilen data , biz bunu 5 elemanlý ayarladýk, eleman sayýsý kafamýza gore olabilir istersek tek elemanlý ister 100 elemanlý;5 ise gonderilen data uzunlugu, burada o deðer x in kay byte' sini gondereceðimizi belirtmek üzere kullamnýlmakta yani hepsini gondermek zorunda deðiliz;en son num ise basta 0 versek te bu .NEt fn-unun geri donusunde toplam gonderilen byte sayýsýný tutmak uzere ayarlanmýþtýr
                              if status_Read==handles.FT_OK
                                        %% Burasi bizim mekan
                                            %%
                                                for i=1:rx_available
                                                          xXx=uint8 ( Rx_Data_Byte(i) ); %Bunun turunu ayar cekilebilecek hale getirelim
                                                          %handles.buffer{handles.degisken,1}= uint8 ( Rx_Data_Byte(i) )  ; %normalde uint32 felen mý ne de bunu dusenlemeliyiz
                                                          handles.buffer{handles.degisken,1}= dec2hex(xXx);
                                                          %handles.buffer{handles.degisken,1}= dec2bin(xXx);
                                                          handles.degisken=handles.degisken+1;
                                                end
                                                %handles.degisken=handles.degisken+1;%Bu
                                                %da iki data arasina bosluk
                                                %icun.... Simdilik kotu
                                                %gorundugunu dusunuyorum
                                                set(handles.listbox1, 'String', handles.buffer);%alinan datanin gorunmesi icin      
                                                rx_available=uint32(0); 
                    
                              end
                                        
                   end
                                                 if (handles.degisken>25)
                                                                handles.degisken=1;
                                                                handles.buffer=cell((handles.degisken),1);%burada asiri dosya sismesini onleyelim,tekrar tek elemanli cellden baslasin iþe
                                                 end
                pause(0.01);%simdilik 20ms yeterli(10 ms yapalim, diger islemlerde 10 ms tutsa felan)
               %System.Threading.Thread.Sleep(1);
          end
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
%pushbutton1_send button kapansin
set(handles.pushbutton1,'Enable','off');%pushbutton1(send button)kapali olsun
set(handles.pushbutton4,'Enable','off');set(handles.text9,'Enable','off');
%Cirrus icin aktif kisimlar
set(handles.radiobutton19,'Value',0);set(handles.radiobutton19,'Enable','off');%Read
set(handles.radiobutton20,'Value',0);set(handles.radiobutton20,'Enable','off');%Write
set(handles.radiobutton21,'Value',0);set(handles.radiobutton21,'Enable','off');%Instruction
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
%% Burasý Serial Porttan ayrýlmak için kullanýlacak
 disp('name_GetCOMPort =')
 disp(handles.name_GetCOMPort.char)
[status_PortOBJClose]=handles.PortOBJ.Close%kapattik geri
%kayit et
guidata(hObject,handles);
%

%%  (Cirrus) Send komut Button
function pushbutton4_Callback(hObject, eventdata, handles)
               TxQueue=uint32(0);
               num_tx=uint32(0);
% olusturulan paketin gonderilmesi asagida. Yukariya doseyip karmasa yapma (radio button / Cirrus)
if 1==get(handles.radiobutton19,'UserData')
          %PageAddr_ReadReg=128+PageAddr_ReadReg;%Basina 10 selecek page koyduk
          %RegAddr_ReadReg=0+RegAddr_ReadReg;%%Basina 00 oku koyduk
          Sending_Cirrus_Data_Array_uint8 = uint8([(128+handles.Cirrus_Page_Addr_ConstName(double(get(handles.popupmenu4,'Value'))))     handles.Cirrus_Register_Addr_ConstName(double(get(handles.popupmenu5,'Value')))]);    
elseif 1==get(handles.radiobutton20,'UserData')
          %PageAddr_ReadReg=128+PageAddr_ReadReg;%Basina 10 selecek page koyduk
          %RegAddr_ReadReg=0+RegAddr_ReadReg;%%Basina 01 yaz koyduk
          string_write_data=get(handles.edit2,'String');
          for (i=1:length(string_write_data))%kontrol hex2dec icin
                   
                    if (~(  ((65<=uint8(string_write_data(i))) && (70>=uint8(string_write_data(i)))) || ((48<=uint8(string_write_data(i))) && (57>=uint8(string_write_data(i)))) || ((97<=uint8(string_write_data(i))) && (102>=uint8(string_write_data(i))))  ))
                        %Burada hex hatasi verecek degerleri sifirliyoruz
                        %(65<=79>=)(48<=57>=)(97<=102>=)  tabi baþýna
                        %degilini koyarak eger boyle degilse sifirliyor
                     string_write_data(i)=0;%degilse hata vermemesi icin sifirladik
                    end
          end         
          %
          if (6<=length(string_write_data))
          dat0=uint8([16*hex2dec(string_write_data(5))+hex2dec(string_write_data(6))]);%0x dat2 dat1 dat0
          dat1=uint8([16*hex2dec(string_write_data(3))+hex2dec(string_write_data(4))]);
          dat2=uint8([16*hex2dec(string_write_data(1))+hex2dec(string_write_data(2))]);
          %
          Sending_Cirrus_Data_Array_uint8 = uint8([(128+handles.Cirrus_Page_Addr_ConstName(double(get(handles.popupmenu6,'Value')))) (64+handles.Cirrus_Register_Addr_ConstName(double(get(handles.popupmenu7,'Value')))) dat0 dat1 dat2 ]);    
          else
          Sending_Cirrus_Data_Array_uint8 = uint8([(128+handles.Cirrus_Page_Addr_ConstName(double(get(handles.popupmenu6,'Value')))) (64+handles.Cirrus_Register_Addr_ConstName(double(get(handles.popupmenu7,'Value')))) 0 0 0 ]);    
          end
elseif 1==get(handles.radiobutton21,'UserData')
        C0=uint8(get(handles.edit7,'String'))==uint8('1');%Burada 1 ile VE islemi yaparark deger 0 harici bir seyse 1 yoksa 0 olsun dedik
        C1=uint8(get(handles.edit6,'String'))==uint8('1');
        C2=uint8(get(handles.edit5,'String'))==uint8('1');
        C3=uint8(get(handles.edit4,'String'))==uint8('1');
        C4=uint8(get(handles.edit3,'String'))==uint8('1');
        %
        C4C3=(C4(1))*(2^4) + (C3(1))*(2^3);
        C2C1C0=(C2(1))*(2^2) + (C1(1))*(2^1) + (C0(1))*(2^0);
        %
        switch double(get(handles.popupmenu8,'Value'))
              case 1
                  Sending_Cirrus_Data_Array_uint8=uint8(192+1);
              case 2
                  Sending_Cirrus_Data_Array_uint8=uint8(192+2);
              case 3
                  Sending_Cirrus_Data_Array_uint8=uint8(192+3);
              case 4
                 Sending_Cirrus_Data_Array_uint8= uint8(192+20);
              case 5
                  Sending_Cirrus_Data_Array_uint8=uint8(192+21);
              case 6
                  Sending_Cirrus_Data_Array_uint8=uint8(192+24);
              case 7
                  Sending_Cirrus_Data_Array_uint8=uint8(192+32+C2C1C0);%C2C1C0 max 7 olabilir
              case 8
                 Sending_Cirrus_Data_Array_uint8= uint8(192+48+C2C1C0);
              case 9
                  Sending_Cirrus_Data_Array_uint8=uint8(192+56+C2C1C0);
              case 10
                  Sending_Cirrus_Data_Array_uint8= uint8(192+C4C3+33);%C4C3 max24 ile 30 arasi
              case 11
                  Sending_Cirrus_Data_Array_uint8=uint8(192+C4C3+34);
              case 12 
                  Sending_Cirrus_Data_Array_uint8=uint8(192+C4C3+38);
              otherwise
                 Sending_Cirrus_Data_Array_uint8= uint8(0);%bunu neler olabilecegini dusunelim
        end
        Sending_Cirrus_Data_Array_uint8= uint8([0 Sending_Cirrus_Data_Array_uint8]);
end
                                   
             Tx_Data_length_int32=int32(length(Sending_Cirrus_Data_Array_uint8));
             [status_Tx_Available,TxQueue]=handles.PortOBJ.GetTxBytesWaiting(TxQueue);
             if ((status_Tx_Available==handles.FT_OK)&&(TxQueue==0))
                 [status_Write,num_tx]=handles.PortOBJ.Write(Sending_Cirrus_Data_Array_uint8,Tx_Data_length_int32,num_tx);
             end                 
               %
               pause(0.025)%25ms bekle birazcik
%kayit et(simdilik ihtiyac yok ama)
%guidata(hObject,handles);s
%

function listbox1_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1

%% Send Cirrus Read/Write
% --- Executes on button press in pushbutton4.

function listbox1_CreateFcn(hObject, eventdata, handles)
% Hint: listbox controls usually have a white background on Windows.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%

function edit1_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

function edit1_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%

function edit2_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%
