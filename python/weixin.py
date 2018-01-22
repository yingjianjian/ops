#!/usr/bin/python
# -*- coding: UTF-8 -*-
import urllib,urllib2,json
import sys
reload(sys)
sys.setdefaultencoding( "utf-8" )
class WeChat(object):
    __token_id = ''
    def __init__(self,url):
        self.__url=url.rstrip('/')
        self.__corpid='wweb909f48b2953b8d'
        self.__secret='6FkM-CJhU64qUbAdmq6A4eGhFIHJrSHJC6VEkCGPt7w'
    def authID(self):
        params={'corpid':self.__corpid, 'corpsecret':self.__secret}
        data=urllib.urlencode(params)
        content=self.getToken(data)
        try:
            self.__token_id = content['access_token']
        except KeyError:
            raise KeyError
    def getToken(self,data,url_prefix='/'):
        url = self.__url+url_prefix+'gettoken?'
        try:
            response=urllib2.Request(url + data)
        except KeyError:
            raise KeyError
        result=urllib2.urlopen(response)
        content=json.loads(result.read())
        return content
    def postData(self,data,url_prefix='/'):
        url = self.__url+url_prefix+'message/send?access_token=%s' % self.__token_id
        try:
            result=urllib2.urlopen(url,data)
        except urllib2.HTTPError as e:
            if hasattr(e,'reason'):
                print 'reason',e.reason
            elif hasattr(e,'code'):
                print 'code',e.code
            return 0
        else:
            content=json.loads(result.read())
            result.close()
        return content
    def sendMessages(self,touser,message):
        self.authID()
        data=json.dumps(
            {
                "touser": touser,
                "msgtype": "text",
                "agentid": "1000002",
                "text": {
                    "content": message
                },
                "safe": "0"
            }
        ,ensure_ascii=False)
        response=self.postData(data)
        print response
if __name__=='__main__':
    a=WeChat('https://qyapi.weixin.qq.com/cgi-bin')
    a.sendMessages(sys.argv[1],sys.argv[3])

