function varargout = NET_Serial_Ref_asli(varargin)
%ati' nin malidir.......
% Last Modified by GUIDE v2.5 12-Oct-2013 19:39:27
%%
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NET_Serial_Ref_asli_OpeningFcn, ...
                   'gui_OutputFcn',  @NET_Serial_Ref_asli_OutputFcn, ...
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
% --- Executes just before NET_Serial_Ref_asli is made visible.
function NET_Serial_Ref_asli_OpeningFcn(hObject, eventdata, handles, varargin)
%% Burada ilk acilirken yapilacaklari koyalim
handles.degisken=1; %Bunu gelen data frameler icin kullanacagiz ileride
handles.buffer=cell((handles.degisken),1);
%Þuraya bir uyari koyalim
 asm_WinForm = NET.addAssembly('System.Windows.Forms');
 import System.Windows.Forms.*;
 MessageBox.Show('UYARI!!! Programin hata vermesi durumunda: USB kablosunu cikartip tekrar takin, programi yeniden baslatin...')
%% Burada com portlarini .NET yardimi ile bulup yazdiriyoruz
handles.SerialPortObj=System.IO.Ports.SerialPort;%Serial Port Objesini olusturalim
handles.SerialPortObj_GetPortNames=System.IO.Ports.SerialPort.GetPortNames;%COM portlarin isimlerini alalým, kac tane oldugu length ile ogrenilebilir
eleman_sayisi=1;
    for i=1:handles.SerialPortObj_GetPortNames.Length
           a=handles.SerialPortObj_GetPortNames(i);
           handles.SerialPortObj.PortName=a;
                if handles.SerialPortObj.IsOpen
                    i=i+1;
                    continue %Bu hic dongu sonuna kadar gitmeden direk yukari cikarabilmek icin kullanýlýr, break' ýn az denisiði
                end
           handles.GetPortNames{eleman_sayisi}=a.char;%Burada da obj icindeki her bir (aslýnda System.String olan) char yapilip cell'e yaziliyor, boylece gosterme imkani buluyoruz.
           eleman_sayisi=eleman_sayisi+1;%Bunu elemanlar 1,2... sýrasý ile yazilmasi icin koydum
     end
% handles.GetPortNames yukarida elde ediliyor....
set(handles.popupmenu_SerialControl_COMPorts,'String',handles.GetPortNames);   % Kullanima hazir portlari gosterelim (Bu sadece acik olmayan, kullanima uygun olanlarý gosterir, bu yonden guzel bir uygulama icin uygundur)
%% Baudrate listesi (sergilenecek olan)
handles.BaudRateList=[9600;600;1200;2400;4800;9600;19200;38400;57600;115200;230400;230400;460800;921600;1500000;3000000];
set(handles.popupmenu_SerialControl_BaudRate,'String',handles.BaudRateList); %Orjinalde 9600'e ayarlý ilk durum icin
%% Data bits  listesi (sergilenecek olan)
handles.DataBitsList=[8;7;6;5];
set(handles.popupmenu_SerialControl_DataBits,'String',handles.DataBitsList); %Orjinalde 9600'e ayarlý ilk durum icin
%% Stop bits  listesi (sergilenecek olan)
handles.StopBitsList=cell(1,3);%3 elemanlý olmasý burada yeterli
handles.StopBitsList{1}=System.IO.Ports.StopBits.One.char;
handles.StopBitsList{2}=System.IO.Ports.StopBits.OnePointFive.char;
handles.StopBitsList{3}=System.IO.Ports.StopBits.Two.char;
set(handles.popupmenu_SerialControl_StopBits,'String',handles.StopBitsList); %Orjinalde 9600'e ayarlý ilk durum icin
%% Handshaking  listesi (sergilenecek olan)
handles.HandshakingList=cell(1,4);
handles.HandshakingList{1}=System.IO.Ports.Handshake.None.char;
handles.HandshakingList{2}=System.IO.Ports.Handshake.RequestToSend.char;
handles.HandshakingList{3}=System.IO.Ports.Handshake.RequestToSendXOnXOff.char;
handles.HandshakingList{4}=System.IO.Ports.Handshake.XOnXOff.char;
set(handles.popupmenu_SerialControl_Handshaking,'String',handles.HandshakingList); %Orjinalde 9600'e ayarlý ilk durum icin
%% Parity  listesi (sergilenecek olan)
handles.ParityList=cell(1,5);
handles.ParityList{1}=System.IO.Ports.Parity.None.char;%Noneden bilerek baslattým, genelde bu kullaniliyor cunku
handles.ParityList{2}=System.IO.Ports.Parity.Even.char;
handles.ParityList{3}=System.IO.Ports.Parity.Mark.char;
handles.ParityList{4}=System.IO.Ports.Parity.Odd.char;
handles.ParityList{5}=System.IO.Ports.Parity.Space.char;
set(handles.popupmenu_SerialControl_Parity,'String',handles.ParityList); %Orjinalde 9600'e ayarlý ilk durum icin
%% ilk acilistaki secili olmasi gereken radio buttonlarim
set(handles.radiobutton_Transmitter_String,'Value',1);set(handles.radiobutton_Transmitter_String,'Enable','off');
set(handles.radiobutton_Reciever_Decimal,'Value',1);set(handles.radiobutton_Reciever_Decimal,'Enable','off');
set(handles.radiobutton_DTR_Off,'Value',1);set(handles.radiobutton_DTR_Off,'Enable','off');
set(handles.radiobutton_RTS_Off,'Value',1);set(handles.radiobutton_RTS_Off,'Enable','off');
%% ilk acilista (simdilik) kapali olacak radio butonlar
set(handles.radiobutton_Transmitter_Binary,'Value',0);set(handles.radiobutton_Transmitter_Binary,'Enable','off');
set(handles.radiobutton_Transmitter_Decimal,'Value',0);set(handles.radiobutton_Transmitter_Decimal,'Enable','off');
set(handles.radiobutton_Transmitter_Hex,'Value',0);set(handles.radiobutton_Transmitter_Hex,'Enable','off');
%
set(handles.radiobutton_Reciever_String,'Value',0);set(handles.radiobutton_Reciever_String,'Enable','off');
set(handles.radiobutton_Reciever_Binary,'Value',0);set(handles.radiobutton_Reciever_Binary,'Enable','off');
set(handles.radiobutton_Reciever_Hex,'Value',0);set(handles.radiobutton_Reciever_Hex,'Enable','off');
%
set(handles.radiobutton_DTR_On,'Value',0);set(handles.radiobutton_DTR_On,'Enable','off');
set(handles.radiobutton_RTS_on,'Value',0);set(handles.radiobutton_RTS_on,'Enable','off');
%%%
% Choose default command line output for NET_Serial_Ref_asli
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes NET_Serial_Ref_asli wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%%
% --- Outputs from this function are returned to the command line.

% --- Executes during object creation, after setting all properties.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton_SerialControl_Connect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_SerialControl_Connect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
function varargout = NET_Serial_Ref_asli_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
%
function popupmenu_SerialControl_COMPorts_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_SerialControl_COMPorts contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_SerialControl_COMPorts

function popupmenu_SerialControl_COMPorts_CreateFcn(hObject, eventdata, handles)
% Hint: popupmenu controls usually have a white background on Windows.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%
function popupmenu_SerialControl_BaudRate_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_SerialControl_BaudRate contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_SerialControl_BaudRate

function popupmenu_SerialControl_BaudRate_CreateFcn(hObject, eventdata, handles)
% Hint: popupmenu controls usually have a white background on Windows.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%
function edit_Transmitter_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of edit_Transmitter as text

%        str2double(get(hObject,'String')) returns contents of edit_Transmitter as a double

function edit_Transmitter_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%

function listbox_Reciever_CreateFcn(hObject, eventdata, handles)
% Hint: listbox controls usually have a white background on Windows.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%
function radiobutton_Reciever_String_Callback(hObject, eventdata, handles)
set(handles.radiobutton_Reciever_Binary,'Value',0);
set(handles.radiobutton_Reciever_Decimal,'Value',0);
set(handles.radiobutton_Reciever_Hex,'Value',0);
set(handles.radiobutton_Reciever_String,'Enable','off');
set(handles.radiobutton_Reciever_Binary,'Enable','on');
set(handles.radiobutton_Reciever_Decimal,'Enable','on');
set(handles.radiobutton_Reciever_Hex,'Enable','on');
% Hint: get(hObject,'Value') returns toggle state of radiobutton_Reciever_String

function radiobutton_Reciever_Binary_Callback(hObject, eventdata, handles)
set(handles.radiobutton_Reciever_String,'Value',0);
set(handles.radiobutton_Reciever_Decimal,'Value',0);
set(handles.radiobutton_Reciever_Hex,'Value',0);
set(handles.radiobutton_Reciever_Binary,'Enable','off');
set(handles.radiobutton_Reciever_String,'Enable','on');
set(handles.radiobutton_Reciever_Decimal,'Enable','on');
set(handles.radiobutton_Reciever_Hex,'Enable','on');
% Hint: get(hObject,'Value') returns toggle state of radiobutton_Reciever_Binary

function radiobutton_Reciever_Decimal_Callback(hObject, eventdata, handles)
set(handles.radiobutton_Reciever_String,'Value',0);
set(handles.radiobutton_Reciever_Binary,'Value',0);
set(handles.radiobutton_Reciever_Hex,'Value',0);
set(handles.radiobutton_Reciever_Decimal,'Enable','off');
set(handles.radiobutton_Reciever_String,'Enable','on');
set(handles.radiobutton_Reciever_Binary,'Enable','on');
set(handles.radiobutton_Reciever_Hex,'Enable','on');
% Hint: get(hObject,'Value') returns toggle state of radiobutton_Reciever_Decimal

function radiobutton_Reciever_Hex_Callback(hObject, eventdata, handles)
set(handles.radiobutton_Reciever_String,'Value',0);
set(handles.radiobutton_Reciever_Binary,'Value',0);
set(handles.radiobutton_Reciever_Decimal,'Value',0);
set(handles.radiobutton_Reciever_Hex,'Enable','off');
set(handles.radiobutton_Reciever_String,'Enable','on');
set(handles.radiobutton_Reciever_Binary,'Enable','on');
set(handles.radiobutton_Reciever_Decimal,'Enable','on');
% Hint: get(hObject,'Value') returns toggle state of radiobutton_Reciever_Hex

function radiobutton_Transmitter_String_Callback(hObject, eventdata, handles)
set(handles.radiobutton_Transmitter_Binary,'Value',0);
set(handles.radiobutton_Transmitter_Decimal,'Value',0);
set(handles.radiobutton_Transmitter_Hex,'Value',0);
set(handles.radiobutton_Transmitter_String,'Enable','off');
set(handles.radiobutton_Transmitter_Binary,'Enable','on');
set(handles.radiobutton_Transmitter_Decimal,'Enable','on');
set(handles.radiobutton_Transmitter_Hex,'Enable','on');
% Hint: get(hObject,'Value') returns toggle state of radiobutton_Transmitter_String

function radiobutton_Transmitter_Binary_Callback(hObject, eventdata, handles)
set(handles.radiobutton_Transmitter_String,'Value',0);
set(handles.radiobutton_Transmitter_Decimal,'Value',0);
set(handles.radiobutton_Transmitter_Hex,'Value',0);
set(handles.radiobutton_Transmitter_Binary,'Enable','off');
set(handles.radiobutton_Transmitter_String,'Enable','on');
set(handles.radiobutton_Transmitter_Decimal,'Enable','on');
set(handles.radiobutton_Transmitter_Hex,'Enable','on');
% Hint: get(hObject,'Value') returns toggle state of radiobutton_Transmitter_Binary

function radiobutton_Transmitter_Decimal_Callback(hObject, eventdata, handles)
set(handles.radiobutton_Transmitter_String,'Value',0);
set(handles.radiobutton_Transmitter_Binary,'Value',0);
set(handles.radiobutton_Transmitter_Hex,'Value',0);
set(handles.radiobutton_Transmitter_Decimal,'Enable','off');
set(handles.radiobutton_Transmitter_String,'Enable','on');
set(handles.radiobutton_Transmitter_Binary,'Enable','on');
set(handles.radiobutton_Transmitter_Hex,'Enable','on');
% Hint: get(hObject,'Value') returns toggle state of radiobutton_Transmitter_Decimal

function radiobutton_Transmitter_Hex_Callback(hObject, eventdata, handles)
set(handles.radiobutton_Transmitter_String,'Value',0);
set(handles.radiobutton_Transmitter_Binary,'Value',0);
set(handles.radiobutton_Transmitter_Decimal,'Value',0);
set(handles.radiobutton_Transmitter_Hex,'Enable','off');
set(handles.radiobutton_Transmitter_String,'Enable','on');
set(handles.radiobutton_Transmitter_Binary,'Enable','on');
set(handles.radiobutton_Transmitter_Decimal,'Enable','on');
% Hint: get(hObject,'Value') returns toggle state of radiobutton_Transmitter_Hex
%% Send button
function pushbutton_Transmitter_Send_Callback(hObject, eventdata, handles)
h_SendButton = hObject(1); % Get the caller's handle.
set(h_SendButton,'UserData',1) % Degerini degistirmek
%% DATA GONDERME KISMI
Sending_Data_Array_uint8=uint8( get(handles.edit_Transmitter,'String') );
if isempty(Sending_Data_Array_uint8)
    Sending_Data_Array_uint8= uint8(0);%Bos durmasýn matris
end
Obj_ByteArray_Write=NET.convertArray( Sending_Data_Array_uint8,'System.Byte');%Bu sekilde uretilen herhangi bir dizi vs. yi System.byte cevirip write ile gonderilebilir halde tutacagiz
% gonderme kismi ayarlari ile birlikte
offset_wr=int32(0);%0. index ten basla
count_wr=int32( Obj_ByteArray_Write.Length );%dizinin tamamini yani uzunlugu kadar elemani yolla
handles.SerialPortObj.Write(Obj_ByteArray_Write,offset_wr,count_wr);%Haberlesme icin genel yapimiz bu
%
pause(0.01);%10 ms bekle
%kayit et
guidata(hObject,handles);
% --- Executes on button press in pushbutton_SerialControl_Connect.
%
%% Connect button
function pushbutton_SerialControl_Connect_Callback(hObject, eventdata, handles)
set(handles.pushbutton_SerialControl_Connect,'Enable','off');     % Disables the 'Connect' button
set(handles.pushbutton_SerialControl_Disconnect,'Enable','on');      % Actives the 'Disconnect' button
%renk icin
h4 = hObject(1); % Get the caller's handle.
set(h4,'backg',[0 1 0]); % Change color of button.
set(handles.pushbutton_SerialControl_Disconnect,'backg',[1 1 1]);
%
set(h4,'UserData',1) % Degerini degistirmek
set(handles.pushbutton_SerialControl_Disconnect,'UserData',0) % Degerini degistirmek (diger butonun elbette)
%% Burasý Serial Porta baðlanmak için kullanýlacak
%datalarý GUI den cekelim
COMPortNumber=get(handles.popupmenu_SerialControl_COMPorts ,'Value'); %Buradan pop-up bardaki kacinci eleman , matristeki onu ogrendik(unutma MATLAB da matris 1. elemandan baslamakta)
BaudRateNumber=get(handles.popupmenu_SerialControl_BaudRate,'Value'); %Buradan pop-up bardaki kacinci eleman , matristeki onu ogrendik     
DataBitsNumber=get(handles.popupmenu_SerialControl_DataBits ,'Value'); %Buradan pop-up bardaki kacinci eleman , matristeki onu ogrendik     
StopBitsNumber=get(handles.popupmenu_SerialControl_StopBits ,'Value'); %Buradan pop-up bardaki kacinci eleman , matristeki onu ogrendik     
HandshakingNumber=get(handles.popupmenu_SerialControl_Handshaking ,'Value'); %Buradan pop-up bardaki kacinci eleman , matristeki onu ogrendik     
ParityNumber=get(handles.popupmenu_SerialControl_Parity,'Value'); %Buradan pop-up bardaki kacinci eleman , matristeki onu ogrendik     
%%%
    %devaminda alinan ayarlamalar yapilarak port baslatilacak
    handles.SerialPortObj.PortName=handles.GetPortNames{COMPortNumber};%1 den basladigi icin matris ici -1 yapiyorum
    %% Com Port ayarlarini set edelim acmadan once
    handles.SerialPortObj.BaudRate=handles.BaudRateList(BaudRateNumber);%matristen istedigimiz degeri cektik
    handles.SerialPortObj.DataBits=handles.DataBitsList(DataBitsNumber);
    switch StopBitsNumber%stopbits
        case 1
            handles.SerialPortObj.StopBits=System.IO.Ports.StopBits.One;
        case 2
            handles.SerialPortObj.StopBits=System.IO.Ports.StopBits.OnePointFive;
        case 3
            handles.SerialPortObj.StopBits=System.IO.Ports.StopBits.Two;
    end
    %
    switch HandshakingNumber%handshaking
        case 1
            handles.SerialPortObj.Handshake=System.IO.Ports.Handshake.None;
        case 2
            handles.SerialPortObj.Handshake=System.IO.Ports.Handshake.RequestToSend;
        case 3 
            handles.SerialPortObj.Handshake=System.IO.Ports.Handshake.RequestToSendXOnXOff;
        case 4
            handles.SerialPortObj.Handshake=System.IO.Ports.Handshake.XOnXOff;
    end
    %
    switch ParityNumber%parity
        case 1
            handles.SerialPortObj.Parity=System.IO.Ports.Parity.None;
        case 2
            handles.SerialPortObj.Parity=System.IO.Ports.Parity.Even;
        case 3 
            handles.SerialPortObj.Parity=System.IO.Ports.Parity.Mark;
        case 4
            handles.SerialPortObj.Parity=System.IO.Ports.Parity.Odd	;
        case 5
            handles.SerialPortObj.Parity=System.IO.Ports.Parity.Space;
    end    
    %%%
if(handles.SerialPortObj.IsOpen==0)
    %Portu ac artik!!
    handles.SerialPortObj.Open;%actik
    %donguye girmeden gecmisi kayit et ozelliklerimizi
    guidata(hObject,handles);
    %%% 
    %% Giden gelen datalar PORT open (connect) durumunda iken buradan kontrol edelim....
         Obj_ByteArray_Read= NET.createArray('System.Byte',256);%burada Byte olarak kullanmak uzere .NET char dizisi tanýmlýyoruz 
         while(true)%sonsuz dongu icinde kontrol edecegiz
                  if get(handles.pushbutton_SerialControl_Disconnect,'UserData') % Degeri 1 ise
                        break;
                  end
               %% GELEN DATALARIN OKUNDUGU KISIM (while ici)
               if (handles.SerialPortObj.BytesToRead > 0)
                     for i=1:handles.SerialPortObj.BytesToRead
                          data(i)=uint8(handles.SerialPortObj.ReadByte);%Burada ObjClass_SerialPort.ReadByte fonksiyon byte-byte verileri yazdirdigi icin data dizisine de byte byte yazdiriyoruz
                     end
                     %veri{m}=data(1:i);
                     %data=0;%sifirla bunu yoksa data þiþiyor, cok ram yiyor
                     %m=m+1;
                     set(handles.listbox_Reciever,'string',data);
                     data=0;
%                                if m>10
%                                    veri=cell(1);%burasi da þiþen cell'i kucultmek icin
%                                    m=1;
%                                end
               end
               %NOT: Data gonderme kýsmý diger handle de hallediliyor......
               %
               pause(0.01);
               %System.Threading.Thread.Sleep(10);%simdilik 20ms yeterli(10 ms yapalim, diger islemlerde 10 ms tutsa felan)
          end
%
else
  disp('Programi kapatip yeniden acin, port baslatilamadi!.....');
end%NOT!!! kapatmayi unutma
%kayit et(Update handles structure)
guidata(hObject,handles);
%
%% Disconnect button
function pushbutton_SerialControl_Disconnect_Callback(hObject, eventdata, handles)
set(handles.pushbutton_SerialControl_Disconnect,'Enable','off');     % Disables the 'Connect' button
set(handles.pushbutton_SerialControl_Connect,'Enable','on');      % Actives the 'Disconnect' button
%renk icin
h4 = hObject(1); % Get the caller's handle.
set(h4,'backg',[1 0 0]) % Change color of button.
set(handles.pushbutton_SerialControl_Connect,'backg',[1 1 1])
% Degerini de degistirelim
set(h4,'UserData',1) % Degerini degistirmek
set(handles.pushbutton_SerialControl_Connect,'UserData',0) % Degerini degistirmek
%kayit et
guidata(hObject,handles);
%
if (handles.SerialPortObj.IsOpen)
    handles.SerialPortObj.Close;%geri kapattýk
    disp('port geri kapatýldý ve port numarasi')
    disp(handles.SerialPortObj.PortName);
else
    disp('bir sorun var ve port  kapatýlamadý !! Kabloyu çýkartýp geri takýnýz ')
end
%kayit et
guidata(hObject,handles);
%
function popupmenu_SerialControl_DataBits_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_SerialControl_DataBits contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_SerialControl_DataBits

function popupmenu_SerialControl_DataBits_CreateFcn(hObject, eventdata, handles)
% Hint: popupmenu controls usually have a white background on Windows.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%

function radiobutton_DTR_On_Callback(hObject, eventdata, handles)
set(handles.radiobutton_DTR_Off,'Value',0);
set(handles.radiobutton_DTR_On,'Enable','off');
set(handles.radiobutton_DTR_Off,'Enable','on');
% Hint: get(hObject,'Value') returns toggle state of radiobutton_DTR_On

function radiobutton_DTR_Off_Callback(hObject, eventdata, handles)
set(handles.radiobutton_DTR_On,'Value',0);
set(handles.radiobutton_DTR_Off,'Enable','off');
set(handles.radiobutton_DTR_On,'Enable','on');
% Hint: get(hObject,'Value') returns toggle state of radiobutton_DTR_Off

function radiobutton_RTS_on_Callback(hObject, eventdata, handles)
set(handles.radiobutton_RTS_Off,'Value',0);
set(handles.radiobutton_RTS_on,'Enable','off');
set(handles.radiobutton_RTS_Off,'Enable','on');
%%% Hint: get(hObject,'Value') returns toggle state of radiobutton_RTS_on

function radiobutton_RTS_Off_Callback(hObject, eventdata, handles)
set(handles.radiobutton_RTS_on,'Value',0);
set(handles.radiobutton_RTS_Off,'Enable','off');
set(handles.radiobutton_RTS_on,'Enable','on');
%%% Hint: get(hObject,'Value') returns toggle state of radiobutton_RTS_Off

function listbox_Reciever_Callback(hObject, eventdata, handles)
%%%

% --- Executes on selection change in popupmenu_SerialControl_Handshaking.
function popupmenu_SerialControl_Handshaking_Callback(hObject, eventdata, handles)
%%%

% --- Executes during object creation, after setting all properties.
function popupmenu_SerialControl_Handshaking_CreateFcn(hObject, eventdata, handles)
%
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%%%

% --- Executes on selection change in popupmenu_SerialControl_StopBits.
function popupmenu_SerialControl_StopBits_Callback(hObject, eventdata, handles)
%%%

% --- Executes during object creation, after setting all properties.
function popupmenu_SerialControl_StopBits_CreateFcn(hObject, eventdata, handles)
%
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%%%

% --- Executes on selection change in popupmenu_SerialControl_Parity.
function popupmenu_SerialControl_Parity_Callback(hObject, eventdata, handles)
%%%

% --- Executes during object creation, after setting all properties.
function popupmenu_SerialControl_Parity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_SerialControl_Parity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%%%

% --- Executes on button press in pushbutton_SerialControl_RefreshPorts.
function pushbutton_SerialControl_RefreshPorts_Callback(hObject, eventdata, handles)
%%%
