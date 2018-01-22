# coding: UTF-8
#! /usr/local/bin/python3.6
import xlwt
import cx_Oracle
import os
import csv,time
import datetime
os.environ['NLS_LANG'] = 'SIMPLIFIED CHINESE_CHINA.UTF8'
conn=cx_Oracle.connect('newsoft','econage','*********/*******')
cr=conn.cursor()
sql="""select case ecl_tasks.status_id when 1 then '***' when 3 then '***' end  *** ,ecl_request_sheet.request_desc ***,
ecl_request_sheet.str_att_1 ***,to_char(ecl_tasks.create_date, 'yyyy-mm-dd') ***,to_char(sysdate,'YYYY-MM-DD')as ****,
trunc(sysdate-ecl_tasks.create_date) ***,ecl_request_sheet.create_user_id ***,ecl_tasks.assignee_name *** ,
user_table.user_id ***,user_table.mi ***
from ecl_request_sheet
inner join ecl_tasks on ecl_tasks.request_id=ecl_request_sheet.request_id inner join user_table on ecl_tasks.assignee = user_table.myws_id where ecl_request_sheet.folder_id=0 and ecl_request_sheet.status_id=1
and ecl_tasks.status_id in (1,3) AND user_table.mi not in ('******','******','******'','******','******','******','******')
and ecl_tasks.create_date between '***' and sysdate and to_char(trunc(sysdate-ecl_tasks.create_date))<>0 order by user_table.mi
"""
cr.execute(sql)
rs=cr.fetchall()
lenrs=len(rs)
wb = xlwt.Workbook()
ws = wb.add_sheet('***')
ws.write(0, 0, "****")
ws.write(0, 1, "*")
ws.write(0, 2, "***")
ws.write(0, 3, "*")
ws.write(0, 4, "*")
ws.write(0, 5, "*")
ws.write(0, 6, "*")
ws.write(0, 7, "*")
ws.write(0, 8, "*")
ws.write(0, 9, "*")
for i in range(1,lenrs+1):
    for j in range(0,10):
        cwidth = ws.col(j).width
        rsr=str(rs[i-1][j])
        if (len(rsr) * 450) > cwidth:
            ws.col(j).width=(len(rs[i-1][j])*450)
        ws.write(i,j,rs[i-1][j])
Time=time.strftime("%Y%m%d")
TC="截止到"+str(Time)+"_17点大于一天以上*********+"共"+str(lenrs)+"条"+".xls"
dirname="/home/liucheng/date/%s/" %(Time)
dirTC=dirname+TC
if os.path.exists(dirname):
    wb.save(dirTC)
else:
    print("dir is not exists")
