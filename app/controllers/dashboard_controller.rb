class DashboardController < ApplicationController
  before_action :authenticate_user

  include DownloadHelper

  def tables
    @df = Daru::DataFrame.new(
      current_user.tables.all.map.with_index do |record, i|
        {
          'SNo'         => i+1,
          'Name'        => "<a href='/tables/#{record.id}'>#{record.name}</a>",
          'Description' => record.description.to_s,
          'No_of_Rows'        => record.rows.count,
          'No_of_Columns'     => record.columns.count,
          'No_of_Collections' => record.collections.count
          # 'Charts'      => record.charts.count
        }
      end,
      index: @current_user.tables.all.map(&:id)
    )
    @vectors = @df.vectors.to_a

    download(@df)
  end

  def charts
    @df = Daru::DataFrame.new(
      current_user.tables.all.map.with_index do |record, i|
        {
          'SNo'         => i+1,
          'Name'        => "<a href='/tables/#{record.id}'>#{record.name}</a>",
          'Description' => record.description.to_s,
          'No_of_Rows'        => record.rows.count.to_s,
          'No_of_Columns'     => record.columns.count.to_s,
          'No_of_Collections' => record.collections.count.to_s
          # 'Charts'      => record.charts.count
        }
      end,
      index: current_user.tables.all.map(&:id)
    )
    @vectors = @df.vectors.to_a

    @category_columns_list = [['No_of_Rows'], ['No_of_Columns'],['No_of_Collections']]
    @data = @df.to_json(orient: :values)
    @category_datasets_list = @category_columns_list.map do |category_columns|
      category_columns.map do |category_column|
        frequency_hash(@data.transpose, @vectors, category_column)
      end
    end
  end

  def collections
    @df = Daru::DataFrame.new(
      current_user.collections.all.map.with_index do |record, i|
        {
          'SNo'         => i+1,
          'Name'        => "<a href='/collections/#{record.id}'>#{record.name}</a>",
          'Description' => record.description.to_s,
          'No_of_Tables'      => record.tables.count
          # 'Charts'      => record.charts.count
        }
      end,
      index: current_user.collections.all.map(&:id)
    )
    @vectors = @df.vectors.to_a

    download(@df)
  end

  def settings
    @current_user = current_user

    if request.post?
      @current_user.update(
        name: user_params[:name],
        email: user_params[:email] || @current_user.email,
        image: user_params[:image] || @current_user.image
      )

      flash[:message] = 'Your preferences have been saved succesfully.'
    end
  end

  def tables_server_side
    compute_datatable_params
    @df = Daru::DataFrame.new(
      current_user.tables.all.map.with_index do |record, i|
        {
          'SNo'         => i+1,
          'Name'        => "<a href='/tables/#{record.id}'>#{record.name}</a>",
          'Description' => record.description.to_s,
          'No_of_Rows'        => record.rows.count,
          'No_of_Columns'     => record.columns.count,
          'No_of_Collections' => record.collections.count
          # 'Charts'      => record.charts.count
        }
      end,
      index: @current_user.tables.all.map(&:id)
    )
    @vectors = @df.vectors.to_a

    matching_df   = @df unless @datatable[:search]
    matching_df ||= @df.filter_rows { |row| row.to_a.join("\t").downcase.include?(@datatable[:search].downcase) }
    ordered_df    =
      case @datatable[:sort_column]
      when nil, "Action"
        matching_df
      else
        matching_df.sort([@datatable[:sort_column]], ascending: @datatable[:sort_order] == 'asc')
      end

    paginated_df   = ordered_df if ordered_df.nrows == 1
    paginated_df ||= ordered_df.row[@datatable[:start_index]..@datatable[:end_index]]

    html_df = paginated_df
    html_df['Action'] = paginated_df.map_rows_with_index do |row, i|
      table_name = row['Name'].gsub(/<\/?[^>]*>/, "")
      "<a class='text-color delete-table' href='#' data-url='/tables/#{i}/delete' data-name=\"#{table_name}\" data-type='ajax-loader'><i class='material-icons'>delete</i></a></div><a href='/tables/#{i}/edit' class='text-color'><i class='material-icons'>edit</i></a>"
    end
    paginated_df = html_df

    respond_to do |format|
      format.json do
        render json: {
          draw: params['draw'],
          recordsTotal: @df.size,
          recordsFiltered: matching_df.size,
          data: paginated_df.to_json
        }
      end
    end
  end


  def collections_server_side
    compute_datatable_params
    @df = Daru::DataFrame.new(
      current_user.collections.all.map.with_index do |record, i|
        {
          'SNo'         => i+1,
          'Name'        => "<a href='/collections/#{record.id}'>#{record.name}</a>",
          'Description' => record.description.to_s,
          'No_of_Tables'      => record.tables.count
          # 'Charts'      => record.charts.count
        }
      end,
      index: current_user.collections.all.map(&:id)
    )
    @vectors = @df.vectors.to_a

    matching_df   = @df unless @datatable[:search]
    matching_df ||= @df.filter_rows { |row| row.to_a.join("\t").downcase.include?(@datatable[:search].downcase) }
    ordered_df    =
      case @datatable[:sort_column]
      when nil, "Action"
        matching_df
      else
        matching_df.sort([@datatable[:sort_column]], ascending: @datatable[:sort_order] == 'asc')
      end

    paginated_df   = ordered_df if ordered_df.nrows == 1
    paginated_df ||= ordered_df.row[@datatable[:start_index]..@datatable[:end_index]]

    html_df = paginated_df
    html_df['Action'] = paginated_df.map_rows_with_index do |row, i|
      table_name = row['Name'].gsub(/<\/?[^>]*>/, "")
      "<a class='text-color delete-collection' href='#' data-url='/collections/#{i}/delete' data-name=\"#{table_name}\" data-type='ajax-loader'><i class='material-icons'>delete</i></a></div><a href='/collections/#{i}/edit' class='text-color'><i class='material-icons'>edit</i></a>"
    end
    paginated_df = html_df

    respond_to do |format|
      format.json do
        render json: {
          draw: params['draw'],
          recordsTotal: @df.size,
          recordsFiltered: matching_df.size,
          data: paginated_df.to_json
        }
      end
    end
  end

  def set_color
    @current_user = current_user
    @current_user.update(color_scheme: user_params[:color])
  end

  private

  def frequency_hash(rows, vectors, category)
    col_index = vectors.index(category)
    col       = rows.map { |row| row[col_index]        }
    col.uniq.sort.map    { |ele| [ele, col.count(ele)] }.to_h
  end

  def compute_datatable_params
    @datatable = {
      start_index: params['start'].to_i,
      end_index: params['start'].to_i + params['length'].to_i - 1,
      search: params['search'] ? params['search']['value'] : nil,
      sort_column: params['order'] ? params['columns'][params['order']['0']['column']]['data'] : nil,
      sort_order: params['order']['0']['dir']
    }
  end

  def user_params
    params.permit(:name, :email, :image, :color)
  end

  def authenticate_user
    redirect_to root_path and return unless signed_in?
  end
end
