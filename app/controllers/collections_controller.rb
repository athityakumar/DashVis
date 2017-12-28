class CollectionsController < ApplicationController
  include DownloadHelper

  before_action :authenticate_user

  before_action :set_collection, except: [:new]
  before_action :authenticate_user_collection_access, except: [:new]

  def show
    @df = Daru::DataFrame.new(
      @collection.tables.all.map.with_index do |record, i|
        {
          'SNo'         => i+1,
          'Name'        => "<a href='/tables/#{record.id}'>#{record.name}</a>",
          'Description' => record.description.to_s,
          'Rows'        => record.rows.count,
          'Columns'     => record.columns.count,
          'Collections' => record.collections.count
          # 'Charts'      => record.charts.count
        }
      end,
      index: @collection.tables.all.map(&:id)
    )
    @vectors = @df.vectors.to_a

    download(@df)
  end

  def new
    if request.post?
      @collection = Collection.new(name: params[:name], description: params[:description])

      if @collection.save
        @current_user.collections << [@collection]

        if params[:tables]
          @collection.tables = params[:tables].map { |table_id| Table.find_by_id(table_id) }
        end

        flash[:message] = 'The collection has been successfully created.'
        redirect_to show_collection_url(collection_id: @collection.id) and return
      else
        flash[:message] = @collection.errors
      end
    end
  end

  def edit
    if request.post?
      @collection.update(name: params[:name], description: params[:description])

      if params[:tables]
        @collection.tables = params[:tables].map { |table_id| Table.find_by_id(table_id) }
      else
        @collection.tables = []
      end

      flash[:message] = 'Settings has been successfully updated.'
      redirect_to show_collection_url(collection_id: @collection.id) and return
    end
  end

  def delete
    @collection.destroy
    redirect_to collections_path
  end

  def datatable_server_side
    @df = Daru::DataFrame.new(
      @collection.tables.all.map.with_index do |record, i|
        {
          'SNo'         => i+1,
          'Name'        => "<a href='/tables/#{record.id}'>#{record.name}</a>",
          'Description' => record.description.to_s,
          'Rows'        => record.rows.count,
          'Columns'     => record.columns.count,
          'Collections' => record.collections.count
          # 'Charts'      => record.charts.count
        }
      end,
      index: @collection.tables.all.map(&:id)
    )
    @vectors = @df.vectors.to_a

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
    html_df['Action'] = paginated_df.map_rows_with_index do |row, i|
      table_name = row['Name'].gsub(/<\/?[^>]*>/, "")
      "<a class='text-color delete-table' href='#' data-url='/tables/#{i}/delete' data-type='ajax-loader' data-name=\"#{table_name}\"><i class='material-icons'>delete</i></a><a href='/tables/#{i}/edit/' class='text-color'><i class='material-icons'>edit</i></a>"
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
  def set_collection
    @collection = Collection.find_by_id(params[:collection_id])

    if @collection.nil?
      flash[:message] = "Sorry, the collection you tried to access doesn't exist."
      redirect_back(fallback_location: collections_path) and return
    end
  end

  def authenticate_user_collection_access
    unless current_user == @collection.user
      flash[:message] = "Sorry, you don't seem to have access to the collection you requested to see."
      redirect_to collections_path and return
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
