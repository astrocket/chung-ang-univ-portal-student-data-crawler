RailsAdmin.config do |config|
  require 'i18n'
  config.total_columns_width = 2000
  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == Authority ==
  config.authorize_with do |controller|
    redirect_to main_app.root_path unless current_user.has_role? :admin
  end

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model 'User' do
    object_label_method do
      :user_label_method
    end
    list do
      field :name do
        label '이름'
      end
      field :email do
        label '메일'
      end
      field :student do
        label '학번'
      end
      field :status do
        label '승인여부'
      end
      field :current_sign_in_at do
        label '최근로그인'
      end
      field :created_at do
        label '가입일'
      end
      field :sign_in_count do
        label '로그인횟수'
      end
    end
  end

  config.model 'Course' do
    object_label_method do
      :course_label_method
    end
    list do
      field :name do
        label '과목명'
      end
      field :number do
        label '과목번호'
      end
      field :professors do
        label '교수'
      end
      field :users do
        label '수강생'
      end
      field :hakboos do
        label '단과대'
      end
      field :year do
        label '연도'
      end
      field :semester do
        label '학기'
      end

    end
  end

  config.model 'Hakboo' do
    exclude_fields :created_at, :updated_at
  end

  config.model 'Professor' do
    exclude_fields :created_at, :updated_at
  end

  private

  def user_label_method
    "#{self.name}(#{self.department_name})"
  end

  def course_label_method
    "[#{self.year}-#{self.semester}]#{self.name}"
  end
end
