import os
import socket

admin = 1

def get_server_ip_address():
    hostname = socket.gethostname()
    IPAddr = socket.gethostbyname(hostname)
    #print("Your Computer Name is:" + hostname)
    #print("Your Computer IP Address is:" + IPAddr

    return IPAddr

def get_admin_status():
    return admin
