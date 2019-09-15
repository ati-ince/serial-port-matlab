clear all,close all,clc;
FTDI_Assembly= NET.addAssembly('D:\DropBox_Dokunma\Dropbox\MATLAB_ati_ozel\SERIAL_PORT_USB_KISMI(_NET)\FTD2XX_NET.dll');
MS_NET_SerialPortClass=System.IO.Ports.SerialPort;
NET_GetPortName= System.IO.Ports.SerialPort.GetPortNames;%Burada tüm COM portlarýnýn ismini aldýk(MS .NET yardimi ile)
%% methodsview( 'FTD2XX_NET.FTDI');
FT_OK=FTD2XX_NET.FT_STATUS.FT_OK;%Burada da dogru-yanlis islem karsilastirmasi yapacagiz
disp('Kullanmaya uygun COM portlari:')
for i=1:NET_GetPortName.Length
    disp(NET_GetPortName(i))
end 
PortOBJ=FTD2XX_NET.FTDI;
GetNumberOfDevices_count=uint32(0);%Burasý uint32 buffer deðeri, içeriðinin ne olduðu önemli deðil kendisi deðiþtiriryor zaten
[status_GetNumberOfDevices,GetNumberOfDevices_count]=PortOBJ.GetNumberOfDevices(GetNumberOfDevices_count);%Burada kac tane FTDI cihaz bagli onu gormekteyiz
i=uint32(0);%Burada data tipi uint32 olmali imiþ
%% Burada bir sekilde hangisini istedigimizi seciyoruz
%ObjClass_SerialPort.PortName = input('Lutfen calismak istediginiz portu giriniz (Ornegin ''COM1'' gibi) : ');
%% bir sekilde sectirecegiz, ondan sonra iclerinden hangisi oldugunu tespit ettikten sonra gereken islemleri yapacagiz
%Mesela COM1 i baslatmak istersek sirasi ile index vs. girip port numarasi
%okuyarak bakacagiz 
%% DAHA sonra eklerim o kismi
%%NOT: OpenBy yaparken index oldugu gibi, serial, description ve
%%location(bu nasil þimdilik bilmiyorum) ile de açabiliyoruz
if (1~=PortOBJ.IsOpen)
[status_OpenByIndex] =PortOBJ.OpenByIndex(0)
end
[status_GetCOMPort,GetCOMPort_name]=PortOBJ.GetCOMPort;
BaudRate=uint32(9600);%burada kullanmak üzere yazdýracaðýmýz yeni baudrate(maalesef eski baudrate ne imiþ okuma yok doðrudan yazdýrýyoruz diðer ozellikler gibi)
status_SetBaudRate=PortOBJ.SetBaudRate(BaudRate);%Burada yazzdýrdýk, diger tum ayarlarda da eski degeri gorme yok, dogrudan SET ederek kullanabiliyoruz.
%% data  gonderelim oncelikler
x = uint8([0,0,0,0,0,0]);
for k=0:9
[r,numWritten] = Write( PortOBJ, x, 21, 0);%Burada r status2u gosteriyor;num ise her an için gonderilen data(byte ) sayýsýný;objemizi gösterdik;x ise gonderilen data , biz bunu 5 elemanlý ayarladýk, eleman sayýsý kafamýza gore olabilir istersek tek elemanlý ister 100 elemanlý;5 ise gonderilen data uzunlugu, burada o deðer x in kay byte' sini gondereceðimizi belirtmek üzere kullamnýlmakta yani hepsini gondermek zorunda deðiliz;en son num ise basta 0 versek te bu .NEt fn-unun geri donusunde toplam gonderilen byte sayýsýný tutmak uzere ayarlanmýþtýr
System.Threading.Thread.Sleep(10);%Biraz uyuttuk sistemi
end
%% READ yapalým
x=uint8(zeros(1,50));
data_adet=uint32(0);
num=uint32(0); 
  %NOT: Burada yazdýðýmýz 50 degeri bufferd e 50 tane deger dolunca bize
  %cevabý gösteriyor.... Buradaki 50 sayýsýný da muhtemelen Rx available
  %ile ayarlamamýz gerekecek
  %örnegin
   rx_available=uint32(0);
   [status_rx,rx_available] =GetRxBytesAvailable(PortOBJ, rx_available);
   rx_ava_buff=rx_available;
   %
   for i=0:10000
   [status_rx,rx_available] =GetRxBytesAvailable(PortOBJ,rx_available);
    if  rx_ava_buff ~= rx_available %bura olmasa da olur ama olursa daha hýzlý çalýþýyor sistem....
        data_sayisi=rx_ava_buff-rx_available ;%farkini alalim
 [r,x,num] = Read( PortOBJ,rx_available, num);%Burada r status2u gosteriyor;num ise her an için gonderilen data(byte ) sayýsýný;objemizi gösterdik;x ise gonderilen data , biz bunu 5 elemanlý ayarladýk, eleman sayýsý kafamýza gore olabilir istersek tek elemanlý ister 100 elemanlý;5 ise gonderilen data uzunlugu, burada o deðer x in kay byte' sini gondereceðimizi belirtmek üzere kullamnýlmakta yani hepsini gondermek zorunda deðiliz;en son num ise basta 0 versek te bu .NEt fn-unun geri donusunde toplam gonderilen byte sayýsýný tutmak uzere ayarlanmýþtýr
 x
 %alinan datanin gorunmesi icin
 rx_ava_buff=rx_available;%son deðerini kullanalým bundan sonra
   end    
 System.Threading.Thread.Sleep(10);
end