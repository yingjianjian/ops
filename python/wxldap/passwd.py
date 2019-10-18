from random import choice
import string

passwd_length = 8
passwd_count = 1

number = string.digits          #通过string.digits 获取所有的数字的字符串 如：'0123456789'
Letter = string.ascii_letters   #通过string.ascii_letters 获取所有因为字符的大小写字符串 'abc....zABC.....Z'

passwd = number + Letter   #定义生成密码是组成密码元素的范围   字符+数字+大小写字母

def generate_passwd(*args,**kwargs):
    passwd_lst = []
    while (len(passwd_lst) < passwd_length):
        passwd_lst.append(choice(passwd))   #把循环出来的字符插入到passwd_lst列表中
    return ''.join(passwd_lst)              #通过''.join(passwd_lst)合并列表中的所有元素组成新的字符串

if __name__ == '__main__':
    for i in range(0,passwd_count):
        print(generate_passwd())