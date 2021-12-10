<!DOCTYPE html>
<html>

<head>
    % include('./static/base/header.tpl', title = 'Department Management')
</head>

<body id="page-top">
    <div id="wrapper">
        % include('./static/base/side_navbar.tpl', active_page = 'Department Management')
        <div class="d-flex flex-column" id="content-wrapper">
            <div id="content">
                % include('./static/base/navbar.tpl')
                <div class="container-fluid">
                    <h3 class="text-dark mb-4">Department Management</h3>
                    <div class="row">
                        <div class="col" style="min-width: 365px;">
                            <div class="row">
                                <div class="col">
                                    <div class="card shadow my-4">
                                        <div class="card-header py-3">
                                            <h6 class="text-primary d-xxl-flex justify-content-xxl-center m-0 fw-bold">Add New Department</h6>
                                        </div>
                                        <div class="card-body">
                                            % include('./static/base/flash.tpl')
                                            <div class="row">
                                                <form action="/department_management/add_department" method="POST">
                                                    <div class="col">
                                                        <div class="row d-flex d-xxl-flex justify-content-center justify-content-xxl-center mb-3">
                                                            <div class="col show" id="collapse-2">
                                                                <div class="row">
                                                                    <div class="col-6 col-md-6 text-nowrap d-xl-flex d-xxl-flex pb-3">
                                                                        <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">Department Name :</label><input name="department_name" class="form-control" type="text" required></div>
                                                                    </div>
                                                                    <div class="col-md-6 text-nowrap d-xl-flex d-xxl-flex pb-3">
                                                                        <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">Department Description :</label><input name="department_description" class="form-control" type="text" required></div>
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
                                            <th>Department ID</th>
                                            <th>Department Name</th>
                                            <th>Department Description</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        % for department in department_list:
                                        <tr>
                                            <td>{{department["department_id"]}}</td>
                                            <td>{{department["department_name"]}}</td>
                                            <td>{{department["department_description"]}}</td>
                                            <td><button class="btn btn-primary" type="button"  data-bs-toggle="modal" data-bs-target="#modal-1" data-department_description = "{{department["department_description"]}}" data-department_id = "{{department["department_id"]}}" data-department_name = "{{department["department_name"]}}" onclick="edit_department(this)" >Edit</button></td>
                                        </tr>
                                        % end
                                    </tbody>
                                    <tfoot>
                                        <tr>
                                            <td><strong>Department ID</strong></td>
                                            <td><strong>Department Name</strong></td>
                                            <td><strong>Department Description</strong></td>
                                            <td><strong>Action</strong></td>
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
        <form action="/department_management/edit_department" method="POST">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Edit Department</h4><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col">
                            <div class="row d-flex d-xxl-flex justify-content-center justify-content-xxl-center mb-3">
                                <div class="col show" id="collapse-3">
                                    <div class="row">
                                        <div class="col text-nowrap d-xl-flex d-xxl-flex pb-3">
                                            <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">Department ID :</label><input name="modal_department_id" type="text" class="form-control" value="" readonly/></div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col text-nowrap d-xl-flex d-xxl-flex pb-3">
                                            <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">Department Name :</label><input name="modal_department_name" class="form-control" type="text" value="" required/></div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col text-nowrap d-xl-flex d-xxl-flex pb-3">
                                            <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">Department Description:</label><input name="modal_department_description" type="text" class="form-control" value="" required/></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row d-flex d-xxl-flex justify-content-center justify-content-xxl-center mb-3"><button name="button" value="submit" class="btn btn-primary" type="submit" style="max-width: 30%;">Save</button></div>
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
        function edit_department(caller){        
            (document.getElementsByName("modal_department_id"))[0].value = caller.dataset.department_id;
            (document.getElementsByName("modal_department_name"))[0].value = caller.dataset.department_name;
            (document.getElementsByName("modal_department_description"))[0].value = caller.dataset.department_description;
        }
    </script>
</body>

</html>