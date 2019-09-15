function varargout = FTDI_serial_REF_GUI_2(varargin)
%ati' nin malidir.......
% Last Modified by GUIDE v2.5 27-Sep-2013 15:54:28
%%
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FTDI_serial_REF_GUI_2_OpeningFcn, ...
                   'gui_OutputFcn',  @FTDI_serial_REF_GUI_2_OutputFcn, ...
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
% --- Executes just before FTDI_serial_REF_GUI_2 is made visible.
function FTDI_serial_REF_GUI_2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FTDI_serial_REF_GUI_2 (see VARARGIN)
handles.degisken=1;
handles.buffer=cell((handles.degisken),1);
%% Burada ilk acilirken yapilacaklari koyalim
% asm = NET.addAssembly('System.Threading');
% import System.Threading.*;
MS_NET_SerialPortClass=System.IO.Ports.SerialPort;
NET_GetPortName= System.IO.Ports.SerialPort.GetPortNames;%Burada tüm COM portlarýnýn ismini aldýk(MS .NET yardimi ile)
%Þuraya bir uyari koyalim
 asm = NET.addAssembly('System.Windows.Forms');
 import System.Windows.Forms.*;
 MessageBox.Show('UYARI!!! Programin hata vermesi durumunda: USB kablosunu cikartip tekrar takin, programi yeniden baslatin...                                                                                             NOT: Program sadece FTDI chip barindiran USB birimleri ile calismaktadir...')
 %% Burada com portlarini .NET yardimi ile bulup yazdiriyoruz
%% Ayrica ftdi portlarinin uzunlugu ile ac-kapa yaparak hangi COM portuna ait oldugunu girecegiz
handles.FTDI_Assembly= NET.addAssembly('D:\DropBox_Dokunma\Dropbox\MATLAB_ati_ozel\SERIAL_PORT_USB_KISMI(_NET)\\FTD2XX_NET.dll');
%burada lib yuklemenin dogrudan yolunu bulmak lazim
handles.PortOBJ=FTD2XX_NET.FTDI;%FTDI nesnesini ekleyelim
handles.FT_OK=FTD2XX_NET.FT_STATUS.FT_OK;%Burada da dogru-yanlis islem karsilastirmasi yapacagiz
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
handles.BaudRateList=[9600;600;1200;2400;4800;9600;19200;38400;57600;115200];%istersek dusuk data rate cikartilabilir
set(handles.popupmenu2,'String',handles.BaudRateList); %Orjinalde 9600'e ayarlý ilk durum icin
%% Data bits  listesi (sergilenecek olan)
handles.DataBitsList=[8;7;6;5];
set(handles.popupmenu3,'String',handles.DataBitsList); %Orjinalde 9600'e ayarlý ilk durum icin
%% ilk acilistaki secili olmasi gereken radio buttonlarim
set(handles.radiobutton5,'Value',1);set(handles.radiobutton5,'Enable','off');
set(handles.radiobutton1,'Value',1);set(handles.radiobutton1,'Enable','off');
set(handles.radiobutton15,'Value',1);set(handles.radiobutton15,'Enable','off');
set(handles.radiobutton9,'Value',1);set(handles.radiobutton9,'Enable','off');%None handshake()
set(handles.radiobutton10,'Value',0);set(handles.radiobutton10,'Enable','off');%Xon/Xoff
set(handles.radiobutton12,'Value',1);set(handles.radiobutton12,'Enable','off');
set(handles.radiobutton14,'Value',1);set(handles.radiobutton14,'Enable','off');
set(handles.radiobutton18,'Value',1);set(handles.radiobutton18,'Enable','off');%Parity
%% if koþulunun sonu 
 else
      MessageBox.Show('UYARI!!! FTDI herhangi bir USB cihaz bulunamadi, kontrol edip programi tekrardan baslatiniz...')
 end
 
% Choose default command line output for FTDI_serial_REF_GUI_2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes FTDI_serial_REF_GUI_2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%%
% --- Outputs from this function are returned to the command line.

% --- Executes during object creation, after setting all properties.
function pushbutton2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
function varargout = FTDI_serial_REF_GUI_2_OutputFcn(hObject, eventdata, handles) 
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
function edit1_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of edit1 as text

%        str2double(get(hObject,'String')) returns contents of edit1 as a double

function edit1_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%

function listbox1_CreateFcn(hObject, eventdata, handles)
% Hint: listbox controls usually have a white background on Windows.
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
% Hint: get(hObject,'Value') returns toggle state of radiobutton4

function radiobutton5_Callback(hObject, eventdata, handles)
set(handles.radiobutton6,'Value',0);
set(handles.radiobutton7,'Value',0);
set(handles.radiobutton8,'Value',0);
set(handles.radiobutton5,'Enable','off');
set(handles.radiobutton6,'Enable','on');
set(handles.radiobutton7,'Enable','on');
set(handles.radiobutton8,'Enable','on');
% Hint: get(hObject,'Value') returns toggle state of radiobutton5

function radiobutton6_Callback(hObject, eventdata, handles)
set(handles.radiobutton5,'Value',0);
set(handles.radiobutton7,'Value',0);
set(handles.radiobutton8,'Value',0);
set(handles.radiobutton6,'Enable','off');
set(handles.radiobutton5,'Enable','on');
set(handles.radiobutton7,'Enable','on');
set(handles.radiobutton8,'Enable','on');
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
set(handles.radiobutton6,'Enable','on');
set(handles.radiobutton7,'Enable','on');
% Hint: get(hObject,'Value') returns toggle state of radiobutton8
%% Send button
function pushbutton1_Callback(hObject, eventdata, handles)
h_SendButton = hObject(1); % Get the caller's handle.
set(h_SendButton,'UserData',1) % Degerini degistirmek
%kayit et
guidata(hObject,handles);
% --- Executes on button press in pushbutton2.
%
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
      %% Giden gelen datalar PORT open (connect) durumunda iken buradan kontrol edelim....
      %donguye girmeden gecmisi kayit et
     guidata(hObject,handles);
     %
     % gelen data icin dongu ici giris degerleri
               rx_available=uint32(0);
               TxQueue=uint32(0);
               num_rx=uint32(0);
               num_tx=uint32(0);
              [status_rx,rx_available] =GetRxBytesAvailable(handles.PortOBJ, rx_available);
              rx_ava_buff=rx_available;
     %
          while(true)%sonsuz dongu icinde kontrol edecegiz
                  if(get(handles.pushbutton3,'UserData')) % Degeri 1 ise
                        break;
                  end
               %% GELEN DATALARIN OKUNDUGU KISIM (while ici)
                    [status_rx,rx_available] =GetRxBytesAvailable(handles.PortOBJ,rx_available);
                   if  ((rx_ava_buff ~= rx_available)&&(handles.FT_OK==status_rx)) %bura olmasa da olur ama olursa daha hýzlý çalýþýyor sistem....
                              data_sayisi=rx_available-rx_ava_buff ;%farkini alalim
                              [status_Read,Rx_Data,num_rx] = Read( handles.PortOBJ,rx_available, num_rx);%Burada r status2u gosteriyor;num ise her an için gonderilen data(byte ) sayýsýný;objemizi gösterdik;x ise gonderilen data , biz bunu 5 elemanlý ayarladýk, eleman sayýsý kafamýza gore olabilir istersek tek elemanlý ister 100 elemanlý;5 ise gonderilen data uzunlugu, burada o deðer x in kay byte' sini gondereceðimizi belirtmek üzere kullamnýlmakta yani hepsini gondermek zorunda deðiliz;en son num ise basta 0 versek te bu .NEt fn-unun geri donusunde toplam gonderilen byte sayýsýný tutmak uzere ayarlanmýþtýr
                              if status_Read==handles.FT_OK
                                          handles.buffer{handles.degisken,1}=Rx_Data.char;%char degerine donustur OBJ'den
                                          set(handles.listbox1, 'String', handles.buffer);%alinan datanin gorunmesi icin
                                          rx_ava_buff=rx_available;%son deðerini kullanalým bundan sonra
                                          %degiskeni ve cell' i buyut
                                          handles.degisken=handles.degisken+1;
                              end
                                                 if (handles.degisken>1000)
                                                                handles.degisken=1;
                                                                handles.buffer=cell((handles.degisken),1);%burada asiri dosya sismesini onleyelim
                                                 end
                   end   
                %% DATA GONDERMEK ISTENDIGINDE (while) DONGUSU ICINDE YAPILACAKLAR KISMI
                 if   get(handles.pushbutton1,'UserData') %send butonuna basildi ise 1 degeri donuyor
                                   % data gondermeyi yazalim
                                   Sending_Data_Array_uint8 = uint8(get(handles.edit1,'String'));
                                   Tx_Data_length_int32=int32(length(Sending_Data_Array_uint8));
                                   [status_Tx_Available,TxQueue]=GetTxBytesWaiting(handles.PortOBJ,TxQueue);
                                   if ((status_Tx_Available==handles.FT_OK)&&(TxQueue==0))
                                              [status_Write,num_tx]=Write(handles.PortOBJ,Sending_Data_Array_uint8,Tx_Data_length_int32,num_tx);
                                   end
                                   set(handles.pushbutton1,'UserData',0);% Degerini geri eski haline getirdik
                 end
                %
               pause2(.01);%simdilik 20ms yeterli(10 ms yapalim, diger islemlerde 10 ms tutsa felan)
               %System.Threading.Thread.Sleep(1);
          end
      %%
   end
   %
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
h4 = hObject(1); % Get the caller's handle.
set(h4,'backg',[1 0 0]) % Change color of button.
set(handles.pushbutton2,'backg',[1 1 1])
% Degerini de degistirelim
set(h4,'UserData',1) % Degerini degistirmek
set(handles.pushbutton2,'UserData',0) % Degerini degistirmek
%kayit et
guidata(hObject,handles);
pause2(.01);%100ms bekle
%% Burasý Serial Porttan ayrýlmak için kullanýlacak
 disp('name_GetCOMPort =')
 disp(handles.name_GetCOMPort.char)
[status_PortOBJClose]=handles.PortOBJ.Close%kapattik geri
%kayit et
guidata(hObject,handles);
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

function listbox1_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
