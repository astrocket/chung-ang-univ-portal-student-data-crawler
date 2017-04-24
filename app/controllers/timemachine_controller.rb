class TimemachineController < ParsingController
  def index
    professor = params[:professor]
    @time_machine = []
    (2009..2017).each do |year|
      (1..2).each do |semester|
        chunk = xml_map_chunk_extraction_job(
            map_chunk = get_time_machine(professor, year, semester),
            key_array = %w(lectureno lecturenamenum profname studydate lecturetype subjectname lecturecollegetype),
            filter_array = %w(msgCode),
            true, true
        )
        if chunk.present?
          @time_machine << chunk
        end
      end
    end

  end
end
