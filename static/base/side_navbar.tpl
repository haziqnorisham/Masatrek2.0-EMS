<nav class="navbar navbar-dark align-items-start sidebar sidebar-dark accordion bg-gradient-primary p-0">
    <div class="container-fluid d-flex flex-column p-0"><a class="navbar-brand d-flex justify-content-center align-items-center sidebar-brand m-0" href="#">
            <div class="sidebar-brand-icon rotate-n-15"><i class="far fa-address-card"></i></div>
            <div class="sidebar-brand-text mx-3"><span>Masatrek</span></div>
        </a>
        <hr class="sidebar-divider my-0">
        <ul class="navbar-nav text-light" id="accordionSidebar">
            
            % if request.get_cookie("admin") == "1":
                % if (active_page == "Dashboard"):
                    <li class="nav-item"><a class="nav-link active" href="/"><i class="fas fa-tachometer-alt"></i><span>Dashboard</span></a></li>            
                % else:
                    <li class="nav-item"><a class="nav-link" href="/"><i class="fas fa-tachometer-alt"></i><span>Dashboard</span></a></li>                
                % end                        
            % end
            
            % if (active_page == "Attendance Summary"):
            <li class="nav-item"><a class="nav-link active" href="attendance_summary"><i class="fa fa-calendar-o"></i><span>Attendance Summary</span></a></li>
            % else:
            <li class="nav-item"><a class="nav-link" href="attendance_summary"><i class="fa fa-calendar-o"></i><span>Attendance Summary</span></a></li>
            % end
            
            % if request.get_cookie("admin") == "1":    
                % if (active_page == "Attendance Management"):
                <li class="nav-item"><a class="nav-link active" href="attendance_management"><i class="fa fa-table"></i><span>Attendance Management</span></a></li>
                % else:
                <li class="nav-item"><a class="nav-link" href="attendance_management"><i class="fa fa-table"></i><span>Attendance Management</span></a></li>
                % end

                % if (active_page == "Employee Management"):
                    <li class="nav-item"><a class="nav-link active" href="employee_management"><i class="fa fa-users"></i><span>Employee Management</span></a></li>
                % else:
                    <li class="nav-item"><a class="nav-link" href="employee_management"><i class="fa fa-users"></i><span>Employee Management</span></a></li>                
                % end
                
                % if (active_page == "Device Management"):
                <li class="nav-item"><a class="nav-link active" href="device_management"><i class="fa fa-desktop"></i><span>Device Management</span></a></li>
                % else:
                <li class="nav-item"><a class="nav-link" href="device_management"><i class="fa fa-desktop"></i><span>Device Management</span></a></li>
                % end

                % if (active_page == "Department Management"):
                <li class="nav-item"><a class="nav-link active" href="department_management"><i class="fas fa-user-circle"></i><span>Department Management</span></a></li>
                % else:
                <li class="nav-item"><a class="nav-link" href="department_management"><i class="fas fa-user-circle"></i><span>Department Management</span></a></li>
                % end

                % if (active_page == "Shift Management"):
                <li class="nav-item"><a class="nav-link active" href="shift_management"><i class="fa fa-clock-o"></i> Shift Management</a></li>
                % else:
                <li class="nav-item"><a class="nav-link"  href="shift_management"><i class="fa fa-clock-o"></i> Shift Management</a></li>
                % end
            % end
        </ul>
        <div class="text-center d-none d-md-inline"><button class="btn rounded-circle border-0" id="sidebarToggle" type="button"></button></div>
    </div>
</nav>