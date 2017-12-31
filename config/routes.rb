 Rails.application.routes.draw do
  root to: 'pages#sign_in'

  # Scaffold pages
  get  '/auth/:provider/callback' => 'sessions#create'
  get  '/auth/:provider/unlink'   => 'sessions#unlink'
  get  '/auth/failure'            => 'pages#sign_in'
  get  '/logout'                  => 'sessions#destroy'

  # Scaffold dashboard
  get  '/tables'                => 'dashboard#tables', format: :json
  get  '/tables_server_side'    => 'dashboard#tables_server_side', format: :json

  # get  '/charts'                => 'dashboard#charts' # TO-DO

  get  '/collections'             => 'dashboard#collections', format: :json
  get  '/collections_server_side' => 'dashboard#collections_server_side', format: :json

  get  '/settings'              => 'dashboard#settings'
  post '/dashboard/set_color'   => 'dashboard#set_color'
  post '/settings'              => 'dashboard#settings', format: :json

  # Scaffold tables
  get  '/tables/new'                => 'tables#new', as: :new_table
  post '/tables/new'                => 'tables#new'
  get  '/tables/:table_id'          => 'tables#show', format: :json, as: :show_table
  get  '/tables/:table_id/edit'     => 'tables#edit', as: :edit_table
  post '/tables/:table_id/edit'     => 'tables#edit'
  get  '/tables/datatable_server_side/:table_id' => 'tables#datatable_server_side', format: :json
  get  '/tables/:table_id/delete'   => 'tables#delete'
  post '/tables/:table_id/delete'   => 'tables#delete'

  get  '/tables/:table_id/new/column'               => 'tables#new_column', as: :new_column
  post '/tables/:table_id/new/column'               => 'tables#new_column'
  get  '/tables/:table_id/edit/column/:column_id'   => 'tables#edit_column', as: :edit_column
  post '/tables/:table_id/edit/column/:column_id'   => 'tables#edit_column'
  get  '/tables/:table_id/delete/column/:column_id' => 'tables#delete_column'
  post '/tables/:table_id/delete/column/:column_id' => 'tables#delete_column'

  get  '/tables/:table_id/new/row'            => 'tables#new_row', as: :new_row
  post '/tables/:table_id/new/row'            => 'tables#new_row'
  get  '/tables/:table_id/edit/row/:row_id'   => 'tables#edit_row', as: :edit_row
  post '/tables/:table_id/edit/row/:row_id'   => 'tables#edit_row'
  get  '/tables/:table_id/delete/row/:row_id' => 'tables#delete_row'
  post '/tables/:table_id/delete/row/:row_id' => 'tables#delete_row'

  # Scaffold collections
  get  '/collections/new'                   => 'collections#new', as: :new_collection
  post '/collections/new'                   => 'collections#new'
  get  '/collections/:collection_id'        => 'collections#show', format: :json, as: :show_collection
  get  '/collections/:collection_id/edit'   => 'collections#edit', as: :edit_collection
  post '/collections/:collection_id/edit'   => 'collections#edit'
  get  '/collections/:collection_id/delete' => 'collections#delete'

  get  '/collections/:collection_id/datatable_server_side' => 'collections#datatable_server_side', format: :json

  #! Yet to be done

  # Scaffold charts
  # get  '/tables/:table_id/charts'                  => 'tables#show_charts', as: :show_charts
  # get  '/tables/:table_id/charts/new'              => 'tables#new_chart'
  # post '/tables/:table_id/charts/new'              => 'tables#new_chart'
  # get  '/tables/:table_id/charts/:chart_id/edit'   => 'tables#edit_chart'
  # post '/tables/:table_id/charts/:chart_id/edit'   => 'tables#edit_chart'
  # get  '/tables/:table_id/charts/:chart_id/delete' => 'tables#delete_chart'

  # Notifications per table
  # get  '/tables/:table_id/activity' => 'table#activity'
end
