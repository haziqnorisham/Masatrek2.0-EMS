'''
    __  ______   _____ ___  __________  ________ __
   /  |/  /   | / ___//   |/_  __/ __ \/ ____/ //_/
  / /|_/ / /| | \__ \/ /| | / / / /_/ / __/ / ,<
 / /  / / ___ |___/ / ___ |/ / / _, _/ /___/ /| |
/_/  /_/_/  |_/____/_/  |_/_/ /_/ |_/_____/_/ |_|
'''
from configparser import ConfigParser

from utils import general

#run when module is imported
config = ConfigParser()

if not config.read('conf.ini'):
    print('CONFIG FILE NOT FOUND!!')

    print('GENERATING CONVIG FILE...')
    config['SERVER']={  'SERVER_IP_ADDRESS'    : '192.168.0.199',
                        'SERVER_PORT'          : '8080' }

    with open('conf.ini', 'w') as configFile:
        config.write(configFile)
        print('CONFIG FILE SAVED')

else:
    print('Succesfully Load Configuration File.')

def get_server_ip():
    """Get server ip address from config file, detect server ip from pc if
    server ip in config file is set to 0.0.0.0

    Returns:
        String: server ip address
    """
    ip_address = config.get('SERVER', 'SERVER_IP_ADDRESS')
    if ip_address == '0.0.0.0':
        ip_address = general.get_server_ip_address()

    return ip_address

def get_server_port():
    """Get server port number from config file, set server port number to 8080 if 
    value in config file is 0

    Returns:
        String: Server port number
    """
    port_num = config.get('SERVER', 'SERVER_PORT')
    if port_num == '0':
        port_num = '8080'
    return port_num
