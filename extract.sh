#! /usr/bin/env python

import sqlite3

import os.path
from lxml import html
con=sqlite3.connect('chrome_issues')
con.execute("PRAGMA busy_timeout = 3000")
cur=con.cursor()

a=".txt"
for x in range(1,2):
    string =str(x)+a
    path="D:\\chrome_raw\\raw_chrome_issue\\"
    print(path+string)
    if(os.path.isfile(path+string)):
        print (" reading text from the file", x)
        text_file=open(path+string,"r",encoding="ISO-8859-1")
        try:
            page=text_file.read()
            tree = html.fromstring(page)
            
            headings = tree.xpath('//div[@id="meta-float"]/table/tr/th/text()')
            temp= tree.xpath('//div[@id="meta-float"]/table/tr/td/span/text()')
            Status=temp[0]
            print(  'Status: ',Status)
            temp= tree.xpath('//div[@id="meta-float"]/table/tr/td/a/text()')
           
            if not temp:
              Owner=""
            else:
                Owner=temp[0].strip()
            print(  'Owner: ',Owner)
            temp= tree.xpath('//div[@id="issueheader"]/table/tbody/tr/td/span/text()')
            bugdisc =temp[0]
            print(  'bugdisc: ',bugdisc)
            print(  'Bug ID: ',x)
            #print(  'Date: ',CloseDate)
            temp= tree.xpath('//div[@id="meta-float"]/table/tr/td/div/a/text()')
            #print(  temp)
            Type=temp[0];
            Pri=temp[1];
            OS=temp[2];
            temp1= tree.xpath('//div[@id="meta-float"]/table/tr/td/div/a/b/text()')
            for i in range(0,len(temp1)):
                if('Type-' ==temp1[i] ):
                    Type=temp[i];
                elif('Pri-' ==temp1[i] ):
                    Pri=temp[i];
                elif('OS-' ==temp1[i] ):
                    OS=temp[i];
           
            cur.execute("insert into chrome values (?,?,?,?,?,?,?)",(x,bugdisc, Owner, Status,Type, Pri,OS))
            print(  'Type: ',Type)
            print(  'Pri: ',Pri)
            print(  'OS: ',OS)
            print("====================")
           # print(  'Area: ',Area)
        
            print("H")
        except IndexError:
            print("");

           
con.commit()
