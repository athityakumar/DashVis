module DownloadHelper
  def download(dataframe, as: %i[html csv xls json])
    respond_to do |format|
      format.html
      format.csv  { send_data(dataframe.to_csv_string)                }
      format.xls  { send_data(dataframe.to_excel_string)              }
      format.json { send_data(dataframe.to_json_string(pretty: true)) }
    end
  end
end
