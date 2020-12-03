$('#usersTable').replaceWith("<%= j render 'users/table' %>")
$('.pagination').replaceWith("<%= j render 'layouts/pagination', records: @users, filter_params: user_filter_params.merge({ controller: 'users', action: 'index' }) %>")
