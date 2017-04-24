class PresentersController < ParsingController
  def notice_detail
    student = params[:student]
    notice_unit = params[:notice_unit]

    @notice_detail = xml_map_chunk_extraction_job(
        map_chunk = get_notice_detail(student, notice_unit), #eclass 과목 별 notice 리스트의 데이터 map chunk 를 가져온다. 맨 마지막 숫자를 조정해서 불러오는 공지사항의 개수 조절 가능
        key_array = %w(username boardtitle lectureno boardno boarddate boardcheck boardhit textcontent fileintro), #해당 키값을 전부 뽑아서 2차월 배열에 넣어준다. @notice[0~N]에 분해 된 맵들이 각가 들어가고, 각 유닛의 2차원 배열 @notice[0][0~M]에 키값에 해당하는 밸류가 들어간다.
        filter_array = %w(msgCode filelist1 filelist2),
        true, true
    )[0]
  end

  def notice_file
    filename = params[:notice_filename]
    filesysname = params[:notice_filesysname]
    filetype = params[:notice_filetype]

    send_data get_notice_file(filename, filesysname, filetype).body, filename: "#{filename}", type: "application/#{filetype}", stream: 'true', buffer_size: '4096'
  end

  def content_detail
    student = params[:student]
    @content_unit = params[:content_unit] #7번째에 외부 접근 파일 리스트 들어있음
    @content_detail = xml_map_chunk_extraction_job(
         map_chunk = get_content_detail(student, @content_unit),
         key_array = %w(lecschtitle lecschfilename contentsdir),
         filter_array = %w(msgCode),
         true, true
    ) #여기서 lecshtitle 이 파일이거나 동영상이거나 둘 중 하나임.
  end

  def content_file
    filename = params[:content_filename]
    filesysname = params[:content_filesysname]
    filetype = params[:content_filetype]

    send_data get_content_file(filename, filesysname, filetype).body, filename: "#{filename}", type: "application/#{filetype}", stream: 'true', buffer_size: '4096'

  end

  def share_detail
    student = params[:student]
    share_unit = params[:share_unit]

    @share_detail = xml_map_chunk_extraction_job(
        map_chunk = get_share_detail(student, share_unit), #eclass 과목 별 share 리스트의 데이터 map chunk 를 가져온다. 맨 마지막 숫자를 조정해서 불러오는 공지사항의 개수 조절 가능
        key_array = %w(username boardtitle lectureno boardno boarddate boardcheck boardhit textcontent fileintro), #해당 키값을 전부 뽑아서 2차월 배열에 넣어준다. @share[0~N]에 분해 된 맵들이 각가 들어가고, 각 유닛의 2차원 배열 @share[0][0~M]에 키값에 해당하는 밸류가 들어간다.
        filter_array = %w(msgCode filelist1 filelist2),
        true, true
    )[0]
  end

  def share_file
    filename = params[:share_filename]
    filesysname = params[:share_filesysname]
    filetype = params[:share_filetype]

    send_data get_share_file(filename, filesysname, filetype).body, filename: "#{filename}", type: "application/#{filetype}", stream: 'true', buffer_size: '4096'
  end

  def professor_detail
  end
end
