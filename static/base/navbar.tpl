<nav class="navbar navbar-light navbar-expand bg-white shadow mb-4 topbar static-top">
    <div class="container-fluid"><button class="btn btn-link d-md-none rounded-circle me-3" id="sidebarToggleTop" type="button"><i class="fas fa-bars"></i></button>
        <ul class="navbar-nav flex-nowrap ms-auto">
            <div class="d-none d-sm-block topbar-divider"></div>
            <li class="nav-item dropdown no-arrow">
                <div class="nav-item dropdown no-arrow"><a class="dropdown-toggle nav-link" aria-expanded="false" data-bs-toggle="dropdown" href="#"><span class="d-none d-lg-inline me-2 text-gray-600 small">{{request.get_cookie("staff_id")}}</span><img class="border rounded-circle img-profile" src="assets/img/avatars/default.jpg"></a>
                    <div class="dropdown-menu shadow dropdown-menu-end animated--grow-in"><!-- <a class="dropdown-item" href="#"><i class="fas fa-user fa-sm fa-fw me-2 text-gray-400"></i>&nbsp;Profile</a><a class="dropdown-item" href="#"><i class="fas fa-cogs fa-sm fa-fw me-2 text-gray-400"></i>&nbsp;Settings</a>-->
                      <a class="dropdown-item" data-bs-toggle="modal" data-bs-target="#update_password_modal"><i class="fas fa-key fa-sm fa-fw me-2 text-gray-400"></i>&nbsp;Update Password</a>
                      <div class="dropdown-divider"></div>
                      <a class="dropdown-item" href="/logout"><i class="fas fa-sign-out-alt fa-sm fa-fw me-2 text-gray-400"></i>&nbsp;Logout</a>
                    </div>
                </div>
            </li>
        </ul>
    </div>
</nav>

<!-- Modal -->
<div role="dialog" tabindex="-1" class="modal fade" id="update_password_modal">
  <div class="modal-dialog modal-lg" role="document">
      <div class="modal-content">
          <div class="modal-header">
              <h4 class="modal-title" >Update Password</h4><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <div class="row">
              <form id="update_password_form" action="/update_password" method="POST">
                <input type="hidden" name="from_url" value="{{request.url}}">
                  <div class="col">
                      <div class="row">
                          <div class="col-md-4 text-nowrap d-xl-flex d-xxl-flex pb-3">
                              <div class="flex-grow-1">
                                  <label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">Old Password:</label>
                                  <input class="form-control" type="password" name="old_password" value="" required="">
                              </div>
                          </div>
                          <div class="col-md-4 text-nowrap d-xl-flex d-xxl-flex pb-3">
                              <div class="flex-grow-1">
                                  <label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">New Password:&nbsp;</label>
                                  <input class="form-control" type="password" name="new_password" value="" required="">
                              </div>
                          </div>
                          <div class="col-md-4 text-nowrap d-xl-flex d-xxl-flex pb-3">
                            <div class="flex-grow-1">
                                <label class="form-label d-flex d-xxl-flex justify-content-center justify-content-xxl-center">Confirm New Password:&nbsp;</label>
                                <input class="form-control" type="password" name="new_password_confirm" value="" required="">
                            </div>
                        </div>
                      </div>                      
                  </div>
              </form>
            </div>
          </div>
          <div class="modal-footer"><button class="btn btn-primary" type="submit" form="update_password_form">Update Password</button></div>
      </div>
  </div>
</div>