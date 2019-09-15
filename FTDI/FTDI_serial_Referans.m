clear all,close all,clc;
FTDI_Assembly= NET.addAssembly('D:\DropBox_Dokunma\Dropbox\MATLAB_ati_ozel\SERIAL_PORT_USB_KISMI(_NET)\FTD2XX_NET.dll');
MS_NET_SerialPortClass=System.IO.Ports.SerialPort;
NET_GetPortName= System.IO.Ports.SerialPort.GetPortNames;%Burada t�m COM portlar�n�n ismini ald�k(MS .NET yardimi ile)
%% methodsview( 'FTD2XX_NET.FTDI');
FT_OK=FTD2XX_NET.FT_STATUS.FT_OK;%Burada da dogru-yanlis islem karsilastirmasi yapacagiz
disp('Kullanmaya uygun COM portlari:')
for i=1:NET_GetPortName.Length
    disp(NET_GetPortName(i))
end 
PortOBJ=FTD2XX_NET.FTDI;
GetNumberOfDevices_count=uint32(0);%Buras� uint32 buffer de�eri, i�eri�inin ne oldu�u �nemli de�il kendisi de�i�tiriryor zaten
[status_GetNumberOfDevices,GetNumberOfDevices_count]=PortOBJ.GetNumberOfDevices(GetNumberOfDevices_count);%Burada kac tane FTDI cihaz bagli onu gormekteyiz
i=uint32(0);%Burada data tipi uint32 olmali imi�
%% Burada bir sekilde hangisini istedigimizi seciyoruz
%ObjClass_SerialPort.PortName = input('Lutfen calismak istediginiz portu giriniz (Ornegin ''COM1'' gibi) : ');
%% bir sekilde sectirecegiz, ondan sonra iclerinden hangisi oldugunu tespit ettikten sonra gereken islemleri yapacagiz
%Mesela COM1 i baslatmak istersek sirasi ile index vs. girip port numarasi
%okuyarak bakacagiz 
%% DAHA sonra eklerim o kismi
%%NOT: OpenBy yaparken index oldugu gibi, serial, description ve
%%location(bu nasil �imdilik bilmiyorum) ile de a�abiliyoruz
if (1~=PortOBJ.IsOpen)
[status_OpenByIndex] =PortOBJ.OpenByIndex(0)
end
[status_GetCOMPort,GetCOMPort_name]=PortOBJ.GetCOMPort;
BaudRate=uint32(9600);%burada kullanmak �zere yazd�raca��m�z yeni baudrate(maalesef eski baudrate ne imi� okuma yok do�rudan yazd�r�yoruz di�er ozellikler gibi)
status_SetBaudRate=PortOBJ.SetBaudRate(BaudRate);%Burada yazzd�rd�k, diger tum ayarlarda da eski degeri gorme yok, dogrudan SET ederek kullanabiliyoruz.
%% data  gonderelim oncelikler
x = uint8([0,0,0,0,0,0]);
for k=0:9
[r,numWritten] = Write( PortOBJ, x, 21, 0);%Burada r status2u gosteriyor;num ise her an i�in gonderilen data(byte ) say�s�n�;objemizi g�sterdik;x ise gonderilen data , biz bunu 5 elemanl� ayarlad�k, eleman say�s� kafam�za gore olabilir istersek tek elemanl� ister 100 elemanl�;5 ise gonderilen data uzunlugu, burada o de�er x in kay byte' sini gonderece�imizi belirtmek �zere kullamn�lmakta yani hepsini gondermek zorunda de�iliz;en son num ise basta 0 versek te bu .NEt fn-unun geri donusunde toplam gonderilen byte say�s�n� tutmak uzere ayarlanm��t�r
System.Threading.Thread.Sleep(10);%Biraz uyuttuk sistemi
end
%% READ yapal�m
x=uint8(zeros(1,50));
data_adet=uint32(0);
num=uint32(0); 
  %NOT: Burada yazd���m�z 50 degeri bufferd e 50 tane deger dolunca bize
  %cevab� g�steriyor.... Buradaki 50 say�s�n� da muhtemelen Rx available
  %ile ayarlamam�z gerekecek
  %�rnegin
   rx_available=uint32(0);
   [status_rx,rx_available] =GetRxBytesAvailable(PortOBJ, rx_available);
   rx_ava_buff=rx_available;
   %
   for i=0:10000
   [status_rx,rx_available] =GetRxBytesAvailable(PortOBJ,rx_available);
    if  rx_ava_buff ~= rx_available %bura olmasa da olur ama olursa daha h�zl� �al���yor sistem....
        data_sayisi=rx_ava_buff-rx_available ;%farkini alalim
 [r,x,num] = Read( PortOBJ,rx_available, num);%Burada r status2u gosteriyor;num ise her an i�in gonderilen data(byte ) say�s�n�;objemizi g�sterdik;x ise gonderilen data , biz bunu 5 elemanl� ayarlad�k, eleman say�s� kafam�za gore olabilir istersek tek elemanl� ister 100 elemanl�;5 ise gonderilen data uzunlugu, burada o de�er x in kay byte' sini gonderece�imizi belirtmek �zere kullamn�lmakta yani hepsini gondermek zorunda de�iliz;en son num ise basta 0 versek te bu .NEt fn-unun geri donusunde toplam gonderilen byte say�s�n� tutmak uzere ayarlanm��t�r
 x
 %alinan datanin gorunmesi icin
 rx_ava_buff=rx_available;%son de�erini kullanal�m bundan sonra
   end    
 System.Threading.Thread.Sleep(10);
end