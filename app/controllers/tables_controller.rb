class TablesController < ApplicationController
  include DownloadHelper

  before_action :authenticate_user

  before_action :set_table, except: [:new]
  before_action :authenticate_user_table_access, except: [:new]

  before_action :set_table_row, only: [:edit_row, :delete_row]
  before_action :set_table_column, only: [:edit_column, :delete_column]

  def show
    if @table.columns.count.zero?
      flash[:message] = "Your '#{@table.name}' table doesn't seem to have any columns yet."
      redirect_to new_column_url(table_id: @table.id) and return
    else
      @df = @table.to_dataframe
      download(@df)
    end
  end

  def new
    if request.post?
      @table = Table.new(name: params[:name], description: params[:description])
      if @table.save
        @current_user.tables << [@table]

        if params[:collections]
          @table.collections = params[:collections].map { |collection_id| Collection.find_by_id(collection_id) }
        end

        flash[:message] = 'Successfully created new table.'
        redirect_to show_table_url(table_id: @table.id) and return
      else
        flash[:message] = @table.errors
      end
    end
  end

  def new_column
    if request.post?
      @column = Column.new(
        name: params[:name].gsub(' ','_'),
        datatype: params[:datatype]
      )

      if @column.save
        @table.columns << [@column]

        default_datum_value = @column.datatype == 'Number' ? '0' : ' '

        @table.rows.each do |row|
          datum = Datum.create(value: default_datum_value)
          row.data     << [datum]
          @column.data << [datum]
        end

        flash[:message] = 'Successfully added new column.'
        redirect_to show_table_url(table_id: @table.id) and return
      else
        flash[:message] = @column.errors
      end
    end
  end

  def new_row
    if request.post?
      @row     = Row.create
      @table.rows << [@row]

      @table.columns.each do |column|
        value = params[column.name.gsub(' ', '_').to_sym]
        datum = Datum.create(value: value)

        column.data << [datum]
        @row.data   << [datum]
      end

      flash[:message] = 'New row has been successfully added.'
      redirect_to show_table_url(table_id: @table.id) and return
    end
  end

  def edit
    if request.post?
      @table.update(name: params[:name], description: params[:description])

      if params[:collections]
        @table.collections = params[:collections].map { |collection_id| Collection.find_by_id(collection_id) }
      else
        @table.collections = []
      end

      flash[:message] = 'Settings has been successfully updated.'
      redirect_to show_table_url(table_id: @table.id) and return
    end
  end

  def edit_column
    if request.post?
      @column.update(
        name: params[:name].gsub(' ','_'),
        datatype: params[:datatype]
      )

      flash[:message] = "The column '#{@column.name}' has been successfully updated."
      redirect_to show_table_url(table_id: @table.id) and return
    end
  end

  def edit_row
    if request.post?
      @table.columns.each_with_index do |column, i|
        value = params[column.name.gsub(' ', '_').to_sym]
        @row.data[i].update(value: value)
      end

      flash[:message] = 'The row has been successfully updated.'
      redirect_to show_table_url(table_id: @table.id) and return
    end
  end

  def delete
    @table.destroy
    redirect_to tables_path
  end

  def delete_column
    @column.destroy
    flash[:message] = 'The column has been successfully deleted.'
    redirect_to show_table_url(table_id: @table.id) and return
  end

  def delete_row
    @row.destroy
    flash[:message] = 'The row has been successfully deleted.'
    redirect_to show_table_url(table_id: @table.id) and return
  end

  def datatable_server_side
    @df = @table.to_dataframe
    compute_datatable_params

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

    html_df           = paginated_df
    html_df['Action'] = paginated_df.index.map do |i|
      "<a class='text-color delete-row' href='#' data-url='/tables/#{@table.id}/delete/row/#{i}' data-type='ajax-loader'><i class='material-icons'>delete</i></a><a href='/tables/#{@table.id}/edit/row/#{i}/' class='text-color'><i class='material-icons'>edit</i></a>"
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

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_table
    @table = Table.find_by_id(params[:table_id])

    if @table.nil?
      flash[:message] = "Sorry, the table you tried to access doesn't exist."
      redirect_back(fallback_location: tables_path) and return
    end
  end

  def set_table_column
    @column = Column.find_by_id(params[:column_id])

    if @column.nil?
      flash[:message] = "Sorry, the table column you tried to access doesn't exist."
      redirect_back(fallback_location: root_path) and return
    end
  end

  def set_table_row
    @row = Row.find_by_id(params[:row_id])

    if @row.nil?
      flash[:message] = "Sorry, the table row you tried to access doesn't exist."
      redirect_back(fallback_location: root_path) and return
    end
  end

  def authenticate_user_table_access
    unless current_user == @table.user
      flash[:message] = "Sorry, you don't seem to have access to the table you requested to see."
      redirect_to tables_path and return
    end
  end

  def compute_datatable_params
    # puts params.inspect

    @datatable = {
      start_index: params['start'].to_i,
      end_index: params['start'].to_i + params['length'].to_i - 1,
      search: params['search'] ? params['search']['value'] : nil,
      sort_column: params['order'] ? params['columns'][params['order']['0']['column']]['data'] : nil,
      sort_order: params['order']['0']['dir']
    }

    puts @datatable.inspect
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  # def table_params
  #   params.require(:table).permit(:name, :description, :columns_ids, :row_ids)
  # end
end
