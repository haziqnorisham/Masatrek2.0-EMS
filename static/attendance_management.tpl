<!DOCTYPE html>
<html>

<head>
    % include('./static/base/header.tpl', title = 'Attendance Management')
</head>

<body id="page-top">
    <div id="wrapper">
        % include('./static/base/side_navbar.tpl', active_page = 'Attendance Management')
        <div class="d-flex flex-column" id="content-wrapper">
            <div id="content">
                % include('./static/base/navbar.tpl')
                <div class="container-fluid">
                    <h3 class="text-dark mb-4">Attendance Management</h3>
                    <div class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="text-primary d-xxl-flex justify-content-xxl-center m-0 fw-bold">Filters</h6>
                        </div>
                        <form action="" method="GET">
                        <div class="card-body">
                            <div class="row">
                                <div class="col">
                                    <div class="row">
                                        <div class="col-md-6 text-nowrap d-xl-flex d-xxl-flex pb-3">
                                            <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">From :</label><input name="from_date" class="form-control" type="date" value="{{from_date}}" ></div>
                                        </div>
                                        <div class="col-md-6 text-nowrap d-xl-flex d-xxl-flex pb-3">
                                            <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">To :&nbsp;</label><input name="to_date" class="form-control" type="date" value="{{to_date}}" ></div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6 text-nowrap d-xl-flex d-xxl-flex pb-3">
                                            <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">Location :&nbsp;</label><select class="form-select">
                                                    <optgroup label="This is a group">
                                                        <option value="12" selected="">This is item 1</option>
                                                        <option value="13">This is item 2</option>
                                                        <option value="14">This is item 3</option>
                                                    </optgroup>
                                                </select></div>
                                        </div>
                                        <div class="col-md-6 text-nowrap d-xl-flex d-xxl-flex pb-3">
                                            <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">Name or NRIC :&nbsp;</label><input name = "search_name" type="text" class="form-control" value="{{search_name}}"></div>
                                        </div>
                                    </div>
                                    <div class="row d-flex d-xxl-flex justify-content-center justify-content-xxl-center mb-3">
                                        <div class="col collapse" id="collapse-1">
                                            <hr>
                                            <div class="row">
                                                <div class="col-md-6 text-nowrap d-xl-flex d-xxl-flex pb-3">
                                                    <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">First Terminal Location:</label><select name="first_terminal" class="form-select">                                                            
                                                            <option value="0" selected="">All Terminal</option>
                                                            % for terminal_details in all_terminal_details:
                                                                % if terminal_details[0] == int(selected_first_terminal):
                                                                <option value="{{terminal_details[0]}}" selected="">{{terminal_details[1]}}</option>
                                                                % else:
                                                                <option value="{{terminal_details[0]}}">{{terminal_details[1]}}</option>
                                                                % end
                                                            % end                                                            
                                                        </select></div>
                                                </div>
                                                <div class="col-md-6 text-nowrap d-xl-flex d-xxl-flex pb-3">
                                                    <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">Last Terminal Location:&nbsp;</label><select name="last_terminal" class="form-select">                                                            
                                                            <option value="0" selected="">All Terminal</option>
                                                            % for terminal_details in all_terminal_details:
                                                                % if terminal_details[0] == int(selected_last_terminal):
                                                                <option value="{{terminal_details[0]}}" selected="">{{terminal_details[1]}}</option>
                                                                % else:
                                                                <option value="{{terminal_details[0]}}">{{terminal_details[1]}}</option>
                                                                % end
                                                            % end                                                                                                                            
                                                        </select></div>
                                                </div>
                                            </div>
                                            <!--
                                            <div class="row">
                                                <div class="col-md-6 text-nowrap d-xl-flex d-xxl-flex pb-3">
                                                    <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">First Scan Time:&nbsp;</label><input class="form-control" type="date"></div>
                                                </div>
                                                <div class="col-md-6 text-nowrap d-xl-flex d-xxl-flex pb-3">
                                                    <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">Last Scan Time</label><input class="form-control" type="date"></div>
                                                </div>
                                            </div>
                                            -->
                                        </div>
                                    </div>
                                    <div class="row d-flex d-xxl-flex justify-content-center justify-content-xxl-center mb-3">
                                        <div class="col d-flex d-xxl-flex justify-content-center justify-content-xxl-center"><a class="link-secondary" href="#collapse-1" data-bs-toggle="collapse" aria-controls="collapse-1" aria-expended="false">Advance Option<i class="fa fa-angle-down"></i></a></div>
                                    </div>
                                    <div class="row d-flex d-xxl-flex justify-content-center justify-content-xxl-center"><button class="btn btn-primary" type="submit" style="max-width: 50%;">Filter Results</button></div>
                                </div>
                            </div>
                        </div>
                        </form>
                    </div>
                    <div class="card shadow">
                        <div class="card-header py-3">
                            <p class="text-primary d-xxl-flex justify-content-xxl-center m-0 fw-bold">Employee Attendance</p>
                        </div>
                        <!-- Attendance Table -->
                        <div class="card-body">
                            % include('./static/base/flash.tpl')
                            <a href="/attendance_print"><button class="btn btn-primary" type="button">Print Report</button></a>
                            <a href="/reports/{{report_name}}.csv"><button class="btn btn-primary" type="button"> Download CSV</button></a>
                            <div class="table-responsive table mt-2" id="dataTable" role="grid" aria-describedby="dataTable_info">
                                <table class="table my-0" id="dataTable">
                                    <thead>
                                        <tr>
                                            <th>Date</th>
                                            <th>Name</th>
                                            <th>Employee ID</th>
                                            <th>Entry Time</th>
                                            <th>Terminal</th>
                                            <th>Leave Time</th>
                                            <th>Terminal</th>
                                            <th>Comment</th>
                                            <th>Files</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        % for attendance in attendance_list:
                                        <tr>
                                            <!-- Date -->
                                            <td>{{attendance[0]}} {{attendance[20]}}</td>
                                            
                                            <!-- Image & Name -->
                                            <td><img class="rounded-circle me-2" width="30" height="30" src="snapshot/{{attendance[15]}}.jpg" data-user_id="{{attendance[16]}}" data-date="{{attendance[0]}}" data-name="{{attendance[2]}}" data-bs-toggle="modal" data-bs-target="#modal-1" onclick="detailed_view(this)">{{attendance[2]}}</td>
                                            
                                            <!-- Employee ID -->
                                            <td>{{attendance[1]}}</td>

                                            <!-- Enter Time -->
                                            % if attendance[17] == 1:
                                            <td><p class="text-danger">{{attendance[7]}}</p></td>
                                            % else:
                                            <td>{{attendance[7]}}</td>
                                            % end

                                            <!-- Enter Location & Temperature -->
                                            <td>{{attendance[8]}}({{attendance[13]}})</td>
                                            
                                            <!-- Exit Time -->
                                            % if attendance[18] == 1: 
                                            <td><p class="text-danger">{{attendance[9]}}</p></td>
                                            % else:
                                            <td>{{attendance[9]}}</td>
                                            % end

                                            <!-- Exit Location & Temperature -->
                                            <td>{{attendance[10]}}({{attendance[14]}})</td>

                                            <!-- Comments -->
                                            <td>{{attendance[11]}}</td>

                                            <!-- Uploaded Picture -->
                                            <td>
                                                % if attendance[19] != None:
                                                <a href="/uploads/{{attendance[19]}}" target="_blank">uploaded file</a>
                                                % else:
                                                No File uploaded
                                                % end
                                            </td>
                                        </tr>
                                        % end
                                    </tbody>
                                    <tfoot>
                                        <tr>
                                            <th>Date</th>
                                            <th>Name</th>
                                            <th>Employee ID</th>
                                            <th>Entry Time</th>
                                            <th>Terminal</th>
                                            <th>Leave Time</th>
                                            <th>Terminal</th>
                                            <th>Comment</th>
                                            <th>Files</th>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <footer class="bg-white sticky-footer">
                <div class="container my-auto">
                    <div class="text-center my-auto copyright"><span>Copyright © Masatrek 2021</span></div>
                </div>
            </footer>
        </div><a class="border rounded d-inline scroll-to-top" href="#page-top"><i class="fas fa-angle-up"></i></a>
    </div>

    <!-- MODAL-1 -->
    <div role="dialog" tabindex="-1" class="modal fade" id="modal-1">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="detailed-view-title">Detailed View - MUHAMMAD HAZIQ BIN NORISHAM</h4><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Timestamp</th>
                                    <th>Location</th>
                                    <th>Temperature</th>
                                </tr>
                            </thead>
                            <tbody id="detailed_attendance_table">
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="modal-footer"><button class="btn btn-light" type="button" data-bs-dismiss="modal">Close</button></div>
            </div>
        </div>
    </div>
    <script src="assets/bootstrap/js/bootstrap.min.js"></script>
    <script src="assets/js/bs-init.js"></script>
    <script src="assets/js/theme.js"></script>
    <script src="assets/js/jquery-3.6.0.min.js"></script>
    <script>
        function detailed_view(caller){
            var attendance_date = caller.dataset.date;
            var user_id = caller.dataset.user_id;
            var param = "user_id="+user_id+"&date="+attendance_date;
            var detailed_attendance_table = document.getElementById("detailed_attendance_table");
            var employee_name = caller.dataset.name;

            document.getElementById("detailed-view-title").innerHTML = "DETAILED VIEW - " + employee_name;

            while(detailed_attendance_table.hasChildNodes()){
                detailed_attendance_table.removeChild(detailed_attendance_table.firstChild);
            }
            const xhttp = new XMLHttpRequest();
            xhttp.onload = function() {
                    var from_server = JSON.parse(this.responseText);
                    for (var attendance of from_server){
                        var table_row = detailed_attendance_table.insertRow();
                        
                        var table_cell = table_row.insertCell()
                        table_cell.innerHTML = attendance.timestamp;
                        
                        var table_cell = table_row.insertCell()
                        table_cell.innerHTML = '<img class="rounded-circle me-2" width="30" height="30" src="snapshot/' + attendance.image_name + '.jpg">' + attendance.terminal_name;
                        
                        var table_cell = table_row.insertCell()
                        table_cell.innerHTML = attendance.temperature;
                    }
            }
            xhttp.open("POST", "/attendance_management/ajax_detailed_view");
            xhttp.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
            xhttp.send(param);
        }
        
    </script>
</body>

</html>