import re
import subprocess
import shutil
import uuid
import os
def read_ic():
    visitor_ic = None
    visitor_name = None
    #subprocess.check_output([r'C:\MyKad_Reader\SDK_App\automatic_reader.bat'])
    ghj = subprocess.run([r'C:\MyKad_Reader\SDK_App\automatic_reader.bat'], capture_output=True, text=True)
    image_name = str(uuid.uuid1())
    try:
        shutil.copyfile('C:\\MyKad_Reader\\SDK_App\\photo.jpg', os.getcwd()+'\\static\\snapshot\\' + image_name + '.jpg')    

        file = open('C:\\MyKad_Reader\\SDK_App\\output.txt', 'r')
        content = file.readlines()

        for line in content:
            
            ic = "IC:"
            do_print = True
            
            for i, char in enumerate(ic):        
                try:
                    if line[i] == char:
                        pass
                    else:
                        do_print = False
                except Exception as e:
                    pass
                
            if "Name:" in line:
                print(repr(line))
                colon_loc = line.find(':')        
                line_split = line.split()
                name = ''
                for parts in line_split:
                    if parts == "Name:":
                        pass
                    else:
                        name = name + parts + " "

                print(name)
                visitor_name = name
                
            if do_print is True:
                print()
                print(repr(line))
                line_split = line.split()
                name = ''
                for parts in line_split:
                    if parts == "IC:":
                        pass
                    else:
                        name = name + parts + " "

                print(name)
                visitor_ic = name

        return [visitor_ic, visitor_name, image_name]

    except Exception as e:
        return False

   