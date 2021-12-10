<!DOCTYPE html>
<html>

<head>
    % include('./static/base/header.tpl', title = 'Employee Management')
</head>

    <body id="page-top">
        <div id="wrapper">
            % include('./static/base/side_navbar.tpl', active_page = 'Employee Management')
            <div class="d-flex flex-column" id="content-wrapper">
                <div id="content">
                    % include('./static/base/navbar.tpl')
                    <div class="container-fluid">
                        <h3 class="text-dark mb-4">Employee Management</h3>
                        <div class="row">
                            <div class="col" style="min-width: 365px;">
                                <div class="row">
                                    <div class="col">
                                        <div class="card shadow border-start-success py-2">
                                            <div class="card-body">
                                                <div class="row align-items-center no-gutters">
                                                    <div class="col me-2">
                                                        <div class="text-uppercase text-success fw-bold text-xs mb-1"><span>TOTAL REGISTERED EMPLOYEE</span></div>
                                                        <div class="text-dark fw-bold h5 mb-0"><span>{{len(all_visitor)}} Employee</span></div>
                                                    </div>
                                                    <div class="col-auto"><i class="fas fa-users fa-2x text-gray-300"></i></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col">
                                        <div class="card shadow my-4">
                                            <div class="card-header py-3">
                                                <h6 class="text-primary d-xxl-flex justify-content-xxl-center m-0 fw-bold">Register New Employee</h6>
                                            </div>
                                            <div class="card-body">
                                                % include('./static/base/flash.tpl')
                                                <div class="row">
                                                    <form action="/employee_management/add_employee" method="POST">
                                                    <div class="col">
                                                        <div class="row d-flex d-xxl-flex justify-content-center justify-content-xxl-center mb-3">
                                                            <div class="col collapse" id="collapse-2">
                                                                <div class="row">
                                                                    <div class="col d-flex d-lg-flex d-xxl-flex justify-content-center justify-content-lg-center justify-content-xxl-center mb-3"><input type="hidden" name="image_name" value="Haziq"><img id="new_user_image" data-bs-toggle="modal" data-bs-target="#modal-2" class="rounded-3 border border-5" src="assets/img/Haziq.png" onclick="image_selection_modal()"></div>
                                                                </div>
                                                                <div class="row">
                                                                    <div class="col-md-6 text-nowrap d-xl-flex d-xxl-flex pb-3">
                                                                        <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">Name :</label><input name="employee_name" type="text" class="form-control" required/></div>
                                                                    </div>
                                                                    <div class="col-md-6 text-nowrap d-xl-flex d-xxl-flex pb-3">
                                                                        <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">Employee ID :</label><input name="employee_id" type="text" class="form-control" required/></div>
                                                                    </div>
                                                                </div>
                                                                <div class="row">
                                                                    <div class="col-md-4 text-nowrap d-xl-flex d-xxl-flex pb-3">
                                                                        <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">Department :</label><select name="department" class="form-select" required>                                                                            
                                                                                <option value="" selected>None</option>
                                                                                % for department in department_list:
                                                                                <option value="{{department["department_id"]}}">{{department["department_name"]}}</option>                                                                            
                                                                                % end
                                                                            </select></div>
                                                                    </div>
                                                                    <div class="col-md-4 text-nowrap d-xl-flex d-xxl-flex pb-3">
                                                                        <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">Shift :</label><select name="shift" class="form-select" required>                                                                            
                                                                                <option value="" selected>None</option>
                                                                                % for shift in shift_list:
                                                                                <option value="{{shift["shift_id"]}}">{{shift["shift_name"]}}</option>
                                                                                % end
                                                                            </select></div>
                                                                    </div>
                                                                    <div class="col-md-4 text-nowrap d-xl-flex d-xxl-flex pb-3">
                                                                        <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">Position :</label><select name="position" class="form-select" required>                                                                            
                                                                                <option value="" selected>None</option>
                                                                                <option value="0">Employee</option>
                                                                                <option value="1">Admin</option>
                                                                            </select></div>
                                                                    </div>                                                                
                                                                </div>
                                                                <div class="row pb-3 d-xl-flex justify-content-xl-center">
                                                                    <div class="col-md-4">
                                                                        <p class="text-center">Access :</p>
                                                                        <div>
                                                                            % for terminal in all_terminal:
                                                                            <div class="form-check"><input type="checkbox" class="form-check-input" id="formCheck-{{terminal[0]}}" name="access_terminal" value="{{terminal[0]}}"/><label class="form-check-label" for="formCheck-{{terminal[0]}}">{{terminal[1]}}</label></div>
                                                                            % end
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="row d-flex d-xxl-flex justify-content-center justify-content-xxl-center mb-3"><button class="btn btn-primary" type="submit" style="max-width: 30%;" id="add_visitor_button">Read From IC</button></div>                                                           
                                                            </div>
                                                        </div>                                                    
                                                        <div class="row d-flex d-xxl-flex justify-content-center justify-content-xxl-center mb-3">
                                                            <div class="col d-flex d-xxl-flex justify-content-center justify-content-xxl-center"><a class="link-secondary" href="#collapse-2" data-bs-toggle="collapse" aria-controls="collapse-2" aria-expended="false" onclick="add_visitor_expand(this)">Expand<i class="fa fa-angle-down"></i></a></div>
                                                        </div>
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
                                <p class="text-primary m-0 fw-bold">Employee Info</p>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive table mt-2" id="dataTable-1" role="grid" aria-describedby="dataTable_info">
                                    <table class="table my-0" id="dataTable">
                                        <thead>
                                            <tr>
                                                <th>Name</th>
                                                <th>Employee ID</th>
                                                <th>Department</th>
                                                <th>Shift</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            % for visitor in all_visitor:
                                            <tr>
                                                <td><img class="rounded-circle me-2" width="30" height="30" src="snapshot/{{visitor['img_name']}}.jpg"><span>{{visitor['name']}}</span></td>
                                                <td>{{visitor['employee_id']}}</td>
                                                <td>{{visitor['department']}}</td>
                                                <td>{{visitor['shift_name']}}</td>
                                                <td><button class="btn btn-primary" type="button" data-bs-toggle="modal" data-bs-target="#modal-1" data-employee_position="{{visitor['employee_position']}}" data-employee_id="{{visitor['employee_id']}}" data-employee_name="{{visitor['name']}}" data-department_id="{{visitor['department_id']}}" data-shift_id="{{visitor['shift_id']}}" data-image_name="{{visitor['img_name']}}" onclick="update_modal(this)">Edit</button></td>
                                            </tr>
                                            % end                                  
                                        </tbody>
                                        <tfoot>
                                            <tr>
                                                <th>Name</th>
                                                <th>Employee ID</th>
                                                <th>Department</th>
                                                <th>Shift</th>
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

        <!-- MODAL 1-->
        <div role="dialog" tabindex="-1" class="modal fade" id="modal-1">
            <div class="modal-dialog modal-xl" role="document">
            <form action="/employee_management/edit_employee" method="POST">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title">Edit Visitor</h4><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="card-body">                        
                            <div class="row">
                                <div class="col">
                                    <div class="row d-flex d-xxl-flex justify-content-center justify-content-xxl-center mb-3">
                                        <div class="col">
                                            <div class="row">
                                                <div class="col d-flex d-lg-flex d-xxl-flex justify-content-center justify-content-lg-center justify-content-xxl-center mb-3"><input type="hidden" name="image_name" value="Haziq"><img id="modal_employee_image" data-bs-toggle="modal" data-bs-target="#modal-2" class="rounded-3 border border-5" src="assets/img/Haziq.png" onclick="image_selection_modal()"></div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-6 text-nowrap d-xl-flex d-xxl-flex pb-3">
                                                    <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">Name :</label><input id="modal_employee_name" name="modal_employee_name" type="text" class="form-control" required/></div>
                                                </div>
                                                <div class="col-md-6 text-nowrap d-xl-flex d-xxl-flex pb-3">
                                                    <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">Employee ID :</label><input id="modal_employee_id" name="modal_employee_id" type="text" class="form-control" readonly/></div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-4 text-nowrap d-xl-flex d-xxl-flex pb-3">
                                                    <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">Department :</label><select id="modal_department" name="modal_department" class="form-select" required>
                                                            <option value="" selected>None</option>
                                                            % for department in department_list:
                                                            <option value="{{department["department_id"]}}">{{department["department_name"]}}</option>                                                                            
                                                            % end
                                                        </select></div>
                                                </div>
                                                <div class="col-md-4 text-nowrap d-xl-flex d-xxl-flex pb-3">
                                                    <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">Shift :</label><select id="modal_shift" name="modal_shift" class="form-select" required>                                                                            
                                                            <option value="" selected>None</option>
                                                            % for shift in shift_list:
                                                            <option value="{{shift["shift_id"]}}">{{shift["shift_name"]}}</option>
                                                            % end
                                                        </select></div>
                                                </div>
                                                <div class="col-md-4 text-nowrap d-xl-flex d-xxl-flex pb-3">
                                                    <div class="flex-grow-1"><label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">Position :</label><select id="modal_position" name="modal_position" class="form-select" required>                                                                            
                                                            <option value="" selected>None</option>
                                                            <option value="0">Employee</option>
                                                            <option value="1">Admin</option>
                                                        </select></div>
                                                </div>                                                                
                                            </div>
                                            <div class="row pb-3 d-xl-flex justify-content-xl-center">
                                                <div class="col-md-4">
                                                    <p class="text-center">Access :</p>
                                                    <div>
                                                        % for terminal in all_terminal:
                                                        <div class="form-check"><input type="checkbox" class="form-check-input" id="formCheck-{{terminal[0]}}" name="access_terminal" value="{{terminal[0]}}"/><label class="form-check-label" for="formCheck-{{terminal[0]}}">{{terminal[1]}}</label></div>
                                                        % end
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row d-flex d-xxl-flex justify-content-center justify-content-xxl-center"><button name="modal_button" value="submit" class="btn btn-primary" type="submit" style="max-width: 30%;" id="add_visitor_button">Save Changes</button></div>
                                        </div>
                                    </div>                                
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer"><button name="modal_button" value="delete" class="btn btn-danger" type="submit">Delete</button></div>
                </div>
            </form>
            </div>
        </div>

        <!-- MODAL 2-->
        <div role="dialog" tabindex="-1" class="modal fade" id="modal-2">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title">Image Selection</h4><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Click On Image To Select</th>
                                    </tr>
                                </thead>
                                <tbody id="image_selection_table">
                                    <tr>
                                        <td style="text-align: center;"><img class="rounded-3 border border-5" src="Haziq.png" value onclick="select_image(this)" /></td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: center;"><img class="rounded-3 border border-5" src="Haziq.png" value onclick="select_image(this)" /></td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: center;"><img class="rounded-3 border border-5" src="Haziq.png" value onclick="select_image(this)" /></td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: center;"><img class="rounded-3 border border-5" src="Haziq.png" value onclick="select_image(this)" /></td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: center;"><img class="rounded-3 border border-5" src="Haziq.png" value onclick="select_image(this)" /></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="modal-footer"><button class="btn btn-primary" type="button" onclick="image_selection_modal()">Refresh Image</button></div>
                </div>
            </div>
        </div>

        <script src="assets/bootstrap/js/bootstrap.min.js"></script>
        <script src="assets/js/bs-init.js"></script>
        <script src="assets/js/theme.js"></script>
        <script src="assets/js/jquery-3.6.0.min.js"></script>
        <script>
            function add_visitor_expand(caller) {
                if (document.getElementById('add_visitor_button').innerHTML == 'Save'){                
                    document.getElementById('add_visitor_button').innerHTML = 'Read From IC';
                }
                else{                
                    document.getElementById('add_visitor_button').innerHTML = 'Save';
                    document.getElementById('add_visitor_button').setAttribute("type", "submit");        
                }
            }        

            function update_modal(caller){
                var employee_id = caller.dataset.employee_id;
                var employee_name = caller.dataset.employee_name;
                var image_name = caller.dataset.image_name;
                var department_id = caller.dataset.department_id;
                var shift_id = caller.dataset.shift_id;
                var employee_position = caller.dataset.employee_position;

                document.getElementById("modal_employee_image").src = "snapshot/" + image_name + ".jpg";
                document.getElementById("modal_employee_name").value = employee_name;
                document.getElementById("modal_employee_id").value = employee_id;

                for (let x of document.getElementById("modal_department").options){
                    if (x.value == department_id){
                        x.selected = true;
                    }
                }
                
                for (let x of document.getElementById("modal_shift").options){
                    if (x.value == shift_id){
                        x.selected = true;
                    }
                }

                for (let x of document.getElementById("modal_position").options){
                    if (x.value == employee_position){
                        x.selected = true;
                    }
                }

                console.log("employee_id : " + employee_id);
                console.log("employee_name : " + employee_name);
                console.log("image_name : " + image_name);
                console.log("department_id : " + department_id);
                console.log("shift_id : " + shift_id);
                console.log("employee_position : " + employee_position);
            }

            function image_selection_modal() {
            
            const xhttp = new XMLHttpRequest();
            xhttp.onload = function() {
                    var from_server = this.responseText;
                    from_server = JSON.parse(from_server);
                    var image_selection_table = document.getElementById("image_selection_table");

                    for (let i in from_server){
                        
                        image_selection_table.rows[i].innerHTML = '<td style="text-align: center;"><img class="rounded-3 border border-5" src="snapshot/' + from_server[i][0] + '.jpg" value="'+ from_server[i][0] +'" onclick="select_image(this)" data-bs-dismiss="modal" aria-label="Close" /></td>';
                    }                              
            }
            xhttp.open("GET", "/visitor_management/ajax_get_latest_image");
            xhttp.send();
            }

            function select_image(caller){            
                document.getElementById("new_user_image").setAttribute("src", caller.getAttribute("src"));            
                document.getElementById("new_user_image").parentNode.children[0].value = caller.getAttribute("value");
                document.getElementById("modal_image").setAttribute("src", caller.getAttribute("src"));
                document.getElementById("modal_image_form").setAttribute("value", caller.getAttribute("value"));
            }
        </script>
    </body>
</html>