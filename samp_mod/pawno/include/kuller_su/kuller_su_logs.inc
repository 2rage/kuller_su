//���� ���������
#define CHATLOG "zombie/logs/chatlog.txt"// - ������
#define CRDLOG "zombie/logs/crdlog.txt"//connect registration disconnect - ������
#define KILLLOG "zombie/logs/deathlog.txt"//  - ������
#define BUYLOG "zombie/logs/buylog.txt"//������
#define MONEYLOG "zombie/logs/moneylog.txt"//������
#define ADMINLOG "zombie/logs/adminlog.txt"//������
#define ACLOG "zombie/logs/aclog.txt"//������
#define PMLOG "zombie/logs/pmlog.txt"//������

#define LOG_FORMAT "*[%02d.%02d.%02d:%02d:%02d:%02d]:%s\r\n"

stock WriteLog(PathLog[],string[])
{
	new IF;
	if(!fexist(PathLog)){IF = ini_createFile(PathLog);ini_closeFile(IF);}
    new text[256],computation1, computation2, computation3,year, month, day,File:LogFile,i;
    gettime(computation1, computation2, computation3);
    getdate(year, month, day);
    format(text, sizeof(text), LOG_FORMAT,day,month,year,computation1,computation2,computation3,string);
    LogFile = fopen(PathLog, io_append);
    while (text[i] != EOS)
    {
        fputchar(LogFile, text[i], false);
        i++;
    }
    fclose(LogFile);
    return 1;
}
