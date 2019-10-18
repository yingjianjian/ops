import ldap,ldap.modlist
import random
import wx
import passwd
import mails
conn = ldap.initialize('LDAP://192.168.9.9:389')
rest = conn.simple_bind_s('cn=admin,dc=isyscore,dc=com', 'westos')




class ldapc:
    def __init__(self,ldap_path,baseDN,ldap_authuser,ldap_authpass):
        self.baseDN=baseDN
        self.path=ldap_path
        self.user=ldap_authuser
        self.passwd=ldap_authpass
        self.ldap_error = None
        self.ldap_init=ldap.initialize(self.path)
        self.rest=self.ldap_init.simple_bind_s(self.user,self.passwd)

    def search_users(self,username):
        if self.ldap_error == None:
            try:
                searchScope = ldap.SCOPE_SUBTREE
                filter =  "uid=%s" % (username)
                attrs = ['cn', 'uid', 'employeeNumber']

                ldap_result =self.ldap_init.search_s(self.baseDN,searchScope,filter,None)
                if len(ldap_result) == 0:
                    return False
                else:
                    return ldap_result
            except ldap.LDAPError as err:
                return err

    def search_groups(self,group):
        if self.ldap_error == None:
            try:
                searchScope = ldap.SCOPE_SUBTREE
                filter = '(' + 'cn' + "=" + group +')'
                attrs = ['cn', 'uid', 'employeeNumber']
                ldap_result =self.ldap_init.search_s(self.baseDN,searchScope,filter,None)
                if len(ldap_result) == 0:
                    return False
                else:
                    return ldap_result
            except ldap.LDAPError as err:
                return err

if __name__ == "__main__":
    count=0
    groups=[]
    Path='LDAP://192.168.9.9:389'
    baseDN='ou=People,dc=isyscore,dc=com'
    ldap_authuser='cn=admin,dc=isyscore,dc=com'
    ldap_authpass='westos'
    a=ldapc(Path,baseDN,ldap_authuser,ldap_authpass)
    weixin = wx.weixin()
    list = weixin.getDep()
    for users in list:
        b = a.search_users(users['uid'])
        if not b:
            userID=random.randint(1000,10000)
            print(users['uid'],userID)
            homeDirectory='/home/%s' %(users['uid'])
            password=passwd.generate_passwd()
            dn = 'uid=%s,ou=People,dc=isyscore,dc=com' % (users['uid'])
            attr_list={}
            attr_list['objectClass'] = [b'posixAccount', b'shadowAccount', b'sambaSamAccount',b'top',b'inetOrgPerson',b'person']
            attr_list['uidNumber'] = str(userID).encode('utf-8')
            attr_list['gidNumber'] = str(users['groupId']).encode('utf-8')
            attr_list['homeDirectory'] = homeDirectory.encode('utf-8')
            attr_list['sambaSID'] = b'isyscore'
            attr_list['cn'] = users['cn'].encode('utf-8')
            attr_list['uid'] = users['uid'].encode('utf-8')
            attr_list['sn'] = users['uid'].encode('utf-8')
            attr_list['mobile'] = users['mobile'].encode('utf-8')
            attr_list['userPassword'] = password.encode('utf-8')
            attr_list['mail'] = users['email'].encode('utf-8')
            attr_list['sambaDomainName'] = b'isyscore.com'
            attr_list['sambaNTPassword'] = b'59E20FD06DF57F53D70CB2D6B3F9AFC7'
            # attr_list = [(ldap.MOD_ADD , 'objectClass', [b'posixAccount', b'shadowAccount', b'sambaSamAccount',b'top',b'inetOrgPerson']),
            #              (ldap.MOD_ADD , 'uidNumber', userID),
            #              (ldap.MOD_ADD, 'gidNumber', users['groupId']),
            #              (ldap.MOD_ADD , 'homeDirectory', homeDirectory.encode('utf-8')),
            #              (ldap.MOD_ADD , 'sambaSID', b'isyscore'),
            #              (ldap.MOD_ADD, 'cn', users['cn'].encode('utf-8')),
            #              (ldap.MOD_ADD, 'uid', users['uid'].encode('utf-8')),
            #              (ldap.MOD_ADD, 'sn', userID),
            #              (ldap.MOD_ADD, 'mobile', users['mobile'].encode('utf-8')),
            #              (ldap.MOD_ADD, 'userPassword', b'isyscore'),
            #              (ldap.MOD_ADD, 'mail', users['email'].encode('utf-8')),
            #              (ldap.MOD_ADD,'sambaDomainName', b'isyscore.com')]
            print(dn,attr_list)
            modlist = ldap.modlist.addModlist(attr_list)
            result = conn.add_s(dn, modlist)
            mails.smtprc(users['email'],users['cn'],users['uid'],password)
            count=count+1
            print(result,count)
        else:
            print("%s is already exist" % (users['uid']))



