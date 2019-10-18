import requests

class weixin():
    def __init__(self):
        self.copyId = 'ww0de9b25972541baf'
        self.secret = '0EZoqwVJqRLQJwVNF_1ihfWf20Ee43a46g9gYuaneCA'
        self.headers = {"User-Agent":"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36"}
        self.result = dict()
        self.user = dict()
        self.users = list()
        self.userlist = list()
    def __getToken(self):
        tokenUrl = 'https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=%s&corpsecret=%s' %(self.copyId,self.secret)
        response = requests.get(tokenUrl,headers = self.headers,verify=False)
        re = response.json()
        token = re['access_token']
        return token

    def __getDepartment(self):
        DepartmentUrl = 'https://qyapi.weixin.qq.com/cgi-bin/department/list?access_token=%s' %(self.__getToken())
        response = requests.get(DepartmentUrl,headers = self.headers,verify=False)
        rs = response.json()
        departmentList = rs['department']
        return departmentList
    def getDep(self):
        for depId in self.__getDepartment():
            if depId['id'] == 1:
                pass
            else:
                getDeprUrl = 'https://qyapi.weixin.qq.com/cgi-bin/user/simplelist?access_token=%s&department_id=%s&fetch_child=0' %(self.__getToken(),depId['id'])
                response = requests.get(getDeprUrl,verify=False)
                result = response.json()
                users = result['userlist']
                for user in users:
                    userUrl = 'https://qyapi.weixin.qq.com/cgi-bin/user/get?access_token=%s&userid=%s' % (self.__getToken(), user['userid'])
                    response = requests.get(userUrl, headers=self.headers,verify=False)
                    result = response.json()
                    mobile = result['mobile']
                    email = result['email']
                    if email == "":
                        print("%s:没有设置email" %(user['name']))
                        pass
                    else:
                        userId = email.split('@')[0]
                        self.user = dict()
                        self.user['uid'] = userId
                        self.user['cn'] = user['name']
                        self.user['group'] = depId['name']
                        self.user['groupId'] = depId['id']
                        self.user['mobile'] = mobile
                        self.user['email'] = email
                        self.userlist.append(self.user)
        return self.userlist
if __name__ == "__main__":
    a= weixin()
    print(a.getDep())