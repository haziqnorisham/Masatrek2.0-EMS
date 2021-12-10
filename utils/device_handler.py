
import sys
import os
import json
import base64
import pprint

import requests

from utils import general
from utils import dbase_handler
from utils import config_handler

def get_all_user(term_id):

    terminal_details = dbase_handler.get_terminal_details(term_id)
    ip_addr = terminal_details[2]

    url = 'http://' + ip_addr + '/action/SearchPersonList'
    headers =   {
                    'Content-Type': "application/json",
                    'Accept': "*/*",
                    'Cache-Control': "no-cache",
                    'Host': ip_addr,
                    'Accept-Encoding': "gzip, deflate",
                    'Content-Length': "",
                    'Connection': "keep-alive",
                    'cache-control': "no-cache"
                }

    body =      {
                    "operator": "SearchPersonList",
                    "info":{
                        "DeviceID":int(term_id),
                        "PersonType":2,
                        "BeginTime":"",
                        "EndTime":"",
                        "Name":"",
                        "RequestCount":500
                    }
                }

    response = requests.request("POST",url, headers=headers, auth=requests.auth.HTTPBasicAuth("admin", "admin"), json=body)
    json_data = json.loads(response.text)
    return json_data

def get_device_param(ip_addr, username, password):

    url = 'http://' + ip_addr + '/action/GetSysParam'

    response = requests.request("POST",url, auth=requests.auth.HTTPBasicAuth(username, password))    

    json_data = json.loads(response.text)    

    return str(json_data["info"]["DeviceID"])

def set_device_subscribe(device_id, ip_addr, username, password):

    url = 'http://' + ip_addr + '/action/Subscribe'
    server_ip = 'http://' + config_handler.get_server_ip() + ':' + config_handler.get_server_port()
    print(server_ip)
    body =  {
                "operator": "Subscribe",
                "info": {
                    "DeviceID": int(device_id),
                    "Num": 2,
                    "Topics":["Snap", "VerifyWithSnap"],
                    "SubscribeAddr":"http://192.168.0.183:8080",
                    "SubscribeUrl":{"Snap":"/Subscribe/Snap", "Verify":"/Subscribe/Verify", "HeartBeat":"/Subscribe/heartbeat"},
                    "Auth":"Basic",
                    "User": "admin",
                    "Pwd": "admin",
                    "BeatInterval":5
                    }
            }

    response = requests.request("POST", url, auth=requests.auth.HTTPBasicAuth(username, password), json=body)
    json_data = json.loads(response.text)
    print(json_data)

def register_user(device_id, user_id, blacklist, name, img_name):

    terminal_details = dbase_handler.get_terminal_details(device_id)
    ip_addr = terminal_details[2]

    with open(os.getcwd()+"/static/snapshot/" + img_name+".jpg", "rb") as image_file:
        encoded_string = base64.b64encode(image_file.read())

    picjson = "data:image/jpeg;base64,"+encoded_string.decode("utf-8")

    url = 'http://' + ip_addr + '/action/AddPerson'

    body =  {
                "operator": "AddPerson",
                "info": {
                    "DeviceID":int(device_id),
                    "IdType":2,
                    "PersonType": blacklist,
                    "Name":name,
                    "PersonUUID":user_id,
                    "Native": "",
                    "Tempvalid": 0
                    },
                    "picinfo": picjson
            }

    try:
        response = requests.request("POST",url, auth=requests.auth.HTTPBasicAuth("admin", "admin"), json=body)
        json_data = json.loads(response.text)
        print(json_data)
    except Exception as e:
        x = None

def register_to_all(nric):
    all_terminal = dbase_handler.get_all_terminals()
    
    for terminal in all_terminal:
        user = dbase_handler.get_employee_details(nric)
        register_user(terminal[0],user[1],0,user[3],user[0])

    return None

def edit_user(device_id, user_id, blacklist):
    terminal_details = dbase_handler.get_terminal_details(device_id)
    ip_addr = terminal_details[2]

    url = 'http://' + ip_addr + '/action/EditPerson'

    body =  {
                
                "operator": "EditPerson",
                "info": {
                            "DeviceID":int(device_id),
                            "IdType":2,
                            "PersonUUID": user_id,
                            "PersonType": blacklist
                        }
            }

    response = requests.request("POST",url, auth=requests.auth.HTTPBasicAuth("admin", "admin"), json=body)
    json_data = json.loads(response.text)
    print(json_data)

def sync(term_id):
    total_num_registered = get_total_registered_user(term_id)
    all_employee = dbase_handler.get_all_employee()

    if total_num_registered != len(all_employee):
        if total_num_registered != 0:
            while(True):
                user_id = get_first_user(term_id)
                if user_id == 0:
                    break
                else:
                    delete_user(term_id, user_id)
        else:            
            for employee in all_employee:
                pp = pprint.PrettyPrinter()
                user_details = dbase_handler.get_employee_details(employee[0])
                pp.pprint(user_details)
                register_user(term_id, user_details[1], 0, user_details[3], user_details[0])

    '''
    terminal_details = dbase_handler.get_terminal_details(term_id)
    ip_addr = terminal_details[2]
    username = terminal_details[3]
    password = terminal_details[4]

    all_users_from_terminal = get_all_user(term_id)
    all_users_from_dbase = dbase_handler.get_all_employee()

    try:
        try:
            print(all_users_from_terminal["info"]["Result"])
        except Exception as identifier:
            pass
        print("from Terminal Num = " + str(all_users_from_terminal["info"]["Totalnum"]))
        print("from dbase Num = " + str(len(all_users_from_dbase)))

        if all_users_from_terminal["info"]["Totalnum"] == len(all_users_from_dbase):
            print("1.0")
            for users in all_users_from_dbase:
                for terminal_users in all_users_from_terminal["info"]["List"]:
                    print(terminal_users["PersonType"])
                    if terminal_users["PersonType"] == dbase_handler.get_user_access_terminal(users[6], term_id)[0]:
                        print("SAME BLACKLIST")
                    else:
                        edit_user(term_id, users[6], dbase_handler.get_user_access_terminal(users[6], term_id)[0])
        elif all_users_from_terminal["info"]["Totalnum"] >len(all_users_from_dbase):
            
            for i, employee in enumerate(all_users_from_terminal["info"]["List"]):
                status = "no_match"
                for usr_dbase in all_users_from_dbase:
                    if str(usr_dbase[6]) == employee["PersonUUID"]:
                        status = "match"
                if status == "no_match":
                    delete_user(term_id, employee["PersonUUID"])
        else:
            raise Exception("Sorry, no numbers below zero")
    except:
        e = sys.exc_info()[0]
        print(e)
        for users in all_users_from_dbase:
            blacklist = dbase_handler.get_user_access_terminal(users[6], term_id)[0]
            register_user(term_id, users[6], blacklist, users[1], users[2])
    '''

def reset_device_subscription(term_id):

    terminal_details = dbase_handler.get_terminal_details(term_id)
    ip_addr = terminal_details[2]

    url = 'http://' + ip_addr + '/action/Subscribe'
    server_ip = 'http://' + '0.0.0.0' + ':8080'
    print(server_ip)
    body =  {
                "operator": "Subscribe",
                "info": {
                    "DeviceID": int(term_id),
                    "Num": 2,
                    "Topics":["Snap", "VerifyWithSnap"],
                    "SubscribeAddr":server_ip,
                    "SubscribeUrl":{"Snap":"/Subscribe/Snap", "Verify":"/Subscribe/Verify", "HeartBeat":"/Subscribe/heartbeat"},
                    "Auth":"Basic",
                    "User": "admin",
                    "Pwd": "admin",
                    "BeatInterval":5
                    }
            }

    response = requests.request("POST", url, auth=requests.auth.HTTPBasicAuth('admin', 'admin'), json=body)
    json_data = json.loads(response.text)
    print(json_data)

def reset_device_list(term_id):

    terminal_details = dbase_handler.get_terminal_details(term_id)
    ip_addr = terminal_details[2]

    url = 'http://' + ip_addr + '/action/SetFactoryDefault'
    
    body =  {   "operator": "SetFactoryDefault",
                "info": {
                "DefaltDoorSet": 0,
                "DefaltSoundSet": 0,
                "DefaltNetPar": 0,
                "DefaltCenterPar": 0,
                "DefaltCapture": 0,
                "DefaltLog": 0,
                "DefaltPerson": 1,
                "DefaltRecord": 0,
                "DefaltMaintainTime": 0,
                "DefaltSystemSettings": 0,
                "DefaltEnterIPC": 0,
                "DefaltServerBasicPara": 0,
                "DefaltWorktype": 0
                }
            }

    response = requests.request("POST", url, auth=requests.auth.HTTPBasicAuth('admin', 'admin'), json=body)
    json_data = json.loads(response.text)
    print(json_data)

def delete_user(device_id, user_id):

    try:
        terminal_details = dbase_handler.get_terminal_details(device_id)
        ip_addr = terminal_details[2]

        url = 'http://' + ip_addr + '/action/DeletePerson'

        body =  {
                    "operator": "DeletePerson",
                    "info": {
                        "DeviceID":int(device_id),
                        "TotalNum":1,
                        "IdType":2,
                        "PersonUUID":[str(user_id)]
                        }
                }

        response = requests.request("POST",url, auth=requests.auth.HTTPBasicAuth("admin", "admin"), json=body)
        json_data = json.loads(response.text)
        print(json_data)
    except Exception as e:
        print(e)

def delete_user_from_all_terminal(user_id):
    terminal_list = dbase_handler.get_all_terminals()
    for terminals in terminal_list:
        delete_user(terminals[0], user_id)

def get_total_registered_user(term_id):

    terminal_details = dbase_handler.get_terminal_details(term_id)
    ip_addr = terminal_details[2]

    url = 'http://' + ip_addr + '/action/SearchPersonList'
    headers =   {
                    'Content-Type': "application/json",
                    'Accept': "*/*",
                    'Cache-Control': "no-cache",
                    'Host': ip_addr,
                    'Accept-Encoding': "gzip, deflate",
                    'Content-Length': "",
                    'Connection': "keep-alive",
                    'cache-control': "no-cache"
                }

    body =      {
                    "operator": "SearchPersonList",
                    "info":{
                        "DeviceID":int(term_id),
                        "PersonType":2,
                        "BeginTime":"",
                        "EndTime":"",
                        "Name":"",
                        "RequestCount":500
                    }
                }

    response = requests.request("POST",url, headers=headers, auth=requests.auth.HTTPBasicAuth("admin", "admin"), json=body)
    json_data = json.loads(response.text)
    try:
        total_registered = json_data['info']['Totalnum']
    except Exception as e:
        total_registered = 0
    return total_registered

def get_first_user(term_id):

    terminal_details = dbase_handler.get_terminal_details(term_id)
    ip_addr = terminal_details[2]

    url = 'http://' + ip_addr + '/action/SearchPersonList'
    headers =   {
                    'Content-Type': "application/json",
                    'Accept': "*/*",
                    'Cache-Control': "no-cache",
                    'Host': ip_addr,
                    'Accept-Encoding': "gzip, deflate",
                    'Content-Length': "",
                    'Connection': "keep-alive",
                    'cache-control': "no-cache"
                }

    body =      {
                    "operator": "SearchPersonList",
                    "info":{
                        "DeviceID":int(term_id),
                        "PersonType":2,
                        "BeginTime":"",
                        "EndTime":"",
                        "Name":"",
                        "BeginNO":0,
                        "RequestCount":1
                    }
                }

    response = requests.request("POST",url, headers=headers, auth=requests.auth.HTTPBasicAuth("admin", "admin"), json=body)
    json_data = json.loads(response.text)
    try:
        user_details = json_data['info']['List'][0]
        user_details = user_details['PersonUUID']
    except Exception as e:
        user_details = 0
    return user_details