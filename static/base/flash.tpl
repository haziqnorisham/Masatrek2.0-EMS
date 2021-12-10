
<!-- Success, Error, Warning, Info -->
% messages = app.get_flashed_messages()  
    % if messages != None:
    % for category, message in messages:
        <div class="alert alert-{{ category }} alert-dismissible fade show">
            <strong class="text-uppercase">{{ category }}!</strong> {{ message }}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    % end
    % end