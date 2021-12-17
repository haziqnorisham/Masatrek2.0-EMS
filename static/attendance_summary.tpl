<!DOCTYPE html>
<html>

<head>
    % include('./static/base/header.tpl', title = 'Attendance Summary')
</head>

<body id="page-top">
    <div id="wrapper">
        % include('./static/base/side_navbar.tpl', active_page = 'Attendance Summary')
        <div class="d-flex flex-column" id="content-wrapper">
            <div id="content">
                % include('./static/base/navbar.tpl')
                <div class="container-fluid">
                    <h3 class="text-dark mb-4">Attendance Summary</h3>
                    <div class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="text-primary d-xxl-flex justify-content-xxl-center m-0 fw-bold">Remote Clock-In / Clock-Out</h6>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <form id="clock_in_form" action="/attendance_summary/remote_clock" method="POST">
                                    <div class="col">
                                        <div class="row">
                                            <div class="col-md-6 text-nowrap d-xl-flex d-xxl-flex pb-3">
                                                <div class="flex-grow-1">
                                                    <label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">Name:</label>
                                                    <input class="form-control" type="text" value="{{attendance_list[0][2]}}" required disabled>
                                                </div>
                                            </div>
                                            <div class="col-md-6 text-nowrap d-xl-flex d-xxl-flex pb-3">
                                                <div class="flex-grow-1">
                                                    <label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">Employee ID:&nbsp;</label>
                                                    <input name="employee_id" class="form-control" type="text" value="{{attendance_list[0][1]}}" required readonly>
                                                </div>
                                            </div>
                                        </div>
                                        <input type="hidden" id="location_latitude" name="location_latitude" value="">
                                        <input type="hidden" id="location_longitude" name="location_longitude" value="">
                                        <div class="row d-flex d-xxl-flex justify-content-center justify-content-xxl-center"><button id="clock-in-button" class="btn btn-primary" type="button" style="max-width: 50%;">Clock-In / Clock-Out</button></div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="card shadow">
                        <div class="card-header py-3">
                            <p class="text-primary d-xxl-flex justify-content-xxl-center m-0 fw-bold">Employee Attendance</p>
                        </div>
                        <div class="card-body">
                            % include('./static/base/flash.tpl')
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
                                            <th>Photo</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        % for attendance in attendance_list:
                                        <tr>
                                            <!--Date-->
                                            <td>{{attendance[0]}}</td>
                                            
                                            <!--Image & Name-->
                                            <td><img class="rounded-circle me-2" width="30" height="30" src="snapshot/{{attendance[15]}}.jpg" data-user_id="{{attendance[16]}}" data-date="{{attendance[0]}}" data-bs-toggle="modal" data-bs-target="#modal-1" onclick="detailed_view(this)">{{attendance[2]}}</td>
                                            
                                            <!--Employee ID-->
                                            <td>{{attendance[1]}}</td>

                                            <!--Entry Time-->
                                            % if attendance[17] == 1:
                                            <td><p class="text-danger">{{attendance[7]}}</p></td>
                                            % elif attendance[7] == None:
                                            <td><p class="text-danger">Absent</p></td>
                                            % else:
                                            <td>{{attendance[7]}}</td>
                                            % end

                                            <!--Enter Location-->
                                            % if attendance[8] == None:
                                            <td><p class="text-danger">Absent</p></td>
                                            % else:
                                            <td>{{attendance[8]}}({{attendance[13]}})</td>
                                            % end                                            
                                            
                                            <!--Exit Time-->
                                            % if attendance[18] == 1: 
                                            <td><p class="text-danger">{{attendance[9]}}</p></td>
                                            % elif attendance[9] == None:
                                            <td><p class="text-danger">Absent</p></td>
                                            % else:
                                            <td>{{attendance[9]}}</td>
                                            % end
                                            
                                            <!--Exit Location-->
                                            % if attendance[10] == None:
                                            <td><p class="text-danger">Absent</p></td>
                                            % else:
                                            <td>{{attendance[10]}}({{attendance[14]}})</td>
                                            % end
                                            
                                            <form action="/attendance_summary/add_comment" method="POST" enctype="multipart/form-data">
                                            <!--Comment Text Field-->
                                            <td>
                                                <input type="hidden" name="attendance_date" value="{{attendance[0]}}">
                                                % if attendance[11] == None:
                                                <div class="flex-grow-1"><input name="comment" type="text" class="form-control" value="" /></div>
                                                % else:
                                                <div class="flex-grow-1"><input name="comment" type="text" class="form-control" value="{{attendance[11]}}" /></div>
                                                % end
                                            </td>

                                            <!--Pohoto Upload Field-->
                                            <td>                                                
                                                <div class="form-group">                                                
                                                <input name="file_upload" class="form-control" type="file" id="formFile">                                                
                                                </div>
                                                % if attendance[19] != None:
                                                <a href="/uploads/{{attendance[19]}}" target="_blank">uploaded file</a>
                                                % else:
                                                No File uploaded
                                                % end
                                            </td>

                                            <!--Save Button-->
                                            <td>
                                                <button class="btn btn-primary" type="submit" style="max-width: 100%;">Save</button>
                                            </td>
                                            </form>
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
                                            <th>Photo</th>
                                            <th>Action</th>
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
                    <h4 class="modal-title">Detailed View - {{attendance_list[0][2]}}</h4><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
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
            while(detailed_attendance_table.hasChildNodes()){
                detailed_attendance_table.removeChild(detailed_attendance_table.firstChild);
            }
            const xhttp = new XMLHttpRequest();
            xhttp.onload = function() {
                    var from_server = JSON.parse(this.responseText);
                    for (var attendance of from_server){
                        var table_row = detailed_attendance_table.insertRow();
                        
                        var table_cell = table_row.insertCell();
                        table_cell.innerHTML = attendance.timestamp;
                        
                        var table_cell = table_row.insertCell();
                        if (attendance.latitude == null){                            
                            table_cell.innerHTML = '<img class="rounded-circle me-2" width="30" height="30" src="snapshot/' + attendance.image_name + '.jpg">' + attendance.terminal_name;
                        }
                        else{
                            table_cell.innerHTML = '<a href= "' + `https://www.openstreetmap.org/?mlat=${attendance.latitude}&mlon=${attendance.longitude}#map=18/${attendance.latitude}/${attendance.longitude}` + '" target="_blank">View Location</a>';
                        }                                                
                        
                        var table_cell = table_row.insertCell();
                        table_cell.innerHTML = attendance.temperature;
                    }
            }
            xhttp.open("POST", "/attendance_management/ajax_detailed_view");
            xhttp.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
            xhttp.send(param);
        }
        
    </script>

    <!-- Get GPS Location Script -->
    <script>
        function geoFindMe() {

            const clock_in_button = document.querySelector('#clock-in-button');
            const latitude_input = document.querySelector('#location_latitude');
            const longitude_input = document.querySelector('#location_longitude');
            const clock_in_form = document.querySelector('#clock_in_form');

            function success(position) {
                const latitude  = position.coords.latitude;
                const longitude = position.coords.longitude;
                
                latitude_input.value = latitude;
                longitude_input.value = longitude;

                console.log(`https://www.openstreetmap.org/?mlat=${latitude}&mlon=${longitude}#map=18/${latitude}/${longitude}`);

                clock_in_form.submit()
            }

            function error() {
                alert('Attendance is NOT recorded, Unable to retrieve your location, please enable location in your browser');
                console.log('Unable to retrieve your location');
            }

            if(!navigator.geolocation) {
                alert('Attendance is NOT recorded, Unable to retrieve your location, please enable location in your browser');
                console.log('Geolocation is not supported by your browser');
            } else {            
                navigator.geolocation.getCurrentPosition(success, error);
            }

        }

        document.querySelector('#clock-in-button').addEventListener('click', geoFindMe);
    </script>
</body>

</html>