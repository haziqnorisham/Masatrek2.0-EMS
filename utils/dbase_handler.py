import os
from re import search
import re
import sqlite3
from sqlite3.dbapi2 import DatabaseError, paramstyle
from datetime import time, datetime, date, timedelta
import traceback
import pprint

conn = sqlite3.connect(os.getcwd()+"/database/masatrek2_sample.db", check_same_thread=False)
c = conn.cursor()
c.execute("PRAGMA foreign_keys = ON", ())

def get_all_employee():
    employee_list = []

    stmt = '''  SELECT
                    employee_details.emp_id ,
                    users.usr_name,
                    users.usr_image,
                    users.usr_phone,
                    departments.dep_name,
                    shifts.shift_name,
                    users.usr_id,
                    departments.dep_id,
                    shifts.shift_id,
                    employee_details.emp_position
                FROM 
                    employee_details
                LEFT JOIN 
                    users 
                ON 
                    employee_details.usr_id = users.usr_id 
                LEFT JOIN 
                    departments 
                ON
                    employee_details.dep_id = departments.dep_id 
                LEFT JOIN 
                    shifts
                ON 
                    employee_details.shift_id = shifts.shift_id'''

    for row in c.execute(stmt):
        employee_list.append({'employee_id': row[0], 'name':row[1], 'img_name':row[2], 'phone':row[3], 'department':row[4], 'shift_name':row[5], 'user_id':row[6], 'department_id':row[7], 'shift_id':row[8], 'employee_position':row[9]})
    
    return employee_list

def get_all_departments():
    department_list = []
    for row in c.execute('SELECT dep_name, dep_id, dep_location from departments'):
        department_list.append({"department_name": row[0], "department_id": row[1], "department_description": row[2]})
    
    return department_list

def delete_department(department_id):
    stmt = "DELETE FROM departments WHERE dep_id = ?"
    param = (department_id ,)

    c.execute(stmt, param)
    conn.commit()
    return None

def udpate_department(department_id, department_name, department_description):
    stmt = "UPDATE departments SET dep_name = ?, dep_location = ? WHERE dep_id = ?"
    param = (department_name, department_description, department_id)
    c.execute(stmt, param)
    conn.commit()
    return None

def get_all_shifts():
    shift_list = []
    for row in c.execute('SELECT * from shifts'):
        shift_list.append({"shift_id" : row[0], "shift_start_time" : row[1], "shift_end_time" : row[2], "shift_name" : row[3]})

    return shift_list

def insert_employee(employee_name, employee_image, employee_phone, employee_id, employee_position ,employee_password, employee_department, employee_shift):
    
    stmt1 = 'INSERT INTO users (usr_name, usr_image, usr_phone) VALUES(?, ?, ?);'
    stmt2 = 'INSERT INTO employee_details (emp_id, emp_position, emp_password, usr_id, dep_id, shift_id) VALUES (?, ?, ?, (SELECT max(users.usr_id) FROM users), ?, ?);'

    c.execute(stmt1, (employee_name, employee_image, employee_phone))
    c.execute(stmt2, (employee_id, employee_position, employee_password, employee_department, employee_shift))
    
    conn.commit()
    return 0

def edit_employee(employee_id, image_name, employee_name, department_id, shift_id, employee_position):
    print(employee_id)
    stmt = "UPDATE users SET usr_name = ?, usr_image = ? WHERE usr_id = (SELECT usr_id FROM employee_details WHERE emp_id = ?)"
    param = (employee_name, image_name, employee_id)
    c.execute(stmt, param)
    conn.commit()

    return None

def get_all_terminals():
    terminal_list = []
    for row in c.execute('SELECT term_id, term_name, term_ip_address, last_sync  from terminal_details WHERE term_id <> 0 AND term_id <> 1'):
        terminal_list.append(row)
    
    return terminal_list

def get_terminal_details(terminal_id):
    terminal_details = None    

    stmt = 'SELECT * FROM terminal_details WHERE term_id = ?;'

    param = (terminal_id,)
    rows = c.execute(stmt, param)
    terminal_details = rows.fetchall()[0]

    return terminal_details

def update_terminal_details(device_id, terminal_name, username, password):

    stmt = 'UPDATE terminal_details SET term_name = ? , term_username = ? , term_password = ? WHERE term_id = ? ;'
    param = (terminal_name, username, password, device_id)
    
    c.execute(stmt, param)

    conn.commit()
    return 

def insert_access_employee(terminal_list, employee_id, blacklist):

    stmt = 'INSERT INTO access (usr_id, term_id, blacklist) VALUES (?, ?, ?);'
    param = (employee_id, terminal_list, blacklist)

    c.execute(stmt, param)

    conn.commit()
    return 0

def get_employee_details(emp_id):
    employee_details = None

    stmt = 'SELECT users.usr_image, users.usr_id, employee_details.emp_id, users.usr_name, users.usr_phone, departments.dep_name, shifts.shift_name, shifts.start_time, shifts.end_time, employee_details.emp_position FROM employee_details LEFT JOIN users ON employee_details.usr_id = users.usr_id LEFT JOIN departments ON employee_details.dep_id = departments.dep_id LEFT JOIN shifts ON employee_details.shift_id = shifts.shift_id WHERE employee_details.emp_id = ?;'

    param = (emp_id,)
    rows = c.execute(stmt, param)
    employee_details = rows.fetchall()[0]

    return employee_details

def get_employee_details_user_id(user_id):
    stmt = 'SELECT users.usr_image, users.usr_id, employee_details.emp_id, users.usr_name, users.usr_phone, departments.dep_name, shifts.shift_name, shifts.start_time, shifts.end_time, employee_details.emp_position FROM employee_details LEFT JOIN users ON employee_details.usr_id = users.usr_id LEFT JOIN departments ON employee_details.dep_id = departments.dep_id LEFT JOIN shifts ON employee_details.shift_id = shifts.shift_id WHERE employee_details.usr_id = ?;'

    param = (user_id,)
    rows = c.execute(stmt, param)
    employee_details = rows.fetchall()[0]

    return employee_details

def delete_employee(emp_id):

    stmt = 'SELect usr_id FROM employee_details WHERE emp_id = ?'
    param = (emp_id,)
    rows = c.execute(stmt, param)
    row = rows.fetchall()[0]
    user_id = row[0]

    delete_user(user_id)
    return None

def get_user_access(user_id):

    stmt = 'SELECT term_id, blacklist FROM access WHERE access.usr_id = ?;'

    param = (user_id,)
    rows = c.execute(stmt, param)
    access_list = rows.fetchall()

    return access_list

def get_user_access_terminal(user_id, term_id):

    stmt = 'SELECT blacklist FROM access WHERE access.usr_id = ? AND access.term_id = ?;'

    param = (user_id, term_id)
    rows = c.execute(stmt, param)
    rows = rows.fetchall()
    if len(rows) > 0 :
        access_list = rows[0]
    else:
        access_list = []

    return access_list

def insert_terminal(term_id, term_name, term_ip_address, term_username, term_password):

    stmt = 'INSERT INTO terminal_details (term_id, term_name, term_ip_address, term_username, term_password) VALUES (? , ?, ?, ?, ?);'
    param = (term_id, term_name, term_ip_address, term_username, term_password)

    c.execute(stmt, param)

    conn.commit()
    return None

def update_employee_details(employee_name, employee_phone, employee_shift, employee_department, employee_admin, user_id, employee_id, image_name):
    
    stmt = 'SELect usr_id FROM employee_details WHERE emp_id = ?'
    param = (employee_id,)
    rows = c.execute(stmt, param)
    row = rows.fetchall()[0]
    user_id = row[0]
    
    stmt1 = 'UPDATE users SET usr_name = ? , usr_phone = ?, usr_image = ? WHERE usr_id = ?;'
    stmt2 = 'UPDATE employee_details SET dep_id = ?, shift_id = ?, emp_position = ? WHERE emp_id = ?;'

    param1 = (employee_name, employee_phone, image_name, user_id)
    param2 = (employee_department, employee_shift, employee_admin, employee_id)

    c.execute(stmt1, param1)

    conn.commit()
    return None

def update_access_employee(user_id, access_terminal):

    all_terminal_access = []

    for terminal in get_all_terminals():
        if str(terminal[0]) in access_terminal:
            all_terminal_access.append({"terminal_id" : terminal[0], "blacklist" : 0})
        else:
            all_terminal_access.append({"terminal_id" : terminal[0], "blacklist" : 1})

    for access_details in all_terminal_access:    
        if len(get_user_access_terminal(user_id, access_details["terminal_id"])) > 0:
            stmt = "UPDATE access SET blacklist = ? WHERE access.usr_id = ? AND access.term_id = ?;"
            param = (access_details["blacklist"], user_id, access_details["terminal_id"])
            c.execute(stmt, param)
            conn.commit()

        else:
            insert_access_employee(access_details["terminal_id"], user_id, access_details["blacklist"])
    return None

def insert_snapshot_registered(image_name, timestamp, status, user_id, terminal_id, temperature):
    stmt = "INSERT INTO snapshot_reg (snap_image, snap_timestamp, snap_status, usr_id, term_id, temperature) VALUES (?,datetime(?),?,?,?,?);"

    param = (image_name, timestamp, status, user_id, terminal_id, temperature)

    c.execute(stmt, param)

    conn.commit()
    return None

def insert_snapshot_unregistered(image_name, timestamp, device_id):
    stmt = "INSERT INTO snapshot_un_reg (snap_image, snap_timestamp, term_id) VALUES (?, ?, ?);"
    param = (image_name, timestamp, device_id)
    c.execute(stmt, param)
    conn.commit()
    return None

def check_employee_attendance(user_id):

    stmt = "SELECT emp_id FROM employee_details WHERE usr_id = ?"
    param = (user_id,)
    rows = c.execute(stmt, param)
    employee_id = rows.fetchall()[0][0]

    stmt = r"SELECT * FROM employee_attendance WHERE emp_id = ? AND date(attn_date) = date('now','localtime')"
    param = (employee_id,)
    rows = c.execute(stmt, param)
    entry =  rows.fetchall()
    entry = entry[0]

    earliest_snap_id = (get_earliest_snap_today(user_id))[0]
    latest_snap_id = (get_latest_snap_today(user_id))[0]

    employee_details = get_employee_details(employee_id)    
    employee_shift_start_time = employee_details[7]
    employee_shift_end_time = employee_details[8]

    if entry[4] == None:
        try:
            temp_time = time.fromisoformat(str(employee_shift_start_time))            
            temp_time2 = datetime.fromisoformat((get_earliest_snap_today(user_id))[1])
            if temp_time2.time() > temp_time:
                late_entry = 1
            else:
                late_entry = 0

            temp_time3 = time.fromisoformat(str(employee_shift_end_time))
            temp_time4 = datetime.fromisoformat((get_latest_snap_today(user_id))[1])

            if temp_time4.time() < temp_time3:
                leave_early = 1
            else:
                leave_early = 0
            update_employee_attendance_entry(employee_id, earliest_snap_id, late_entry)
            update_employee_attendance(employee_id, latest_snap_id, leave_early)
        except Exception as e:
            print(traceback.format_exc())
            print(e)

    else:
        temp_time3 = time.fromisoformat(employee_shift_end_time)
        temp_time4 = datetime.fromisoformat((get_latest_snap_today(user_id))[1])

        if temp_time4.time() < temp_time3:
            leave_early = 1
        else:
            leave_early = 0
        update_employee_attendance(employee_id, latest_snap_id, leave_early)

def update_employee_attendance(employee_id, latest_snap_id, leave_early):
    print()
    print("Update Employee Attendance")
    print()
    stmt = "UPDATE employee_attendance SET snap_id_out = ?, leave_early = ?, status = 0 WHERE emp_id = ? AND date(attn_date) = date('now','localtime');"
    param = (latest_snap_id, leave_early, employee_id)
    c.execute(stmt, param)
    conn.commit()
    return None

def update_employee_attendance_comment(employee_id, attendance_date, comment, file_name):
    print()
    print("Updating employee comment")
    print()
    stmt = "UPDATE employee_attendance SET attn_comment = ?, file_name = ? WHERE emp_id = ? AND date(attn_date) = date(?)"
    param = (comment, file_name, employee_id, attendance_date)
    rows = c.execute(stmt, param)
    conn.commit()
    if rows.rowcount == 0:
        insert_employee_attendance(employee_id, attendance_date)
        c.execute(stmt, param)
        conn.commit()

    return None

def employee_has_attendance(employee_id, attendance_date):
    stmt = "SELECT * FROM employee_attendance WHERE emp_id = ? AND date(attn_date) = date(?)"
    param = (employee_id, attendance_date)
    rows = c.execute(stmt, param)
    rows = rows.fetchall()
    if len(rows) > 0:
        return 1
    else:
        return 0

def update_employee_attendance_entry(employee_id, latest_snap_id, late_entry):
    stmt = "UPDATE employee_attendance SET snap_id_in = ?, late_entry = ? WHERE emp_id = ? AND date(attn_date) = date('now','localtime');"
    param = (latest_snap_id, late_entry, employee_id)
    c.execute(stmt, param)
    conn.commit()
    return None

def insert_employee_attendance(employee_id, date):
    stmt = "INSERT INTO employee_attendance (attn_date, emp_id, status) VALUES (date(?), ?, 1);"
    param = (date, employee_id)
    c.execute(stmt, param)
    conn.commit()
    return None

def get_earliest_snap_today(user_id):    
    stmt = r"SELECT snap_id , snap_timestamp FROM (SELECT snap_id, MIN(datetime(snap_timestamp)), snap_timestamp FROM snapshot_reg WHERE usr_id = ? AND date(snap_timestamp) = date('now', 'localtime'))"    
    param = (user_id,)
    rows = c.execute(stmt, param)
    rows = rows.fetchall()[0]
    return rows

def get_latest_snap_today(user_id):
    stmt = r"SELECT snap_id, snap_timestamp FROM (SELECT snap_id, MAX(datetime(snap_timestamp)), snap_timestamp FROM snapshot_reg WHERE usr_id = ? AND date(snap_timestamp) = date('now', 'localtime'))"
    param = (user_id,)    
    rows = c.execute(stmt, param)
    return rows.fetchall()[0]

def get_employee_attendance_summary(name):

    #get employee details
    employee_details = get_employee_details(name)

    #sql query
    stmt = '''
            SELECT 
                employee_attendance.attn_date,
                employee_attendance.emp_id,
                users.usr_name,
                shifts.shift_id,
                shifts.shift_name,
                employee_attendance.snap_id_in,
                employee_attendance.snap_id_out,	
                snp1.snap_timestamp,
                term1.term_name,
                snp2.snap_timestamp,
                term2.term_name,
                employee_attendance.attn_comment,
                employee_attendance.attn_comment,
                snp1.temperature,
                snp2.temperature,
                users.usr_image,
                users.usr_id,
                employee_attendance.late_entry,
                employee_attendance.leave_early,
                employee_attendance.file_name,
                employee_attendance.status
            FROM 
                employee_attendance
            LEFT JOIN
                employee_details
            ON
                employee_attendance.emp_id = employee_details.emp_id
            LEFT JOIN
                users
            ON
                employee_details.usr_id = users.usr_id
            LEFT JOIN
                shifts
            ON
                employee_details.shift_id = shifts.shift_id
            LEFT JOIN
                snapshot_reg AS snp1
            ON
                employee_attendance.snap_id_in = snp1.snap_id
            LEFT JOIN
                terminal_details AS term1
            ON
                snp1.term_id = term1.term_id
            LEFT JOIN
                snapshot_reg AS snp2
            ON
                employee_attendance.snap_id_out = snp2.snap_id
            LEFT JOIN
                terminal_details AS term2
            ON
                snp2.term_id = term2.term_id
            WHERE
                date(employee_attendance.attn_date) BETWEEN date(?) AND date(?)
            AND
                (users.usr_name LIKE ?
            OR
                employee_attendance.emp_id LIKE ?  )
            ORDER BY 
                employee_attendance.attn_date DESC
    '''
    #format name for sql LIKE format
    search_name = "%"+name+"%"

    #hold 1 week of attendance query result
    results = []

    #query database to get attendance for each date in current week
    dt = date.today()
    #from_date, start of week date
    from_date = dt - timedelta(days=dt.weekday())

    i=0
    #loop to get attendance for each day in current week
    #TO-DO: 7 is a week, variable should be user so users can setup 
    #   custom number of days to display attendance summary
    while i<7:
        # get date for i days after the start date
        temp_date = from_date + timedelta(i)
        # update query parameter with the new date
        param = (temp_date, temp_date, search_name, search_name)
        # execute the sql query
        rows = c.execute(stmt, param)
        rows = rows.fetchall()

        # append query result to attendance result if attendance is available
        if (len(rows) > 0) and (rows[0][20] == 0):
            results.append(rows[0])            

        # append query result to attendance result if absent attendance is available
        elif (len(rows) > 0) and (rows[0][20] == 1):
            results.append(rows[0])

        # generate new attendance result and appent to result when no attendance 
        #   is available in attendance table
        else:
            results.append([temp_date,employee_details[2], employee_details[3], 7, employee_details[6],None,None,None,None,None,None,None,None,None,None,employee_details[0],employee_details[1],None,None,None,1])
        i+=1

    return results

def get_all_employee_attendance_date(start_date, end_date, first_terminal, last_terminal, search_name):
    # empty list to store final attendance result for return value
    all_attendance = []
    employee_list = []

    # get all employee based on name / employee id filters
    search_name = "%"+search_name+"%"
    if first_terminal == '0':
        first_terminal = '%'
    if last_terminal == '0':
        last_terminal = '%'
    stmt = """
            SELECT 
                users.usr_name,
                employee_details.emp_id
            FROM
                employee_details
            LEFT JOIN
                users
            ON
                employee_details.usr_id = users.usr_id
            WHERE
                (users.usr_name LIKE ? OR employee_details.emp_id LIKE ?)
            """
    param = (search_name, search_name)
    rows = c.execute(stmt, param)
    for employee in rows.fetchall():
        employee_list.append(get_employee_details(employee[1]))

    if type(start_date) != type(date.today()) :
        start_date = datetime.strptime(start_date, "%Y-%m-%d")
        start_date = start_date.date()

        end_date = datetime.strptime(end_date, "%Y-%m-%d")
        end_date = end_date.date()

    stmt = '''
            SELECT 
                employee_attendance.attn_date,
                employee_attendance.emp_id,
                users.usr_name,
                shifts.shift_id,
                shifts.shift_name,
                employee_attendance.snap_id_in,
                employee_attendance.snap_id_out,	
                snp1.snap_timestamp,
                term1.term_name,
                snp2.snap_timestamp,
                term2.term_name,
                employee_attendance.attn_comment,
                employee_attendance.attn_comment,
                snp1.temperature,
                snp2.temperature,
                users.usr_image,
                users.usr_id,
                employee_attendance.late_entry,
                employee_attendance.leave_early,
                employee_attendance.file_name,
                employee_attendance.status
            FROM 
                employee_attendance
            LEFT JOIN
                employee_details
            ON
                employee_attendance.emp_id = employee_details.emp_id
            LEFT JOIN
                users
            ON
                employee_details.usr_id = users.usr_id
            LEFT JOIN
                shifts
            ON
                employee_details.shift_id = shifts.shift_id
            LEFT JOIN
                snapshot_reg AS snp1
            ON
                employee_attendance.snap_id_in = snp1.snap_id
            LEFT JOIN
                terminal_details AS term1
            ON
                snp1.term_id = term1.term_id
            LEFT JOIN
                snapshot_reg AS snp2
            ON
                employee_attendance.snap_id_out = snp2.snap_id
            LEFT JOIN
                terminal_details AS term2
            ON
                snp2.term_id = term2.term_id
            WHERE
                date(employee_attendance.attn_date) BETWEEN date(?) AND date(?)
            AND
                (snp1.term_id LIKE ? OR snp1.term_id IS NULL)
            AND 
                (snp2.term_id LIKE ? OR snp2.term_id IS NULL)
            AND
                (users.usr_name LIKE ?
            OR
                employee_attendance.emp_id LIKE ?  )
            ORDER BY 
                employee_attendance.attn_date DESC
    '''

    while start_date <= end_date:
        for employees in employee_list:            
            param = (start_date, start_date, first_terminal,
                last_terminal, employees[2], employees[2])

            rows = None
            rows = c.execute(stmt, param)
            rows = rows.fetchall()
            if len(rows) > 0:
                all_attendance.append(rows[0])
            else:
                all_attendance.append([start_date, employees[2], employees[3], 7, employees[6], None, None, None, None, None, None, None, None, None, None, employees[0], employees[1], None, None, None, 1])
        start_date = start_date + timedelta(days=1)

    return all_attendance

def get_latest_image_list():
    stmt = 'SELECT snapshot_un_reg.snap_image FROM snapshot_un_reg ORDER BY datetime(snapshot_un_reg.snap_timestamp) DESC LIMIT 5'
    param = ()
    rows = c.execute(stmt, param)
    rows = rows.fetchall()

    return rows

def get_shift_details(shift_id):

    stmt = "SELECT * from shifts WHERE shift_id = ?"
    param = (shift_id,)
    rows = c.execute(stmt, param)
    return rows.fetchall()[0]

def delete_shift(shift_id):
    stmt = "DELETE FROM shifts WHERE shift_id = ?"
    param = (shift_id,)
    c.execute(stmt, param)
    conn.commit()
    return None

def edit_shift(shift_id, shift_name, shift_start_time, shift_end_time):
    stmt = """UPDATE shifts SET shift_name = ?, start_time = time(?), flexi_in = time(?),
        end_time = time(?), flexi_out = time(?) WHERE shift_id = ?"""

    param = (shift_name, shift_start_time, shift_start_time,
        shift_end_time, shift_end_time, shift_id)

    c.execute(stmt, param)
    conn.commit()
    return None

def delete_user(user_id):
    stmt = "DELETE FROM users WHERE users.usr_id = ?;"
    param = (user_id,)

    c.execute(stmt, param)
    conn.commit()
    return None

def delete_device(device_id):
    stmt = "DELETE FROM terminal_details WHERE term_id = ?"
    param = (device_id,)
    c.execute(stmt, param)
    conn.commit()
    return None

def insert_department(depertment_name, department_location):
    stmt = 'INSERT INTO departments (dep_name, dep_location) VALUES (?, ?)'
    param = (depertment_name, department_location)

    c.execute(stmt, param)
    conn.commit()

def verify_login(emp_id, password):
    stmt = 'SELECT * FROM employee_details WHERE emp_id = ? AND emp_password = ?'
    param = (emp_id, password)
    c.execute(stmt, param)
    rows = c.fetchall()

    return rows

def insert_shift(shift_name, shift_start1, shift_start2, shift_end1, shift_end2, is_flexi):
    stmt = 'INSERT INTO shifts (start_time, flexi_in, end_time, flexi_out, shift_name, flexi) VALUES (time(?), time(?), time(?), time(?), ?, ?)'
    param = (shift_start1, shift_start2, shift_end1, shift_end2, shift_name, is_flexi)
    c.execute(stmt, param)
    conn.commit()
    print("what???")
    return None

def is_employee_available(emp_id):    
    stmt = 'SELECT * FROM employee_details WHERE emp_id = ?'
    param = (emp_id,)
    rows = c.execute(stmt, param)
    rows = rows.fetchall()
    if len(rows) == 0:
        return 0
    else:
        return 1

def is_user_available(usr_id):
    stmt = 'SELECT * FROM employee_details WHERE usr_id = ?'
    param = (usr_id,)
    rows = c.execute(stmt, param)
    rows = rows.fetchall()
    if len(rows) == 0:
        return 0
    else:
        return 1

def check_employee_attendance2(employee_id, reason, comment):

    stmt = r"SELECT datetime(attn_date) FROM employee_attendance WHERE emp_id = ? AND date(attn_date) = date('now','localtime')"
    param = (employee_id,)
    rows = c.execute(stmt, param)

    if len(rows.fetchall()) == 0:
        insert_employee_attendance(employee_id, reason, comment)
    else:
        #latest_snap_id = get_latest_snap_today(user_id)
        #update_employee_attendance(employee_id, latest_snap_id)
        pass

def get_all_visit_reason():
    visit_reason_list = []
    for row in c.execute('SELECT * FROM visit_reason'):
        visit_reason_list.append(row)

    return visit_reason_list
    
def get_latest_snap():
    stmt = "SELECT snap_image FROM snapshot_un_reg WHERE snap_id = (SELECT MAX(snap_id) FROM snapshot_un_reg)"
    rows = c.execute(stmt,())
    rows = rows.fetchall()
    rows = rows[0]
    return rows

def is_flexi(shift_id):
    stmt = 'SELECT flexi FROM shifts WHERE shift_id = ?'
    param = (shift_id,)
    rows = c.execute(stmt, param)
    rows = rows.fetchall[0]

    return rows[0]

def get_all_login_user():
    login_user = []
    for row in c.execute('SELECT id, username, admin FROM login_user'):
        login_user.append(row)

    return login_user

def register_new_staff(name, password, admin):
    stmt = 'INSERT INTO login_user (username, password, admin) VALUES (?,?,?)'
    param = (name, password, int(admin))
    c.execute(stmt, param)
    conn.commit()
    return None

def delete_login_user(username):
    stmt = 'DELETE FROM login_user WHERE username = ?'
    param = (username,)
    c.execute(stmt, param)
    conn.commit()
    return None

def update_hearbeat(terminal_id, timestamp):
    stmt = 'UPDATE terminal_details SET last_sync = datetime(?) WHERE term_id = ?'
    param = (timestamp, terminal_id)

    c.execute(stmt, param)
    conn.commit()
    return None

def get_unique_visitor(date):
    stmt = 'SELECT count(*) FROM employee_attendance WHERE date(attn_date) = date(?)'
    param = (date,)
    rows = c.execute(stmt, param).fetchall()

    return rows[0][0]

def get_current_week_unique_visitor(dates):
    unique_visitor_for_week = []

    for date in dates:
        unique_visitor_for_week.append(get_unique_visitor(date))

    return unique_visitor_for_week

def get_all_terminal_usage():
    terminal_usage = []

    all_terminal = get_all_terminals()
    for terminal in all_terminal:
        stmt = "SELECT count(*) FROM snapshot_reg WHERE term_id = ?"
        param = (terminal[0],)
        rows = c.execute(stmt, param).fetchall()
        temp = rows[0][0]
        stmt = "SELECT count(*) FROM snapshot_un_reg WHERE term_id = ?"
        param = (terminal[0],)
        rows = c.execute(stmt, param).fetchall()
        total_snapshot = rows[0][0] + temp
        terminal_usage.append({"terminal_id" : total_snapshot, "terminal_name" : terminal[1], "usage": total_snapshot})

    return terminal_usage

def get_user_detailed_attendance(date, user_id):
    
    attendance_details = []

    stmt = """
            SELECT 
            snapshot_reg.snap_timestamp, 
            snapshot_reg.snap_image, 
            terminal_details.term_name, 
            snapshot_reg.temperature 
            FROM 
                snapshot_reg 
            LEFT JOIN
                terminal_details
            ON
                terminal_details.term_id = snapshot_reg.term_id
            WHERE 
                date(snapshot_reg.snap_timestamp) = date(?) 
            AND 
                snapshot_reg.usr_id = ?
            ORDER BY
                snapshot_reg.snap_id 
            ASC"""
    
    param = (date, user_id)
    for row in c.execute(stmt, param):
        attendance_details.append({"timestamp": row[0], "image_name": row[1], "terminal_name": row[2], "temperature": row[3]})

    return attendance_details