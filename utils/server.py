#    __  ______   _____ ___  __________  ________ __
#   /  |/  /   | / ___//   |/_  __/ __ \/ ____/ //_/
#  / /|_/ / /| | \__ \/ /| | / / / /_/ / __/ / ,<
# / /  / / ___ |___/ / ___ |/ / / _, _/ /___/ /| |
#/_/  /_/_/  |_/____/_/  |_/_/ /_/ |_/_____/_/ |_|

import os
import json
import csv
import uuid
import time
from datetime import date, datetime, timedelta
import pprint
import base64
from sqlite3.dbapi2 import DatabaseError, Timestamp
from typing import cast
from reportlab.pdfgen import canvas 
from reportlab.lib.pagesizes import A4

from bottle_flash2 import FlashPlugin
from bottle import Bottle, Request, run, post, request, get, route, template, static_file, redirect, response
import requests

from utils import config_handler, device_handler
from utils import dbase_handler

def start():
    #pylint: disable=unused-variable, invalid-name

    server_ip = config_handler.get_server_ip()
    server_port = int(config_handler.get_server_port())

    @get('/')
    def home():
        if request.get_cookie("logged_in"):
            dates_for_week = []

            today = date.today()
            unique_visitor_count = dbase_handler.get_unique_visitor(today)
            visitor_count =  len(dbase_handler.get_all_employee())
            terminal_count =  len(dbase_handler.get_all_terminals())
            my_date = date.today()
            year, week_num, day_of_week = my_date.isocalendar()

            d = str(my_date.year) + "-W" + str(week_num)
            r = datetime.strptime(d + '-1', "%Y-W%W-%w")
            i = 0
            while i < 7 :
                dates_for_week.append(str((r + timedelta(days = i)).date()))
                i+=1

            week_unique_visitor = dbase_handler.get_current_week_unique_visitor(dates_for_week)      

            all_terminal_usage = dbase_handler.get_all_terminal_usage()

            return template("./static/index", unique_visitor_count = unique_visitor_count,
                week_unique_visitor = week_unique_visitor, terminal_count = terminal_count,
                visitor_count = visitor_count, all_terminal_usage = all_terminal_usage,
                dates_for_week = dates_for_week, request = request)
        else:
            redirect("/login")

    @get('/login')
    def login():
        return template("./static/login")
    
    @get('/logout')
    def logout():
        response.delete_cookie('logged_in')
        response.delete_cookie('staff_id')
        redirect('/')

    @post('/login_check')
    def login_check():
        staff_id = request.forms.get("user_id")
        password = request.forms.get("password")
        verify_login = dbase_handler.verify_login(staff_id, password)
        if len(verify_login) > 0:
            response.set_cookie("logged_in", "yes")
            response.set_cookie("staff_id", staff_id)
            if (verify_login[0][1] == 1):
                response.set_cookie("admin", '1')
                redirect("/")
            else:
                response.set_cookie("admin", '0')
                redirect("/attendance_summary")
            
            
        else:
            redirect("/login")
    
    @get('/employee_management')
    def employee_management():
        if request.get_cookie("logged_in"):
            
            all_visitor = dbase_handler.get_all_employee()
            department_list = dbase_handler.get_all_departments()
            all_terminal = dbase_handler.get_all_terminals()
            shift_list = dbase_handler.get_all_shifts()

            return template('./static/employee_management', shift_list = shift_list, all_terminal = all_terminal, department_list = department_list, app = app, all_visitor = all_visitor, request = request)
        else:
            redirect("/login")

    @post('/employee_management/add_employee')
    def add_employee():

        employee_image = request.forms.image_name
        employee_name = request.forms.employee_name
        employee_id = request.forms.employee_id
        department = request.forms.department
        shift = request.forms.shift
        position = request.forms.position
        access = request.forms.getlist("access_terminal")
        
        print()
        print("ACCESS TERMINAL")
        print(access)
        print()

        try:
            dbase_handler.insert_employee(employee_name, employee_image, "",
                employee_id, position, employee_id,
                department, shift)

            device_handler.register_to_all(employee_id)
            
            user_id = dbase_handler.get_employee_details(employee_id)[1]

            dbase_handler.update_access_employee(user_id,access)

            for access_detail in dbase_handler.get_user_access(user_id):
                    try:
                        device_handler.edit_user(access_detail[0], user_id, access_detail[1])
                    except Exception as e:
                        print(None)

            app.flash("success", "Successfully added visitor " + employee_id)
        except Exception as e:
            app.flash("danger", e)

        redirect("/employee_management")

    @post('/employee_management/edit_employee')
    def edit_visitor():

        button = request.forms.modal_button

        if button == "submit":
            image_name = request.forms.image_name
            employee_name = request.forms.modal_employee_name
            employee_id = request.forms.modal_employee_id
            department_id = request.forms.modal_department
            shift_id = request.forms.modal_shift
            employee_position = request.forms.modal_position
            access_terminal = request.forms.getlist("access_terminal")
            user_id = dbase_handler.get_employee_details(employee_id)[1]

            try:
                dbase_handler.update_access_employee(user_id, access_terminal)

                for access_detail in dbase_handler.get_user_access(user_id):
                    try:
                        device_handler.edit_user(access_detail[0], user_id, access_detail[1])
                    except Exception as e:
                        print(None)

                dbase_handler.edit_employee(employee_id, image_name, employee_name,
                    department_id, shift_id, employee_position)
                app.flash("success", "Successfully Updates Employee " + employee_name)
                
            except Exception as e:
                app.flash("danger", e)

        else:
            employee_id = request.forms.modal_employee_id
            employee_name = request.forms.modal_employee_name
            try:                
                dbase_handler.delete_employee(employee_id)
                app.flash("success", "Successfully Deleted " + employee_name)
            except Exception as e:
                app.flash("danger", e)                

        redirect("/employee_management")

    @get('/device_management')
    def device_management():
        if request.get_cookie("logged_in"):
            all_terminal = dbase_handler.get_all_terminals()

            return template('./static/device_management', all_terminal=all_terminal, request = request)
        else:
            redirect("/login")

    @post('/device_management/add_device')
    def add_device():
        terminal_name = request.forms.terminal_name
        terminal_ip_address = request.forms.terminal_ip_address
        terminal_username = request.forms.terminal_username
        terminal_password = request.forms.terminal_password

        terminal_id = device_handler.get_device_param(terminal_ip_address, terminal_username, terminal_password)
        
        dbase_handler.insert_terminal(terminal_id, terminal_name, terminal_ip_address, terminal_username, terminal_password)
        device_handler.set_device_subscribe(terminal_id, terminal_ip_address, terminal_username, terminal_password)

        redirect('/device_management')

    @get('/shift_management')
    def shift_management():
        if request.get_cookie("logged_in"):
            shift_list =  dbase_handler.get_all_shifts()            
            return template('./static/shift_management', app = app, request = request, shift_list = shift_list)
        else:
            redirect("/login")

    @post('/shift_management/add_shift')
    def add_shift():

        shift_name = request.forms.shift_name
        shift_start_time = request.forms.shift_start_time
        shift_end_time = request.forms.shift_end_time

        try:
            dbase_handler.insert_shift(shift_name, shift_start_time, shift_start_time, shift_end_time, shift_end_time, 0)
            app.flash("success", "Successfully added shift " + shift_name)
        except Exception as e:
            app.flash("danger", e)

        redirect("/shift_management")

    @post('/shift_management/edit_shift')
    def edit_shift():
        shift_id = request.forms.shift_id
        shift_name = request.forms.shift_name
        shift_start_time = request.forms.shift_start_time
        shift_end_time = request.forms.shift_end_time
        button_type = request.forms.button

        try:
            if button_type == "delete":
                dbase_handler.delete_shift(shift_id)
                app.flash("success", "Successfully deleted shift " + shift_name)
            else:
                dbase_handler.edit_shift(shift_id, shift_name, shift_start_time, shift_end_time)
                app.flash("success", "Successfully Updated shift " + shift_name)
        except Exception as e:
            app.flash("danger", e)
        redirect("/shift_management")

    @get('/department_management')
    def department_management():
        if request.get_cookie("logged_in"):
            department_list = dbase_handler.get_all_departments()
            return template('./static/department_management', app = app, request = request, department_list = department_list)
        else:
            redirect("/login")

    @post('/department_management/add_department')
    def add_department():
        
        department_name = request.forms.department_name
        department_description = request.forms.department_description

        try:
            dbase_handler.insert_department(department_name, department_description)
            app.flash("success", "Successfully added department " + department_name)
        except Exception as e:
            app.flash("danger", e)

        redirect('/department_management')

    @post('/department_management/edit_department')
    def edit_department():
        department_id = request.forms.modal_department_id
        department_name = request.forms.modal_department_name
        department_description = request.forms.modal_department_description

        if request.forms.button == "submit":
            try:
                dbase_handler.udpate_department(department_id, department_name, department_description)
                app.flash("success", "Successfully edited department " + department_name)
            except Exception as e:
                app.flash("danger", e)
        else:
            try:
                dbase_handler.delete_department(department_id)
                app.flash("success", "Succesfully deleted department " + department_name)
            except Exception as e:
                app.flash("danger", e)

        redirect('/department_management')

    @post('/ajax_test')
    def ajax_test():
           
        terminal_ip = request.forms.terminal_ip

        try:
            device_handler.get_device_param(terminal_ip,'admin', 'admin')
            return "success"
        except Exception as e:
            return "failed"

    @get('/visitor_management/ajax_get_latest_image')
    def ajax_get_latest_image():
        latest_image_list = dbase_handler.get_latest_image_list()
        return json.dumps(latest_image_list)

    @get('/attendance_management')
    def attendance_management():
        if request.get_cookie("logged_in"):
            #Check if there is a date specifed, if no date is specified, default to today's date
            if (request.query.from_date == '') or (request.query.to_date == ''):
                from_date = date.today()
                to_date = date.today()
            else:
                from_date = request.query.from_date
                to_date = request.query.to_date

            if (request.query.first_terminal == '') or (request.query.last_terminal == ''):
                selected_first_terminal = '0'
                selected_last_terminal = '0'
            else:
                selected_first_terminal = request.query.first_terminal
                selected_last_terminal = request.query.last_terminal

            if request.query.search_name == '':
                search_name = ""
            else:
                search_name = request.query.search_name

            attendance_list = dbase_handler.get_all_employee_attendance_date(from_date, to_date, selected_first_terminal, selected_last_terminal, search_name)

            pp = pprint.PrettyPrinter()
            #pp.pprint(attendance_list)

            all_terminal_details = dbase_handler.get_all_terminals()

            #pp.pprint(selected_first_terminal)

            report_name = uuid.uuid4().hex
            report_filename = os.getcwd() + '/static/reports/' + report_name + '.csv'
            with open(report_filename, 'w', newline='') as report_file:
                writer = csv.writer(report_file)
                writer.writerows(attendance_list)

            return template('./static/attendance_management', report_name = report_name, app = app, search_name = search_name, request = request, selected_last_terminal = selected_last_terminal, selected_first_terminal = selected_first_terminal, all_terminal_details = all_terminal_details, from_date = from_date, to_date = to_date, attendance_list = attendance_list)
        else:
            redirect("/login")

    @get('/attendance_print')
    def attendance_print():
        return template('./static/attendance_print')

    @post('/attendance_management/ajax_detailed_view')
    def ajax_detailed_view():
        user_id = request.forms.user_id
        date = request.forms.date

        detailed_attendance = dbase_handler.get_user_detailed_attendance(date, user_id)

        return json.dumps(detailed_attendance)

    @get('/attendance_summary')
    def attendance_summary():
        if request.get_cookie("logged_in"):

            #set attendance search filters to include all terminal
            selected_first_terminal = '0'
            selected_last_terminal = '0'            

            #get staff_id from set cookies
            search_name = request.get_cookie("staff_id")            

            #get today's date
            dt = date.today()

            #get date for start of week & end of week.
            #from_date = today's date - day number of current week e.g. 0 = monday, 1 = tuesday
            #to_date = start of week date + 6 days
            from_date = dt - timedelta(days=dt.weekday())
            to_date = from_date + timedelta(days=6)

            attendance_list = dbase_handler.get_employee_attendance_summary(search_name)

            all_terminal_details = dbase_handler.get_all_terminals()

            return template('./static/attendance_summary',
                app = app,
                search_name = search_name,
                request = request,
                all_terminal_details = all_terminal_details,
                attendance_list = attendance_list)

        else:
            redirect("/login")

    @post('/attendance_summary/remote_clock')
    def remote_clock():
        import pytz

        MY_TIME = pytz.timezone('Asia/Kuala_Lumpur')
        employee_id = request.forms.get("employee_id")
        employee_details = dbase_handler.get_employee_details(employee_id)

        timestamp = datetime.now(MY_TIME)
        timestamp = timestamp.strftime("%Y-%m-%d %H:%M:%S")
        
        server_ip = 'http://' + config_handler.get_server_ip() + ':' + config_handler.get_server_port()

        url = server_ip + '/Subscribe/Verify'
        headers =   {
                        'Content-Type': "application/json",
                        'Accept': "*/*",
                        'Cache-Control': "no-cache",
                        'Host': config_handler.get_server_ip() + ':' +config_handler.get_server_port(),
                        'Accept-Encoding': "gzip, deflate",
                        'Content-Length': "",
                        'Connection': "keep-alive",
                        'cache-control': "no-cache"
                    }

        body =  {
                "info": {
                    "CreateTime": timestamp,
                    "Name": "Muhammad Haziq Bin Norisham",
                    "PersonUUID": employee_details[1],
                    "PersonType": "0",
                    "DeviceID": "1",
                    "Temperature": "0"
                },
                "SanpPic": "base64:idshsfjawrfiwaier3q8294qt4ijfs"
                }

        response = requests.request("POST",url, headers=headers ,json=body)

        redirect("/attendance_summary")


    @post('/attendance_summary/add_comment')
    def add_comment():

        comment = request.forms.get("comment")
        attendance_date = request.forms.get("attendance_date")

        unique_id = uuid.uuid4().hex
        try:
            upload = request.files.get('file_upload')                                
            file_name = unique_id + "/" + upload.filename
            os.mkdir(os.getcwd() + "/static/uploads/" + unique_id )
            upload.save(os.getcwd() + "/static/uploads/" + unique_id + "/")
        except Exception as e:
            file_name = None

        try:
            dbase_handler.update_employee_attendance_comment(request.get_cookie("staff_id"),
                attendance_date, comment, file_name)
            app.flash("success", "Succesfully updated comment " + comment)
        except Exception as e:
            app.flash("danger", e)
        redirect('/attendance_summary')

    @get("/testing")
    def testing():
        return template('./static/debug')

    @post("/testing")
    def testing_form():
        print()
        print(request.forms.getlist("subscribe"))
        print()
        redirect("/testing")

    @get('/debug')
    def debug():
        pdf = canvas.Canvas("test_report.pdf", pagesize = A4)
        pdf.setTitle("Test Report")
        text = pdf.beginText(40, 680)
        text.setFont("Courier", 18)
        textLines = [
        'The Tasmanian devil (Sarcophilus harrisii) is',
        'a carnivorous marsupial of the family',
        'Dasyuridae.'
        ]
        for line in textLines:
            text.textLine(line)

        pdf.drawText(text)
        pdf.drawString(100,810, 'x100')
        pdf.drawString(200,810, 'x200')
        pdf.drawString(300,810, 'x300')
        pdf.drawString(400,810, 'x400')
        pdf.drawString(500,810, 'x500')

        pdf.drawString(10,100, 'y100')
        pdf.drawString(10,200, 'y200')
        pdf.drawString(10,300, 'y300')
        pdf.drawString(10,400, 'y400')
        pdf.drawString(10,500, 'y500')
        pdf.drawString(10,600, 'y600')
        pdf.drawString(10,700, 'y700')
        pdf.drawString(10,800, 'y800')

        pdf.drawInlineImage(os.getcwd() + "/static/logo/Masatrek.jpg", 130, 400)

        pdf.save()

        return template('./static/debug',request = request)

    @route('/assets/<filepath:path>')
    def assets_route(filepath):
        return static_file(filepath, root="./static/assets/")

    @route('/snapshot/<filepath:path>')
    def snapshot_route(filepath):
        return static_file(filepath, root="./static/snapshot/")

    @route('/uploads/<filepath:path>')
    def uploads_route(filepath):
        return static_file(filepath, root="./static/uploads/")

    @route('/reports/<filepath:path>')
    def reports_route(filepath):
        return static_file(filepath, root="./static/reports/")

    @route('/logo/<filepath:path>')
    def logo_route(filepath):
        return static_file(filepath, root="./static/logo/")

    #DEVICE API ------------------------------------------------------------------------------------------------
    @post('/Subscribe/heartbeat')
    def heartbeat():
        try:
            json_reply = json.load(request.body)
            device_id = json_reply['info']['DeviceID']
            heartbeat_timestamp = json_reply['info']['Time']
            dbase_handler.update_hearbeat(device_id, heartbeat_timestamp)

            t = time.process_time()

            all_user_from_device = device_handler.get_all_user(device_id)
            try:
                all_user_from_device = all_user_from_device["info"]["List"]
            except Exception as e:
                all_user_from_device = []
            all_user_from_list = []
            all_user_from_list_2 = []
            for user in all_user_from_device:
                all_user_from_list.append(user["PersonUUID"])            

            all_user_from_masatrek = dbase_handler.get_all_employee()
            for user in all_user_from_masatrek:
                all_user_from_list_2.append(str(user["user_id"]))            

            set_difference = set(all_user_from_list_2) ^ set(all_user_from_list)            

            for checking_id in set_difference:
                checking_id = str(checking_id)
                if checking_id in all_user_from_list_2:                    
                    user_details = dbase_handler.get_employee_details_user_id(checking_id)
                    device_handler.register_user(device_id, checking_id, 0, user_details[3], user_details[0])

                else:
                    device_handler.delete_user(device_id, checking_id)                    

            elapsed = time.process_time() - t            

            all_user_from_device = device_handler.get_all_user(device_id)
            terminal_checking = []
            for user in all_user_from_device["info"]["List"]:
                terminal_checking.append({"user_id":user["PersonUUID"], "user_name":user["Name"], "blacklist":user["PersonType"]})

            # {'employee_id': 'emp002', 'name': 'Basyir', 'img_name': '2021-10-29T17_30_52', 'phone': '', 'department': 'IT', 'shift_name': 'Morning Shift', 'user_id': 115, 'department_id': 6, 'shift_id': 7, 'employee_position': 0}
            for index, item in enumerate(all_user_from_masatrek):
                del all_user_from_masatrek[index]["employee_id"]            

            rv = { "code": 200, "desc": "OK" }
            response.content_type = 'application/json'

            return rv

        except Exception as e:
            return None

    @post('/Subscribe/Verify')
    def verify():
        print('Connection_verify')
        json_reply = json.load(request.body)

        print(json_reply)

        image_name = json_reply['info']['CreateTime']
        image_name = image_name.replace(":", "_")
        employee_name = json_reply['info']['Name']
        user_id = json_reply['info']['PersonUUID']
        snapshot_timestamp = json_reply['info']['CreateTime']
        if json_reply['info']['PersonType'] == 0:
            employee_name = employee_name + "\nWhitelist"
        else:
            employee_name = employee_name + "\nBlacklist"

        device_id = str(json_reply['info']['DeviceID'])

        try:
            base_64_image = str.encode(json_reply['SanpPic'])

            temperature = json_reply['info']['Temperature']
        except Exception as e:
            temperature = 0

        if (dbase_handler.is_user_available(user_id) == 1):
            dbase_handler.insert_snapshot_registered(image_name, snapshot_timestamp, 0, user_id, device_id, temperature)

            employee_details = dbase_handler.get_employee_details_user_id(user_id)

            if (dbase_handler.employee_has_attendance(employee_details[2], snapshot_timestamp) == 0):
                dbase_handler.insert_employee_attendance(employee_details[2], date.today())
                dbase_handler.check_employee_attendance(user_id)
            else:
                dbase_handler.check_employee_attendance(user_id)

            with open(os.getcwd()+"/static/snapshot/"+ image_name + ".jpg", "wb") as fh:
                fh.write(base64.decodebytes(base_64_image[23:]))

        rv = { "code": 200, "desc": "OK" }
        response.content_type = 'application/json'

        return rv

    @post('/Subscribe/Snap')
    def snap():
        print('Connection_snap')

        json_reply = json.load(request.body)
        #test
        pp = pprint.PrettyPrinter()
        pp.pprint(json_reply)

        image_name = json_reply['info']['CreateTime']
        image_name = image_name.replace(":", "_")
        snap_status = "unregistered"
        snapshot_timestamp = json_reply['info']['CreateTime']
        device_id = str(json_reply['info']['DeviceID'])

        base_64_image = str.encode(json_reply['SanpPic'])

        with open(os.getcwd()+"/static/snapshot/"+ image_name + ".jpg", "wb") as fh:
            fh.write(base64.decodebytes(base_64_image[23:]))

        dbase_handler.insert_snapshot_unregistered(image_name, snapshot_timestamp, device_id)

        rv = { "code": 200, "desc": "OK" }
        response.content_type = 'application/json'

        return rv

    app = Bottle()
    COOKIE_SECRET = 'super_secret_string'
    app.install(FlashPlugin(secret=COOKIE_SECRET))
    run(server='paste', host=server_ip, port=server_port, debug=True, reloader=True)
