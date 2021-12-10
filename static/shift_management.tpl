<!DOCTYPE html>
<html>

<head>
    % include('./static/base/header.tpl', title = 'Shift Management')
</head>

<body id="page-top">
    <div id="wrapper">
        % include('./static/base/side_navbar.tpl', active_page = 'Shift Management')
        <div class="d-flex flex-column" id="content-wrapper">
            <div id="content">
                % include('./static/base/navbar.tpl')
                <div class="container-fluid">
                    <h3 class="text-dark mb-4">Shift Management</h3>
                    <div class="row">
                        <div class="col" style="min-width: 365px;">
                            <div class="row">
                                <div class="col">
                                    <div class="card shadow my-4">
                                        <div class="card-header py-3">
                                            <h6 class="text-primary d-xxl-flex justify-content-xxl-center m-0 fw-bold">Add New Shift</h6>
                                        </div>
                                        <div class="card-body">
                                            % include('./static/base/flash.tpl')
                                            <div class="row">
                                            <form action="/shift_management/add_shift" method="POST">
                                                <div class="col">
                                                    <div class="row d-flex d-xxl-flex justify-content-center justify-content-xxl-center mb-3">
                                                        <div class="col show" id="collapse-2">
                                                            <div class="row">
                                                                <div class="col text-nowrap d-xl-flex d-xxl-flex pb-3">
                                                                    <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">Shift Name:</label><input name="shift_name" type="text" class="form-control" required/></div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="row d-flex d-xxl-flex justify-content-center justify-content-xxl-center mb-3">
                                                        <div class="col show" id="collapse-1">
                                                            <div class="row">
                                                                <div class="col text-nowrap d-xl-flex d-xxl-flex pb-3">
                                                                    <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">Start Time :</label><input name="shift_start_time" class="form-control" type="time" required/></div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col show" id="collapse-4">
                                                            <div class="row">
                                                                <div class="col text-nowrap d-xl-flex d-xxl-flex pb-3">
                                                                    <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">End Time:</label><input name="shift_end_time" class="form-control" type="time" required/></div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="row d-flex d-xxl-flex justify-content-center justify-content-xxl-center mb-3"><button class="btn btn-primary" type="submit" style="max-width: 30%;">Save</button></div>
                                                </div>
                                            </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card shadow">
                        <div class="card-header py-3">
                            <p class="text-primary m-0 fw-bold">Department Info</p>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive table mt-2" id="dataTable-1" role="grid" aria-describedby="dataTable_info">
                                <table class="table my-0" id="dataTable">
                                    <thead>
                                        <tr>
                                            <th>Shift ID</th>
                                            <th>Shift Name</th>
                                            <th>Start Time</th>
                                            <th>End Time</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        % for shift in shift_list:
                                        <tr>
                                            <td>{{shift["shift_id"]}}</td>
                                            <td>{{shift["shift_name"]}}</td>
                                            <td>{{shift["shift_start_time"]}}</td>
                                            <td>{{shift["shift_end_time"]}}</td>
                                            <td><button class="btn btn-primary" type="button" 
                                                data-shift_id = "{{shift["shift_id"]}}" data-shift_name = "{{shift["shift_name"]}}" 
                                                data-shift_start_time = "{{shift["shift_start_time"]}}" data-shift_end_time = "{{shift["shift_end_time"]}}"
                                                data-bs-toggle="modal" data-bs-target="#modal-1"  onclick="edit_shift(this)" >Edit</button></td>
                                        </tr>
                                        % end
                                    </tbody>
                                    <tfoot>
                                        <tr>
                                            <th>Shift ID</th>
                                            <th>Shift Name</th>
                                            <th>Start Time</th>
                                            <th>End Time</th>
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
    <!-- MODAL -->
    <div class="modal fade" role="dialog" tabindex="-1" id="modal-1">
        <div class="modal-dialog" role="document">
        <form action="/shift_management/edit_shift" method="POST">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Edit Shift</h4><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col">
                            <div class="row d-flex d-xxl-flex justify-content-center justify-content-xxl-center mb-3">
                                <div class="col show" id="collapse-3">
                                    <div class="row">
                                        <div class="col text-nowrap d-xl-flex d-xxl-flex pb-3">
                                            <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">Shift ID:</label><input id="modal_shift_id" name="shift_id" type="text" class="form-control" readonly/></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row d-flex d-xxl-flex justify-content-center justify-content-xxl-center mb-3">
                                <div class="col show" id="collapse-3">
                                    <div class="row">
                                        <div class="col text-nowrap d-xl-flex d-xxl-flex pb-3">
                                            <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">Shift Name:</label><input id="modal_shift_name" name="shift_name" type="text" class="form-control" required/></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row d-flex d-xxl-flex justify-content-center justify-content-xxl-center mb-3">
                                <div class="col show" id="collapse-5">
                                    <div class="row">
                                        <div class="col text-nowrap d-xl-flex d-xxl-flex pb-3">
                                            <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">Start Time :</label><input id="modal_shift_start_time" name="shift_start_time" class="form-control" type="time" required/></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col show" id="collapse-6">
                                    <div class="row">
                                        <div class="col text-nowrap d-xl-flex d-xxl-flex pb-3">
                                            <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">End Time:</label><input id="modal_shift_end_time" name="shift_end_time" class="form-control" type="time" required/></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row d-flex d-xxl-flex justify-content-center justify-content-xxl-center mb-3"><button class="btn btn-primary" type="submit" name="button" value="save" style="max-width: 30%;">Save</button></div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer"><button name="button" value="delete" class="btn btn-danger" type="submit">Delete</button></div>
            </div>
        </form>
        </div>
    </div>
    <!-- END MODAL -->
    <script src="assets/bootstrap/js/bootstrap.min.js"></script>
    <script src="assets/js/bs-init.js"></script>
    <script src="assets/js/theme.js"></script>
    <script src="assets/js/jquery-3.6.0.min.js"></script>
    <script>
        function edit_shift(caller){
            document.getElementById("modal_shift_id").value = caller.dataset.shift_id;
            document.getElementById("modal_shift_name").value = caller.dataset.shift_name;
            document.getElementById("modal_shift_start_time").value = caller.dataset.shift_start_time;
            document.getElementById("modal_shift_end_time").value = caller.dataset.shift_end_time;
        }
    </script>
</body>

</html>