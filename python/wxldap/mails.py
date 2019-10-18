# !/usr/bin/python3

import smtplib
from email.mime.text import MIMEText
from email.header import Header
def  smtprc(receivers,name,username,passwd):
    # 第三方 SMTP 服务
    mail_host = "smtp.exmail.qq.com"  # 设置服务器
    mail_user = "devops@isyscore.com"  # 用户名
    mail_pass = "6KQKxrtL@E8FpkJ"  # 口令

    sender = 'devops@isyscore.com'
    message = MIMEText('%s 你好 你的LDAP的账号为%s,初始化密码为:%s\n后续修改密码请登录：http://192.168.9.9:8087'%(name,username,passwd), 'plain', 'utf-8')
    message['From'] = Header("运维", 'utf-8')
    message['To'] = Header("指令集", 'utf-8')

    subject = 'LDAP初始化密码'
    message['Subject'] = Header(subject, 'utf-8')

    try:
        smtpObj = smtplib.SMTP_SSL()
        smtpObj.connect(mail_host, 465)  # 25 为 SMTP 端口号
        smtpObj.login(mail_user, mail_pass)
        smtpObj.sendmail(sender, receivers, message.as_string())
        print("邮件发送成功")
    except smtplib.SMTPException:
        print("Error: 无法发送邮件")
