<!DOCTYPE html>
<html>

<head>
    % include('./static/base/header.tpl', title = 'Device Management')
</head>

<body id="page-top">
    <div id="wrapper">
         % include('./static/base/side_navbar.tpl', active_page = 'Device Management')
        <div class="d-flex flex-column" id="content-wrapper">
            <div id="content">
                % include('./static/base/navbar.tpl')
                <div class="container-fluid">
                    <h3 class="text-dark mb-4">Device Management</h3>
                    <div class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="text-primary d-xxl-flex justify-content-xxl-center m-0 fw-bold">Add Device</h6>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <form action="/device_management/add_device" method="POST">
                                <div class="col">
                                    <div class="row">
                                        <div class="col-md-6 text-nowrap d-xl-flex d-xxl-flex pb-3">
                                            <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">Terminal Name:</label><input name="terminal_name" class="form-control" type="text" required></div>
                                        </div>
                                        <div class="col-md-6 text-nowrap d-xl-flex d-xxl-flex pb-3">
                                            <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">Terminal IP Address:&nbsp;</label><input name="terminal_ip_address" class="form-control" type="text" required></div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6 text-nowrap d-xl-flex d-xxl-flex pb-3">
                                            <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">Terminal Username:&nbsp;</label><input name="terminal_username" type="text" class="form-control" required></div>
                                        </div>
                                        <div class="col-md-6 text-nowrap d-xl-flex d-xxl-flex pb-3">
                                            <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">Terminal Password :&nbsp;</label><input name="terminal_password" type="password" class="form-control" required></div>
                                        </div>
                                    </div>
                                    <div class="row d-flex d-xxl-flex justify-content-center justify-content-xxl-center"><button class="btn btn-primary" type="submit" style="max-width: 50%;">Save</button></div>
                                </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="card shadow">
                        <div class="card-header py-3">
                            <p class="text-primary d-xxl-flex justify-content-xxl-center m-0 fw-bold">Terminal List</p>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive table mt-2" id="dataTable" role="grid" aria-describedby="dataTable_info">
                                <table class="table my-0" id="dataTable">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Name<br></th>
                                            <th>IP Address</th>
                                            <th>Last Hearbeat</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        % for terminal in all_terminal:
                                        <tr>
                                            <td>{{terminal[0]}}</td>
                                            <td>{{terminal[1]}}</td>
                                            <td>{{terminal[2]}}</td>
                                            <td>{{terminal[3]}}</td>
                                            <td><button class="btn btn-primary" type="button" data-bs-toggle="modal" data-bs-target="#modal-1" onclick="loadDoc(this.value)" value="{{terminal[2]}}">Test Connection</button></td>
                                        </tr>
                                        % end
                                    </tbody>
                                    <tfoot>
                                        <tr>
                                            <td><strong>Date</strong></td>
                                            <td><strong>Name</strong></td>
                                            <td><strong>NRIC</strong></td>
                                            <td><strong>First Scan</strong></td>
                                            <td><strong>Terminal</strong></td>
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
    <!-- MODAL -->
    <div role="dialog" tabindex="-1" class="modal fade" id="modal-1">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Test Connection</h4><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center">
                    <div class="text-center p-4" id="modal_spinner"><span  role="status" class="spinner-border textprimary text-primary"></span></div><div class="text-center"><span><button id="test_button_success" style="display: none;" class="btn btn-success disabled" type="button">Success</button><button id="test_button_failed" style="display: none;" class="btn btn-danger disabled" type="button">Failed</button></span></div>
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
        function loadDoc(terminal_ip) {
          document.getElementById("test_button_failed").style.display = "none";
          document.getElementById("test_button_success").style.display = "none";  
          document.getElementById("modal_spinner").style.display = "block";
          const xhttp = new XMLHttpRequest();
          xhttp.onload = function() {
            var test_result = this.responseText
            document.getElementById("modal_spinner").style.display = "none";
            if (test_result == "failed"){                
                document.getElementById("test_button_failed").style.display = "inherit";
            }
            else{
                document.getElementById("test_button_success").style.display = "inherit";
            }        
          }
          xhttp.open("POST", "/ajax_test");
          xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
          xhttp.send("terminal_ip=" + terminal_ip);
        }
        </script>
</body>

</html>